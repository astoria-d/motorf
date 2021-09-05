
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity cordic_nco is 
	PORT
	(
		clk : in std_logic;
		frq : in std_logic_vector( 31 downto 0 );
		sin : out signed( 15 downto 0 );
		cos : out signed( 15 downto 0 )
	);
end cordic_nco;

architecture rtl of cordic_nco is

begin

end rtl;




----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity nco_1mhz is 
	PORT
	(
		clk80m : in std_logic;
		sin : out std_logic_vector( 13 downto 0 );
		cos : out std_logic_vector( 13 downto 0 )
	);
end nco_1mhz;

architecture rtl of nco_1mhz is

--component cordic_nco
component MY_NCO
	PORT
	(
		clk : in std_logic;
		frq : in std_logic_vector( 31 downto 0 );
		sin : out signed( 15 downto 0 );
		cos : out signed( 15 downto 0 )
	);
end component;

signal sin_16 : signed(15 downto 0);
signal cos_16 : signed(15 downto 0);

begin

	sin <= std_logic_vector(sin_16(15 downto 2));
	cos <= std_logic_vector(cos_16(15 downto 2));
--	cordic_nco_inst : cordic_nco PORT MAP (
	cordic_nco_inst : MY_NCO PORT MAP (
		clk	=> clk80m,
		frq	=> conv_std_logic_vector(53687091, 32),
		sin	=> sin_16,
		cos	=> cos_16
	);

end rtl;
