library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_unsigned.all;

entity prfx1_test03_tx is 
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
end prfx1_test03_tx;

architecture rtl of prfx1_test03_tx is

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

component timing_sync
	PORT
	(
		signal clk80m : in std_logic;
		signal symbol_cnt : out std_logic_vector(15 downto 0);
		signal symbol_num : out std_logic_vector(7 downto 0)
	);
END component;

component tx_data_gen
	PORT
	(
		signal clk80m : in std_logic;
		signal symbol_cnt : in std_logic_vector(15 downto 0);
		signal symbol_num : in std_logic_vector(7 downto 0);
		signal inc_data : in std_logic;
		signal uart_rxd : in std_logic;
		signal tx_data : out std_logic_vector(31 downto 0)
	);
end component;

component tx_baseband
	PORT
	(
		signal clk80m : in std_logic;
		signal symbol_cnt : in std_logic_vector(15 downto 0);
		signal symbol_num : in std_logic_vector(7 downto 0);
		signal pilot_only : in std_logic;
		signal tx_data : in std_logic_vector(31 downto 0);
		signal i_data : out std_logic_vector(15 downto 0);
		signal q_data : out std_logic_vector(15 downto 0)
	);
end component;

component lpf_24tap
	port (
	signal clk80m		: in std_logic;
	signal indata       : in std_logic_vector(15 downto 0);
	signal outdata      : out std_logic_vector(15 downto 0)
	);
end component;

component upconv
	port (
		clk80m : in std_logic;
		I : in std_logic_vector( 15 downto 0 );
		Q : in std_logic_vector( 15 downto 0 );
		I_IF : out std_logic_vector( 13 downto 0 );
		Q_IF : out std_logic_vector( 13 downto 0 )
	);
end component;

component DDR_OUT
	PORT
	(
		datain_h		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		datain_l		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		outclock		: IN STD_LOGIC;
		dataout		: OUT STD_LOGIC_VECTOR (13 DOWNTO 0)
	);
END component;

component dac_spi_init_data
   port (
		signal clk16m     : in std_logic;
		signal oe_n			: in std_logic;
		signal reset_n		: in std_logic;
		signal indata		: out std_logic_vector( 15 downto 0 );
		signal trig			: out std_logic
	);
end component;

component pll_spi_init_data
   port (
	signal clk16m     : in std_logic;
	signal oe_n			: in std_logic;
	signal reset_n		: in std_logic;
	signal indata		: out std_logic_vector(31 downto 0);
	signal trig			: out std_logic
	);
end component;

component spi_out
	generic (bus_size : integer := 16);
   port (
	signal clk16m     : in std_logic;
	signal indata		: in std_logic_vector(bus_size - 1 downto 0);
	signal trig			: in std_logic;

	signal spics		: out std_logic;
	signal sdi			: out std_logic
	);
end component;


signal clk80m  : std_logic;
signal clk40m  : std_logic;

signal symbol_cnt : std_logic_vector(15 downto 0);
signal symbol_num : std_logic_vector(7 downto 0);
signal pilot_only : std_logic;
signal no_tx : std_logic;
signal inc_data : std_logic;

signal tx_data : std_logic_vector(31 downto 0);
signal i_data : std_logic_vector(15 downto 0);
signal q_data : std_logic_vector(15 downto 0);
signal i_lpf : std_logic_vector(15 downto 0);
signal q_lpf : std_logic_vector(15 downto 0);
signal i_if : std_logic_vector(13 downto 0);
signal q_if : std_logic_vector(13 downto 0);
signal ddr_in_h : std_logic_vector(13 downto 0);
signal ddr_in_l : std_logic_vector(13 downto 0);




signal dac_en : std_logic;
signal dac_spi_data : std_logic_vector(15 downto 0);
signal dac_spi_oe_n : std_logic := '1';
signal dac_sdi : std_logic;
signal dac_cs : std_logic;

signal pll_en : std_logic;
signal pll_spi_data : std_logic_vector(31 downto 0);
signal pll_spi_oe_n : std_logic := '1';
signal pll_sdi : std_logic;
signal pll_cs : std_logic;

constant CLK_16M_PS : integer := (1000 * 1000 / 16);
constant WAIT_10US : integer := (10 * 1000 * 1000 / CLK_16M_PS);

