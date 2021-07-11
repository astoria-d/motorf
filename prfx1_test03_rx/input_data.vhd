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


---------------------------

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
					+ sign_extend_11_to_29(indata)
					+ sign_extend_11_to_29(offset);
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

