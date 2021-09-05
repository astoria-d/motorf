
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;

entity dac_spi_init_data is 
   port (
	signal clk16m     : in std_logic;
	signal oe_n			: in std_logic;
	signal reset_n		: in std_logic;
	signal indata		: out std_logic_vector(15 downto 0);
	signal trig			: out std_logic
	);
end dac_spi_init_data;

architecture rtl of dac_spi_init_data is

type spi_data_t is record
	addr : std_logic_vector(7 downto 0);
	data : std_logic_vector(7 downto 0);
end record;

type spi_data_arr_t is array(0 to 4) of spi_data_t;

constant SPI_CONTROL 	: integer := 16#00#;
constant POWER_DOWN 		: integer := 16#01#;
constant DATA_CONTROL 	: integer := 16#02#;
constant I_DAC_GAIN 		: integer := 16#03#;
constant I_RSET 			: integer := 16#04#;
constant I_RCML 			: integer := 16#05#;
constant Q_DAC_GAIN 		: integer := 16#06#;
constant Q_RSET 			: integer := 16#07#;
constant Q_RCML 			: integer := 16#08#;
constant AUX_DAC_Q 		: integer := 16#09#;
constant AUX_CTL_Q 		: integer := 16#0a#;
constant AUX_DAC_I 		: integer := 16#0b#;
constant AUX_CTL_I 		: integer := 16#0c#;
constant REF_REG 			: integer := 16#0d#;
constant CAL_CTL 			: integer := 16#0e#;
constant CAL_MEM 			: integer := 16#0f#;
constant MEM_ADDR 		: integer := 16#10#;
constant MEM_DATA 		: integer := 16#11#;
constant MEM_RW 			: integer := 16#12#;
constant CLK_MODE 		: integer := 16#14#;
constant VERSION 			: integer := 16#1f#;


