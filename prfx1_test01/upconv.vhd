library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_unsigned.all;

entity upconv is
	PORT
	(
		signal clk16m : in std_logic;
		signal clk80m : in std_logic;
		signal reset_n : in std_logic;
		signal bb_i : in std_logic_vector(15 downto 0);
		signal bb_q : in std_logic_vector(15 downto 0);
		signal if_i : out std_logic_vector(15 downto 0);
		signal if_q : out std_logic_vector(15 downto 0)
	);
end upconv;

architecture rtl of upconv is

component moto_nco
	PORT
	(
		clk : in std_logic;
		frq : in std_logic_vector( 31 downto 0 );
		sin : out std_logic_vector( 15 downto 0 );
		cos : out std_logic_vector( 15 downto 0 )
	);
END component;

component MY_NCO
	PORT
	(
		clk : in std_logic;
		frq : in std_logic_vector( 31 downto 0 );
		sin : out std_logic_vector( 15 downto 0 );
		cos : out std_logic_vector( 15 downto 0 )
	);
END component;

signal sin : std_logic_vector(15 downto 0);
signal cos : std_logic_vector(15 downto 0);

begin

	if_i <= bb_i;
	if_q <= bb_q;
--	if_i <= sin;
--	if_q <= cos;

--	--NCO instance
--	NCO_1MHz : MY_NCO PORT MAP (
--		clk	=> clk80m,
--		frq   => conv_std_logic_vector(53687091, 32),
--		sin	=> sin,
--		cos	=> cos
--	);
	--NCO instance
	NCO_1MHz : moto_nco PORT MAP (
		clk	=> clk80m,
		frq   => conv_std_logic_vector(53687091, 32),
		sin	=> sin,
		cos	=> cos
	);


end rtl;
