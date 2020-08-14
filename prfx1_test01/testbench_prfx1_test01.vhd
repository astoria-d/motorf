library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity testbench_prfx1_test01 is
end testbench_prfx1_test01;

architecture stimulus of testbench_prfx1_test01 is 

component prfx1_test01
   port (
	signal clk16m     : in std_logic;
	signal dac 			: out std_logic_vector( 13 downto 0 );
	signal dac_clk		: out std_logic;

	signal spiclk		: out std_logic;
	signal sdi			: out std_logic;
	signal spics_dac	: out std_logic;
	signal spics_pll	: out std_logic;

	signal sw1     	: in std_logic;
	signal sw2     	: in std_logic;
	signal led1			: out std_logic;
	signal led2			: out std_logic;
	signal led3			: out std_logic
	);
end component;

component CORDIC
    port(
        i_clk   :in     std_logic                       ;--クロック
        i_theta :in     std_logic_vector(18 downto 0)   ;--目標角度0～360°(整数9bit 小数10bit)
        i_ena   :in     std_logic                       ;--イネーブル
        o_ena   :out    std_logic                       ;--イネーブル
        o_sin   :out    std_logic_vector(15 downto 0)   );--
end component;


signal base_clk         : std_logic;
signal reset_input      : std_logic;

signal dac 			: std_logic_vector( 13 downto 0 );
signal dac_clk		: std_logic;

signal spiclk		: std_logic;
signal sdi			: std_logic;
signal spics_dac	: std_logic;
signal spics_pll	: std_logic;

signal led1			: std_logic;
signal led2			: std_logic;
signal led3			: std_logic;

signal theta        : std_logic_vector(18 downto 0);
signal sin          : std_logic_vector(15 downto 0);
signal o_sin        : std_logic;

constant powerup_time   : time := 500 ns;
constant reset_time     : time := 1 us;

---clock frequency = 16,000,000 Hz
--constant base_clock_time : time := 62.5 ns;
constant base_clock_time : time := 62.5 ns;

begin

    sim_board : prfx1_test01 port map (
		clk16m		=> base_clk,
		dac 		=> dac,
		dac_clk		=> dac_clk,

		spiclk		=> spiclk,
		sdi			=> sdi,
		spics_dac	=> spics_dac,
		spics_pll	=> spics_pll,

		sw1     	=> reset_input,
		sw2     	=> '0',
		led1		=> led1,
		led2		=> led2,
		led3		=> led3
	);

    cordic_inst : CORDIC port map (
        i_clk   => base_clk,
        i_theta => theta,
        i_ena   => '1',
        o_ena   => o_sin,
        o_sin   => sin
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

    theta_p : process (base_clk)
    use ieee.std_logic_arith.conv_std_logic_vector;
    variable cnt : integer range 0 to 360000 := 0;
    begin
		if (rising_edge(base_clk)) then
		    theta <= conv_std_logic_vector(cnt, 19);
		    if (cnt < 360000 - 10000) then
    		    cnt := cnt + 10000;
		    else
    		    cnt := 0;
		    end if;
		end if;
	end process;

end stimulus;

