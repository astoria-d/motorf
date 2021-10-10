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


---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity sync_carrier is
	port (
	signal clk80m		: in std_logic;
	signal indata		: in std_logic_vector(17 downto 0);
	signal symbol_num : in std_logic_vector(7 downto 0);
	signal symbol_cnt : in std_logic_vector(15 downto 0);
	signal outdata		: out std_logic_vector(31 downto 0);
	signal synchronized : out std_logic
	);
end sync_carrier;

architecture rtl of sync_carrier is

--why 26 bits??
signal seq : std_logic_vector(25 downto 0) := (others => '0');

signal saw_chk : std_logic_vector(9 downto 0) := (others => '0');
signal nco_chk : std_logic_vector(9 downto 0) := (others => '0');

signal shift_fir_input : signed(17 downto 0) := (others => '0');

signal shift_sin : signed(15 downto 0) := (others => '0');
signal sin_1 : signed(15 downto 0) := (others => '0');

signal sync_lock : std_logic_vector(31 downto 0) := (others => '0');

signal pk_cnt : std_logic_vector(23 downto 0) := (others => '0');
signal minus_peak : signed(17 downto 0) := (others => '0');
signal plus_peak : signed(17 downto 0) := (others => '0');
signal peak_2_peak : signed(18 downto 0) := (others => '0');


signal lp_filtered : signed(31 downto 0) := (others => '0');
signal lp_gated : signed(31 downto 0) := (others => '0');

signal multi_i : integer := 0;

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

begin

	seq_cnt_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			seq <= seq + 1;
		end if;
	end process;

	lpf_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (seq(3 downto 0) = 0) then
				---create shifted fir of indata
				shift_fir_input <= signed(indata);
				shift_sin <= sin_1;
			end if;
		end if;
	end process;

	--create sawtooth wave to check sync with nco.
	saw_indata_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (seq(3 downto 0) /= 0) then
				saw_chk <= saw_chk;
			elsif (saw_chk = 0 and nco_chk > 1 and nco_chk < 1023) then   -----1023 = "1111111111"
				saw_chk <= (others => '0');
			elsif (saw_chk /= 0 and saw_chk /= 1023 and saw_chk - 1 /= nco_chk and saw_chk /= nco_chk and saw_chk + 1 /= nco_chk ) then
				saw_chk <= (others => '0');
			elsif (saw_chk = 1023 and nco_chk > 0 and nco_chk < 1022) then-----1022 = "1111111110"
				saw_chk <= (others => '0');
			elsif (shift_fir_input <= 0 and signed(indata) > 0) then
				saw_chk <= saw_chk + 1;
			end if;
		end if;
	end process;

	--create nco sawtooth wave.
	saw_nco_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (seq(3 downto 0) /= 0) then
				nco_chk <= nco_chk;
			elsif (saw_chk = 0 and nco_chk > 1 and nco_chk < 1023) then
				nco_chk <= (others => '0');
			elsif (saw_chk = 0 and saw_chk /= 1023 and saw_chk - 1 /= nco_chk and saw_chk /= nco_chk and saw_chk + 1 /= nco_chk ) then
				nco_chk <= (others => '0');
			elsif (shift_sin <= 0 and signed(sin_1) > 0) then
				nco_chk <= nco_chk + 1;
			end if;
		end if;
	end process;

	sync_lock_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (seq(3 downto 0) /= 0) then
				sync_lock <= sync_lock;
			elsif (saw_chk = 0 and nco_chk > 1 and nco_chk < 1023) then
				sync_lock <= (others => '0');
			elsif (saw_chk /= 0 and saw_chk /= 1023 and saw_chk - 1 /= nco_chk and saw_chk /= nco_chk and saw_chk + 1 /= nco_chk ) then
				sync_lock <= (others => '0');
			elsif (saw_chk = 1023 and nco_chk /= 0 and nco_chk < 1022) then
				sync_lock <= (others => '0');
			elsif (sync_lock < 1000 * 1000 * 100 * 40) then
				sync_lock <= sync_lock + 1;
			end if;
		end if;
	end process;

	sync_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (sync_lock > 10000) then
				synchronized <= seq(20);
			else
				synchronized <= '0';
			end if;
		end if;
	end process;

	peak_cnt_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (pk_cnt = 76 * 80 * 100 * 6 - 1) then
				pk_cnt <= (others => '0');
			else
				pk_cnt <= pk_cnt + 1;
			end if;
		end if;
	end process;

	minus_peak_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (pk_cnt = 0) then
				minus_peak <= signed(indata);
			elsif (signed(indata) < minus_peak) then
				minus_peak <= signed(indata);
			end if;
		end if;
	end process;

	plus_peak_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (pk_cnt = 0) then
				plus_peak <= signed(indata);
			elsif (signed(indata) > plus_peak) then
				plus_peak <= signed(indata);
			end if;
		end if;
	end process;

	peak2peak_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (pk_cnt = 0) then
				peak_2_peak <= sign_extend_18_to_19(plus_peak) - sign_extend_18_to_19(minus_peak);
			end if;
		end if;
	end process;

	pre_gate_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (peak_2_peak > 16384 * 4) then
				lp_filtered <= to_signed(multi_i / 16 / 8, lp_filtered'length);
			elsif (peak_2_peak > 8192 * 4) then
				lp_filtered <= to_signed(multi_i / 8 / 8, lp_filtered'length);
			elsif (peak_2_peak > 4096 * 4) then
				lp_filtered <= to_signed(multi_i / 4 / 8, lp_filtered'length);
			elsif (peak_2_peak > 2048 * 4) then
				lp_filtered <= to_signed(multi_i / 2 / 8, lp_filtered'length);
			elsif (peak_2_peak > 2048 * 2) then
				lp_filtered <= to_signed(multi_i / 8, lp_filtered'length);
			elsif (peak_2_peak > 2048) then
				lp_filtered <= to_signed(multi_i / 4, lp_filtered'length);
			else
				lp_filtered <= to_signed(multi_i / 2, lp_filtered'length);
			end if;
		end if;
	end process;

	gate_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (symbol_cnt > 6 * 80 and symbol_cnt < 6 * 80 + 64 * 80 and symbol_num = 1) then
				lp_gated <= lp_filtered / 8;
			elsif (symbol_cnt > 6 * 80 and symbol_cnt < 6 * 80 + 64 * 80 and symbol_num /= 0) then
				lp_gated <= lp_filtered;
			else
				lp_gated <= (others => '0');
			end if;
		end if;
	end process;

end rtl;

