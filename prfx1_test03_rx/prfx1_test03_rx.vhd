library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_unsigned.all;

entity prfx1_test03_rx is 
	port (
	signal clk16m     : in std_logic;
	signal adc 			: in std_logic_vector(11 downto 0);
	signal jtag_clk   : out std_logic;
	signal adc_clk		: out std_logic;

	signal attn			: out std_logic_vector(4 downto 0);
	signal attn_oe		: out std_logic;

	signal spiclk		: out std_logic;
	signal sdi			: out std_logic;
	signal spics_pll	: out std_logic;

	signal uart_out	: out std_logic;

	signal sw1     	: in std_logic;
	signal sw2     	: in std_logic;
	signal led1			: out std_logic;
	signal led2			: out std_logic;
	signal led3			: out std_logic
	);
end prfx1_test03_rx;

architecture rtl of prfx1_test03_rx is

component pll
	PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		c1		: OUT STD_LOGIC ;
		c2		: OUT STD_LOGIC ;
		c3		: OUT STD_LOGIC
	);
end component;

component pll_spi_data
	port (
	signal clk16m		: in std_logic;
	signal reset_n		: in std_logic;
	signal spiclk		: out std_logic;
	signal spics		: out std_logic;
	signal sdi			: out std_logic
	);
end component;

component conv_signed
	port (
	signal clk80m		: in std_logic;
	signal udata		: in std_logic_vector(11 downto 0);
	signal sdata		: out std_logic_vector(11 downto 0)
	);
end component;

component zero_offset
	port (
	signal clk80m		: in std_logic;
	signal indata		: in std_logic_vector(11 downto 0);
	signal outdata		: out std_logic_vector(11 downto 0)
	);
end component;

component lpf_28tap
	port (
	signal clk80m		: in std_logic;
	signal indata       : in std_logic_vector(11 downto 0);
	signal outdata      : out std_logic_vector(15 downto 0)
	);
end component;

component bpf_32tap
	port (
	signal clk80m		: in std_logic;
	signal indata       : in std_logic_vector(15 downto 0);
	signal outdata      : out std_logic_vector(17 downto 0)
	);
end component;

component agc
	port (
	signal clk80m		: in std_logic;
	signal indata     : in std_logic_vector(15 downto 0);
	signal att_val		: out std_logic_vector(4 downto 0);
	signal att_oe		: out std_logic
	);
end component;

component sync_symbol
	port (
	signal clk80m		: in std_logic;
	signal indata		: in std_logic_vector(17 downto 0);
	signal symbol_num : out std_logic_vector(7 downto 0);
	signal symbol_cnt : out std_logic_vector(15 downto 0);
	signal pilot_only	: out std_logic
	);
end component;

component sync_carrier
	port (
	signal clk80m		: in std_logic;
	signal indata		: in std_logic_vector(17 downto 0);
	signal symbol_num : in std_logic_vector(7 downto 0);
	signal symbol_cnt : in std_logic_vector(15 downto 0);
	signal pilot_only	: in std_logic;
	signal outdata		: out std_logic_vector(31 downto 0);
	signal synchronized : out std_logic
	);
end component;

component demodulator
	port (
	signal clk80m		: in std_logic;
	signal symbol_num : in std_logic_vector(7 downto 0);
	signal symbol_cnt : in std_logic_vector(15 downto 0);
	signal indata		: in std_logic_vector(31 downto 0);
	signal out_word 	: out std_logic_vector(31 downto 0);
	signal out_en		: out std_logic
	);
end component;

component output_uart
	port (
	signal clk80m		: in std_logic;
	signal in_en		: in std_logic;
	signal indata		: in std_logic_vector(7 downto 0);
	signal uart_out	: out std_logic
	);
end component;

component debug_stub
	port (
	signal clk80m		: in std_logic;
	signal reset_n		: in std_logic;
	signal symbol_num : out std_logic_vector(7 downto 0);
	signal symbol_cnt : out std_logic_vector(15 downto 0);
	signal testdata		: out std_logic_vector(31 downto 0)
	);
end component;

signal reset_n : std_logic;

signal clk80m		: std_logic;
signal clk40m		: std_logic;
signal clk12m		: std_logic;
signal clk5m     	: std_logic;

signal raw_adc 		: std_logic_vector(11 downto 0);
signal s_adc			: std_logic_vector(11 downto 0);
signal z_adc			: std_logic_vector(11 downto 0);
signal lp_filtered	: std_logic_vector(15 downto 0);
signal bp_filtered	: std_logic_vector(17 downto 0);

