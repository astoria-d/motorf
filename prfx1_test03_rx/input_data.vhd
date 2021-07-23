library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.conv_std_logic_vector;

entity conv_signed is 
	port (
	signal clk80m		: in std_logic;
	signal udata		: in std_logic_vector(11 downto 0);
	signal sdata		: out std_logic_vector(11 downto 0)
	);
end conv_signed;

architecture rtl of conv_signed is

signal reg_sdata		: std_logic_vector(11 downto 0);

begin

	sdata <= reg_sdata;

	conv_p : process (clk80m)
	variable tmp1 : std_logic_vector(12 downto 0);
	variable tmp2 : std_logic_vector(12 downto 0);
	begin
		if (rising_edge(clk80m)) then
			tmp1 := "0" & udata;
			tmp2 := tmp1 - conv_std_logic_vector(2048, 13);
			reg_sdata <= tmp2(11 downto 0);
		end if;
	end process;

end rtl;


---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.motorf.all;

entity zero_offset is
	port (
	signal clk80m		: in std_logic;
	signal indata		: in std_logic_vector(11 downto 0);
	signal outdata		: out std_logic_vector(11 downto 0)
	);
end zero_offset;

architecture rtl of zero_offset is

signal reg_out	: std_logic_vector(11 downto 0);
signal sum	: std_logic_vector(29 downto 0);
signal offset	: std_logic_vector(11 downto 0);
signal cnt		: integer range 0 to 72 * 80 * 10 := 0;


begin

	cnt_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (cnt < 72 * 80 * 10) then
				cnt <= cnt + 1;
			else
				cnt <= 0;
			end if;
		end if;
	end process;

	sum_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (cnt = 0) then
				sum <= (others => '0');
			else
				sum <= sum
					+ sign_extend_12_to_30(indata)
					+ sign_extend_12_to_30(offset);
			end if;
		end if;
	end process;

	offset_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (cnt = 0 and sum(29) = '0') then
				offset <= offset - 1;
			elsif (cnt = 0 and sum(29) = '1') then
				offset <= offset + 1;
			else
				offset <= offset;
			end if;
		end if;
	end process;

	outdata <= reg_out;

	out_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			reg_out <= indata + offset;
		end if;
	end process;

end rtl;

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.motorf.all;

entity agc is 
	port (
	signal clk80m		: in std_logic;
	signal indata     : in std_logic_vector(15 downto 0);
	signal att_val		: out std_logic_vector(4 downto 0);
	signal att_oe		: out std_logic
	);
end agc;

architecture rtl of agc is

signal cnt			: integer range 0 to 76 * 80 * 100 * 6 := 0;
signal att_reg 	: std_logic_vector(4 downto 0) := (others => '0');
signal att_oe_reg : std_logic := '0';

signal minus_peak		: signed(15 downto 0) := (others => '0');
signal plus_peak		: signed(15 downto 0) := (others => '0');
signal abs_peak		: signed(16 downto 0) := (others => '0');

begin

	cnt_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (cnt = 76 * 80 * 100 * 6 - 1) then
				cnt <= 0;
			else
				cnt <= cnt + 1;
			end if;
		end if;
	end process;

	minus_peak_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (cnt = 0) then
				minus_peak <= signed(indata);
			elsif (signed(indata) < minus_peak) then
				minus_peak <= signed(indata);
			else
				minus_peak <= minus_peak;
			end if;
		end if;
	end process;

	plus_peak_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (cnt = 0) then
				plus_peak <= signed(indata);
			elsif (signed(indata) > plus_peak) then
				plus_peak <= signed(indata);
			else
				plus_peak <= plus_peak;
			end if;
		end if;
	end process;

	abs_peak_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (cnt = 0) then
				abs_peak <= sign_extend_16_to_17(plus_peak) - sign_extend_16_to_17(minus_peak);
			else
				abs_peak <= abs_peak;
			end if;
		end if;
	end process;

	att_val <= att_reg;
	att_p : process (clk80m)
	use ieee.std_logic_unsigned.all;
	begin
		if (rising_edge(clk80m)) then
			if (cnt = 0 and (abs_peak < 2000 * 8) and (att_reg /= "0000")) then
				att_reg <= att_reg - 1;
			elsif (cnt = 0 and (abs_peak > 2300 * 8) and (att_reg /= "1111")) then
				att_reg <= att_reg + 1;
			else
				att_reg <= att_reg;
			end if;
		end if;
	end process;

	att_oe <= att_oe_reg;
	att_oe_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if ((cnt > 20 * 80 * 100) and (cnt < 30 * 80 * 100)) then
				att_oe_reg <= '1';
			else
				att_oe_reg <= '0';
			end if;
		end if;
	end process;

end rtl;
