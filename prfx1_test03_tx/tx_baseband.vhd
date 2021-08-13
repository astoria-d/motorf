

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_unsigned.all;

entity tx_baseband is 
	PORT
	(
		signal clk80m : in std_logic;
		signal symbol_cnt : in std_logic_vector(15 downto 0);
		signal symbol_num : in std_logic_vector(7 downto 0);
		signal tx_data : in std_logic_vector(7 downto 0);
		signal i_data : out std_logic_vector(15 downto 0);
		signal q_data : out std_logic_vector(15 downto 0)
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

constant END_SYM_NUM : integer := 99;
constant END_SYM_CNT : integer := 76 * 80 - 1;
constant END_ADDR_CNT : integer := 380 - 1;

signal reg_i_data : std_logic_vector(15 downto 0);
signal reg_q_data : std_logic_vector(15 downto 0);

signal address		: std_logic_vector (12 DOWNTO 0) := (others => '0');
signal mem_data_sin_pilot : std_logic_vector(15 downto 0);
signal mem_data_cos_pilot : std_logic_vector(15 downto 0);

begin

	i_data <= reg_i_data;
	q_data <= reg_q_data;

	sin_pilot_inst : wave_mem generic map ("pilot-sin.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_sin_pilot
	);

	cos_pilot_inst : wave_mem generic map ("pilot-cos.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_cos_pilot
	);

	addr_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if ((conv_integer(symbol_num) = END_SYM_NUM) and (conv_integer(symbol_cnt) = END_SYM_CNT)) then
				address <= (others => '0');
			elsif ((conv_integer(address(12 downto 4)) = END_ADDR_CNT) and (conv_integer(symbol_cnt) = END_SYM_CNT)) then
				address <= (others => '0');
			else
				address <= address + 1;
			end if;
		end if;
	end process;

	bb_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conv_integer(symbol_num) = 0) then
				--symbol 0: no data
				reg_i_data <= (others => '0');
				reg_q_data <= (others => '0');
			elsif (conv_integer(symbol_num) = 1) then
				--symbol 1: pilot only
				reg_i_data <= mem_data_cos_pilot;
				reg_q_data <= mem_data_sin_pilot;
			elsif (conv_integer(symbol_num) = 2) then
				--symbol 2: define phase 0.
				reg_i_data <= (others => '0');
				reg_q_data <= (others => '0');
			else
				--baseband encoding
				reg_i_data <= (others => '0');
				reg_q_data <= (others => '0');
			end if;
		end if;
	end process;

end rtl;