begin

	--PLL instance
	pll_inst : pll PORT MAP (
		inclk0	=> clk16m,
		c0	 		=> clk80m,
		c1	 		=> clk40m,
		c2	 		=> ftdi_clk,
		c3	 		=> clk5m
	);

	--data generation and tranfer timing synchronizer
	timing_inst : timing_sync port map (
		clk80m => clk80m,
		symbol_cnt => symbol_cnt,
		symbol_num => symbol_num
	);

	--data generator
	data_gen_inst : tx_data_gen PORT map
	(
		clk80m => clk80m,
		symbol_cnt => symbol_cnt,
		symbol_num => symbol_num,
		inc_data => inc_data,
		uart_rxd => ftdi_rxd,
		tx_data => tx_data
	);

	--baseband encoding
	tx_baseband_inst : tx_baseband PORT map
	(
		clk80m => clk80m,
		symbol_cnt => symbol_cnt,
		symbol_num => symbol_num,
		pilot_only => pilot_only,
		tx_data => tx_data,
		i_data => i_data,
		q_data => q_data
	);

	--lpf instance
	lpf_24tap_i_inst : lpf_24tap port map (
		clk80m => clk80m,
		indata => i_data,
		outdata => i_lpf
	);
	lpf_24tap_q_inst : lpf_24tap port map (
		clk80m => clk80m,
		indata => q_data,
		outdata => q_lpf
	);

	--moto nco and upconv instance
	upconv_inst : upconv port map (
		clk80m => clk80m,
		I => i_lpf,
		Q => q_lpf,
		I_IF => i_if,
		Q_IF => q_if
	);

	--control reset signal before ddr input
	ddr_in_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (no_tx = '0') then
				-- tx is enabled
				ddr_in_h <= i_if;
				ddr_in_l <= q_if;
			else
				-- tx is disabled. zero output
				ddr_in_h <= (others => '0');
				ddr_in_l <= (others => '0');
			end if;
		end if;
	end process;

	--DDR instance
	DDR_OUT_inst : DDR_OUT PORT MAP (
		datain_h	=> ddr_in_h,
		datain_l	=> ddr_in_l,
		outclock	=> clk80m,
		dataout	=> dac
	);
	dac_clk <= clk80m;

	--dac parameter set module instance
	dac_spi_init_data_inst : dac_spi_init_data PORT MAP (
		clk16m => clk16m,
		oe_n => dac_spi_oe_n,
		reset_n => '1',
		indata => dac_spi_data,
		trig => dac_en
	);

	--spi output module for dac
	dac_spi_out_inst : spi_out generic map (16) PORT MAP (
		clk16m => clk16m,
		indata=> dac_spi_data,
		trig => dac_en,
		sdi => dac_sdi,
		spics => dac_cs
	);

	--pll parameter set module instance
	pll_spi_init_data_inst : pll_spi_init_data port map (
		clk16m => clk16m,
		oe_n => pll_spi_oe_n,
		reset_n => '1',
		indata => pll_spi_data,
		trig => pll_en
		);

	--pll output module for dac
	pll_spi_out_inst : spi_out generic map (32) PORT MAP (
		clk16m => clk16m,
		indata=> pll_spi_data,
		trig => pll_en,
		sdi => pll_sdi,
		spics => pll_cs
	);

	spiclk <= not clk16m;

   spi_init_p : process (clk16m)
	variable cnt : integer := 0;
	variable init_done : boolean := false;
   begin
		if (rising_edge(clk16m)) then
			spics_dac <= dac_cs;
			spics_pll <= pll_cs;
			if (init_done = false) then
				if (cnt <= WAIT_10US) then
					dac_spi_oe_n <= '1';
					pll_spi_oe_n <= '1';
					sdi <= '1';
				elsif (cnt >= WAIT_10US and cnt < WAIT_10US * 2) then
					dac_spi_oe_n <= '0';
					pll_spi_oe_n <= '1';
					sdi <= dac_sdi;
				elsif (cnt >= WAIT_10US * 2 and cnt < WAIT_10US * 4) then
					sdi <= pll_sdi;
					dac_spi_oe_n <= '1';
					pll_spi_oe_n <= '0';
				elsif (cnt >= WAIT_10US * 4) then
					dac_spi_oe_n <= '1';
					pll_spi_oe_n <= '1';
					sdi <= '1';
					init_done := true;
				end if;
			end if;
			cnt := cnt + 1;
		end if;
	end process;

	--led signal handling
   led_p : process (clk16m)
	variable cnt : std_logic_vector(23 downto 0);
   begin
		if (rising_edge(clk16m)) then
			--sw1 = no tx
			--sw2 = pilot only
			--sw1 and sw2 = increment data
			no_tx <= sw1 and not sw2;
			pilot_only <= sw2 and not sw1;
			inc_data <= sw1 and sw2;
			if (sw1 = '1') then
				led1 <= '0';
				led2 <= '0';
				led3 <= '0';
				cnt := (others => '0');
			else
				led1 <= sw2;
				led2 <= cnt(23);
				led3 <= '1';
				cnt := cnt + 1;
			end if;
		end if;
	end process;

end rtl;
