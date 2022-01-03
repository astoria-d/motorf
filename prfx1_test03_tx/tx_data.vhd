

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_unsigned.all;

entity timing_sync is 
	PORT
	(
		signal clk80m : in std_logic;
		signal symbol_cnt : out std_logic_vector(15 downto 0);
		signal symbol_num : out std_logic_vector(7 downto 0)
	);
end timing_sync;

architecture rtl of timing_sync is

signal symbol_cnt_reg : std_logic_vector(15 downto 0) := (others => '0');
signal symbol_num_reg : std_logic_vector(7 downto 0)  := (others => '0');

begin

	symbol_cnt <= symbol_cnt_reg;
	symbol_num <= symbol_num_reg;
	cnt_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conv_integer(symbol_cnt_reg) = 76 * 80 - 1) then
				symbol_cnt_reg <= (others => '0');
			else
				symbol_cnt_reg <= symbol_cnt_reg + 1;
			end if;
		end if;
	end process;

	num_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conv_integer(symbol_cnt_reg) = 76 * 80 - 1) then
				if (conv_integer(symbol_num_reg) = 100 - 1) then
					symbol_num_reg <= (others => '0');
				else
					symbol_num_reg <= symbol_num_reg + 1;
				end if;
			end if;
		end if;
	end process;

end rtl;


------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_unsigned.all;

entity tx_data_gen is 
	PORT
	(
		signal clk80m : in std_logic;
		signal symbol_cnt : in std_logic_vector(15 downto 0);
		signal symbol_num : in std_logic_vector(7 downto 0);
		signal uart_rxd : in std_logic;
		signal tx_data : out std_logic_vector(31 downto 0)
	);
end tx_data_gen;

architecture rtl of tx_data_gen is

component uart_in
	port (
	signal clk80m			: in std_logic;
	signal uart_rxd		: in std_logic;
	signal uart_data		: out std_logic_vector(7 downto 0);
	signal uart_en			: out std_logic
	);
end component;

type tx_data_status is (
	TD_IDLE,
	TD_ESCAPE,
	TD_LATCH
	);

constant escape_char : std_logic_vector(7 downto 0) := (others => '1');
constant escape_idle : std_logic_vector(7 downto 0) := (others => '0');

signal outdata_reg : std_logic_vector(31 downto 0) := (others => '0');
signal uart_data : std_logic_vector(7 downto 0);
signal uart_data_latch : std_logic_vector(7 downto 0);
signal uart_en : std_logic;
signal outdata_0 : std_logic_vector(7 downto 0);
signal outdata_1 : std_logic_vector(7 downto 0);
signal outdata_2 : std_logic_vector(7 downto 0);
signal outdata_3 : std_logic_vector(7 downto 0);

signal cur_state : tx_data_status;
signal next_state : tx_data_status;

begin

	uart_inst : uart_in
	PORT MAP (
		clk80m => clk80m,
		uart_rxd => uart_rxd,
		uart_data => uart_data,
		uart_en => uart_en
	);

	set_nx_stat_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			case cur_state is
			when TD_IDLE =>
				if (uart_en = '1') then
					uart_data_latch <= uart_data;
					if (uart_data = escape_char or uart_data = escape_idle) then
						next_state <= TD_ESCAPE;
					else
						next_state <= TD_LATCH;
					end if;
				end if;
			when TD_ESCAPE =>
				next_state <= TD_LATCH;
			when TD_LATCH =>
				next_state <= TD_IDLE;
			end case;
		end if;
	end process;

	set_cr_stat_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (((symbol_num = 0) or (symbol_num = 25) or (symbol_num = 50) or (symbol_num = 75)) and (symbol_cnt = 0)) then
				cur_state <= next_state;
			end if;
		end if;
	end process;

	--data is captured at the beginning of 1/4 frame.
	set_data0_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if ((symbol_num = 0) and (symbol_cnt = 1)) then
				if (cur_state = TD_ESCAPE) then
					outdata_0 <= escape_char;
				elsif (cur_state = TD_LATCH) then
					outdata_0 <= uart_data_latch;
				else
					outdata_0 <= escape_idle;
				end if;
			end if;
		end if;
	end process;

	set_data1_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if ((symbol_num = 25) and (symbol_cnt = 1)) then
				if (cur_state = TD_ESCAPE) then
					outdata_1 <= escape_char;
				elsif (cur_state = TD_LATCH) then
					outdata_1 <= uart_data_latch;
				else
					outdata_1 <= escape_idle;
				end if;
			end if;
		end if;
	end process;

	set_data2_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if ((symbol_num = 50) and (symbol_cnt = 1)) then
				if (cur_state = TD_ESCAPE) then
					outdata_2 <= escape_char;
				elsif (cur_state = TD_LATCH) then
					outdata_2 <= uart_data_latch;
				else
					outdata_2 <= escape_idle;
				end if;
			end if;
		end if;
	end process;

	set_data3_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if ((symbol_num = 75) and (symbol_cnt = 1)) then
				if (cur_state = TD_ESCAPE) then
					outdata_3 <= escape_char;
				elsif (cur_state = TD_LATCH) then
					outdata_3 <= uart_data_latch;
				else
					outdata_3 <= escape_idle;
				end if;
			end if;
		end if;
	end process;

	--output data is set at the init frame.
	tx_data <= outdata_reg;
	set_p80m : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if ((symbol_num = 1) and (symbol_cnt = 1)) then
				outdata_reg <= outdata_3 & outdata_2 & outdata_1 & outdata_0;
			end if;
		end if;
	end process;

end rtl;
