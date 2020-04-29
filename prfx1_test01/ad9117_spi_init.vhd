
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


begin
   spi_p : process (clk80m)
   begin
		if (falling_edge(clk80m)) then
			indata <= (others => '0');
			trig <= '1';
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

