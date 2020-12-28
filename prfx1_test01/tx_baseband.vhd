library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_unsigned.all;

entity tx_baseband is
	PORT
	(
		signal clk16m : in std_logic;
		signal clk80m : in std_logic;
		signal reset_n : in std_logic;
		signal tx_data : in std_logic_vector(31 downto 0);
		signal bb_sin : out std_logic_vector(15 downto 0);
		signal bb_cos : out std_logic_vector(15 downto 0);
		signal next_sym_en : out std_logic
	);
end tx_baseband;

architecture rtl of tx_baseband is

component wave_mem
	generic (mif_file : string := "null-file.mif");
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
end component;

constant CNT_100_MAX : integer := 100 - 1;
constant CNT_76US_MAX : integer := 76 * 16 - 1;

signal count_100sym	: integer range 0 to CNT_100_MAX := 0;
signal count_76us		: integer range 0 to CNT_76US_MAX:= 0;

signal reset_address : boolean;
signal address : std_logic_vector(8 downto 0);
signal bb_data_sin4 : std_logic_vector(15 downto 0);
signal bb_data_sin8 : std_logic_vector(15 downto 0);
signal bb_data_sin12 : std_logic_vector(15 downto 0);
signal bb_data_sin16 : std_logic_vector(15 downto 0);

signal bb_data_cos4 : std_logic_vector(15 downto 0);
signal bb_data_cos8 : std_logic_vector(15 downto 0);
signal bb_data_cos12 : std_logic_vector(15 downto 0);
signal bb_data_cos16 : std_logic_vector(15 downto 0);

signal get_next_symbol : std_logic;

begin

	next_sym_en <= get_next_symbol;

	--baseband
	sin4_inst : wave_mem generic map ("wave-sin4.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_sin4
	);
	sin8_inst : wave_mem generic map ("wave-sin8.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_sin8
	);
	sin12_inst : wave_mem generic map ("wave-sin12.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_sin12
	);
	sin16_inst : wave_mem generic map ("wave-sin16.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_sin16
	);

	cos4_inst : wave_mem generic map ("wave-cos4.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_cos4
	);
	cos8_inst : wave_mem generic map ("wave-cos8.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_cos8
	);
	cos12_inst : wave_mem generic map ("wave-cos12.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_cos12
	);
	cos16_inst : wave_mem generic map ("wave-cos16.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_cos16
	);
	
	--16mhz flipflop setting
   set_p16 : process (clk16m)
   begin
		if (falling_edge(clk16m)) then
			if (reset_n = '0') then
				reset_address <= true;
				count_100sym <= 0;
				count_76us <= 0;
				get_next_symbol <= '0';
				bb_sin <= (others => '0');
				bb_cos <= (others => '0');
			else

				if (count_76us < CNT_76US_MAX) then
					count_76us <= count_76us + 1;
				else
					count_76us <= 0;
				end if;

				if (count_76us = CNT_76US_MAX) then
					if (count_100sym < CNT_100_MAX) then
						count_100sym <= count_100sym + 1;
					else
						count_100sym <= 0;
					end if;
				end if;

				if (count_76us = CNT_76US_MAX - 1) then
					reset_address <= true;
				else
					reset_address <= false;
				end if;

				if ((count_76us = CNT_76US_MAX - 1) and (count_100sym = CNT_100_MAX)) then
					get_next_symbol <= '1';
				else
					get_next_symbol <= '0';
				end if;

				if (count_100sym = 0) then
					bb_sin <= (others => '0');
					bb_cos <= (others => '0');
				elsif (count_100sym = 1) then
					bb_sin <= bb_data_sin16;
					bb_cos <= bb_data_cos16;
				elsif (count_100sym = 2) then
					bb_sin <= bb_data_sin4 + bb_data_sin8 + bb_data_sin12 + bb_data_sin16;
					bb_cos <= bb_data_cos4 + bb_data_cos8 + bb_data_cos12 + bb_data_cos16;
				else
					bb_sin <= (others => '0');
					bb_cos <= (others => '0');
				end if;
			end if;
		end if;
	end process;

	--80mhz flipflop setting
   set_p80 : process (clk80m)
	variable cnt16 : integer range 0 to 15 := 0;
   begin
		if (rising_edge(clk80m)) then
			if (reset_n = '0') then
				cnt16 := 0;
				address <= (others => '0');
			else
				if (cnt16 = 15) then
					cnt16 := 0;
					if (reset_address = true) then
						address <= (others => '0');
					else
						address <= address + 1;
					end if;
				else
					cnt16 := cnt16 + 1;
				end if;
			end if;
		end if;
	end process;

end rtl;
