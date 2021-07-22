library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

package motorf is
-- used in zero offset
	function sign_extend_12_to_30 (
		signal indata_12 : in std_logic_vector
		) return std_logic_vector;

--used in lpf
	function sign_extend_25_to_26 (
		signal indata_25 : in signed
		) return signed;

--used in lpf
	function mul_ex(
		signal indata12 : in signed;
		constant coef12 : in signed
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
function sign_extend_25_to_26 (
	signal indata_25 : in signed
	) return signed
	is
variable retdata : signed(25 downto 0);
begin
	if (indata_25(24) = '0') then
		retdata := "0" & indata_25;
	else
		retdata := "1" & indata_25;
	end if;
	return retdata;
end sign_extend_25_to_26;

--used in lpf
function mul_ex(
	signal indata12 : in signed;
	constant coef12 : in signed
	) return signed
	is
variable tmp_mul24 : signed(23 downto 0);
variable retdata : signed(24 downto 0);
begin
	tmp_mul24 := indata12 * coef12;
	if (tmp_mul24(23) = '0') then
		retdata := "0" & tmp_mul24;
	else
		retdata := "1" & tmp_mul24;
	end if;
	return retdata;
end mul_ex;

end package body motorf;

