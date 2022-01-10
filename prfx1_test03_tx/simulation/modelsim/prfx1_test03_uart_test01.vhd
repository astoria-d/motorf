library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity prfx1_test03_uart_test01 is
end prfx1_test03_uart_test01;

architecture stimulus of prfx1_test03_uart_test01 is 

component prfx1_test03_tx
   port (
	signal clk16m     : in std_logic;
	signal dac 			: out std_logic_vector( 13 downto 0 );
	signal dac_clk		: out std_logic;

	signal spiclk		: out std_logic;
	signal sdi			: out std_logic;
	signal spics_dac	: out std_logic;
	signal spics_pll	: out std_logic;

	signal clk5m  		: out std_logic;

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

signal base_clk         : std_logic;
signal reset_input      : std_logic;

signal dac 			: std_logic_vector( 13 downto 0 );
signal dac_clk		: std_logic;

signal spiclk		: std_logic;
signal sdi			: std_logic;
signal spics_dac	: std_logic;
signal spics_pll	: std_logic;

signal jtg_clk		: std_logic;

signal ftdi_clk	: std_logic;
signal ftdi_txd	: std_logic;
signal ftdi_rxd	: std_logic;

signal led1			: std_logic;
signal led2			: std_logic;
signal led3			: std_logic;

constant powerup_time   : time := 500 ns;
constant reset_time     : time := 1 us;

---clock frequency = 16,000,000 Hz
--constant base_clock_time : time := 62.5 ns;
constant base_clock_time : time := 62.5 ns;

constant uart_input_time : time := 100us;
---baud rate is 460800
constant uart_clk_cycle : time := (1000000000 / 460800) * 1ns;

constant uart_input_data1 : std_logic_vector(7 downto 0) := conv_std_logic_vector(16#61#, 8);
constant uart_input_data2 : std_logic_vector(7 downto 0) := conv_std_logic_vector(16#62#, 8);
constant uart_input_data3 : std_logic_vector(7 downto 0) := conv_std_logic_vector(16#63#, 8);
constant uart_input_data4 : std_logic_vector(7 downto 0) := conv_std_logic_vector(16#0d#, 8);
constant uart_input_data5 : std_logic_vector(7 downto 0) := conv_std_logic_vector(16#ff#, 8);
constant uart_input_data6 : std_logic_vector(7 downto 0) := conv_std_logic_vector(16#64#, 8);
constant uart_input_data7 : std_logic_vector(7 downto 0) := conv_std_logic_vector(16#00#, 8);
constant uart_input_data8 : std_logic_vector(7 downto 0) := conv_std_logic_vector(16#01#, 8);

begin

    sim_board : prfx1_test03_tx port map (
		clk16m		=> base_clk,
		dac 		=> dac,
		dac_clk		=> dac_clk,

		spiclk		=> spiclk,
		sdi			=> sdi,
		spics_dac	=> spics_dac,
		spics_pll	=> spics_pll,

		clk5m		=> jtg_clk,

		ftdi_clk	=> ftdi_clk,
		ftdi_txd	=> ftdi_txd,
		ftdi_rxd	=> ftdi_rxd,

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

    --- ftdi test data.
    ftdi_p: process
    begin
        ftdi_rxd <= '1';
        wait for uart_input_time;

		--start bit
        ftdi_rxd <= '0';
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data1(0);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data1(1);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data1(2);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data1(3);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data1(4);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data1(5);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data1(6);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data1(7);
        wait for uart_clk_cycle;

		--end bit
        ftdi_rxd <= '1';
        wait for uart_clk_cycle;

		-----------data2
		--start bit
        ftdi_rxd <= '0';
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data2(0);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data2(1);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data2(2);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data2(3);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data2(4);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data2(5);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data2(6);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data2(7);
        wait for uart_clk_cycle;

        ftdi_rxd <= '1';
        wait for uart_clk_cycle;

		-----------data3
		--start bit
        ftdi_rxd <= '0';
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data3(0);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data3(1);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data3(2);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data3(3);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data3(4);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data3(5);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data3(6);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data3(7);
        wait for uart_clk_cycle;

        ftdi_rxd <= '1';
        wait for uart_clk_cycle;

		-----------data4
		--start bit
        ftdi_rxd <= '0';
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data4(0);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data4(1);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data4(2);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data4(3);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data4(4);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data4(5);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data4(6);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data4(7);
        wait for uart_clk_cycle;

        ftdi_rxd <= '1';
        wait for uart_clk_cycle;

		-----------data5
		--start bit
        ftdi_rxd <= '0';
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data5(0);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data5(1);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data5(2);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data5(3);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data5(4);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data5(5);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data5(6);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data5(7);
        wait for uart_clk_cycle;

        ftdi_rxd <= '1';
        wait for uart_clk_cycle;

		-----------data6
		--start bit
        ftdi_rxd <= '0';
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data6(0);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data6(1);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data6(2);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data6(3);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data6(4);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data6(5);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data6(6);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data6(7);
        wait for uart_clk_cycle;

        ftdi_rxd <= '1';
        wait for uart_clk_cycle;

		-----------data7
		--start bit
        ftdi_rxd <= '0';
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data7(0);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data7(1);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data7(2);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data7(3);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data7(4);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data7(5);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data7(6);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data7(7);
        wait for uart_clk_cycle;

        ftdi_rxd <= '1';
        wait for uart_clk_cycle;

		-----------data8
		--start bit
        ftdi_rxd <= '0';
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data8(0);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data8(1);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data8(2);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data8(3);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data8(4);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data8(5);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data8(6);
        wait for uart_clk_cycle;

        ftdi_rxd <= uart_input_data8(7);
        wait for uart_clk_cycle;

        ftdi_rxd <= '1';
        wait for uart_clk_cycle;

        wait;
    end process;


end stimulus;

