library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.motorf.all;

entity demodulator is
	port (
	signal clk80m		: in std_logic;
	signal symbol_num : in std_logic_vector(7 downto 0);
	signal symbol_cnt : in std_logic_vector(15 downto 0);
	signal indata		: in std_logic_vector(31 downto 0);
	signal out_word 	: out std_logic_vector(31 downto 0);
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

constant integ_end : integer := 64 * 80;

--work buffer for each carrier
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

	addr_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (symbol_cnt < offset or symbol_cnt > offset + integ_end) then
				rom_addr <= (others => '0');
			else
				-- symbol_cnt is 0 - 6080. make it 0 - 380 by 1/16
				-- rom read from 6 us
				rom_addr <= conv_std_logic_vector((conv_integer(unsigned(symbol_cnt)) - offset) / 16, rom_addr'length);
			end if;
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

	aggregate_rom_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (symbol_cnt(3 downto 0) = 3) then
				rom_s <= rom_sin0;
				rom_c <= rom_cos0;
			elsif (symbol_cnt(3 downto 0) = 4) then
				rom_s <= rom_sin1;
				rom_c <= rom_cos1;
			elsif (symbol_cnt(3 downto 0) = 5) then
				rom_s <= rom_sin2;
				rom_c <= rom_cos2;
			elsif (symbol_cnt(3 downto 0) = 6) then
				rom_s <= rom_sin3;
				rom_c <= rom_cos3;
			elsif (symbol_cnt(3 downto 0) = 7) then
				rom_s <= rom_sin4;
				rom_c <= rom_cos4;
			elsif (symbol_cnt(3 downto 0) = 8) then
				rom_s <= rom_sin5;
				rom_c <= rom_cos5;
			elsif (symbol_cnt(3 downto 0) = 9) then
				rom_s <= rom_sin6;
				rom_c <= rom_cos6;
			elsif (symbol_cnt(3 downto 0) = 10) then
				rom_s <= rom_sin7;
				rom_c <= rom_cos7;
			elsif (symbol_cnt(3 downto 0) = 11) then
				rom_s <= rom_sin8;
				rom_c <= rom_cos8;
			elsif (symbol_cnt(3 downto 0) = 12) then
				rom_s <= rom_sin9;
				rom_c <= rom_cos9;
			elsif (symbol_cnt(3 downto 0) = 13) then
				rom_s <= rom_sin10;
				rom_c <= rom_cos10;
			elsif (symbol_cnt(3 downto 0) = 14) then
				rom_s <= rom_sin11;
				rom_c <= rom_cos11;
			elsif (symbol_cnt(3 downto 0) = 15) then
				rom_s <= rom_sin12;
				rom_c <= rom_cos12;
			elsif (symbol_cnt(3 downto 0) = 0) then
				rom_s <= rom_sin13;
				rom_c <= rom_cos13;
			elsif (symbol_cnt(3 downto 0) = 1) then
				rom_s <= rom_sin14;
				rom_c <= rom_cos14;
			else
				rom_s <= rom_sin15;
				rom_c <= rom_cos15;
			end if;
		end if;
	end process;

	---we do not have enough multipler. so share the circuit across the different frequencies...
	mul_s_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_s, result => multi_s );
	mul_c_ist : multi_0 PORT MAP ( clock => clk80m, dataa => indata(31 downto 16), datab => rom_c, result => multi_c );

	--calculate integral
	work_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (symbol_cnt < offset + 7) then
				wdata_s0 <= (others => '0');
				wdata_s1 <= (others => '0');
				wdata_s2 <= (others => '0');
				wdata_s3 <= (others => '0');
				wdata_s4 <= (others => '0');
				wdata_s5 <= (others => '0');
				wdata_s6 <= (others => '0');
				wdata_s7 <= (others => '0');
				wdata_s8 <= (others => '0');
				wdata_s9 <= (others => '0');
				wdata_s10 <= (others => '0');
				wdata_s11 <= (others => '0');
				wdata_s12 <= (others => '0');
				wdata_s13 <= (others => '0');
				wdata_s14 <= (others => '0');
				wdata_s15 <= (others => '0');
				wdata_c0 <= (others => '0');
				wdata_c1 <= (others => '0');
				wdata_c2 <= (others => '0');
				wdata_c3 <= (others => '0');
				wdata_c4 <= (others => '0');
				wdata_c5 <= (others => '0');
				wdata_c6 <= (others => '0');
				wdata_c7 <= (others => '0');
				wdata_c8 <= (others => '0');
				wdata_c9 <= (others => '0');
				wdata_c10 <= (others => '0');
				wdata_c11 <= (others => '0');
				wdata_c12 <= (others => '0');
				wdata_c13 <= (others => '0');
				wdata_c14 <= (others => '0');
				wdata_c15 <= (others => '0');
			elsif (symbol_cnt >= offset + 7 and symbol_cnt < offset + 7 + 16) then
				if (symbol_cnt(3 downto 0) = 9) then
					wdata_s0 <= conv_std_logic_vector(conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c0 <= conv_std_logic_vector(conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 10) then
					wdata_s1 <= conv_std_logic_vector(conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c1 <= conv_std_logic_vector(conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 11) then
					wdata_s2 <= conv_std_logic_vector(conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c2 <= conv_std_logic_vector(conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 12) then
					wdata_s3 <= conv_std_logic_vector(conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c3 <= conv_std_logic_vector(conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 13) then
					wdata_s4 <= conv_std_logic_vector(conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c4 <= conv_std_logic_vector(conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 14) then
					wdata_s5 <= conv_std_logic_vector(conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c5 <= conv_std_logic_vector(conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 15) then
					wdata_s6 <= conv_std_logic_vector(conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c6 <= conv_std_logic_vector(conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 0) then
					wdata_s7 <= conv_std_logic_vector(conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c7 <= conv_std_logic_vector(conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 1) then
					wdata_s8 <= conv_std_logic_vector(conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c8 <= conv_std_logic_vector(conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 2) then
					wdata_s9 <= conv_std_logic_vector(conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c9 <= conv_std_logic_vector(conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 3) then
					wdata_s10 <= conv_std_logic_vector(conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c10 <= conv_std_logic_vector(conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 4) then
					wdata_s11 <= conv_std_logic_vector(conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c11 <= conv_std_logic_vector(conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 5) then
					wdata_s12 <= conv_std_logic_vector(conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c12 <= conv_std_logic_vector(conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 6) then
					wdata_s13 <= conv_std_logic_vector(conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c13 <= conv_std_logic_vector(conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 7) then
					wdata_s14 <= conv_std_logic_vector(conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c14 <= conv_std_logic_vector(conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				else
					wdata_s15 <= conv_std_logic_vector(conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c15 <= conv_std_logic_vector(conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				end if;
			elsif (symbol_cnt < offset + 7 + integ_end) then
				if (symbol_cnt(3 downto 0) = 9) then
					wdata_s0 <= conv_std_logic_vector(conv_integer(signed(wdata_s0)) + conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c0 <= conv_std_logic_vector(conv_integer(signed(wdata_c0)) + conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 10) then
					wdata_s1 <= conv_std_logic_vector(conv_integer(signed(wdata_s1)) + conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c1 <= conv_std_logic_vector(conv_integer(signed(wdata_c1)) + conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 11) then
					wdata_s2 <= conv_std_logic_vector(conv_integer(signed(wdata_s2)) + conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c2 <= conv_std_logic_vector(conv_integer(signed(wdata_c2)) + conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 12) then
					wdata_s3 <= conv_std_logic_vector(conv_integer(signed(wdata_s3)) + conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c3 <= conv_std_logic_vector(conv_integer(signed(wdata_c3)) + conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 13) then
					wdata_s4 <= conv_std_logic_vector(conv_integer(signed(wdata_s4)) + conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c4 <= conv_std_logic_vector(conv_integer(signed(wdata_c4)) + conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 14) then
					wdata_s5 <= conv_std_logic_vector(conv_integer(signed(wdata_s5)) + conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c5 <= conv_std_logic_vector(conv_integer(signed(wdata_c5)) + conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 15) then
					wdata_s6 <= conv_std_logic_vector(conv_integer(signed(wdata_s6)) + conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c6 <= conv_std_logic_vector(conv_integer(signed(wdata_c6)) + conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 0) then
					wdata_s7 <= conv_std_logic_vector(conv_integer(signed(wdata_s7)) + conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c7 <= conv_std_logic_vector(conv_integer(signed(wdata_c7)) + conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 1) then
					wdata_s8 <= conv_std_logic_vector(conv_integer(signed(wdata_s8)) + conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c8 <= conv_std_logic_vector(conv_integer(signed(wdata_c8)) + conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 2) then
					wdata_s9 <= conv_std_logic_vector(conv_integer(signed(wdata_s9)) + conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c9 <= conv_std_logic_vector(conv_integer(signed(wdata_c9)) + conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 3) then
					wdata_s10 <= conv_std_logic_vector(conv_integer(signed(wdata_s10)) + conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c10 <= conv_std_logic_vector(conv_integer(signed(wdata_c10)) + conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 4) then
					wdata_s11 <= conv_std_logic_vector(conv_integer(signed(wdata_s11)) + conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c11 <= conv_std_logic_vector(conv_integer(signed(wdata_c11)) + conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 5) then
					wdata_s12 <= conv_std_logic_vector(conv_integer(signed(wdata_s12)) + conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c12 <= conv_std_logic_vector(conv_integer(signed(wdata_c12)) + conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 6) then
					wdata_s13 <= conv_std_logic_vector(conv_integer(signed(wdata_s13)) + conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c13 <= conv_std_logic_vector(conv_integer(signed(wdata_c13)) + conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				elsif (symbol_cnt(3 downto 0) = 7) then
					wdata_s14 <= conv_std_logic_vector(conv_integer(signed(wdata_s14)) + conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c14 <= conv_std_logic_vector(conv_integer(signed(wdata_c14)) + conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				else
					wdata_s15 <= conv_std_logic_vector(conv_integer(signed(wdata_s15)) + conv_integer(signed(multi_s)) / 32, wdata_s0'length);
					wdata_c15 <= conv_std_logic_vector(conv_integer(signed(wdata_c15)) + conv_integer(signed(multi_c)) / 32, wdata_s0'length);
				end if;
			end if;
		end if;
	end process;

	base_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (symbol_num = 2 and symbol_cnt >= offset + 7 + integ_end and symbol_cnt < offset + 7 + integ_end + 16) then
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
			if (symbol_num > 2 and symbol_cnt >= offset + 7 + integ_end + 1 and symbol_cnt < offset + 7 + integ_end + 1 + 16) then
				if (symbol_cnt(3 downto 0) = 0) then
					base_s <= base_s0;
					base_c <= base_c0;
					result_s <= wdata_s0;
					result_c <= wdata_c0;
				elsif (symbol_cnt(3 downto 0) = 1) then
					base_s <= base_s1;
					base_c <= base_c1;
					result_s <= wdata_s1;
					result_c <= wdata_c1;
				elsif (symbol_cnt(3 downto 0) = 2) then
					base_s <= base_s2;
					base_c <= base_c2;
					result_s <= wdata_s2;
					result_c <= wdata_c2;
				elsif (symbol_cnt(3 downto 0) = 3) then
					base_s <= base_s3;
					base_c <= base_c3;
					result_s <= wdata_s3;
					result_c <= wdata_c3;
				elsif (symbol_cnt(3 downto 0) = 4) then
					base_s <= base_s4;
					base_c <= base_c4;
					result_s <= wdata_s4;
					result_c <= wdata_c4;
				elsif (symbol_cnt(3 downto 0) = 5) then
					base_s <= base_s5;
					base_c <= base_c5;
					result_s <= wdata_s5;
					result_c <= wdata_c5;
				elsif (symbol_cnt(3 downto 0) = 6) then
					base_s <= base_s6;
					base_c <= base_c6;
					result_s <= wdata_s6;
					result_c <= wdata_c6;
				elsif (symbol_cnt(3 downto 0) = 7) then
					base_s <= base_s7;
					base_c <= base_c7;
					result_s <= wdata_s7;
					result_c <= wdata_c7;
				elsif (symbol_cnt(3 downto 0) = 8) then
					base_s <= base_s8;
					base_c <= base_c8;
					result_s <= wdata_s8;
					result_c <= wdata_c8;
				elsif (symbol_cnt(3 downto 0) = 9) then
					base_s <= base_s9;
					base_c <= base_c9;
					result_s <= wdata_s9;
					result_c <= wdata_c9;
				elsif (symbol_cnt(3 downto 0) = 10) then
					base_s <= base_s10;
					base_c <= base_c10;
					result_s <= wdata_s10;
					result_c <= wdata_c10;
				elsif (symbol_cnt(3 downto 0) = 11) then
					base_s <= base_s11;
					base_c <= base_c11;
					result_s <= wdata_s11;
					result_c <= wdata_c11;
				elsif (symbol_cnt(3 downto 0) = 12) then
					base_s <= base_s12;
					base_c <= base_c12;
					result_s <= wdata_s12;
					result_c <= wdata_c12;
				elsif (symbol_cnt(3 downto 0) = 13) then
					base_s <= base_s13;
					base_c <= base_c13;
					result_s <= wdata_s13;
					result_c <= wdata_c13;
				elsif (symbol_cnt(3 downto 0) = 14) then
					base_s <= base_s14;
					base_c <= base_c14;
					result_s <= wdata_s14;
					result_c <= wdata_c14;
				else
					base_s <= base_s15;
					base_c <= base_c15;
					result_s <= wdata_s15;
					result_c <= wdata_c15;
				end if;
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

	out_word_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (symbol_num > 2 and symbol_cnt >= offset + 7 + integ_end + 1 + 5 + 2 and symbol_cnt < offset + 7 + integ_end + 1 + 5 + 2 + 16) then
				if (symbol_cnt(3 downto 0) = 15) then
					out_word(17 downto 16) <= decode_data(conste_i, conste_q);
				elsif (symbol_cnt(3 downto 0) = 0) then
					out_word(19 downto 18) <= decode_data(conste_i, conste_q);
				elsif (symbol_cnt(3 downto 0) = 1) then
					out_word(21 downto 20) <= decode_data(conste_i, conste_q);
				elsif (symbol_cnt(3 downto 0) = 2) then
					out_word(23 downto 22) <= decode_data(conste_i, conste_q);
				elsif (symbol_cnt(3 downto 0) = 3) then
					out_word(25 downto 24) <= decode_data(conste_i, conste_q);
				elsif (symbol_cnt(3 downto 0) = 4) then
					out_word(27 downto 26) <= decode_data(conste_i, conste_q);
				elsif (symbol_cnt(3 downto 0) = 5) then
					out_word(29 downto 28) <= decode_data(conste_i, conste_q);
				elsif (symbol_cnt(3 downto 0) = 6) then
					out_word(31 downto 30) <= decode_data(conste_i, conste_q);
				elsif (symbol_cnt(3 downto 0) = 7) then
					out_word(1 downto 0) <= decode_data(conste_i, conste_q);
				elsif (symbol_cnt(3 downto 0) = 8) then
					out_word(3 downto 2) <= decode_data(conste_i, conste_q);
				elsif (symbol_cnt(3 downto 0) = 9) then
					out_word(5 downto 4) <= decode_data(conste_i, conste_q);
				elsif (symbol_cnt(3 downto 0) = 10) then
					out_word(7 downto 6) <= decode_data(conste_i, conste_q);
				elsif (symbol_cnt(3 downto 0) = 11) then
					out_word(9 downto 8) <= decode_data(conste_i, conste_q);
				elsif (symbol_cnt(3 downto 0) = 12) then
					out_word(11 downto 10) <= decode_data(conste_i, conste_q);
				elsif (symbol_cnt(3 downto 0) = 13) then
					out_word(13 downto 12) <= decode_data(conste_i, conste_q);
				else
					out_word(15 downto 14) <= decode_data(conste_i, conste_q);
				end if;
			end if;
		end if;
	end process;

	out_en_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (symbol_num > 2 and symbol_cnt >= offset + 7 + integ_end + 1 + 5 + 2 + 16) then
				out_en <= '1';
			else
				out_en <= '0';
			end if;
		end if;
	end process;

end rtl;
