library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity prfx1_test04_nco_test01 is
end prfx1_test04_nco_test01;

architecture stimulus of prfx1_test04_nco_test01 is 

component prfx1_test04_nco
   port (
	signal clk16m     : in std_logic;
	signal dac 			: out std_logic_vector( 13 downto 0 );
	signal dac_clk		: out std_logic;

	signal spiclk		: out std_logic;
	signal sdi			: out std_logic;
	signal spics_dac	: out std_logic;

	signal jtg_clk	: out std_logic;

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

signal jtg_clk		: std_logic;

signal led1			: std_logic;
signal led2			: std_logic;
signal led3			: std_logic;

constant powerup_time   : time := 500 ns;
constant reset_time     : time := 1 us;

---clock frequency = 16,000,000 Hz
--constant base_clock_time : time := 62.5 ns;
constant base_clock_time : time := 62.5 ns;

begin

    sim_board : prfx1_test04_nco port map (
		clk16m		=> base_clk,
		dac 		=> dac,
		dac_clk		=> dac_clk,

		spiclk		=> spiclk,
		sdi			=> sdi,
		spics_dac	=> spics_dac,

		jtg_clk		=> jtg_clk,

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

