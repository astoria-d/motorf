library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_unsigned.all;

entity prfx1_test06_uart is 
	port (
	signal clk16m     : in std_logic;
	signal jtag_clk   : out std_logic;

	signal ftdi_clk	: out std_logic;
	signal ftdi_txd	: out std_logic;
	signal ftdi_rxd	: in std_logic;

	signal sw1     	: in std_logic;
	signal sw2     	: in std_logic;
	signal led1			: out std_logic;
	signal led2			: out std_logic;
	signal led3			: out std_logic
	);
end prfx1_test06_uart;

architecture rtl of prfx1_test06_uart is

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

component uart_out
	port (
	signal clk80m			: in std_logic;
	signal uart_en			: in std_logic;
	signal uart_data		: in std_logic_vector(7 downto 0);
	signal uart_txd		: out std_logic
	);
end component;

signal reset_n : std_logic;

signal clk80m		: std_logic;
signal clk40m		: std_logic;
signal clk12m		: std_logic;
signal clk5m     	: std_logic;

signal uart_data	: std_logic_vector(7 downto 0);
signal uart_data_en	: std_logic;

signal uart_clk_cnt : std_logic_vector (10 downto 0);
constant input_data_div		: integer := 196 * 8;

begin

	jtag_clk <= clk5m;
	ftdi_clk <= clk12m;

	--PLL instance
	pll_inst : pll PORT MAP (
		inclk0	=> clk16m,
		c0	 		=> clk80m,
		c1	 		=> clk40m,
		c2	 		=> clk12m,
		c3	 		=> clk5m
	);

	uart_out_inst : uart_out PORT MAP (
		clk80m			=> clk80m,
		uart_en			=> uart_data_en,
		uart_data		=> uart_data,
		uart_txd			=> ftdi_txd
	);

	--led signal handling
	led_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			--sw1 = reset
			reset_n <= not sw1;
			if (reset_n = '0') then
				led1 <= '0';
				led2 <= '0';
				led3 <= '0';
			else
				led1 <= sw2;
				led2 <= not sw2;
				led3 <= sw2;
			end if;
		end if;
	end process;

	uart_clk_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (reset_n = '0') then
				uart_clk_cnt <= (others => '0');
			else
				if (uart_clk_cnt = input_data_div) then
					uart_clk_cnt <= (others => '0');
				else
					uart_clk_cnt <= uart_clk_cnt + 1;
				end if;
			end if;
		end if;
	end process;

	uart_data_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (reset_n = '0') then
				uart_data <= (others => '0');
			else
				if (uart_clk_cnt = 0) then
					uart_data <= uart_data + 1;
				end if;
			end if;
		end if;
	end process;

	uart_en_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (uart_clk_cnt = 1) then
				uart_data_en <= '1';
			else
				uart_data_en <= '0';
			end if;
		end if;
	end process;

end rtl;
