library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity testbench_prfx1_test01 is
end testbench_prfx1_test01;

architecture stimulus of testbench_prfx1_test01 is 

component prfx1_test03_rx
   port (
	signal clk16m     : in std_logic;
	signal adc 			: in std_logic_vector(11 downto 0);
	signal adc_clk		: out std_logic;

	signal spiclk		: out std_logic;
	signal sdi			: out std_logic;
	signal spics_pll	: out std_logic;

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

signal adc 			: std_logic_vector(11 downto 0);
signal adc_clk		: std_logic;

signal spiclk		: std_logic;
signal sdi			: std_logic;
signal spics_pll	: std_logic;

signal base_clk         : std_logic;
signal reset_input      : std_logic;

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

    sim_board : prfx1_test03_rx port map (
		clk16m		=> base_clk,
		adc 		=> adc,
		adc_clk		=> adc_clk,

		spiclk		=> spiclk,
		sdi			=> sdi,
		spics_pll	=> spics_pll,

		sw1     	=> reset_input,
		sw2     	=> '0',
		led1		=> led1,
		led2		=> led2,
		led3		=> led3
	);

    lpf_test_inst : test_lpf port map (
    	clk80m => base_clk,
    	reset => reset_input
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

