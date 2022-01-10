

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
		signal inc_data : in std_logic;
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

component fifo
	PORT
	(
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdreq		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		empty		: OUT STD_LOGIC ;
		full		: OUT STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		usedw		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
	);
end component;

type tx_data_status is (
	TD_IDLE,
	TD_ESCAPE,
	TD_LATCH
	);

constant escape_char : std_logic_vector(7 downto 0) := (others => '1');
constant escape_idle : std_logic_vector(7 downto 0) := (others => '0');
constant END_SYM_CNT : integer := 76 * 80;

signal inc_cnt : std_logic_vector (31 downto 0) := (others => '0');
signal uart_data_tmp : std_logic_vector(7 downto 0);
signal uart_data_latch : std_logic_vector(7 downto 0);
signal uart_en : std_logic;

signal fifo_input : std_logic_vector(7 downto 0);
signal fifo_output : std_logic_vector(7 downto 0);
signal fifo_rd : std_logic;
signal fifo_wr : std_logic;
signal fifo_empty : std_logic;
signal fifo_full : std_logic;
signal fifo_cnt : std_logic_vector(3 downto 0);

signal output_cnt : std_logic_vector(3 downto 0);


signal cur_state : tx_data_status;

begin

	uart_inst : uart_in
	PORT MAP (
		clk80m => clk80m,
		uart_rxd => uart_rxd,
		uart_data => uart_data_tmp,
		uart_en => uart_en
	);

	input_fifo_inst : fifo
	PORT MAP (
		clock		=> clk80m,
		data		=> fifo_input,
		rdreq		=> fifo_rd,
		wrreq		=> fifo_wr,
		empty		=> fifo_empty,
		full		=> fifo_full,
		q			=> fifo_output,
		usedw		=> fifo_cnt
	);

	set_stat_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			case cur_state is
			when TD_IDLE =>
				if (uart_en = '1') then
					if (uart_data_tmp = escape_char or uart_data_tmp = escape_idle) then
						cur_state <= TD_ESCAPE;
					else
						cur_state <= TD_LATCH;
					end if;
				end if;
			when TD_ESCAPE =>
				cur_state <= TD_LATCH;
			when TD_LATCH =>
				cur_state <= TD_IDLE;
			end case;
		end if;
	end process;

	data_latch_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (uart_en = '1') then
				uart_data_latch <= uart_data_tmp;
			end if;
		end if;
	end process;

	data_fifo_in_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (cur_state = TD_ESCAPE) then
				fifo_input <= escape_char;
				fifo_wr <= '1';
			elsif (cur_state = TD_LATCH) then
				fifo_input <= uart_data_latch;
				fifo_wr <= '1';
			else
				fifo_wr <= '0';
			end if;
		end if;
	end process;

	data_fifo_rd_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if ((symbol_num > 2) and (symbol_cnt = 0) and (fifo_empty = '0')) then
				fifo_rd <= '1';
			elsif ((symbol_num > 2) and (symbol_cnt = 1) and (fifo_empty = '0')) then
				fifo_rd <= '1';
			elsif ((symbol_num > 2) and (symbol_cnt = 2) and (fifo_empty = '0')) then
				fifo_rd <= '1';
			elsif ((symbol_num > 2) and (symbol_cnt = 3) and (fifo_empty = '0')) then
				fifo_rd <= '1';
			else
				fifo_rd <= '0';
			end if;
		end if;
	end process;

	data_cnt_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if ((symbol_num > 2) and (symbol_cnt = 0)) then
				output_cnt <= fifo_cnt;
			end if;
		end if;
	end process;

	--output data is set at the init frame.
	set_uart_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if ((symbol_num > 2) and (symbol_cnt = 2)) then
--				outdata_reg <= outdata_3 & outdata_2 & outdata_1 & outdata_0;
				inc_cnt <= inc_cnt + 1;
			end if;
		end if;
	end process;

	set_output_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (inc_data = '0') then
				if ((symbol_num > 2) and (symbol_cnt = 2)) then
					if (output_cnt > 0) then
						tx_data(7 downto 0) <= fifo_output;
					else
						tx_data(7 downto 0) <= escape_idle;
					end if;
				end if;

				if ((symbol_num > 2) and (symbol_cnt = 3)) then
					if (output_cnt > 1) then
						tx_data(15 downto 8) <= fifo_output;
					else
						tx_data(15 downto 8) <= escape_idle;
					end if;
				end if;

				if ((symbol_num > 2) and (symbol_cnt = 4)) then
					if (output_cnt > 2) then
						tx_data(23 downto 16) <= fifo_output;
					else
						tx_data(23 downto 16) <= escape_idle;
					end if;
				end if;

				if ((symbol_num > 2) and (symbol_cnt = 5)) then
					if (output_cnt > 3) then
						tx_data(31 downto 24) <= fifo_output;
					else
						tx_data(31 downto 24) <= escape_idle;
					end if;
				end if;

			else
				tx_data <= inc_cnt;
			end if;
		end if;
	end process;

end rtl;
