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

--R1=0x08008141
constant R1_PR			: std_logic_vector(1 downto 1) := "1";
constant R1_P			: std_logic_vector(12 downto 1) := "000000000001";
constant R1_M			: std_logic_vector(12 downto 1) := "000000101000";

--R0=0x00728018
constant R0_N			: std_logic_vector(16 downto 1) := "0000000011100101";
constant R0_F			: std_logic_vector(12 downto 1) := "000000000011";


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
