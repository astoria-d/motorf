

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.motorf.all;

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
signal mem_data_sin0 : std_logic_vector(15 downto 0);
signal mem_data_sin1 : std_logic_vector(15 downto 0);
signal mem_data_sin2 : std_logic_vector(15 downto 0);
signal mem_data_sin3 : std_logic_vector(15 downto 0);
signal mem_data_sin4 : std_logic_vector(15 downto 0);
signal mem_data_sin5 : std_logic_vector(15 downto 0);
signal mem_data_sin6 : std_logic_vector(15 downto 0);
signal mem_data_sin7 : std_logic_vector(15 downto 0);
signal mem_data_sin8 : std_logic_vector(15 downto 0);
signal mem_data_sin9 : std_logic_vector(15 downto 0);
signal mem_data_sin10 : std_logic_vector(15 downto 0);
signal mem_data_sin11 : std_logic_vector(15 downto 0);
signal mem_data_sin12 : std_logic_vector(15 downto 0);
signal mem_data_sin13 : std_logic_vector(15 downto 0);
signal mem_data_sin14 : std_logic_vector(15 downto 0);
signal mem_data_sin15 : std_logic_vector(15 downto 0);

signal mem_data_cos_pilot : std_logic_vector(15 downto 0);
signal mem_data_cos0 : std_logic_vector(15 downto 0);
signal mem_data_cos1 : std_logic_vector(15 downto 0);
signal mem_data_cos2 : std_logic_vector(15 downto 0);
signal mem_data_cos3 : std_logic_vector(15 downto 0);
signal mem_data_cos4 : std_logic_vector(15 downto 0);
signal mem_data_cos5 : std_logic_vector(15 downto 0);
signal mem_data_cos6 : std_logic_vector(15 downto 0);
signal mem_data_cos7 : std_logic_vector(15 downto 0);
signal mem_data_cos8 : std_logic_vector(15 downto 0);
signal mem_data_cos9 : std_logic_vector(15 downto 0);
signal mem_data_cos10 : std_logic_vector(15 downto 0);
signal mem_data_cos11 : std_logic_vector(15 downto 0);
signal mem_data_cos12 : std_logic_vector(15 downto 0);
signal mem_data_cos13 : std_logic_vector(15 downto 0);
signal mem_data_cos14 : std_logic_vector(15 downto 0);
signal mem_data_cos15 : std_logic_vector(15 downto 0);

signal tmp_sin_pilot : signed(20 downto 0);
signal tmp_sin0 : signed(20 downto 0);
signal tmp_sin1 : signed(20 downto 0);
signal tmp_sin2 : signed(20 downto 0);
signal tmp_sin3 : signed(20 downto 0);
signal tmp_sin4 : signed(20 downto 0);
signal tmp_sin5 : signed(20 downto 0);
signal tmp_sin6 : signed(20 downto 0);
signal tmp_sin7 : signed(20 downto 0);
signal tmp_sin8 : signed(20 downto 0);
signal tmp_sin9 : signed(20 downto 0);
signal tmp_sin10 : signed(20 downto 0);
signal tmp_sin11 : signed(20 downto 0);
signal tmp_sin12 : signed(20 downto 0);
signal tmp_sin13 : signed(20 downto 0);
signal tmp_sin14 : signed(20 downto 0);
signal tmp_sin15 : signed(20 downto 0);

signal tmp_cos_pilot : signed(20 downto 0);
signal tmp_cos0 : signed(20 downto 0);
signal tmp_cos1 : signed(20 downto 0);
signal tmp_cos2 : signed(20 downto 0);
signal tmp_cos3 : signed(20 downto 0);
signal tmp_cos4 : signed(20 downto 0);
signal tmp_cos5 : signed(20 downto 0);
signal tmp_cos6 : signed(20 downto 0);
signal tmp_cos7 : signed(20 downto 0);
signal tmp_cos8 : signed(20 downto 0);
signal tmp_cos9 : signed(20 downto 0);
signal tmp_cos10 : signed(20 downto 0);
signal tmp_cos11 : signed(20 downto 0);
signal tmp_cos12 : signed(20 downto 0);
signal tmp_cos13 : signed(20 downto 0);
signal tmp_cos14 : signed(20 downto 0);
signal tmp_cos15 : signed(20 downto 0);

