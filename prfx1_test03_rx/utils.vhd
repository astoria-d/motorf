library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package motorf is
	function sign_extend_12_to_30 (
		signal indata_12 : in std_logic_vector
		) return std_logic_vector;

	function sign_extend_25_to_26 (
		signal indata_25 : in std_logic_vector
		) return std_logic_vector;

	function mul_ex(
		signal indata12 : in std_logic_vector;
		constant coef12 : in std_logic_vector
		) return std_logic_vector;

	function add_ex(
		signal indata1_25 : in std_logic_vector;
		signal indata2_25 : in std_logic_vector;
		signal indata3_25 : in std_logic_vector;
		signal indata4_25 : in std_logic_vector;
		signal indata5_25 : in std_logic_vector;
		signal indata6_25 : in std_logic_vector;
		signal indata7_25 : in std_logic_vector
		) return std_logic_vector;

	function sign_extend_12_to_16 (
		signal indata_12 : in std_logic_vector
		) return std_logic_vector;

	function sign_extend_24_to_27 (
		signal indata_24 : in std_logic_vector
		) return std_logic_vector;

	function sign_extend_27_to_29 (
		signal indata_27 : in std_logic_vector
		) return std_logic_vector;

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
	signal indata_25 : in std_logic_vector
	) return std_logic_vector
	is
variable retdata : std_logic_vector(25 downto 0);
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
	signal indata12 : in std_logic_vector;
	constant coef12 : in std_logic_vector
	) return std_logic_vector
	is
variable tmp_mul24 : std_logic_vector(23 downto 0);
variable retdata : std_logic_vector(24 downto 0);
begin
	tmp_mul24 := indata12 * coef12;
	if (tmp_mul24(23) = '0') then
		retdata := "0" & tmp_mul24;
	else
		retdata := "1" & tmp_mul24;
	end if;
	return retdata;
end mul_ex;

--used in lpf
function add_ex(
	signal indata1_25 : in std_logic_vector;
	signal indata2_25 : in std_logic_vector;
	signal indata3_25 : in std_logic_vector;
	signal indata4_25 : in std_logic_vector;
	signal indata5_25 : in std_logic_vector;
	signal indata6_25 : in std_logic_vector;
	signal indata7_25 : in std_logic_vector
	) return std_logic_vector
	is
variable tmp26_1 : std_logic_vector(25 downto 0);
variable tmp26_2 : std_logic_vector(25 downto 0);
variable tmp26_3 : std_logic_vector(25 downto 0);
variable tmp26_4 : std_logic_vector(25 downto 0);
variable tmp26_5 : std_logic_vector(25 downto 0);
variable tmp26_6 : std_logic_vector(25 downto 0);
variable tmp26_7 : std_logic_vector(25 downto 0);
variable retdata : std_logic_vector(25 downto 0);
begin

	if (indata1_25(24) = '0') then
		tmp26_1 := "0" & indata1_25;
	else
		tmp26_1 := "1" & indata1_25;
	end if;
	if (indata2_25(24) = '0') then
		tmp26_2 := "0" & indata2_25;
	else
		tmp26_2 := "1" & indata2_25;
	end if;
	if (indata3_25(24) = '0') then
		tmp26_3 := "0" & indata3_25;
	else
		tmp26_3 := "1" & indata3_25;
	end if;
	if (indata4_25(24) = '0') then
		tmp26_4 := "0" & indata4_25;
	else
		tmp26_4 := "1" & indata4_25;
	end if;
	if (indata5_25(24) = '0') then
		tmp26_5 := "0" & indata5_25;
	else
		tmp26_5 := "1" & indata5_25;
	end if;
	if (indata6_25(24) = '0') then
		tmp26_6 := "0" & indata6_25;
	else
		tmp26_6 := "1" & indata6_25;
	end if;
	if (indata7_25(24) = '0') then
		tmp26_7 := "0" & indata7_25;
	else
		tmp26_7 := "1" & indata7_25;
	end if;

	retdata := tmp26_1 + tmp26_2 + tmp26_3 + tmp26_4 + tmp26_5 + tmp26_6 + tmp26_7;
	return retdata;

end add_ex;

--test purpose
function sign_extend_12_to_16 (
	signal indata_12 : in std_logic_vector
	) return std_logic_vector
	is
variable retdata : std_logic_vector(15 downto 0);
begin
	if (indata_12(11) = '0') then
		retdata := "0000" & indata_12;
	else
		retdata := "1111" & indata_12;
	end if;
	return retdata;
end sign_extend_12_to_16;

function sign_extend_24_to_27 (
	signal indata_24 : in std_logic_vector
	) return std_logic_vector
	is
variable retdata : std_logic_vector(26 downto 0);
begin
	if (indata_24(23) = '0') then
		retdata := "000" & indata_24;
	else
		retdata := "111" & indata_24;
	end if;
	return retdata;
end sign_extend_24_to_27;

function sign_extend_27_to_29 (
	signal indata_27 : in std_logic_vector
	) return std_logic_vector
	is
variable retdata : std_logic_vector(28 downto 0);
begin
	if (indata_27(26) = '0') then
		retdata := "00" & indata_27;
	else
		retdata := "11" & indata_27;
	end if;
	return retdata;
end sign_extend_27_to_29;



end package body motorf;

