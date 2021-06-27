library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;

entity lpf is 
    generic (in_size : integer := 16; out_size : integer := 8; tap : integer := 25);
	port (
	signal clk16m		: in std_logic;
	signal indata       : in std_logic_vector(in_size - 1 downto 0);
	signal outdata      : out std_logic_vector(out_size - 1 downto 0)
	);
end lpf;

architecture rtl of lpf is

begin

end rtl;