begin

	i_data <= reg_i_data;
	q_data <= reg_q_data;

	sin_pilot_inst : wave_mem generic map ("pilot-sin.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_sin_pilot
	);
	sin0_inst : wave_mem generic map ("wave-sin0.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_sin0
	);
	sin1_inst : wave_mem generic map ("wave-sin1.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_sin1
	);
	sin2_inst : wave_mem generic map ("wave-sin2.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_sin2
	);
	sin3_inst : wave_mem generic map ("wave-sin3.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_sin3
	);
	sin4_inst : wave_mem generic map ("wave-sin4.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_sin4
	);
	sin5_inst : wave_mem generic map ("wave-sin5.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_sin5
	);
	sin6_inst : wave_mem generic map ("wave-sin6.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_sin6
	);
	sin7_inst : wave_mem generic map ("wave-sin7.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_sin7
	);
	sin8_inst : wave_mem generic map ("wave-sin8.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_sin8
	);
	sin9_inst : wave_mem generic map ("wave-sin9.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_sin9
	);
	sin10_inst : wave_mem generic map ("wave-sin10.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_sin10
	);
	sin11_inst : wave_mem generic map ("wave-sin11.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_sin11
	);
	sin12_inst : wave_mem generic map ("wave-sin12.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_sin12
	);
	sin13_inst : wave_mem generic map ("wave-sin13.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_sin13
	);
	sin114_inst : wave_mem generic map ("wave-sin14.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_sin14
	);
	sin15_inst : wave_mem generic map ("wave-sin15.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_sin15
	);

	cos_pilot_inst : wave_mem generic map ("pilot-cos.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_cos_pilot
	);
	cos0_inst : wave_mem generic map ("wave-cos0.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_cos0
	);
	cos1_inst : wave_mem generic map ("wave-cos1.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_cos1
	);
	cos2_inst : wave_mem generic map ("wave-cos2.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_cos2
	);
	cos3_inst : wave_mem generic map ("wave-cos3.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_cos3
	);
	cos4_inst : wave_mem generic map ("wave-cos4.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_cos4
	);
	cos5_inst : wave_mem generic map ("wave-cos5.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_cos5
	);
	cos6_inst : wave_mem generic map ("wave-cos6.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_cos6
	);
	cos7_inst : wave_mem generic map ("wave-cos7.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_cos7
	);
	cos8_inst : wave_mem generic map ("wave-cos8.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_cos8
	);
	cos9_inst : wave_mem generic map ("wave-cos9.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_cos9
	);
	cos10_inst : wave_mem generic map ("wave-cos10.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_cos10
	);
	cos11_inst : wave_mem generic map ("wave-cos11.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_cos11
	);
	cos12_inst : wave_mem generic map ("wave-cos12.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_cos12
	);
	cos13_inst : wave_mem generic map ("wave-cos13.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_cos13
	);
	cos14_inst : wave_mem generic map ("wave-cos14.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_cos14
	);
	cos15_inst : wave_mem generic map ("wave-cos15.mif")
	PORT MAP (
		address   => address(12 downto 4),
		clock	=> clk80m,
		q	=> mem_data_cos15
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

	cast_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			tmp_sin0 <= sign_extend_16_to_21(signed(mem_data_sin0));
			tmp_sin1 <= sign_extend_16_to_21(signed(mem_data_sin1));
			tmp_sin2 <= sign_extend_16_to_21(signed(mem_data_sin2));
			tmp_sin3 <= sign_extend_16_to_21(signed(mem_data_sin3));
			tmp_sin4 <= sign_extend_16_to_21(signed(mem_data_sin4));
			tmp_sin5 <= sign_extend_16_to_21(signed(mem_data_sin5));
			tmp_sin6 <= sign_extend_16_to_21(signed(mem_data_sin6));
			tmp_sin7 <= sign_extend_16_to_21(signed(mem_data_sin7));
			tmp_sin8 <= sign_extend_16_to_21(signed(mem_data_sin8));
			tmp_sin9 <= sign_extend_16_to_21(signed(mem_data_sin9));
			tmp_sin10 <= sign_extend_16_to_21(signed(mem_data_sin10));
			tmp_sin11 <= sign_extend_16_to_21(signed(mem_data_sin11));
			tmp_sin12 <= sign_extend_16_to_21(signed(mem_data_sin12));
			tmp_sin13 <= sign_extend_16_to_21(signed(mem_data_sin13));
			tmp_sin14 <= sign_extend_16_to_21(signed(mem_data_sin14));
			tmp_sin15 <= sign_extend_16_to_21(signed(mem_data_sin15));
			tmp_sin_pilot <= sign_extend_16_to_21(signed(mem_data_sin_pilot));

			tmp_cos0 <= sign_extend_16_to_21(signed(mem_data_cos0));
			tmp_cos1 <= sign_extend_16_to_21(signed(mem_data_cos1));
			tmp_cos2 <= sign_extend_16_to_21(signed(mem_data_cos2));
			tmp_cos3 <= sign_extend_16_to_21(signed(mem_data_cos3));
			tmp_cos4 <= sign_extend_16_to_21(signed(mem_data_cos4));
			tmp_cos5 <= sign_extend_16_to_21(signed(mem_data_cos5));
			tmp_cos6 <= sign_extend_16_to_21(signed(mem_data_cos6));
			tmp_cos7 <= sign_extend_16_to_21(signed(mem_data_cos7));
			tmp_cos8 <= sign_extend_16_to_21(signed(mem_data_cos8));
			tmp_cos9 <= sign_extend_16_to_21(signed(mem_data_cos9));
			tmp_cos10 <= sign_extend_16_to_21(signed(mem_data_cos10));
			tmp_cos11 <= sign_extend_16_to_21(signed(mem_data_cos11));
			tmp_cos12 <= sign_extend_16_to_21(signed(mem_data_cos12));
			tmp_cos13 <= sign_extend_16_to_21(signed(mem_data_cos13));
			tmp_cos14 <= sign_extend_16_to_21(signed(mem_data_cos14));
			tmp_cos15 <= sign_extend_16_to_21(signed(mem_data_cos15));
			tmp_cos_pilot <= sign_extend_16_to_21(signed(mem_data_cos_pilot));
		end if;
	end process;

	bb_p : process (clk80m)
	variable tmp_i : integer;
	variable tmp_q : integer;
	begin
		if (rising_edge(clk80m)) then
			if (conv_integer(symbol_num) = 0) then
				--symbol 0: no data
				tmp_i := 0;
				tmp_q := 0;
			elsif (conv_integer(symbol_num) = 1) then
				--symbol 1: pilot only
				tmp_i := conv_integer(mem_data_cos_pilot);
				tmp_q := conv_integer(mem_data_sin_pilot);
			elsif (conv_integer(symbol_num) = 2) then
				--symbol 2: define phase 0.
				tmp_i := conv_integer(tmp_cos0 +
					tmp_cos1 +
					tmp_cos2 +
					tmp_cos3 +
					tmp_cos4 +
					tmp_cos5 +
					tmp_cos6 +
					tmp_cos7 +
					tmp_cos8 +
					tmp_cos9 +
					tmp_cos10 +
					tmp_cos11 +
					tmp_cos12 +
					tmp_cos13 +
					tmp_cos14 +
					tmp_cos15) * 5 / 64;
				tmp_q := conv_integer(tmp_sin0 +
					tmp_sin1 +
					tmp_sin2 +
					tmp_sin3 +
					tmp_sin4 +
					tmp_sin5 +
					tmp_sin6 +
					tmp_sin7 +
					tmp_sin8 +
					tmp_sin9 +
					tmp_sin10 +
					tmp_sin11 +
					tmp_sin12 +
					tmp_sin13 +
					tmp_sin14 +
					tmp_sin15) * 5 / 64;
			else
				--baseband encoding
				tmp_i := 0;
				tmp_q := 0;
			end if;
			reg_i_data <= conv_std_logic_vector(tmp_i, 16);
			reg_q_data <= conv_std_logic_vector(tmp_q, 16);
		end if;
	end process;

end rtl;

