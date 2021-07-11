library ieee;
use ieee.std_logic_1164.all;

package motorf is
	function sign_extend_11_to_29 (
		signal indata_11 : in std_logic_vector
		) return std_logic_vector;

	function sign_extend_24_to_25 (
		signal indata_24 : in std_logic_vector
		) return std_logic_vector;

end package motorf;

package body motorf is

function sign_extend_11_to_29 (
	signal indata_11 : in std_logic_vector
	) return std_logic_vector
	is
variable retdata : std_logic_vector(29 downto 0);
begin
	if (indata_11(11) = '0') then
		retdata := "000000000000000000" & indata_11;
	else
		retdata := "111111111111111111" & indata_11;
	end if;
	return retdata;
end sign_extend_11_to_29;

function sign_extend_24_to_25 (
	signal indata_24 : in std_logic_vector
	) return std_logic_vector
	is
variable retdata : std_logic_vector(25 downto 0);
begin
	if (indata_24(24) = '0') then
		retdata := "0" & indata_24;
	else
		retdata := "1" & indata_24;
	end if;
	return retdata;
end sign_extend_24_to_25;

end package body motorf;

