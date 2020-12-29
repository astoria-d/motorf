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
		signal bb_i : out std_logic_vector(15 downto 0);
		signal bb_q : out std_logic_vector(15 downto 0);
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
signal bb_data_sin0 : std_logic_vector(15 downto 0);
signal bb_data_sin2 : std_logic_vector(15 downto 0);
signal bb_data_sin4 : std_logic_vector(15 downto 0);
signal bb_data_sin6 : std_logic_vector(15 downto 0);
signal bb_data_sin8 : std_logic_vector(15 downto 0);
signal bb_data_sin10 : std_logic_vector(15 downto 0);
signal bb_data_sin12 : std_logic_vector(15 downto 0);
signal bb_data_sin14 : std_logic_vector(15 downto 0);
signal bb_data_sin16 : std_logic_vector(15 downto 0);

signal bb_data_cos0 : std_logic_vector(15 downto 0);
signal bb_data_cos2 : std_logic_vector(15 downto 0);
signal bb_data_cos4 : std_logic_vector(15 downto 0);
signal bb_data_cos6 : std_logic_vector(15 downto 0);
signal bb_data_cos8 : std_logic_vector(15 downto 0);
signal bb_data_cos10 : std_logic_vector(15 downto 0);
signal bb_data_cos12 : std_logic_vector(15 downto 0);
signal bb_data_cos14 : std_logic_vector(15 downto 0);
signal bb_data_cos16 : std_logic_vector(15 downto 0);

function negative(
	signal unsigned_data : in std_logic_vector
	) return std_logic_vector
	is
variable outdata : std_logic_vector(15 downto 0);
begin
	outdata := unsigned_data;
	return outdata;
end negative;


function get_sym_i(
	signal sin_data : in std_logic_vector;
	signal cos_data : in std_logic_vector;
	signal sym : std_logic_vector
	) return std_logic_vector
	is
variable outdata : std_logic_vector(15 downto 0);
begin
	if (sym = "00") then
		outdata := cos_data;
	elsif (sym = "01") then
		outdata := negative(sin_data);
	elsif (sym = "10") then
		outdata := negative(cos_data);
	else
		outdata := sin_data;
	end if;
	return outdata;
end get_sym_i;

function get_sym_q(
	signal sin_data : in std_logic_vector;
	signal cos_data : in std_logic_vector;
	signal sym : std_logic_vector
	) return std_logic_vector
	is
variable outdata : std_logic_vector(15 downto 0);
begin
	if (sym = "00") then
		outdata := sin_data;
	elsif (sym = "01") then
		outdata := cos_data;
	elsif (sym = "10") then
		outdata := negative(sin_data);
	else
		outdata := negative(cos_data);
	end if;
	return outdata;
end get_sym_q;

