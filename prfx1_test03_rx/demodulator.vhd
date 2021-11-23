library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use work.motorf.all;

entity demodulator is
	port (
	signal clk80m		: in std_logic;
	signal symbol_num : in std_logic_vector(7 downto 0);
	signal symbol_cnt : in std_logic_vector(15 downto 0);
	signal indata		: in std_logic_vector(31 downto 0);
	signal out_byte	: out std_logic_vector(7 downto 0);
	signal out_en		: out std_logic
	);
end demodulator;

architecture rtl of demodulator is

component wave_mem
	generic (mif_file : string := "null-file.mif");
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
end component;

component multi_0
	PORT
	(
		clock		: IN STD_LOGIC ;
		dataa		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;

component demod_sram
	PORT
	(
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		wraddress		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		wren		: IN STD_LOGIC  := '0';
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;

signal rom_addr : std_logic_vector(8 downto 0);

signal rom_sin0 : std_logic_vector(15 downto 0);
signal rom_sin1 : std_logic_vector(15 downto 0);
signal rom_sin2 : std_logic_vector(15 downto 0);
signal rom_sin3 : std_logic_vector(15 downto 0);
signal rom_sin4 : std_logic_vector(15 downto 0);
signal rom_sin5 : std_logic_vector(15 downto 0);
signal rom_sin6 : std_logic_vector(15 downto 0);
signal rom_sin7 : std_logic_vector(15 downto 0);
signal rom_sin8 : std_logic_vector(15 downto 0);
signal rom_sin9 : std_logic_vector(15 downto 0);
signal rom_sin10 : std_logic_vector(15 downto 0);
signal rom_sin11 : std_logic_vector(15 downto 0);
signal rom_sin12 : std_logic_vector(15 downto 0);
signal rom_sin13 : std_logic_vector(15 downto 0);
signal rom_sin14 : std_logic_vector(15 downto 0);
signal rom_sin15 : std_logic_vector(15 downto 0);

signal rom_cos0 : std_logic_vector(15 downto 0);
signal rom_cos1 : std_logic_vector(15 downto 0);
signal rom_cos2 : std_logic_vector(15 downto 0);
signal rom_cos3 : std_logic_vector(15 downto 0);
signal rom_cos4 : std_logic_vector(15 downto 0);
signal rom_cos5 : std_logic_vector(15 downto 0);
signal rom_cos6 : std_logic_vector(15 downto 0);
signal rom_cos7 : std_logic_vector(15 downto 0);
signal rom_cos8 : std_logic_vector(15 downto 0);
signal rom_cos9 : std_logic_vector(15 downto 0);
signal rom_cos10 : std_logic_vector(15 downto 0);
signal rom_cos11 : std_logic_vector(15 downto 0);
signal rom_cos12 : std_logic_vector(15 downto 0);
signal rom_cos13 : std_logic_vector(15 downto 0);
signal rom_cos14 : std_logic_vector(15 downto 0);
signal rom_cos15 : std_logic_vector(15 downto 0);

signal multi_s0 : std_logic_vector(31 downto 0);
signal multi_s1 : std_logic_vector(31 downto 0);
signal multi_s2 : std_logic_vector(31 downto 0);
signal multi_s3 : std_logic_vector(31 downto 0);
signal multi_s4 : std_logic_vector(31 downto 0);
signal multi_s5 : std_logic_vector(31 downto 0);
signal multi_s6 : std_logic_vector(31 downto 0);
signal multi_s7 : std_logic_vector(31 downto 0);
signal multi_s8 : std_logic_vector(31 downto 0);
signal multi_s9 : std_logic_vector(31 downto 0);
signal multi_s10 : std_logic_vector(31 downto 0);
signal multi_s11 : std_logic_vector(31 downto 0);
signal multi_s12 : std_logic_vector(31 downto 0);
signal multi_s13 : std_logic_vector(31 downto 0);
signal multi_s14 : std_logic_vector(31 downto 0);
signal multi_s15 : std_logic_vector(31 downto 0);

signal multi_c0 : std_logic_vector(31 downto 0);
signal multi_c1 : std_logic_vector(31 downto 0);
signal multi_c2 : std_logic_vector(31 downto 0);
signal multi_c3 : std_logic_vector(31 downto 0);
signal multi_c4 : std_logic_vector(31 downto 0);
signal multi_c5 : std_logic_vector(31 downto 0);
signal multi_c6 : std_logic_vector(31 downto 0);
signal multi_c7 : std_logic_vector(31 downto 0);
signal multi_c8 : std_logic_vector(31 downto 0);
signal multi_c9 : std_logic_vector(31 downto 0);
signal multi_c10 : std_logic_vector(31 downto 0);
signal multi_c11 : std_logic_vector(31 downto 0);
signal multi_c12 : std_logic_vector(31 downto 0);
signal multi_c13 : std_logic_vector(31 downto 0);
signal multi_c14 : std_logic_vector(31 downto 0);
signal multi_c15 : std_logic_vector(31 downto 0);

constant offset : integer := 7 * 80;
signal wren_base : std_logic;
signal wren_result : std_logic;

signal wdata_s0 : std_logic_vector(31 downto 0);
signal wdata_s1 : std_logic_vector(31 downto 0);
signal wdata_s2 : std_logic_vector(31 downto 0);
signal wdata_s3 : std_logic_vector(31 downto 0);
signal wdata_s4 : std_logic_vector(31 downto 0);
signal wdata_s5 : std_logic_vector(31 downto 0);
signal wdata_s6 : std_logic_vector(31 downto 0);
signal wdata_s7 : std_logic_vector(31 downto 0);
signal wdata_s8 : std_logic_vector(31 downto 0);
signal wdata_s9 : std_logic_vector(31 downto 0);
signal wdata_s10 : std_logic_vector(31 downto 0);
signal wdata_s11 : std_logic_vector(31 downto 0);
signal wdata_s12 : std_logic_vector(31 downto 0);
signal wdata_s13 : std_logic_vector(31 downto 0);
signal wdata_s14 : std_logic_vector(31 downto 0);
signal wdata_s15 : std_logic_vector(31 downto 0);

signal wdata_c0 : std_logic_vector(31 downto 0);
signal wdata_c1 : std_logic_vector(31 downto 0);
signal wdata_c2 : std_logic_vector(31 downto 0);
signal wdata_c3 : std_logic_vector(31 downto 0);
signal wdata_c4 : std_logic_vector(31 downto 0);
signal wdata_c5 : std_logic_vector(31 downto 0);
signal wdata_c6 : std_logic_vector(31 downto 0);
signal wdata_c7 : std_logic_vector(31 downto 0);
signal wdata_c8 : std_logic_vector(31 downto 0);
signal wdata_c9 : std_logic_vector(31 downto 0);
signal wdata_c10 : std_logic_vector(31 downto 0);
signal wdata_c11 : std_logic_vector(31 downto 0);
signal wdata_c12 : std_logic_vector(31 downto 0);
signal wdata_c13 : std_logic_vector(31 downto 0);
signal wdata_c14 : std_logic_vector(31 downto 0);
signal wdata_c15 : std_logic_vector(31 downto 0);

signal result_s0 : std_logic_vector(31 downto 0);
signal result_s1 : std_logic_vector(31 downto 0);
signal result_s2 : std_logic_vector(31 downto 0);
signal result_s3 : std_logic_vector(31 downto 0);
signal result_s4 : std_logic_vector(31 downto 0);
signal result_s5 : std_logic_vector(31 downto 0);
signal result_s6 : std_logic_vector(31 downto 0);
signal result_s7 : std_logic_vector(31 downto 0);
signal result_s8 : std_logic_vector(31 downto 0);
signal result_s9 : std_logic_vector(31 downto 0);
signal result_s10 : std_logic_vector(31 downto 0);
signal result_s11 : std_logic_vector(31 downto 0);
signal result_s12 : std_logic_vector(31 downto 0);
signal result_s13 : std_logic_vector(31 downto 0);
signal result_s14 : std_logic_vector(31 downto 0);
signal result_s15 : std_logic_vector(31 downto 0);

signal result_c0 : std_logic_vector(31 downto 0);
signal result_c1 : std_logic_vector(31 downto 0);
signal result_c2 : std_logic_vector(31 downto 0);
signal result_c3 : std_logic_vector(31 downto 0);
signal result_c4 : std_logic_vector(31 downto 0);
signal result_c5 : std_logic_vector(31 downto 0);
signal result_c6 : std_logic_vector(31 downto 0);
signal result_c7 : std_logic_vector(31 downto 0);
signal result_c8 : std_logic_vector(31 downto 0);
signal result_c9 : std_logic_vector(31 downto 0);
signal result_c10 : std_logic_vector(31 downto 0);
signal result_c11 : std_logic_vector(31 downto 0);
signal result_c12 : std_logic_vector(31 downto 0);
signal result_c13 : std_logic_vector(31 downto 0);
signal result_c14 : std_logic_vector(31 downto 0);
signal result_c15 : std_logic_vector(31 downto 0);

signal base_s0 : std_logic_vector(31 downto 0);
signal base_s1 : std_logic_vector(31 downto 0);
signal base_s2 : std_logic_vector(31 downto 0);
signal base_s3 : std_logic_vector(31 downto 0);
signal base_s4 : std_logic_vector(31 downto 0);
signal base_s5 : std_logic_vector(31 downto 0);
signal base_s6 : std_logic_vector(31 downto 0);
signal base_s7 : std_logic_vector(31 downto 0);
signal base_s8 : std_logic_vector(31 downto 0);
signal base_s9 : std_logic_vector(31 downto 0);
signal base_s10 : std_logic_vector(31 downto 0);
signal base_s11 : std_logic_vector(31 downto 0);
signal base_s12 : std_logic_vector(31 downto 0);
signal base_s13 : std_logic_vector(31 downto 0);
signal base_s14 : std_logic_vector(31 downto 0);
signal base_s15 : std_logic_vector(31 downto 0);

signal base_c0 : std_logic_vector(31 downto 0);
signal base_c1 : std_logic_vector(31 downto 0);
signal base_c2 : std_logic_vector(31 downto 0);
signal base_c3 : std_logic_vector(31 downto 0);
signal base_c4 : std_logic_vector(31 downto 0);
signal base_c5 : std_logic_vector(31 downto 0);
signal base_c6 : std_logic_vector(31 downto 0);
signal base_c7 : std_logic_vector(31 downto 0);
signal base_c8 : std_logic_vector(31 downto 0);
signal base_c9 : std_logic_vector(31 downto 0);
signal base_c10 : std_logic_vector(31 downto 0);
signal base_c11 : std_logic_vector(31 downto 0);
signal base_c12 : std_logic_vector(31 downto 0);
signal base_c13 : std_logic_vector(31 downto 0);
signal base_c14 : std_logic_vector(31 downto 0);
signal base_c15 : std_logic_vector(31 downto 0);

signal dmulti0_0 : std_logic_vector(31 downto 0);
signal dmulti0_1 : std_logic_vector(31 downto 0);
signal dmulti0_2 : std_logic_vector(31 downto 0);
signal dmulti0_3 : std_logic_vector(31 downto 0);

signal dmulti1_0 : std_logic_vector(31 downto 0);
signal dmulti1_1 : std_logic_vector(31 downto 0);
signal dmulti1_2 : std_logic_vector(31 downto 0);
signal dmulti1_3 : std_logic_vector(31 downto 0);

signal dmulti2_0 : std_logic_vector(31 downto 0);
signal dmulti2_1 : std_logic_vector(31 downto 0);
signal dmulti2_2 : std_logic_vector(31 downto 0);
signal dmulti2_3 : std_logic_vector(31 downto 0);

signal dmulti3_0 : std_logic_vector(31 downto 0);
signal dmulti3_1 : std_logic_vector(31 downto 0);
signal dmulti3_2 : std_logic_vector(31 downto 0);
signal dmulti3_3 : std_logic_vector(31 downto 0);

signal dmulti4_0 : std_logic_vector(31 downto 0);
signal dmulti4_1 : std_logic_vector(31 downto 0);
signal dmulti4_2 : std_logic_vector(31 downto 0);
signal dmulti4_3 : std_logic_vector(31 downto 0);

signal dmulti5_0 : std_logic_vector(31 downto 0);
signal dmulti5_1 : std_logic_vector(31 downto 0);
signal dmulti5_2 : std_logic_vector(31 downto 0);
signal dmulti5_3 : std_logic_vector(31 downto 0);

signal dmulti6_0 : std_logic_vector(31 downto 0);
signal dmulti6_1 : std_logic_vector(31 downto 0);
signal dmulti6_2 : std_logic_vector(31 downto 0);
signal dmulti6_3 : std_logic_vector(31 downto 0);

signal dmulti7_0 : std_logic_vector(31 downto 0);
signal dmulti7_1 : std_logic_vector(31 downto 0);
signal dmulti7_2 : std_logic_vector(31 downto 0);
signal dmulti7_3 : std_logic_vector(31 downto 0);

signal dmulti8_0 : std_logic_vector(31 downto 0);
signal dmulti8_1 : std_logic_vector(31 downto 0);
signal dmulti8_2 : std_logic_vector(31 downto 0);
signal dmulti8_3 : std_logic_vector(31 downto 0);

signal dmulti9_0 : std_logic_vector(31 downto 0);
signal dmulti9_1 : std_logic_vector(31 downto 0);
signal dmulti9_2 : std_logic_vector(31 downto 0);
signal dmulti9_3 : std_logic_vector(31 downto 0);

signal dmulti10_0 : std_logic_vector(31 downto 0);
signal dmulti10_1 : std_logic_vector(31 downto 0);
signal dmulti10_2 : std_logic_vector(31 downto 0);
signal dmulti10_3 : std_logic_vector(31 downto 0);

signal dmulti11_0 : std_logic_vector(31 downto 0);
signal dmulti11_1 : std_logic_vector(31 downto 0);
signal dmulti11_2 : std_logic_vector(31 downto 0);
signal dmulti11_3 : std_logic_vector(31 downto 0);

signal dmulti12_0 : std_logic_vector(31 downto 0);
signal dmulti12_1 : std_logic_vector(31 downto 0);
signal dmulti12_2 : std_logic_vector(31 downto 0);
signal dmulti12_3 : std_logic_vector(31 downto 0);

signal dmulti13_0 : std_logic_vector(31 downto 0);
signal dmulti13_1 : std_logic_vector(31 downto 0);
signal dmulti13_2 : std_logic_vector(31 downto 0);
signal dmulti13_3 : std_logic_vector(31 downto 0);

signal dmulti14_0 : std_logic_vector(31 downto 0);
signal dmulti14_1 : std_logic_vector(31 downto 0);
signal dmulti14_2 : std_logic_vector(31 downto 0);
signal dmulti14_3 : std_logic_vector(31 downto 0);

signal dmulti15_0 : std_logic_vector(31 downto 0);
signal dmulti15_1 : std_logic_vector(31 downto 0);
signal dmulti15_2 : std_logic_vector(31 downto 0);
signal dmulti15_3 : std_logic_vector(31 downto 0);

signal conste_i_data0 : signed(31 downto 0);
signal conste_i_data1 : signed(31 downto 0);
signal conste_i_data2 : signed(31 downto 0);
signal conste_i_data3 : signed(31 downto 0);
signal conste_i_data4 : signed(31 downto 0);
signal conste_i_data5 : signed(31 downto 0);
signal conste_i_data6 : signed(31 downto 0);
signal conste_i_data7 : signed(31 downto 0);
signal conste_i_data8 : signed(31 downto 0);
signal conste_i_data9 : signed(31 downto 0);
signal conste_i_data10 : signed(31 downto 0);
signal conste_i_data11 : signed(31 downto 0);
signal conste_i_data12 : signed(31 downto 0);
signal conste_i_data13 : signed(31 downto 0);
signal conste_i_data14 : signed(31 downto 0);
signal conste_i_data15 : signed(31 downto 0);

signal conste_q_data0 : signed(31 downto 0);
signal conste_q_data1 : signed(31 downto 0);
signal conste_q_data2 : signed(31 downto 0);
signal conste_q_data3 : signed(31 downto 0);
signal conste_q_data4 : signed(31 downto 0);
signal conste_q_data5 : signed(31 downto 0);
signal conste_q_data6 : signed(31 downto 0);
signal conste_q_data7 : signed(31 downto 0);
signal conste_q_data8 : signed(31 downto 0);
signal conste_q_data9 : signed(31 downto 0);
signal conste_q_data10 : signed(31 downto 0);
signal conste_q_data11 : signed(31 downto 0);
signal conste_q_data12 : signed(31 downto 0);
signal conste_q_data13 : signed(31 downto 0);
signal conste_q_data14 : signed(31 downto 0);
signal conste_q_data15 : signed(31 downto 0);

signal out_word : std_logic_vector(31 downto 0);

begin

	out_en <= '1';

	addr_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			-- symbol_cnt is 0 - 6080. make it 0 - 380 by 1/16
			-- rom read from 6 us
			rom_addr <= conv_std_logic_vector((conv_integer(unsigned(symbol_cnt)) - 6 * 80) / 16, rom_addr'length);
		end if;
	end process;

	sin0_inst : wave_mem generic map ("wave-sin0.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_sin0 );
	sin1_inst : wave_mem generic map ("wave-sin1.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_sin1 );
	sin2_inst : wave_mem generic map ("wave-sin2.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_sin2 );
	sin3_inst : wave_mem generic map ("wave-sin3.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_sin3 );
	sin4_inst : wave_mem generic map ("wave-sin4.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_sin4 );
	sin5_inst : wave_mem generic map ("wave-sin5.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_sin5 );
	sin6_inst : wave_mem generic map ("wave-sin6.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_sin6 );
	sin7_inst : wave_mem generic map ("wave-sin7.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_sin7 );
	sin8_inst : wave_mem generic map ("wave-sin8.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_sin8 );
	sin9_inst : wave_mem generic map ("wave-sin9.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_sin9 );
	sin10_inst : wave_mem generic map ("wave-sin10.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_sin10 );
	sin11_inst : wave_mem generic map ("wave-sin11.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_sin11 );
	sin12_inst : wave_mem generic map ("wave-sin12.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_sin12 );
	sin13_inst : wave_mem generic map ("wave-sin13.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_sin13 );
	sin14_inst : wave_mem generic map ("wave-sin14.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_sin14 );
	sin15_inst : wave_mem generic map ("wave-sin15.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_sin15 );

	cos0_inst : wave_mem generic map ("wave-cos0.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_cos0 );
	cos1_inst : wave_mem generic map ("wave-cos1.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_cos1 );
	cos2_inst : wave_mem generic map ("wave-cos2.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_cos2 );
	cos3_inst : wave_mem generic map ("wave-cos3.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_cos3 );
	cos4_inst : wave_mem generic map ("wave-cos4.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_cos4 );
	cos5_inst : wave_mem generic map ("wave-cos5.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_cos5 );
	cos6_inst : wave_mem generic map ("wave-cos6.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_cos6 );
	cos7_inst : wave_mem generic map ("wave-cos7.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_cos7 );
	cos8_inst : wave_mem generic map ("wave-cos8.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_cos8 );
	cos9_inst : wave_mem generic map ("wave-cos9.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_cos9 );
	cos10_inst : wave_mem generic map ("wave-cos10.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_cos10 );
	cos11_inst : wave_mem generic map ("wave-cos11.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_cos11 );
	cos12_inst : wave_mem generic map ("wave-cos12.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_cos12 );
	cos13_inst : wave_mem generic map ("wave-cos13.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_cos13 );
	cos14_inst : wave_mem generic map ("wave-cos14.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_cos14 );
	cos15_inst : wave_mem generic map ("wave-cos15.mif") PORT MAP ( address => rom_addr, clock => clk80m, q => rom_cos15 );

	mul_s0_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_sin0, result => multi_s0 );
	mul_s1_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_sin1, result => multi_s1 );
	mul_s2_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_sin2, result => multi_s2 );
	mul_s3_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_sin3, result => multi_s3 );
	mul_s4_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_sin4, result => multi_s4 );
	mul_s5_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_sin5, result => multi_s5 );
	mul_s6_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_sin6, result => multi_s6 );
	mul_s7_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_sin7, result => multi_s7 );
	mul_s8_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_sin8, result => multi_s8 );
	mul_s9_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_sin9, result => multi_s9 );
	mul_s10_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_sin10, result => multi_s10 );
	mul_s11_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_sin11, result => multi_s11 );
	mul_s12_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_sin12, result => multi_s12 );
	mul_s13_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_sin13, result => multi_s13 );
	mul_s14_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_sin14, result => multi_s14 );
	mul_s15_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_sin15, result => multi_s15 );

	mul_c0_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_cos0, result => multi_c0 );
	mul_c1_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_cos1, result => multi_c1 );
	mul_c2_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_cos2, result => multi_c2 );
	mul_c3_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_cos3, result => multi_c3 );
	mul_c4_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_cos4, result => multi_c4 );
	mul_c5_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_cos5, result => multi_c5 );
	mul_c6_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_cos6, result => multi_c6 );
	mul_c7_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_cos7, result => multi_c7 );
	mul_c8_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_cos8, result => multi_c8 );
	mul_c9_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_cos9, result => multi_c9 );
	mul_c10_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_cos10, result => multi_c10 );
	mul_c11_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_cos11, result => multi_c11 );
	mul_c12_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_cos12, result => multi_c12 );
	mul_c13_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_cos13, result => multi_c13 );
	mul_c14_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_cos14, result => multi_c14 );
	mul_c15_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_cos15, result => multi_c15 );


	we_base_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (symbol_cnt >= 7 + offset and symbol_cnt < 64 * 80 + 7 + offset and symbol_num = 2) then
				wren_base <= '1';
			else
				wren_base <= '0';
			end if;
		end if;
	end process;

	we_result_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (symbol_cnt >= 7 + offset and symbol_cnt < 64 * 80 + 7 + offset) then
				wren_result <= '1';
			else
				wren_result <= '0';
			end if;
		end if;
	end process;

	wdata_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (symbol_cnt >= 7 + offset and symbol_cnt < 7 + 16 + offset) then
				wdata_s0 <= conv_std_logic_vector(conv_integer(signed(multi_s0)) / 32, wdata_s0'length);
				wdata_s1 <= conv_std_logic_vector(conv_integer(signed(multi_s1)) / 32, wdata_s0'length);
				wdata_s2 <= conv_std_logic_vector(conv_integer(signed(multi_s2)) / 32, wdata_s0'length);
				wdata_s3 <= conv_std_logic_vector(conv_integer(signed(multi_s3)) / 32, wdata_s0'length);
				wdata_s4 <= conv_std_logic_vector(conv_integer(signed(multi_s4)) / 32, wdata_s0'length);
				wdata_s5 <= conv_std_logic_vector(conv_integer(signed(multi_s5)) / 32, wdata_s0'length);
				wdata_s6 <= conv_std_logic_vector(conv_integer(signed(multi_s6)) / 32, wdata_s0'length);
				wdata_s7 <= conv_std_logic_vector(conv_integer(signed(multi_s7)) / 32, wdata_s0'length);
				wdata_s8 <= conv_std_logic_vector(conv_integer(signed(multi_s8)) / 32, wdata_s0'length);
				wdata_s9 <= conv_std_logic_vector(conv_integer(signed(multi_s9)) / 32, wdata_s0'length);
				wdata_s10 <= conv_std_logic_vector(conv_integer(signed(multi_s10)) / 32, wdata_s0'length);
				wdata_s11 <= conv_std_logic_vector(conv_integer(signed(multi_s11)) / 32, wdata_s0'length);
				wdata_s12 <= conv_std_logic_vector(conv_integer(signed(multi_s12)) / 32, wdata_s0'length);
				wdata_s13 <= conv_std_logic_vector(conv_integer(signed(multi_s13)) / 32, wdata_s0'length);
				wdata_s14 <= conv_std_logic_vector(conv_integer(signed(multi_s14)) / 32, wdata_s0'length);
				wdata_s15 <= conv_std_logic_vector(conv_integer(signed(multi_s15)) / 32, wdata_s0'length);

				wdata_c0 <= conv_std_logic_vector(conv_integer(signed(multi_c0)) / 32, wdata_c0'length);
				wdata_c1 <= conv_std_logic_vector(conv_integer(signed(multi_c1)) / 32, wdata_c0'length);
				wdata_c2 <= conv_std_logic_vector(conv_integer(signed(multi_c2)) / 32, wdata_c0'length);
				wdata_c3 <= conv_std_logic_vector(conv_integer(signed(multi_c3)) / 32, wdata_c0'length);
				wdata_c4 <= conv_std_logic_vector(conv_integer(signed(multi_c4)) / 32, wdata_c0'length);
				wdata_c5 <= conv_std_logic_vector(conv_integer(signed(multi_c5)) / 32, wdata_c0'length);
				wdata_c6 <= conv_std_logic_vector(conv_integer(signed(multi_c6)) / 32, wdata_c0'length);
				wdata_c7 <= conv_std_logic_vector(conv_integer(signed(multi_c7)) / 32, wdata_c0'length);
				wdata_c8 <= conv_std_logic_vector(conv_integer(signed(multi_c8)) / 32, wdata_c0'length);
				wdata_c9 <= conv_std_logic_vector(conv_integer(signed(multi_c9)) / 32, wdata_c0'length);
				wdata_c10 <= conv_std_logic_vector(conv_integer(signed(multi_c10)) / 32, wdata_c0'length);
				wdata_c11 <= conv_std_logic_vector(conv_integer(signed(multi_c11)) / 32, wdata_c0'length);
				wdata_c12 <= conv_std_logic_vector(conv_integer(signed(multi_c12)) / 32, wdata_c0'length);
				wdata_c13 <= conv_std_logic_vector(conv_integer(signed(multi_c13)) / 32, wdata_c0'length);
				wdata_c14 <= conv_std_logic_vector(conv_integer(signed(multi_c14)) / 32, wdata_c0'length);
				wdata_c15 <= conv_std_logic_vector(conv_integer(signed(multi_c15)) / 32, wdata_c0'length);
			else
				wdata_s0 <= conv_std_logic_vector(conv_integer(signed(result_s0) + signed(multi_s0)) / 32, wdata_s0'length);
				wdata_s1 <= conv_std_logic_vector(conv_integer(signed(result_s1) + signed(multi_s1)) / 32, wdata_s0'length);
				wdata_s2 <= conv_std_logic_vector(conv_integer(signed(result_s2) + signed(multi_s2)) / 32, wdata_s0'length);
				wdata_s3 <= conv_std_logic_vector(conv_integer(signed(result_s3) + signed(multi_s3)) / 32, wdata_s0'length);
				wdata_s4 <= conv_std_logic_vector(conv_integer(signed(result_s4) + signed(multi_s4)) / 32, wdata_s0'length);
				wdata_s5 <= conv_std_logic_vector(conv_integer(signed(result_s5) + signed(multi_s5)) / 32, wdata_s0'length);
				wdata_s6 <= conv_std_logic_vector(conv_integer(signed(result_s6) + signed(multi_s6)) / 32, wdata_s0'length);
				wdata_s7 <= conv_std_logic_vector(conv_integer(signed(result_s7) + signed(multi_s7)) / 32, wdata_s0'length);
				wdata_s8 <= conv_std_logic_vector(conv_integer(signed(result_s8) + signed(multi_s8)) / 32, wdata_s0'length);
				wdata_s9 <= conv_std_logic_vector(conv_integer(signed(result_s9) + signed(multi_s9)) / 32, wdata_s0'length);
				wdata_s10 <= conv_std_logic_vector(conv_integer(signed(result_s10) + signed(multi_s10)) / 32, wdata_s0'length);
				wdata_s11 <= conv_std_logic_vector(conv_integer(signed(result_s11) + signed(multi_s11)) / 32, wdata_s0'length);
				wdata_s12 <= conv_std_logic_vector(conv_integer(signed(result_s12) + signed(multi_s12)) / 32, wdata_s0'length);
				wdata_s13 <= conv_std_logic_vector(conv_integer(signed(result_s13) + signed(multi_s13)) / 32, wdata_s0'length);
				wdata_s14 <= conv_std_logic_vector(conv_integer(signed(result_s14) + signed(multi_s14)) / 32, wdata_s0'length);
				wdata_s15 <= conv_std_logic_vector(conv_integer(signed(result_s15) + signed(multi_s15)) / 32, wdata_s0'length);

				wdata_c0 <= conv_std_logic_vector(conv_integer(signed(result_c0) + signed(multi_c0)) / 32, wdata_c0'length);
				wdata_c1 <= conv_std_logic_vector(conv_integer(signed(result_c1) + signed(multi_c1)) / 32, wdata_c0'length);
				wdata_c2 <= conv_std_logic_vector(conv_integer(signed(result_c2) + signed(multi_c2)) / 32, wdata_c0'length);
				wdata_c3 <= conv_std_logic_vector(conv_integer(signed(result_c3) + signed(multi_c3)) / 32, wdata_c0'length);
				wdata_c4 <= conv_std_logic_vector(conv_integer(signed(result_c4) + signed(multi_c4)) / 32, wdata_c0'length);
				wdata_c5 <= conv_std_logic_vector(conv_integer(signed(result_c5) + signed(multi_c5)) / 32, wdata_c0'length);
				wdata_c6 <= conv_std_logic_vector(conv_integer(signed(result_c6) + signed(multi_c6)) / 32, wdata_c0'length);
				wdata_c7 <= conv_std_logic_vector(conv_integer(signed(result_c7) + signed(multi_c7)) / 32, wdata_c0'length);
				wdata_c8 <= conv_std_logic_vector(conv_integer(signed(result_c8) + signed(multi_c8)) / 32, wdata_c0'length);
				wdata_c9 <= conv_std_logic_vector(conv_integer(signed(result_c9) + signed(multi_c9)) / 32, wdata_c0'length);
				wdata_c10 <= conv_std_logic_vector(conv_integer(signed(result_c10) + signed(multi_c10)) / 32, wdata_c0'length);
				wdata_c11 <= conv_std_logic_vector(conv_integer(signed(result_c11) + signed(multi_c11)) / 32, wdata_c0'length);
				wdata_c12 <= conv_std_logic_vector(conv_integer(signed(result_c12) + signed(multi_c12)) / 32, wdata_c0'length);
				wdata_c13 <= conv_std_logic_vector(conv_integer(signed(result_c13) + signed(multi_c13)) / 32, wdata_c0'length);
				wdata_c14 <= conv_std_logic_vector(conv_integer(signed(result_c14) + signed(multi_c14)) / 32, wdata_c0'length);
				wdata_c15 <= conv_std_logic_vector(conv_integer(signed(result_c15) + signed(multi_c15)) / 32, wdata_c0'length);
			end if;
		end if;
	end process;

	base_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (wren_base = '1') then
				base_s0 <= wdata_s0;
				base_s1 <= wdata_s1;
				base_s2 <= wdata_s2;
				base_s3 <= wdata_s3;
				base_s4 <= wdata_s4;
				base_s5 <= wdata_s5;
				base_s6 <= wdata_s6;
				base_s7 <= wdata_s7;
				base_s8 <= wdata_s8;
				base_s9 <= wdata_s9;
				base_s10 <= wdata_s10;
				base_s11 <= wdata_s11;
				base_s12 <= wdata_s12;
				base_s13 <= wdata_s13;
				base_s14 <= wdata_s14;
				base_s15 <= wdata_s15;

				base_c0 <= wdata_c0;
				base_c1 <= wdata_c1;
				base_c2 <= wdata_c2;
				base_c3 <= wdata_c3;
				base_c4 <= wdata_c4;
				base_c5 <= wdata_c5;
				base_c6 <= wdata_c6;
				base_c7 <= wdata_c7;
				base_c8 <= wdata_c8;
				base_c9 <= wdata_c9;
				base_c10 <= wdata_c10;
				base_c11 <= wdata_c11;
				base_c12 <= wdata_c12;
				base_c13 <= wdata_c13;
				base_c14 <= wdata_c14;
				base_c15 <= wdata_c15;
			end if;
		end if;
	end process;

	result_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (wren_result = '1') then
				result_s0 <= wdata_s0;
				result_s1 <= wdata_s1;
				result_s2 <= wdata_s2;
				result_s3 <= wdata_s3;
				result_s4 <= wdata_s4;
				result_s5 <= wdata_s5;
				result_s6 <= wdata_s6;
				result_s7 <= wdata_s7;
				result_s8 <= wdata_s8;
				result_s9 <= wdata_s9;
				result_s10 <= wdata_s10;
				result_s11 <= wdata_s11;
				result_s12 <= wdata_s12;
				result_s13 <= wdata_s13;
				result_s14 <= wdata_s14;
				result_s15 <= wdata_s15;

				result_c0 <= wdata_c0;
				result_c1 <= wdata_c1;
				result_c2 <= wdata_c2;
				result_c3 <= wdata_c3;
				result_c4 <= wdata_c4;
				result_c5 <= wdata_c5;
				result_c6 <= wdata_c6;
				result_c7 <= wdata_c7;
				result_c8 <= wdata_c8;
				result_c9 <= wdata_c9;
				result_c10 <= wdata_c10;
				result_c11 <= wdata_c11;
				result_c12 <= wdata_c12;
				result_c13 <= wdata_c13;
				result_c14 <= wdata_c14;
				result_c15 <= wdata_c15;
			end if;
		end if;
	end process;

	mul_phase_base0_0 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s0(31 downto 16), datab => result_s0(31 downto 16), result => dmulti0_0 );
	mul_phase_base0_1 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c0(31 downto 16), datab => result_c0(31 downto 16), result => dmulti0_1 );
	mul_phase_base0_2 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s0(31 downto 16), datab => result_c0(31 downto 16), result => dmulti0_2 );
	mul_phase_base0_3 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c0(31 downto 16), datab => result_s0(31 downto 16), result => dmulti0_3 );

	mul_phase_base1_0 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s1(31 downto 16), datab => result_s1(31 downto 16), result => dmulti1_0 );
	mul_phase_base1_1 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c1(31 downto 16), datab => result_c1(31 downto 16), result => dmulti1_1 );
	mul_phase_base1_2 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s1(31 downto 16), datab => result_c1(31 downto 16), result => dmulti1_2 );
	mul_phase_base1_3 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c1(31 downto 16), datab => result_s1(31 downto 16), result => dmulti1_3 );

	mul_phase_base2_0 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s2(31 downto 16), datab => result_s2(31 downto 16), result => dmulti2_0 );
	mul_phase_base2_1 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c2(31 downto 16), datab => result_c2(31 downto 16), result => dmulti2_1 );
	mul_phase_base2_2 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s2(31 downto 16), datab => result_c2(31 downto 16), result => dmulti2_2 );
	mul_phase_base2_3 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c2(31 downto 16), datab => result_s2(31 downto 16), result => dmulti2_3 );

	mul_phase_base3_0 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s3(31 downto 16), datab => result_s3(31 downto 16), result => dmulti3_0 );
	mul_phase_base3_1 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c3(31 downto 16), datab => result_c3(31 downto 16), result => dmulti3_1 );
	mul_phase_base3_2 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s3(31 downto 16), datab => result_c3(31 downto 16), result => dmulti3_2 );
	mul_phase_base3_3 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c3(31 downto 16), datab => result_s3(31 downto 16), result => dmulti3_3 );

	mul_phase_base4_0 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s4(31 downto 16), datab => result_s4(31 downto 16), result => dmulti4_0 );
	mul_phase_base4_1 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c4(31 downto 16), datab => result_c4(31 downto 16), result => dmulti4_1 );
	mul_phase_base4_2 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s4(31 downto 16), datab => result_c4(31 downto 16), result => dmulti4_2 );
	mul_phase_base4_3 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c4(31 downto 16), datab => result_s4(31 downto 16), result => dmulti4_3 );

	mul_phase_base5_0 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s5(31 downto 16), datab => result_s5(31 downto 16), result => dmulti5_0 );
	mul_phase_base5_1 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c5(31 downto 16), datab => result_c5(31 downto 16), result => dmulti5_1 );
	mul_phase_base5_2 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s5(31 downto 16), datab => result_c5(31 downto 16), result => dmulti5_2 );
	mul_phase_base5_3 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c5(31 downto 16), datab => result_s5(31 downto 16), result => dmulti5_3 );

	mul_phase_base6_0 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s6(31 downto 16), datab => result_s6(31 downto 16), result => dmulti6_0 );
	mul_phase_base6_1 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c6(31 downto 16), datab => result_c6(31 downto 16), result => dmulti6_1 );
	mul_phase_base6_2 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s6(31 downto 16), datab => result_c6(31 downto 16), result => dmulti6_2 );
	mul_phase_base6_3 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c6(31 downto 16), datab => result_s6(31 downto 16), result => dmulti6_3 );

	mul_phase_base7_0 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s7(31 downto 16), datab => result_s7(31 downto 16), result => dmulti7_0 );
	mul_phase_base7_1 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c7(31 downto 16), datab => result_c7(31 downto 16), result => dmulti7_1 );
	mul_phase_base7_2 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s7(31 downto 16), datab => result_c7(31 downto 16), result => dmulti7_2 );
	mul_phase_base7_3 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c7(31 downto 16), datab => result_s7(31 downto 16), result => dmulti7_3 );

	mul_phase_base8_0 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s8(31 downto 16), datab => result_s8(31 downto 16), result => dmulti8_0 );
	mul_phase_base8_1 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c8(31 downto 16), datab => result_c8(31 downto 16), result => dmulti8_1 );
	mul_phase_base8_2 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s8(31 downto 16), datab => result_c8(31 downto 16), result => dmulti8_2 );
	mul_phase_base8_3 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c8(31 downto 16), datab => result_s8(31 downto 16), result => dmulti8_3 );

	mul_phase_base9_0 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s9(31 downto 16), datab => result_s9(31 downto 16), result => dmulti9_0 );
	mul_phase_base9_1 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c9(31 downto 16), datab => result_c9(31 downto 16), result => dmulti9_1 );
	mul_phase_base9_2 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s9(31 downto 16), datab => result_c9(31 downto 16), result => dmulti9_2 );
	mul_phase_base9_3 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c9(31 downto 16), datab => result_s9(31 downto 16), result => dmulti9_3 );

	mul_phase_base10_0 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s10(31 downto 16), datab => result_s10(31 downto 16), result => dmulti10_0 );
	mul_phase_base10_1 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c10(31 downto 16), datab => result_c10(31 downto 16), result => dmulti10_1 );
	mul_phase_base10_2 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s10(31 downto 16), datab => result_c10(31 downto 16), result => dmulti10_2 );
	mul_phase_base10_3 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c10(31 downto 16), datab => result_s10(31 downto 16), result => dmulti10_3 );

	mul_phase_base11_0 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s11(31 downto 16), datab => result_s11(31 downto 16), result => dmulti11_0 );
	mul_phase_base11_1 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c11(31 downto 16), datab => result_c11(31 downto 16), result => dmulti11_1 );
	mul_phase_base11_2 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s11(31 downto 16), datab => result_c11(31 downto 16), result => dmulti11_2 );
	mul_phase_base11_3 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c11(31 downto 16), datab => result_s11(31 downto 16), result => dmulti11_3 );

	mul_phase_base12_0 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s12(31 downto 16), datab => result_s12(31 downto 16), result => dmulti12_0 );
	mul_phase_base12_1 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c12(31 downto 16), datab => result_c12(31 downto 16), result => dmulti12_1 );
	mul_phase_base12_2 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s12(31 downto 16), datab => result_c12(31 downto 16), result => dmulti12_2 );
	mul_phase_base12_3 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c12(31 downto 16), datab => result_s12(31 downto 16), result => dmulti12_3 );

	mul_phase_base13_0 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s13(31 downto 16), datab => result_s13(31 downto 16), result => dmulti13_0 );
	mul_phase_base13_1 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c13(31 downto 16), datab => result_c13(31 downto 16), result => dmulti13_1 );
	mul_phase_base13_2 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s13(31 downto 16), datab => result_c13(31 downto 16), result => dmulti13_2 );
	mul_phase_base13_3 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c13(31 downto 16), datab => result_s13(31 downto 16), result => dmulti13_3 );

	mul_phase_base14_0 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s14(31 downto 16), datab => result_s14(31 downto 16), result => dmulti14_0 );
	mul_phase_base14_1 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c14(31 downto 16), datab => result_c14(31 downto 16), result => dmulti14_1 );
	mul_phase_base14_2 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s14(31 downto 16), datab => result_c14(31 downto 16), result => dmulti14_2 );
	mul_phase_base14_3 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c14(31 downto 16), datab => result_s14(31 downto 16), result => dmulti14_3 );

	mul_phase_base15_0 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s15(31 downto 16), datab => result_s15(31 downto 16), result => dmulti15_0 );
	mul_phase_base15_1 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c15(31 downto 16), datab => result_c15(31 downto 16), result => dmulti15_1 );
	mul_phase_base15_2 : multi_0 PORT MAP ( clock => clk80m, dataa => base_s15(31 downto 16), datab => result_c15(31 downto 16), result => dmulti15_2 );
	mul_phase_base15_3 : multi_0 PORT MAP ( clock => clk80m, dataa => base_c15(31 downto 16), datab => result_s15(31 downto 16), result => dmulti15_3 );

	constellation_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			conste_i_data0 <= signed(dmulti0_0) + signed(dmulti0_1);
			conste_i_data1 <= signed(dmulti1_0) + signed(dmulti1_1);
			conste_i_data2 <= signed(dmulti2_0) + signed(dmulti2_1);
			conste_i_data3 <= signed(dmulti3_0) + signed(dmulti3_1);
			conste_i_data4 <= signed(dmulti4_0) + signed(dmulti4_1);
			conste_i_data5 <= signed(dmulti5_0) + signed(dmulti5_1);
			conste_i_data6 <= signed(dmulti6_0) + signed(dmulti6_1);
			conste_i_data7 <= signed(dmulti7_0) + signed(dmulti7_1);
			conste_i_data8 <= signed(dmulti8_0) + signed(dmulti8_1);
			conste_i_data9 <= signed(dmulti9_0) + signed(dmulti9_1);
			conste_i_data10 <= signed(dmulti10_0) + signed(dmulti10_1);
			conste_i_data11 <= signed(dmulti11_0) + signed(dmulti11_1);
			conste_i_data12 <= signed(dmulti12_0) + signed(dmulti12_1);
			conste_i_data13 <= signed(dmulti13_0) + signed(dmulti13_1);
			conste_i_data14 <= signed(dmulti14_0) + signed(dmulti14_1);
			conste_i_data15 <= signed(dmulti15_0) + signed(dmulti15_1);

			conste_q_data0 <= signed(dmulti0_2) - signed(dmulti0_3);
			conste_q_data1 <= signed(dmulti1_2) - signed(dmulti1_3);
			conste_q_data2 <= signed(dmulti2_2) - signed(dmulti2_3);
			conste_q_data3 <= signed(dmulti3_2) - signed(dmulti3_3);
			conste_q_data4 <= signed(dmulti4_2) - signed(dmulti4_3);
			conste_q_data5 <= signed(dmulti5_2) - signed(dmulti5_3);
			conste_q_data6 <= signed(dmulti6_2) - signed(dmulti6_3);
			conste_q_data7 <= signed(dmulti7_2) - signed(dmulti7_3);
			conste_q_data8 <= signed(dmulti8_2) - signed(dmulti8_3);
			conste_q_data9 <= signed(dmulti9_2) - signed(dmulti9_3);
			conste_q_data10 <= signed(dmulti10_2) - signed(dmulti10_3);
			conste_q_data11 <= signed(dmulti11_2) - signed(dmulti11_3);
			conste_q_data12 <= signed(dmulti12_2) - signed(dmulti12_3);
			conste_q_data13 <= signed(dmulti13_2) - signed(dmulti13_3);
			conste_q_data14 <= signed(dmulti14_2) - signed(dmulti14_3);
			conste_q_data15 <= signed(dmulti15_2) - signed(dmulti15_3);
		end if;
	end process;

	out_data0_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conste_i_data0 > conste_q_data0 and -conste_i_data0 <= conste_q_data0) then
				out_word(1 downto 0) <= "00";
			elsif (conste_i_data0 <= conste_q_data0 and -conste_i_data0 <= conste_q_data0) then
				out_word(1 downto 0) <= "01";
			elsif (conste_i_data0 <= conste_q_data0 and -conste_i_data0 > conste_q_data0) then
				out_word(1 downto 0) <= "10";
			elsif (conste_i_data0 > conste_q_data0 and -conste_i_data0 > conste_q_data0) then
				out_word(1 downto 0) <= "11";
			end if;
		end if;
	end process;

	out_data1_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conste_i_data1 > conste_q_data1 and -conste_i_data1 <= conste_q_data1) then
				out_word(3 downto 2) <= "00";
			elsif (conste_i_data1 <= conste_q_data1 and -conste_i_data1 <= conste_q_data1) then
				out_word(3 downto 2) <= "01";
			elsif (conste_i_data1 <= conste_q_data1 and -conste_i_data1 > conste_q_data1) then
				out_word(3 downto 2) <= "10";
			elsif (conste_i_data1 > conste_q_data1 and -conste_i_data1 > conste_q_data1) then
				out_word(3 downto 2) <= "11";
			end if;
		end if;
	end process;

	out_data2_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conste_i_data2 > conste_q_data2 and -conste_i_data2 <= conste_q_data2) then
				out_word(5 downto 4) <= "00";
			elsif (conste_i_data2 <= conste_q_data2 and -conste_i_data2 <= conste_q_data2) then
				out_word(5 downto 4) <= "01";
			elsif (conste_i_data2 <= conste_q_data2 and -conste_i_data2 > conste_q_data2) then
				out_word(5 downto 4) <= "10";
			elsif (conste_i_data2 > conste_q_data2 and -conste_i_data2 > conste_q_data2) then
				out_word(5 downto 4) <= "11";
			end if;
		end if;
	end process;

	out_data3_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conste_i_data3 > conste_q_data3 and -conste_i_data3 <= conste_q_data3) then
				out_word(7 downto 6) <= "00";
			elsif (conste_i_data3 <= conste_q_data3 and -conste_i_data3 <= conste_q_data3) then
				out_word(7 downto 6) <= "01";
			elsif (conste_i_data3 <= conste_q_data3 and -conste_i_data3 > conste_q_data3) then
				out_word(7 downto 6) <= "10";
			elsif (conste_i_data3 > conste_q_data3 and -conste_i_data3 > conste_q_data3) then
				out_word(7 downto 6) <= "11";
			end if;
		end if;
	end process;

	out_data4_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conste_i_data4 > conste_q_data4 and -conste_i_data4 <= conste_q_data4) then
				out_word(9 downto 8) <= "00";
			elsif (conste_i_data4 <= conste_q_data4 and -conste_i_data4 <= conste_q_data4) then
				out_word(9 downto 8) <= "01";
			elsif (conste_i_data4 <= conste_q_data4 and -conste_i_data4 > conste_q_data4) then
				out_word(9 downto 8) <= "10";
			elsif (conste_i_data4 > conste_q_data4 and -conste_i_data4 > conste_q_data4) then
				out_word(9 downto 8) <= "11";
			end if;
		end if;
	end process;

	out_data5_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conste_i_data5 > conste_q_data5 and -conste_i_data5 <= conste_q_data5) then
				out_word(11 downto 10) <= "00";
			elsif (conste_i_data5 <= conste_q_data5 and -conste_i_data5 <= conste_q_data5) then
				out_word(11 downto 10) <= "01";
			elsif (conste_i_data5 <= conste_q_data5 and -conste_i_data5 > conste_q_data5) then
				out_word(11 downto 10) <= "10";
			elsif (conste_i_data5 > conste_q_data5 and -conste_i_data5 > conste_q_data5) then
				out_word(11 downto 10) <= "11";
			end if;
		end if;
	end process;

	out_data6_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conste_i_data6 > conste_q_data6 and -conste_i_data6 <= conste_q_data6) then
				out_word(13 downto 12) <= "00";
			elsif (conste_i_data6 <= conste_q_data6 and -conste_i_data6 <= conste_q_data6) then
				out_word(13 downto 12) <= "01";
			elsif (conste_i_data6 <= conste_q_data6 and -conste_i_data6 > conste_q_data6) then
				out_word(13 downto 12) <= "10";
			elsif (conste_i_data6 > conste_q_data6 and -conste_i_data6 > conste_q_data6) then
				out_word(13 downto 12) <= "11";
			end if;
		end if;
	end process;

	out_data7_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conste_i_data7 > conste_q_data7 and -conste_i_data7 <= conste_q_data7) then
				out_word(15 downto 14) <= "00";
			elsif (conste_i_data7 <= conste_q_data7 and -conste_i_data7 <= conste_q_data7) then
				out_word(15 downto 14) <= "01";
			elsif (conste_i_data7 <= conste_q_data7 and -conste_i_data7 > conste_q_data7) then
				out_word(15 downto 14) <= "10";
			elsif (conste_i_data7 > conste_q_data7 and -conste_i_data7 > conste_q_data7) then
				out_word(15 downto 14) <= "11";
			end if;
		end if;
	end process;

	out_data8_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conste_i_data8 > conste_q_data8 and -conste_i_data8 <= conste_q_data8) then
				out_word(17 downto 16) <= "00";
			elsif (conste_i_data8 <= conste_q_data8 and -conste_i_data8 <= conste_q_data8) then
				out_word(17 downto 16) <= "01";
			elsif (conste_i_data8 <= conste_q_data8 and -conste_i_data8 > conste_q_data8) then
				out_word(17 downto 16) <= "10";
			elsif (conste_i_data8 > conste_q_data8 and -conste_i_data8 > conste_q_data8) then
				out_word(17 downto 16) <= "11";
			end if;
		end if;
	end process;

	out_data9_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conste_i_data9 > conste_q_data9 and -conste_i_data9 <= conste_q_data9) then
				out_word(19 downto 18) <= "00";
			elsif (conste_i_data9 <= conste_q_data9 and -conste_i_data9 <= conste_q_data9) then
				out_word(19 downto 18) <= "01";
			elsif (conste_i_data9 <= conste_q_data9 and -conste_i_data9 > conste_q_data9) then
				out_word(19 downto 18) <= "10";
			elsif (conste_i_data9 > conste_q_data9 and -conste_i_data9 > conste_q_data9) then
				out_word(19 downto 18) <= "11";
			end if;
		end if;
	end process;

	out_data10_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conste_i_data10 > conste_q_data10 and -conste_i_data10 <= conste_q_data10) then
				out_word(21 downto 20) <= "00";
			elsif (conste_i_data10 <= conste_q_data10 and -conste_i_data10 <= conste_q_data10) then
				out_word(21 downto 20) <= "01";
			elsif (conste_i_data10 <= conste_q_data10 and -conste_i_data10 > conste_q_data10) then
				out_word(21 downto 20) <= "10";
			elsif (conste_i_data10 > conste_q_data10 and -conste_i_data10 > conste_q_data10) then
				out_word(21 downto 20) <= "11";
			end if;
		end if;
	end process;

	out_data11_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conste_i_data11 > conste_q_data11 and -conste_i_data11 <= conste_q_data11) then
				out_word(23 downto 22) <= "00";
			elsif (conste_i_data11 <= conste_q_data11 and -conste_i_data11 <= conste_q_data11) then
				out_word(23 downto 22) <= "01";
			elsif (conste_i_data11 <= conste_q_data11 and -conste_i_data11 > conste_q_data11) then
				out_word(23 downto 22) <= "10";
			elsif (conste_i_data11 > conste_q_data11 and -conste_i_data11 > conste_q_data11) then
				out_word(23 downto 22) <= "11";
			end if;
		end if;
	end process;

	out_data12_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conste_i_data12 > conste_q_data12 and -conste_i_data12 <= conste_q_data12) then
				out_word(25 downto 24) <= "00";
			elsif (conste_i_data12 <= conste_q_data12 and -conste_i_data12 <= conste_q_data12) then
				out_word(25 downto 24) <= "01";
			elsif (conste_i_data12 <= conste_q_data12 and -conste_i_data12 > conste_q_data12) then
				out_word(25 downto 24) <= "10";
			elsif (conste_i_data12 > conste_q_data12 and -conste_i_data12 > conste_q_data12) then
				out_word(25 downto 24) <= "11";
			end if;
		end if;
	end process;

	out_data13_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conste_i_data13 > conste_q_data13 and -conste_i_data13 <= conste_q_data13) then
				out_word(27 downto 26) <= "00";
			elsif (conste_i_data13 <= conste_q_data13 and -conste_i_data13 <= conste_q_data13) then
				out_word(27 downto 26) <= "01";
			elsif (conste_i_data13 <= conste_q_data13 and -conste_i_data13 > conste_q_data13) then
				out_word(27 downto 26) <= "10";
			elsif (conste_i_data13 > conste_q_data13 and -conste_i_data13 > conste_q_data13) then
				out_word(27 downto 26) <= "11";
			end if;
		end if;
	end process;

	out_data14_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conste_i_data14 > conste_q_data14 and -conste_i_data14 <= conste_q_data14) then
				out_word(29 downto 28) <= "00";
			elsif (conste_i_data14 <= conste_q_data14 and -conste_i_data14 <= conste_q_data14) then
				out_word(29 downto 28) <= "01";
			elsif (conste_i_data14 <= conste_q_data14 and -conste_i_data14 > conste_q_data14) then
				out_word(29 downto 28) <= "10";
			elsif (conste_i_data14 > conste_q_data14 and -conste_i_data14 > conste_q_data14) then
				out_word(29 downto 28) <= "11";
			end if;
		end if;
	end process;

	out_data15_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conste_i_data15 > conste_q_data15 and -conste_i_data15 <= conste_q_data15) then
				out_word(31 downto 30) <= "00";
			elsif (conste_i_data15 <= conste_q_data15 and -conste_i_data15 <= conste_q_data15) then
				out_word(31 downto 30) <= "01";
			elsif (conste_i_data15 <= conste_q_data15 and -conste_i_data15 > conste_q_data15) then
				out_word(31 downto 30) <= "10";
			elsif (conste_i_data15 > conste_q_data15 and -conste_i_data15 > conste_q_data15) then
				out_word(31 downto 30) <= "11";
			end if;
		end if;
	end process;

	out_data_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (symbol_cnt >= 7 + offset and symbol_cnt < 16 * 80 + 7 + offset and symbol_num > 2) then
				out_byte <= out_word(7 downto 0);
			elsif (symbol_cnt >= 7 + offset and symbol_cnt < 32 * 80 + 7 + offset and symbol_num > 2) then
				out_byte <= out_word(15 downto 8);
			elsif (symbol_cnt >= 7 + offset and symbol_cnt < 48 * 80 + 7 + offset and symbol_num > 2) then
				out_byte <= out_word(23 downto 16);
			elsif (symbol_cnt >= 7 + offset and symbol_cnt < 64 * 80 + 7 + offset and symbol_num > 2) then
				out_byte <= out_word(31 downto 24);
			end if;
		end if;
	end process;

end rtl;

