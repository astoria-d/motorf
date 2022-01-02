library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_unsigned.all;

entity uart_out is 
	port (
	signal clk80m			: in std_logic;
	signal uart_en			: in std_logic;
	signal uart_data		: in std_logic_vector(7 downto 0);
	signal uart_txd		: out std_logic
	);
end uart_out;

architecture rtl of uart_out is

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
constant baud_rate		: integer := 921600;
constant divider			: integer := clk_freq / baud_rate;

signal cur_state			: uart_status;
signal next_state			: uart_status;
signal reg_uart_data		: std_logic_vector(7 downto 0);

begin


	uart_nx_stat_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			case cur_state is
			when IDLE =>
				if uart_en = '1' then
					next_state <= UT_START;
					reg_uart_data <= uart_data;
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
			when others =>
				next_state <= IDLE;
			end case;
		end if;
	end process;

	uart_cr_stat_p : process (clk80m)
	variable cnt : integer := 0;
	begin
		if (rising_edge(clk80m)) then
			if (next_state = UT_START) then
				cur_state <= next_state;
				cnt := 0;
			elsif (cnt < divider) then
				cnt := cnt + 1;
			else
				cur_state <= next_state;
				cnt := 0;
			end if;
		end if;
	end process;

	uart_tx_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			case cur_state is
			when IDLE =>
				uart_txd <= '1';
			when UT_START =>
				uart_txd <= '0';
			when UT_DATA0 =>
				uart_txd <= reg_uart_data(0);
			when UT_DATA1 =>
				uart_txd <= reg_uart_data(1);
			when UT_DATA2 =>
				uart_txd <= reg_uart_data(2);
			when UT_DATA3 =>
				uart_txd <= reg_uart_data(3);
			when UT_DATA4 =>
				uart_txd <= reg_uart_data(4);
			when UT_DATA5 =>
				uart_txd <= reg_uart_data(5);
			when UT_DATA6 =>
				uart_txd <= reg_uart_data(6);
			when UT_DATA7 =>
				uart_txd <= reg_uart_data(7);
			when UT_STOP =>
				uart_txd <= '1';
			end case;
		end if;
	end process;

end rtl;
