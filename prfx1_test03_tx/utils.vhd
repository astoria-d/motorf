library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

package motorf is

---------------------------------------------------------------------------------
--we also have ieee.numeric_std.resize function but
--this function requires to be "signal"
--in this project we carete own resize function for each signal
---------------------------------------------------------------------------------


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

--used in bpf
	function mul_ex2(
		signal indata16 : in signed;
		constant coef12 : in signed
		) return signed;

--used in bpf
	function sign_extend_29_to_32 (
		signal indata_29 : in signed
		) return signed;

--used in agc
	function sign_extend_16_to_17 (
		signal indata_16 : in signed
		) return signed;

--used in sync_symbol
	function sign_extend_18_to_19 (
		signal indata_18 : in signed
		) return signed;

--used in tx_baseband
	function sign_extend_16_to_21 (
		signal indata_16 : in signed
		) return signed;

--used in lpf_24tap
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

--used in bpf
function mul_ex2(
	signal indata16 : in signed;
	constant coef12 : in signed
	) return signed
	is
variable tmp_mul28 : signed(27 downto 0);
variable retdata : signed(28 downto 0);
begin
	tmp_mul28 := indata16 * coef12;
	if (tmp_mul28(27) = '0') then
		retdata := "0" & tmp_mul28;
	else
		retdata := "1" & tmp_mul28;
	end if;
	return retdata;
end mul_ex2;

--used in bpf
function sign_extend_29_to_32 (
		signal indata_29 : in signed
		) return signed
	is
variable retdata : signed(31 downto 0);
begin
	if (indata_29(28) = '0') then
		retdata := "000" & indata_29;
	else
		retdata := "111" & indata_29;
	end if;
	return retdata;
end sign_extend_29_to_32;

--used in agc
function sign_extend_16_to_17 (
		signal indata_16 : in signed
		) return signed
	is
variable retdata : signed(16 downto 0);
begin
	if (indata_16(15) = '0') then
		retdata := "0" & indata_16;
	else
		retdata := "1" & indata_16;
	end if;
	return retdata;
end sign_extend_16_to_17;

--used in sync_symbol
	function sign_extend_18_to_19 (
		signal indata_18 : in signed
		) return signed
	is
variable retdata : signed(18 downto 0);
begin
	if (indata_18(indata_18'length - 1) = '0') then
		retdata := "0" & indata_18;
	else
		retdata := "1" & indata_18;
	end if;
	return retdata;
end sign_extend_18_to_19;

--used in tx_baseband
function sign_extend_16_to_21 (
		signal indata_16 : in signed
		) return signed
	is
variable retdata : signed(20 downto 0);
begin
	if (indata_16(indata_16'length - 1) = '0') then
		retdata := "00000" & indata_16;
	else
		retdata := "11111" & indata_16;
	end if;
	return retdata;
end sign_extend_16_to_21;

--used in lpf_24tap
function sign_extend_27_to_29 (
		signal indata_27 : in signed
		) return signed
	is
variable retdata : signed(28 downto 0);
begin
	if (indata_27(indata_27'length - 1) = '0') then
		retdata := "00" & indata_27;
	else
		retdata := "11" & indata_27;
	end if;
	return retdata;
end sign_extend_27_to_29;


end package body motorf;
