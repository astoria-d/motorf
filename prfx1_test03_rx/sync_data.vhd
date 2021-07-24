library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.motorf.all;

entity sync_symbol is
	port (
	signal clk80m		: in std_logic;
	signal indata		: in std_logic_vector(17 downto 0);
	signal symbol_num : out std_logic_vector(7 downto 0);
	signal symbol_cnt : out std_logic_vector(15 downto 0)
	);
end sync_symbol;

architecture rtl of sync_symbol is

signal frame_cnt : integer range 0 to 76 * 80 * 100 * 6 := 0;

signal minus_peak : signed (17 downto 0) := (others => '0');
signal plus_peak : signed (17 downto 0) := (others => '0');
signal abs_peak : signed (18 downto 0) := (others => '0');

signal plus_boarder : signed (17 downto 0) := (others => '0');
signal minus_boarder : signed (17 downto 0) := (others => '0');

signal mute_cnt : integer range 0 to 100 * 80 * 1000 := 0;

signal symbol_num_reg : std_logic_vector(7 downto 0) := (others => '0');
signal symbol_cnt_reg : std_logic_vector(15 downto 0) := (others => '0');

begin

	frame_proc : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (frame_cnt = 76 * 80 * 100 * 6 - 1) then
				frame_cnt <= 0;
			else
				frame_cnt <= frame_cnt + 1;
			end if;
		end if;
	end process;

	minus_peak_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (frame_cnt = 0) then
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
			if (frame_cnt = 0) then
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
			if (frame_cnt = 0) then
				abs_peak <= sign_extend_18_to_19(plus_peak) - sign_extend_18_to_19(minus_peak);
			else
				abs_peak <= abs_peak;
			end if;

		end if;
	end process;

	plus_boarder <= conv_signed((conv_integer(abs_peak) / 8), 18);
	minus_boarder <= conv_signed(((-1) * conv_integer(abs_peak) / 8), 18);

	mute_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if ((signed(indata) > minus_boarder) and (signed(indata) < plus_boarder) and (mute_cnt < 100 * 80 * 1000)) then
				mute_cnt <= mute_cnt + 1;
			elsif ((signed(indata) < minus_boarder) or (signed(indata) > plus_boarder)) then
				mute_cnt <= 0;
			else
				mute_cnt <= mute_cnt;
			end if;
		end if;
	end process;

	symbol_cnt <= symbol_cnt_reg;
	symbol_cnt_p : process (clk80m)
	use ieee.std_logic_unsigned.all;
	begin
		if (rising_edge(clk80m)) then
			if ((mute_cnt > 40 * 80) and ((signed(indata) < minus_boarder) or (signed(indata) > plus_boarder))) then
				symbol_cnt_reg <= (others => '0');
			elsif (symbol_cnt_reg = conv_std_logic_vector(76 * 80 - 1, 16)) then
				symbol_cnt_reg <= (others => '0');
			else
				symbol_cnt_reg <= symbol_cnt_reg + 1;
			end if;
		end if;
	end process;

	symbol_num <= symbol_num_reg;
	symbol_num_p : process (clk80m)
	use ieee.std_logic_unsigned.all;
	begin
		if (rising_edge(clk80m)) then
			if ((mute_cnt > 40 * 80) and ((signed(indata) < minus_boarder) or (signed(indata) > plus_boarder))) then
				symbol_num_reg <= conv_std_logic_vector(1, 8);
			elsif ((symbol_cnt_reg = conv_std_logic_vector(76 * 80 - 1, 16)) and (symbol_num_reg = conv_std_logic_vector(99, 8))) then
				symbol_num_reg <= (others => '0');
			elsif ((symbol_cnt_reg = conv_std_logic_vector(76 * 80 - 1, 16)) and (symbol_num_reg = conv_std_logic_vector(0, 8))) then
				symbol_num_reg <= (others => '0');
			elsif (symbol_cnt_reg = conv_std_logic_vector(76 * 80 - 1, 16)) then
				symbol_num_reg <= symbol_num_reg + 1;
			else
				symbol_num_reg <= symbol_num_reg;
			end if;
		end if;
	end process;

end rtl;