begin

	--baseband
	sin0_inst : wave_mem generic map ("wave-sin0.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_sin0
	);
	sin2_inst : wave_mem generic map ("wave-sin2.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_sin2
	);
	sin4_inst : wave_mem generic map ("wave-sin4.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_sin4
	);
	sin6_inst : wave_mem generic map ("wave-sin6.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_sin6
	);
	sin8_inst : wave_mem generic map ("wave-sin8.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_sin8
	);
	sin10_inst : wave_mem generic map ("wave-sin10.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_sin10
	);
	sin12_inst : wave_mem generic map ("wave-sin12.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_sin12
	);
	sin114_inst : wave_mem generic map ("wave-sin14.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_sin14
	);
	sin16_inst : wave_mem generic map ("wave-sin16.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_sin16
	);

	cos0_inst : wave_mem generic map ("wave-cos0.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_cos0
	);
	cos2_inst : wave_mem generic map ("wave-cos2.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_cos2
	);
	cos4_inst : wave_mem generic map ("wave-cos4.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_cos4
	);
	cos6_inst : wave_mem generic map ("wave-cos6.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_cos6
	);
	cos8_inst : wave_mem generic map ("wave-cos8.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_cos8
	);
	cos10_inst : wave_mem generic map ("wave-cos10.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_cos10
	);
	cos12_inst : wave_mem generic map ("wave-cos12.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_cos12
	);
	cos14_inst : wave_mem generic map ("wave-cos14.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_cos14
	);
	cos16_inst : wave_mem generic map ("wave-cos16.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_cos16
	);
	
	--16mhz flipflop setting
   set_p16 : process (clk16m)
	variable sym0 : std_logic_vector (1 downto 0);
	variable sym1 : std_logic_vector (1 downto 0);
	variable sym2 : std_logic_vector (1 downto 0);
	variable sym3 : std_logic_vector (1 downto 0);
	variable sym4 : std_logic_vector (1 downto 0);
	variable sym5 : std_logic_vector (1 downto 0);
	variable sym6 : std_logic_vector (1 downto 0);
	variable sym7 : std_logic_vector (1 downto 0);
   begin
		if (falling_edge(clk16m)) then
			if (reset_n = '0') then
				reset_address <= true;
				count_100sym <= 0;
				count_76us <= 0;
				next_sym_en <= '0';
				bb_i <= (others => '0');
				bb_q <= (others => '0');
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

				if ((count_76us = CNT_76US_MAX - 1) and ((count_100sym > 1) and (count_100sym mod 2 = 0))) then
					next_sym_en <= '1';
				else
					next_sym_en <= '0';
				end if;

				if (count_100sym = 0) then
					bb_i <= (others => '0');
					bb_q <= (others => '0');
				elsif (count_100sym = 1) then
					bb_i <= bb_data_cos16;
					bb_q <= bb_data_sin16;
				elsif (count_100sym = 2) then
					bb_i <=
							bb_data_cos0 +
							bb_data_cos2 +
							bb_data_cos4 +
							bb_data_cos6 +
							bb_data_cos8 +
							bb_data_cos10 +
							bb_data_cos12 +
							bb_data_cos14 +
							bb_data_cos16;
						bb_q <=
							bb_data_sin0 +
							bb_data_sin2 +
							bb_data_sin4 +
							bb_data_sin6 +
							bb_data_sin8 +
							bb_data_sin10 +
							bb_data_sin12 +
							bb_data_sin14 +
							bb_data_sin16;
				else
					if (count_100sym mod 2 = 1) then
						bb_i <=
							get_sym_i(bb_data_sin0, bb_data_cos0, tx_data(15 downto 14)) +
							get_sym_i(bb_data_sin2, bb_data_cos2, tx_data(13 downto 12)) +
							get_sym_i(bb_data_sin4, bb_data_cos4, tx_data(11 downto 10)) +
							get_sym_i(bb_data_sin6, bb_data_cos6, tx_data(9 downto 8)) +
							get_sym_i(bb_data_sin8, bb_data_cos8, tx_data(7 downto 6)) +
							get_sym_i(bb_data_sin10, bb_data_cos10, tx_data(5 downto 4)) +
							get_sym_i(bb_data_sin12, bb_data_cos12, tx_data(3 downto 2)) +
							get_sym_i(bb_data_sin14, bb_data_cos14, tx_data(1 downto 0)) +
							bb_data_cos16;
						bb_q <=
							get_sym_q(bb_data_cos0, bb_data_cos0, tx_data(15 downto 14)) +
							get_sym_q(bb_data_cos2, bb_data_cos2, tx_data(13 downto 12)) +
							get_sym_q(bb_data_cos4, bb_data_cos4, tx_data(11 downto 10)) +
							get_sym_q(bb_data_cos6, bb_data_cos6, tx_data(9 downto 8)) +
							get_sym_q(bb_data_cos8, bb_data_cos8, tx_data(7 downto 6)) +
							get_sym_q(bb_data_cos10, bb_data_cos10, tx_data(5 downto 4)) +
							get_sym_q(bb_data_cos12, bb_data_cos12, tx_data(3 downto 2)) +
							get_sym_q(bb_data_cos14, bb_data_cos14, tx_data(1 downto 0)) +
							bb_data_sin16;
					else
						bb_i <=
							get_sym_i(bb_data_sin0, bb_data_cos0, tx_data(31 downto 30)) +
							get_sym_i(bb_data_sin2, bb_data_cos2, tx_data(29 downto 28)) +
							get_sym_i(bb_data_sin4, bb_data_cos4, tx_data(27 downto 26)) +
							get_sym_i(bb_data_sin6, bb_data_cos6, tx_data(25 downto 24)) +
							get_sym_i(bb_data_sin8, bb_data_cos8, tx_data(23 downto 22)) +
							get_sym_i(bb_data_sin10, bb_data_cos10, tx_data(21 downto 20)) +
							get_sym_i(bb_data_sin12, bb_data_cos12, tx_data(19 downto 18)) +
							get_sym_i(bb_data_sin14, bb_data_cos14, tx_data(17 downto 16)) +
							bb_data_cos16;
						bb_q <=
							get_sym_q(bb_data_cos0, bb_data_cos0, tx_data(31 downto 30)) +
							get_sym_q(bb_data_cos2, bb_data_cos2, tx_data(29 downto 28)) +
							get_sym_q(bb_data_cos4, bb_data_cos4, tx_data(27 downto 26)) +
							get_sym_q(bb_data_cos6, bb_data_cos6, tx_data(25 downto 24)) +
							get_sym_q(bb_data_cos8, bb_data_cos8, tx_data(23 downto 22)) +
							get_sym_q(bb_data_cos10, bb_data_cos10, tx_data(21 downto 20)) +
							get_sym_q(bb_data_cos12, bb_data_cos12, tx_data(19 downto 18)) +
							get_sym_q(bb_data_cos14, bb_data_cos14, tx_data(17 downto 16)) +
							bb_data_sin16;
					end if;
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
