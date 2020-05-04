
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;

entity spi_init_data is 
   port (
	signal clk80m     : in std_logic;
	signal reset_n		: in std_logic;
	signal indata		: out std_logic_vector( 15 downto 0 );
	signal trig			: out std_logic
	);
end spi_init_data;

architecture rtl of spi_init_data is

type spi_data_t is record
	addr : std_logic_vector(7 downto 0);
	data : std_logic_vector(7 downto 0);
end record;

type spi_data_arr_t is array(0 to 4) of spi_data_t;

--AD9117 SPI init data.
constant spi_data : spi_data_arr_t := (
	(addr => conv_std_logic_vector(16#00#, 8), data => conv_std_logic_vector(16#20#, 8)),
	(addr => conv_std_logic_vector(16#00#, 8), data => conv_std_logic_vector(16#00#, 8)),
	(addr => conv_std_logic_vector(16#02#, 8), data => conv_std_logic_vector(16#92#, 8)),
	(addr => conv_std_logic_vector(16#04#, 8), data => conv_std_logic_vector(16#80#, 8)),
	(addr => conv_std_logic_vector(16#07#, 8), data => conv_std_logic_vector(16#80#, 8))
);


begin
   spi_p : process (clk80m)
	variable cnt5 : integer range 0 to 5 := 0;
	variable cnt16 : integer range 0 to 16 := 0;
   begin
		if (falling_edge(clk80m)) then
			if (reset_n = '1') then
				indata <= (others => '0');
				trig <= '1';
				cnt5 := 0;
				cnt16 := 0;
			else
				if (cnt5 < 5) then
					if (cnt16 < 16) then
						indata <= spi_data(cnt16).addr & spi_data(cnt16).data;
						trig <= '0';
						cnt16 := cnt16 + 1;
					else
						indata <= (others => '0');
						trig <= '1';
						cnt16 := 0;
					end if;
					cnt5 := cnt5 + 1;
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

entity spi_out_dac is 
   port (
	signal clk80m     : in std_logic;
	signal indata		: in std_logic_vector( 15 downto 0 );
	signal trig			: in std_logic;

	signal spiclk		: out std_logic;
	signal spics		: out std_logic;
	signal sdi			: out std_logic
	);
end spi_out_dac;

architecture rtl of spi_out_dac is


begin

	spiclk <= clk80m;

   spi_p : process (clk80m)
	variable do_output : boolean := false;
	variable old_trig : std_logic;
	variable cnt : integer range 0 to 15 := 0;
   begin
		if (falling_edge(clk80m)) then
			old_trig := trig;

			if (old_trig = '0' and trig = '1') then
				do_output := true;
				spics <= '1';
			else
				if (cnt < 15) then
					spics <= '0';
					sdi <= indata(cnt);
					cnt := cnt + 1;
				else
					cnt := 0;
					do_output := false;
					spics <= '1';
				end if;
			end if;
		end if;
	end process;

end rtl;

