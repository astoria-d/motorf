library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

package motorf is
-- used in zero offset
	function sign_extend_12_to_30 (
		signal indata_12 : in std_logic_vector
		) return std_logic_vector;

--used in lpf
	function sign_extend_24_to_27 (
		signal indata_24 : in signed
		) return signed;

--used in lpf
	function sign_extend_27_to_29 (
		signal indata_27 : in signed
		) return signed;

end package motorf;

package body motorf is

-- used in zero offset
function sign_extend_12_to_30 (
	signal indata_12 : in std_logic_vector
	) return std_logic_vector
	is
variable retdata : std_logic_vector(29 downto 0);
begin
	if (indata_12(11) = '0') then
		retdata := "000000000000000000" & indata_12;
	else
		retdata := "111111111111111111" & indata_12;
	end if;
	return retdata;
end sign_extend_12_to_30;

--used in lpf
function sign_extend_24_to_27 (
	signal indata_24 : in signed
	) return signed
	is
variable retdata : signed(26 downto 0);
begin
	if (indata_24(23) = '0') then
		retdata := "000" & indata_24;
	else
		retdata := "111" & indata_24;
	end if;
	return retdata;
end sign_extend_24_to_27;

--used in lpf
function sign_extend_27_to_29 (
	signal indata_27 : in signed
	) return signed
	is
variable retdata : signed(28 downto 0);
begin
	if (indata_27(26) = '0') then
		retdata := "00" & indata_27;
	else
		retdata := "11" & indata_27;
	end if;
	return retdata;
end sign_extend_27_to_29;



end package body motorf;

