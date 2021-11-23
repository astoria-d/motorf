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

---aggregate rom s/c
signal rom_s : std_logic_vector(15 downto 0);
signal rom_c : std_logic_vector(15 downto 0);

signal multi_s : std_logic_vector(31 downto 0);
signal multi_c : std_logic_vector(31 downto 0);

constant offset : integer := 7 * 80;

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

---aggregate base/result
signal base_s : std_logic_vector(31 downto 0);
signal base_c : std_logic_vector(31 downto 0);
signal result_s : std_logic_vector(31 downto 0);
signal result_c : std_logic_vector(31 downto 0);

signal dmulti0 : std_logic_vector(31 downto 0);
signal dmulti1 : std_logic_vector(31 downto 0);
signal dmulti2 : std_logic_vector(31 downto 0);
signal dmulti3 : std_logic_vector(31 downto 0);

signal conste_i : signed(31 downto 0);
signal conste_q : signed(31 downto 0);

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

	rom_sc_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (symbol_cnt(3 downto 0) = 0) then
				rom_s <= rom_sin0;
				rom_c <= rom_cos0;
			elsif (symbol_cnt(3 downto 0) = 1) then
				rom_s <= rom_sin1;
				rom_c <= rom_cos1;
			elsif (symbol_cnt(3 downto 0) = 2) then
				rom_s <= rom_sin2;
				rom_c <= rom_cos2;
			elsif (symbol_cnt(3 downto 0) = 3) then
				rom_s <= rom_sin3;
				rom_c <= rom_cos3;
			elsif (symbol_cnt(3 downto 0) = 4) then
				rom_s <= rom_sin4;
				rom_c <= rom_cos4;
			elsif (symbol_cnt(3 downto 0) = 5) then
				rom_s <= rom_sin5;
				rom_c <= rom_cos5;
			elsif (symbol_cnt(3 downto 0) = 6) then
				rom_s <= rom_sin6;
				rom_c <= rom_cos6;
			elsif (symbol_cnt(3 downto 0) = 7) then
				rom_s <= rom_sin7;
				rom_c <= rom_cos7;
			elsif (symbol_cnt(3 downto 0) = 8) then
				rom_s <= rom_sin8;
				rom_c <= rom_cos8;
			elsif (symbol_cnt(3 downto 0) = 9) then
				rom_s <= rom_sin9;
				rom_c <= rom_cos9;
			elsif (symbol_cnt(3 downto 0) = 10) then
				rom_s <= rom_sin10;
				rom_c <= rom_cos10;
			elsif (symbol_cnt(3 downto 0) = 11) then
				rom_s <= rom_sin11;
				rom_c <= rom_cos11;
			elsif (symbol_cnt(3 downto 0) = 12) then
				rom_s <= rom_sin12;
				rom_c <= rom_cos12;
			elsif (symbol_cnt(3 downto 0) = 13) then
				rom_s <= rom_sin13;
				rom_c <= rom_cos13;
			elsif (symbol_cnt(3 downto 0) = 14) then
				rom_s <= rom_sin14;
				rom_c <= rom_cos14;
			else
				rom_s <= rom_sin15;
				rom_c <= rom_cos15;
			end if;
		end if;
	end process;

	---we do not have enough multipler. so share the circuit with the frequencies...
	mul_s_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_s, result => multi_s );
	mul_c_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_c, result => multi_c );

	base_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (symbol_cnt >= 7 + offset and symbol_cnt < 64 * 80 + 7 + offset and symbol_num =2) then
				if (symbol_cnt(3 downto 0) = 0) then
					base_s0 <= multi_s;
					base_c0 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 1) then
					base_s1 <= multi_s;
					base_c1 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 2) then
					base_s2 <= multi_s;
					base_c2 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 3) then
					base_s3 <= multi_s;
					base_c3 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 4) then
					base_s4 <= multi_s;
					base_c4 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 5) then
					base_s5 <= multi_s;
					base_c5 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 6) then
					base_s6 <= multi_s;
					base_c6 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 7) then
					base_s7 <= multi_s;
					base_c7 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 8) then
					base_s8 <= multi_s;
					base_c8 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 9) then
					base_s9 <= multi_s;
					base_c9 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 10) then
					base_s10 <= multi_s;
					base_c10 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 11) then
					base_s11 <= multi_s;
					base_c11 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 12) then
					base_s12 <= multi_s;
					base_c12 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 13) then
					base_s13 <= multi_s;
					base_c13 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 14) then
					base_s14 <= multi_s;
					base_c14 <= multi_c;
				else
					base_s15 <= multi_s;
					base_c15 <= multi_c;
				end if;
			end if;
		end if;
	end process;

	result_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (symbol_cnt >= 7 + offset and symbol_cnt < 64 * 80 + 7 + offset and symbol_num =2) then
				if (symbol_cnt(3 downto 0) = 0) then
					result_s0 <= multi_s;
					result_c0 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 1) then
					result_s1 <= multi_s;
					result_c1 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 2) then
					result_s2 <= multi_s;
					result_c2 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 3) then
					result_s3 <= multi_s;
					result_c3 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 4) then
					result_s4 <= multi_s;
					result_c4 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 5) then
					result_s5 <= multi_s;
					result_c5 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 6) then
					result_s6 <= multi_s;
					result_c6 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 7) then
					result_s7 <= multi_s;
					result_c7 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 8) then
					result_s8 <= multi_s;
					result_c8 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 9) then
					result_s9 <= multi_s;
					result_c9 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 10) then
					result_s10 <= multi_s;
					result_c10 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 11) then
					result_s11 <= multi_s;
					result_c11 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 12) then
					result_s12 <= multi_s;
					result_c12 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 13) then
					result_s13 <= multi_s;
					result_c13 <= multi_c;
				elsif (symbol_cnt(3 downto 0) = 14) then
					result_s14 <= multi_s;
					result_c14 <= multi_c;
				else
					result_s15 <= multi_s;
					result_c15 <= multi_c;
				end if;
			end if;
		end if;
	end process;

	base_sc_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (symbol_cnt(3 downto 0) = 0) then
				base_s <= base_s0;
				base_c <= base_c0;
			elsif (symbol_cnt(3 downto 0) = 1) then
				base_s <= base_s1;
				base_c <= base_c1;
			elsif (symbol_cnt(3 downto 0) = 2) then
				base_s <= base_s2;
				base_c <= base_c2;
			elsif (symbol_cnt(3 downto 0) = 3) then
				base_s <= base_s3;
				base_c <= base_c3;
			elsif (symbol_cnt(3 downto 0) = 4) then
				base_s <= base_s4;
				base_c <= base_c4;
			elsif (symbol_cnt(3 downto 0) = 5) then
				base_s <= base_s5;
				base_c <= base_c5;
			elsif (symbol_cnt(3 downto 0) = 6) then
				base_s <= base_s6;
				base_c <= base_c6;
			elsif (symbol_cnt(3 downto 0) = 7) then
				base_s <= base_s7;
				base_c <= base_c7;
			elsif (symbol_cnt(3 downto 0) = 8) then
				base_s <= base_s8;
				base_c <= base_c8;
			elsif (symbol_cnt(3 downto 0) = 9) then
				base_s <= base_s9;
				base_c <= base_c9;
			elsif (symbol_cnt(3 downto 0) = 10) then
				base_s <= base_s10;
				base_c <= base_c10;
			elsif (symbol_cnt(3 downto 0) = 11) then
				base_s <= base_s11;
				base_c <= base_c11;
			elsif (symbol_cnt(3 downto 0) = 12) then
				base_s <= base_s12;
				base_c <= base_c12;
			elsif (symbol_cnt(3 downto 0) = 13) then
				base_s <= base_s13;
				base_c <= base_c13;
			elsif (symbol_cnt(3 downto 0) = 14) then
				base_s <= base_s14;
				base_c <= base_c14;
			else
				base_s <= base_s15;
				base_c <= base_c15;
			end if;
		end if;
	end process;

	result_sc_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (symbol_cnt(3 downto 0) = 0) then
				result_s <= result_s0;
				result_c <= result_c0;
			elsif (symbol_cnt(3 downto 0) = 1) then
				result_s <= result_s1;
				result_c <= result_c1;
			elsif (symbol_cnt(3 downto 0) = 2) then
				result_s <= result_s2;
				result_c <= result_c2;
			elsif (symbol_cnt(3 downto 0) = 3) then
				result_s <= result_s3;
				result_c <= result_c3;
			elsif (symbol_cnt(3 downto 0) = 4) then
				result_s <= result_s4;
				result_c <= result_c4;
			elsif (symbol_cnt(3 downto 0) = 5) then
				result_s <= result_s5;
				result_c <= result_c5;
			elsif (symbol_cnt(3 downto 0) = 6) then
				result_s <= result_s6;
				result_c <= result_c6;
			elsif (symbol_cnt(3 downto 0) = 7) then
				result_s <= result_s7;
				result_c <= result_c7;
			elsif (symbol_cnt(3 downto 0) = 8) then
				result_s <= result_s8;
				result_c <= result_c8;
			elsif (symbol_cnt(3 downto 0) = 9) then
				result_s <= result_s9;
				result_c <= result_c9;
			elsif (symbol_cnt(3 downto 0) = 10) then
				result_s <= result_s10;
				result_c <= result_c10;
			elsif (symbol_cnt(3 downto 0) = 11) then
				result_s <= result_s11;
				result_c <= result_c11;
			elsif (symbol_cnt(3 downto 0) = 12) then
				result_s <= result_s12;
				result_c <= result_c12;
			elsif (symbol_cnt(3 downto 0) = 13) then
				result_s <= result_s13;
				result_c <= result_c13;
			elsif (symbol_cnt(3 downto 0) = 14) then
				result_s <= result_s14;
				result_c <= result_c14;
			else
				result_s <= result_s15;
				result_c <= result_c15;
			end if;
		end if;
	end process;

	---we do not have enough multipler. so share the circuit with the frequencies...
	mul_normalize0_ist : multi_0 PORT MAP ( clock => clk80m, dataa => base_s(31 downto 16), datab => result_s(31 downto 16), result => dmulti0 );
	mul_normalize1_ist : multi_0 PORT MAP ( clock => clk80m, dataa => base_c(31 downto 16), datab => result_c(31 downto 16), result => dmulti1 );
	mul_normalize2_ist : multi_0 PORT MAP ( clock => clk80m, dataa => base_s(31 downto 16), datab => result_c(31 downto 16), result => dmulti2 );
	mul_normalize3_ist : multi_0 PORT MAP ( clock => clk80m, dataa => base_c(31 downto 16), datab => result_s(31 downto 16), result => dmulti3 );

	constellation_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			conste_i <= signed(dmulti0) + signed(dmulti1);
			conste_q <= signed(dmulti2) - signed(dmulti3);
		end if;
	end process;

	out_byte0_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conste_i > conste_q and -conste_i <= conste_q) then
				out_byte(1 downto 0) <= "00";
			elsif (conste_i <= conste_q and -conste_i <= conste_q) then
				out_byte(1 downto 0) <= "01";
			elsif (conste_i <= conste_q and -conste_i > conste_q) then
				out_byte(1 downto 0) <= "10";
			elsif (conste_i > conste_q and -conste_i > conste_q) then
				out_byte(1 downto 0) <= "11";
			end if;
		end if;
	end process;

	out_byte1_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conste_i > conste_q and -conste_i <= conste_q) then
				out_byte(3 downto 2) <= "00";
			elsif (conste_i <= conste_q and -conste_i <= conste_q) then
				out_byte(3 downto 2) <= "01";
			elsif (conste_i <= conste_q and -conste_i > conste_q) then
				out_byte(3 downto 2) <= "10";
			elsif (conste_i > conste_q and -conste_i > conste_q) then
				out_byte(3 downto 2) <= "11";
			end if;
		end if;
	end process;

	out_byte2_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conste_i > conste_q and -conste_i <= conste_q) then
				out_byte(5 downto 4) <= "00";
			elsif (conste_i <= conste_q and -conste_i <= conste_q) then
				out_byte(5 downto 4) <= "01";
			elsif (conste_i <= conste_q and -conste_i > conste_q) then
				out_byte(5 downto 4) <= "10";
			elsif (conste_i > conste_q and -conste_i > conste_q) then
				out_byte(5 downto 4) <= "11";
			end if;
		end if;
	end process;

	out_byte3_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conste_i > conste_q and -conste_i <= conste_q) then
				out_byte(7 downto 6) <= "00";
			elsif (conste_i <= conste_q and -conste_i <= conste_q) then
				out_byte(7 downto 6) <= "01";
			elsif (conste_i <= conste_q and -conste_i > conste_q) then
				out_byte(7 downto 6) <= "10";
			elsif (conste_i > conste_q and -conste_i > conste_q) then
				out_byte(7 downto 6) <= "11";
			end if;
		end if;
	end process;

end rtl;
