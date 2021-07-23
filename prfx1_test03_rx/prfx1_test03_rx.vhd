library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_unsigned.all;

entity prfx1_test03_rx is 
	port (
	signal clk16m     : in std_logic;
	signal adc 			: in std_logic_vector(11 downto 0);
	signal clk5m     	: out std_logic;
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

component output_uart
	port (
	signal clk80m		: in std_logic;
	signal indata		: in std_logic_vector(11 downto 0);
	signal uart_out	: out std_logic
	);
end component;

component sync_symbol
	port (
	signal clk80m		: in std_logic;
	signal in_data		: in std_logic_vector(11 downto 0);
	signal symbol_num : out std_logic_vector(7 downto 0);
	signal symbol_cnt : out std_logic_vector(15 downto 0)
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

signal reset_n : std_logic;

signal clk80m     : std_logic;
signal clk40m     : std_logic;
signal clk12m     : std_logic;

signal raw_adc 		: std_logic_vector(11 downto 0);
signal s_adc			: std_logic_vector(11 downto 0);
signal z_adc			: std_logic_vector(11 downto 0);
signal lp_filtered	: std_logic_vector(15 downto 0);
signal bp_filtered	: std_logic_vector(17 downto 0);

signal symbol_num : std_logic_vector(7 downto 0);
signal symbol_cnt : std_logic_vector(15 downto 0);

begin

	adc_clk <= clk40m;

	attn_oe <= '1';
	attn <= conv_std_logic_vector(16#10#, 5);

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

	--sync symbol
	sync_symbol_inst : sync_symbol port map (
		clk80m => clk80m,
		in_data => s_adc,
		symbol_num => symbol_num,
		symbol_cnt => symbol_cnt
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
		indata => s_adc,
		uart_out => uart_out
	);

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
				led2 <= not sw2;
				led3 <= '1';
			end if;
		end if;
	end process;


end rtl;