signal symbol_num : std_logic_vector(7 downto 0);
signal symbol_cnt : std_logic_vector(15 downto 0);
signal pilot_only	: std_logic;

signal upcon_data	: std_logic_vector(31 downto 0);
signal carrier_sync_stat	: std_logic;

signal demod_out	: std_logic_vector(31 downto 0);
signal demod_out_en	: std_logic;

signal uart_data	: std_logic_vector(7 downto 0);
signal uart_data_en	: std_logic;


begin

	adc_clk <= clk40m;
--	jtag_clk <= clk80m;
	jtag_clk <= clk5m;

	--PLL instance
	pll_inst : pll PORT MAP (
		inclk0	=> clk16m,
		c0	 		=> clk80m,
		c1	 		=> clk40m,
		c2	 		=> clk12m,
		c3	 		=> clk5m
	);

	--raw adc
	clk_80m_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (reset_n = '0') then
				raw_adc <= (others => '0');
			else
				raw_adc <= adc;
			end if;
		end if;
	end process;

	--convert from raw adc value to signed adc
	conv_u2s_inst : conv_signed port map (
		clk80m => clk80m,
		udata => raw_adc,
		sdata => s_adc
	);

	--zero offset adjustment
	z_ofs_inst : zero_offset port map (
		clk80m => clk80m,
		indata => s_adc,
		outdata => z_adc
	);

	--lpf
	lpf_inst : lpf_28tap
	PORT MAP (
		clk80m => clk80m,
		indata => z_adc,
		outdata => lp_filtered
	);

	--bpf
	bpf_inst : bpf_32tap
	PORT MAP (
		clk80m => clk80m,
		indata => lp_filtered,
		outdata => bp_filtered
	);

	--agc
	agc_inst : agc
	port map (
		clk80m => clk80m,
		indata => lp_filtered,
		att_val => attn,
		att_oe => attn_oe
	);

--	--sync symbol
--	sync_symbol_inst : sync_symbol port map (
--		clk80m => clk80m,
--		indata => bp_filtered,
--		symbol_num => symbol_num,
--		symbol_cnt => symbol_cnt,
--		pilot_only => pilot_only
--	);
--
--	--sync carrier
--	sync_carrier_inst :sync_carrier
--	port map (
--		clk80m => clk80m,
--		indata => bp_filtered,
--		symbol_num => symbol_num,
--		symbol_cnt => symbol_cnt,
--		pilot_only => pilot_only,
--		outdata => upcon_data,
--		synchronized => carrier_sync_stat
--	);

	--for debugging
	debut_inst : debug_stub
	port map (
	clk80m		=> clk80m,
	reset_n		=> reset_n,
	symbol_num => symbol_num,
	symbol_cnt => symbol_cnt,
	testdata		=> upcon_data
	);

	--demodulator
	demod_inst : demodulator
	port map (
	clk80m		=> clk80m,
	symbol_num => symbol_num,
	symbol_cnt => symbol_cnt,
	indata		=> upcon_data,
	out_word		=> demod_out,
	out_en		=> demod_out_en
	);

	--spi output module for pll
	pll_spi_out_inst : pll_spi_data port map (
		clk16m => clk16m,
		reset_n => reset_n,
		spiclk => spiclk,
		spics => spics_pll,
		sdi => sdi
	);

	uart_out_inst : output_uart port map (
		clk80m => clk80m,
		in_en => uart_data_en,
		indata => uart_data,
		uart_out => uart_out
	);

	--convert to 8 bit uart data
	uart_gen_p : process (clk16m)
	begin
		if (rising_edge(clk16m)) then
			if (symbol_cnt = 6080 / 4) then
				uart_data <= demod_out(7 downto 0);
				uart_data_en <= '1';
			elsif (symbol_cnt = 6080 / 4 * 2) then
				uart_data <= demod_out(15 downto 8);
				uart_data_en <= '1';
			elsif (symbol_cnt = 6080 / 4 * 3) then
				uart_data <= demod_out(23 downto 16);
				uart_data_en <= '1';
			elsif (symbol_cnt = 6080 ) then
				uart_data <= demod_out(31 downto 24);
				uart_data_en <= '1';
			else
				uart_data_en <= '0';
			end if;
		end if;
	end process;

	--led signal handling
	led_p : process (clk16m)
	begin
		if (rising_edge(clk16m)) then
			--sw1 = reset
			reset_n <= not sw1;
			if (reset_n = '0') then
				led1 <= '0';
				led2 <= '0';
				led3 <= '0';
			else
				led1 <= sw2;
				led2 <= demod_out_en;
				led3 <= carrier_sync_stat;
			end if;
		end if;
	end process;

end rtl;
