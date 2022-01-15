library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity uart_test_banch is
end uart_test_banch;

architecture stimulus of uart_test_banch is 

component prfx1_test03_rx
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

signal adc 			: std_logic_vector(11 downto 0);
signal adc_clk		: std_logic;

signal attn			: std_logic_vector(4 downto 0);
signal attn_oe		: std_logic;

signal ftdi_clk	: std_logic;
signal ftdi_txd	: std_logic;
signal ftdi_rxd	: std_logic;

signal spiclk		: std_logic;
signal sdi			: std_logic;
signal spics_pll	: std_logic;

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

		attn		=> attn,
		attn_oe		=> attn_oe,

		spiclk		=> spiclk,
		sdi			=> sdi,
		spics_pll	=> spics_pll,

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

end stimulus;


-------------------------------


library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity debug_stub is 
	port (
	signal clk80m		: in std_logic;
	signal reset_n		: in std_logic;
	signal symbol_num : out std_logic_vector(7 downto 0);
	signal symbol_cnt : out std_logic_vector(15 downto 0);
	signal testdata		: out std_logic_vector(31 downto 0)
	);
end debug_stub;

architecture rtl of debug_stub is 

signal work_cnt : std_logic_vector(15 downto 0);
signal work_num : std_logic_vector(7 downto 0);
signal outdata : std_logic_vector(31 downto 0);

constant offset : integer := 7 * 80;
constant integ_end : integer := 64 * 80;

begin

	count_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (reset_n = '0') then
				work_num <= "00000010";
				work_cnt <= (others => '0');
				outdata <= conv_std_logic_vector(16#b0922908#, 32);
			else
				if (work_cnt = 6080 - 1) then
					work_cnt <= (others => '0');
				else
					work_cnt <= work_cnt + conv_std_logic_vector(1, work_cnt'length);
				end if;

				if (work_cnt = 6080 - 1) then
					if (work_num = 99) then
						work_num <= (others => '0');
					else
						work_num <= work_num + conv_std_logic_vector(1, work_num'length);
					end if;
				end if;

				if (work_cnt = offset + 7 + integ_end + 1 + 5 + 2 + 16 + 1) then
					outdata <= outdata + 1;
				end if;
			end if;
		end if;
	end process;

	symbol_cnt <= work_cnt;
	symbol_num <= work_num;
	testdata <= outdata;

end rtl;

