library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity prfx1_test06_uart_testbench is
end prfx1_test06_uart_testbench;

architecture stimulus of prfx1_test06_uart_testbench is 

component prfx1_test06_uart
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
end component;

component test_lpf
	port (
	signal clk80m       : in std_logic;
	signal reset        : in std_logic
	);
end component;

signal base_clk         : std_logic;
signal reset_input      : std_logic;

signal jtag_clk			: std_logic;

signal ftdi_clk			: std_logic;
signal ftdi_txd			: std_logic;
signal ftdi_rxd			: std_logic;

signal sw1			: std_logic;
signal sw2			: std_logic;
signal led1			: std_logic;
signal led2			: std_logic;
signal led3			: std_logic;

constant powerup_time   : time := 500 ns;
constant reset_time     : time := 1 us;

---clock frequency = 16,000,000 Hz
--constant base_clock_time : time := 62.5 ns;
constant base_clock_time : time := 62.5 ns;

begin

    sim_board : prfx1_test06_uart port map (
		clk16m		=> base_clk,
		jtag_clk		=> jtag_clk,

		ftdi_clk		=> ftdi_clk,
		ftdi_txd		=> ftdi_txd,
		ftdi_rxd		=> ftdi_rxd,

		sw1     	=> reset_input,
		sw2     	=> '0',
		led1		=> led1,
		led2		=> led2,
		led3		=> led3
	);

    --- input reset.
    reset_p: process
    begin
        reset_input <= '0';
        wait for powerup_time;

        reset_input <= '1';
        wait for reset_time;

        reset_input <= '0';
        wait;
    end process;

    --- generate base clock.
    clock_p: process
    begin
        base_clk <= '1';
        wait for base_clock_time / 2;
        base_clk <= '0';
        wait for base_clock_time / 2;
    end process;

end stimulus;