--AD9117 SPI init data.
constant spi_data : spi_data_arr_t := (
	--reset (0x0020)
	(addr => conv_std_logic_vector(SPI_CONTROL, 8), data => conv_std_logic_vector(16#20#, 8)),
	--clear reset (0x0000)
	(addr => conv_std_logic_vector(SPI_CONTROL, 8), data => (others => '0')),
	--TWOS, SIMULBIT, DCOSGL (0x0292)
	(addr => conv_std_logic_vector(DATA_CONTROL, 8), data => conv_std_logic_vector(16#92#, 8)),
	--IRSETEN (0x0480)
	(addr => conv_std_logic_vector(I_RSET, 8), data => conv_std_logic_vector(16#80#, 8)),
	--QRSETEN (0x0780)
	(addr => conv_std_logic_vector(Q_RSET, 8), data => conv_std_logic_vector(16#80#, 8))
);


begin
   spi_p : process (clk16m)
	variable cnt5 : integer range 0 to 5 := 0;
	variable cnt16 : integer range 0 to 16 := 0;
   begin
		if (rising_edge(clk16m)) then
			if (reset_n = '0' or oe_n = '1') then
				indata <= (others => '0');
				trig <= '1';
				cnt5 := 0;
				cnt16 := 0;
			else
				if (cnt5 < 5) then
					if (cnt16 < 16) then
						indata <= spi_data(cnt5).addr & spi_data(cnt5).data;
						trig <= '0';
						cnt16 := cnt16 + 1;
					else
						indata <= (others => '0');
						trig <= '1';
						cnt16 := 0;
						cnt5 := cnt5 + 1;
					end if;
				else
					indata <= (others => '0');
					trig <= '1';
				end if;
			end if;
		end if;
	end process;

end rtl;



--------------------------------
--------------------------------
--------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;

entity pll_spi_init_data is 
   port (
	signal clk16m     : in std_logic;
	signal oe_n			: in std_logic;
	signal reset_n		: in std_logic;
	signal indata		: out std_logic_vector(31 downto 0);
	signal trig			: out std_logic
	);
end pll_spi_init_data;

architecture rtl of pll_spi_init_data is

type spi_data_arr_t is array(0 to 5) of std_logic_vector(31 downto 0);

--R5=0x00580005
constant R5_D			: std_logic_vector(15 downto 14) := "01";

--R4=0x00a2a124
constant R4_BS			: std_logic_vector(8 downto 1) := "00101010";
constant R4_D			: std_logic_vector(13 downto 1) := "1010000100100";

--R3=0x00001003
constant R3_F			: std_logic_vector(1 downto 1) := "0";
constant R3_C			: std_logic_vector(2 downto 1) := "00";
constant R3_D			: std_logic_vector(12 downto 1) := "001000000000";

--R2=0x18005742
constant R2_L			: std_logic_vector(2 downto 1) := "00";
constant R2_M			: std_logic_vector(3 downto 1) := "110";
constant R2_RD			: std_logic_vector(2 downto 1) := "00";
constant R2_R			: std_logic_vector(10 downto 1) := "0000000001";
constant R2_D			: std_logic_vector(1 downto 1) := "0";
constant R2_CP			: std_logic_vector(4 downto 1) := "1011";
constant R2_U			: std_logic_vector(6 downto 1) := "101000";

--R1=0x08008041
constant R1_PR			: std_logic_vector(1 downto 1) := "1";
constant R1_P			: std_logic_vector(12 downto 1) := "000000000001";
constant R1_M			: std_logic_vector(12 downto 1) := "000000001000";

--R0=0x00720038
constant R0_N			: std_logic_vector(16 downto 1) := "0000000011100100";
constant R0_F			: std_logic_vector(12 downto 1) := "000000000111";


--ADF4350 SPI init data.
constant spi_data : spi_data_arr_t := (
	--register5
	("00000000" & R5_D & "0110000000000000000" & "101"),
	--register4
	("00000000" & R4_D(13 downto 10) & R4_BS & R4_D(9 downto 1) & "100"),
	--register3
	("0000000000000" & R3_F & "0" & R3_C & R3_D & "011"),
	--register2
	("0" & R2_L & R2_M & R2_RD & R2_R & R2_D & R2_CP & R2_U & "010"),
	--register1
	("0000" & R1_PR & R1_P & R1_M & "001"),
	--register0
	("0" & R0_N & R0_F & "000")
);


begin
   spi_p : process (clk16m)
	variable cnt6 : integer range 0 to 6 := 0;
	variable cnt32 : integer range 0 to 32 := 0;
   begin
		if (rising_edge(clk16m)) then
			if (reset_n = '0' or oe_n = '1') then
				indata <= (others => '0');
				trig <= '1';
				cnt6 := 0;
				cnt32 := 0;
			else
				if (cnt6 < 6) then
					if (cnt32 < 32) then
						indata <= spi_data(cnt6);
						trig <= '0';
						cnt32 := cnt32 + 1;
					else
						indata <= (others => '0');
						trig <= '1';
						cnt32 := 0;
						cnt6 := cnt6 + 1;
					end if;
				else
					indata <= (others => '0');
					trig <= '1';
				end if;
			end if;
		end if;
	end process;

end rtl;



--------------------------------
--------------------------------
--------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;

entity spi_out is 
	generic (bus_size : integer := 16);
   port (
	signal clk16m     : in std_logic;
	signal indata		: in std_logic_vector(bus_size - 1 downto 0);
	signal trig			: in std_logic;

	signal spics		: out std_logic;
	signal sdi			: out std_logic
	);
end spi_out;

architecture rtl of spi_out is

begin

   spi_p : process (clk16m)
	variable cnt : integer range 0 to bus_size := 0;
   begin
		if (rising_edge(clk16m)) then

			if (trig = '1') then
				cnt := 0;
				spics <= '1';
				sdi <= '1';
			else
				if (cnt < bus_size) then
					spics <= '0';
					sdi <= indata(bus_size - 1 - cnt);
					cnt := cnt + 1;
				else
					cnt := 0;
					spics <= '1';
				end if;
			end if;
		end if;
	end process;

end rtl;
