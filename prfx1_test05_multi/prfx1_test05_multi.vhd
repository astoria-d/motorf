library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_unsigned.all;

entity prfx1_test05_multi is 
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
end prfx1_test05_multi;

architecture rtl of prfx1_test05_multi is

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

component output_uart
	port (
	signal clk80m		: in std_logic;
	signal in_en		: in std_logic;
	signal indata		: in std_logic_vector(7 downto 0);
	signal uart_out	: out std_logic
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


signal reset_n : std_logic;

signal clk80m		: std_logic;
signal clk40m		: std_logic;
signal clk12m		: std_logic;
signal clk5m     	: std_logic;

signal data_1	: std_logic_vector(15 downto 0) := (others => '0');
signal data_2	: std_logic_vector(15 downto 0) := (others => '0');

signal mul_wk		: std_logic_vector(31 downto 0);
signal data_mul	: std_logic_vector(31 downto 0);

signal uart_data	: std_logic_vector(7 downto 0);
signal uart_en		: std_logic;


begin

	jtag_clk <= clk80m;

	--PLL instance
	pll_inst : pll PORT MAP (
		inclk0	=> clk16m,
		c0	 		=> clk80m,
		c1	 		=> clk40m,
		c2	 		=> clk12m,
		c3	 		=> clk5m
	);

	uart_out_inst : output_uart port map (
		clk80m => clk40m,
		in_en => uart_en,
		indata => uart_data,
		uart_out => uart_out
	);

	mul_s_ist : multi_0 PORT MAP ( clock => clk40m, dataa => data_1, datab => data_2, result => mul_wk );

	--led signal handling
	indata_p : process (clk40m)
	begin
		if (rising_edge(clk40m)) then
			data_1 <= data_1 + 1;
			data_2 <= data_2 - 13;
		end if;
	end process;

	--convert to 8 bit uart data
	uart_gen_p : process (clk40m)
	variable cnt : std_logic_vector(4 downto 0) := (others => '0');
	begin
		if (rising_edge(clk40m)) then
			cnt := cnt + 1;

			if (cnt = 31) then
				data_mul <= mul_wk;
			end if;

			if (cnt(2 downto 0) = 0) then
				uart_en <= '1';
			else
				uart_en <= '0';
			end if;

			if (cnt = 0) then
				uart_data <= data_mul(31 downto 24);
			elsif (cnt = 8) then
				uart_data <= data_mul(23 downto 16);
			elsif (cnt = 16) then
				uart_data <= data_mul(15 downto 8);
			elsif (cnt = 24) then
				uart_data <= data_mul(7 downto 0);
			end if;

		end if;
	end process;

	--led signal handling
	led_p : process (clk40m)
	begin
		if (rising_edge(clk40m)) then
			--sw1 = reset
			reset_n <= not sw1;
			if (reset_n = '0') then
				led1 <= '0';
				led2 <= '0';
				led3 <= '0';
			else
				led1 <= sw2;
				led2 <= '0';
				led3 <= '1';
			end if;
		end if;
	end process;

end rtl;
