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

component demodulator_dummy
	port (
	signal reset_n 	: in std_logic;
	signal clk80m		: in std_logic;
	signal out_en		: out std_logic;
	signal out_word 	: out std_logic_vector(7 downto 0)
	);
end component;

signal reset_n : std_logic;

signal clk80m		: std_logic;
signal clk40m		: std_logic;
signal clk12m		: std_logic;
signal clk5m     	: std_logic;

signal baseband_data	: std_logic_vector(7 downto 0);
signal baseband_data_en	: std_logic;



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

	demodulator_dummy_inst : demodulator_dummy PORT MAP (
		reset_n 			=> reset_n,
		clk80m			=> clk80m,
		out_en			=> baseband_data_en,
		out_word			=> baseband_data
	);

	uart_out_inst : uart_out PORT MAP (
		clk80m			=> clk80m,
		uart_en			=> baseband_data_en,
		uart_data		=> baseband_data,
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

end rtl;


--------------------
--------------------
--------------------
--------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity demodulator_dummy is
	port (
	signal reset_n 	: in std_logic;
	signal clk80m		: in std_logic;
	signal out_en		: out std_logic;
	signal out_word 	: out std_logic_vector(7 downto 0)
	);
end demodulator_dummy;

architecture rtl of demodulator_dummy is

constant escape_char : std_logic_vector(7 downto 0) := (others => '1');
constant escape_idle : std_logic_vector(7 downto 0) := (others => '0');

---demodulator 1 frame is 6080 clocks.
---divide by 4 to create 8 bit data stream.
constant input_data_period		: integer := 6080 / 4;
constant uart_start_time : time := 10 us;


signal clk_cnt : std_logic_vector (10 downto 0);
signal data_cnt : std_logic_vector (3 downto 0);
signal uart_start : std_logic;

begin

	--- modelsim
	--- start testing.
	uart_data_in: process
	begin
		uart_start <= '0';
		wait for uart_start_time;
		uart_start <= '1';
		wait;
	end process;

	-- for actual hardware
	--	uart_start <= '1';

	---dummy demod clock counter
	data_clk_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (reset_n = '0') then
				clk_cnt <= (others => '0');
			else
				if (clk_cnt = input_data_period) then
					clk_cnt <= (others => '0');
				else
					clk_cnt <= clk_cnt + 1;
				end if;
			end if;
		end if;
	end process;

	out_data_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (reset_n = '0' or uart_start = '0') then
				out_word <= (others => '0');
				data_cnt <= (others => '0');
			else
				if (clk_cnt = 0) then
					data_cnt <= data_cnt + 1;
					if (data_cnt = conv_std_logic_vector(2, data_cnt'length)) then
						-- escape "00000000"
						out_word <= escape_char;
					elsif (data_cnt = conv_std_logic_vector(3, data_cnt'length)) then
						out_word <= escape_idle;
					elsif (data_cnt = conv_std_logic_vector(6, data_cnt'length)) then
						-- escape "11111111"
						out_word <= escape_char;
					elsif (data_cnt = conv_std_logic_vector(7, data_cnt'length)) then
						out_word <= escape_char;
					elsif (data_cnt = conv_std_logic_vector(9, data_cnt'length)) then
						out_word <= conv_std_logic_vector(16#64#, out_word'length);
					elsif (data_cnt = conv_std_logic_vector(10, data_cnt'length)) then
						out_word <= conv_std_logic_vector(16#65#, out_word'length);
					elsif (data_cnt = conv_std_logic_vector(11, data_cnt'length)) then
						out_word <= conv_std_logic_vector(16#2E#, out_word'length);
					else
						out_word <= (others => '0');
					end if;
				end if;
			end if;
		end if;
	end process;

	en_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (reset_n = '0' or uart_start = '0') then
				out_en <= '0';
			else
				-- output on clock=10
				if (clk_cnt = 10) then
					out_en <= '1';
				else
					out_en <= '0';
				end if;
			end if;
		end if;
	end process;


end rtl;


