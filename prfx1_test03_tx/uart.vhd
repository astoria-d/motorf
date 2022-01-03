library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_unsigned.all;

entity uart_in is 
	port (
	signal clk80m			: in std_logic;
	signal uart_rxd		: in std_logic;
	signal uart_data		: out std_logic_vector(7 downto 0);
	signal uart_en			: out std_logic
	);
end uart_in;

architecture rtl of uart_in is

type uart_status is (
	IDLE,
	UT_START,
	UT_DATA0,
	UT_DATA1,
	UT_DATA2,
	UT_DATA3,
	UT_DATA4,
	UT_DATA5,
	UT_DATA6,
	UT_DATA7,
	UT_STOP
	);

constant clk_freq			: integer := 80000000;
constant baud_rate		: integer := 230400;
--constant baud_rate		: integer := 1200;
constant divider			: integer := clk_freq / baud_rate;

signal cur_state			: uart_status;
signal next_state			: uart_status;
signal reg_uart_data		: std_logic_vector(7 downto 0);
signal uart_cnt : integer;

begin

	uart_nx_stat_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			case cur_state is
			when IDLE =>
				if uart_rxd = '0' then
					next_state <= UT_START;
				end if;
			when UT_START =>
				next_state <= UT_DATA0;
			when UT_DATA0 =>
				next_state <= UT_DATA1;
			when UT_DATA1 =>
				next_state <= UT_DATA2;
			when UT_DATA2 =>
				next_state <= UT_DATA3;
			when UT_DATA3 =>
				next_state <= UT_DATA4;
			when UT_DATA4 =>
				next_state <= UT_DATA5;
			when UT_DATA5 =>
				next_state <= UT_DATA6;
			when UT_DATA6 =>
				next_state <= UT_DATA7;
			when UT_DATA7 =>
				next_state <= UT_STOP;
			when UT_STOP =>
				next_state <= IDLE;
			end case;
		end if;
	end process;

	uart_cr_stat_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (cur_state = IDLE and next_state = UT_START) then
				cur_state <= next_state;
				uart_cnt <= 0;
			elsif (uart_cnt > divider) then
				cur_state <= next_state;
				uart_cnt <= 0;
			else
				uart_cnt <= uart_cnt + 1;
			end if;
		end if;
	end process;

	uart_data <= reg_uart_data;
	uart_rx_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			--capture data in half of clock cycle.
			if (uart_cnt = divider / 2) then
				if (cur_state = UT_DATA0) then
					reg_uart_data(0) <= uart_rxd;
				elsif (cur_state = UT_DATA1) then
					reg_uart_data(1) <= uart_rxd;
				elsif (cur_state = UT_DATA2) then
					reg_uart_data(2) <= uart_rxd;
				elsif (cur_state = UT_DATA3) then
					reg_uart_data(3) <= uart_rxd;
				elsif (cur_state = UT_DATA4) then
					reg_uart_data(4) <= uart_rxd;
				elsif (cur_state = UT_DATA5) then
					reg_uart_data(5) <= uart_rxd;
				elsif (cur_state = UT_DATA6) then
					reg_uart_data(6) <= uart_rxd;
				elsif (cur_state = UT_DATA7) then
					reg_uart_data(7) <= uart_rxd;
				end if;
			end if;
		end if;
	end process;

	uart_en_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (uart_cnt = divider / 2) then
				if (cur_state = UT_STOP) then
					uart_en <= '1';
				else
					uart_en <= '0';
				end if;
			end if;
		end if;
	end process;

end rtl;
