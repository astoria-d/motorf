library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.motorf.all;

entity sync_symbol is
	port (
	signal clk80m		: in std_logic;
	signal indata		: in std_logic_vector(17 downto 0);
	signal symbol_num : out std_logic_vector(7 downto 0);
	signal symbol_cnt : out std_logic_vector(15 downto 0);
	signal pilot_only	: out std_logic
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

	--pilot check
	pilot_p : process (clk80m)
	variable clk_cnt : integer := 0;
	variable frame : integer := 0;
	begin
		if (rising_edge(clk80m)) then
			if (symbol_num_reg = conv_std_logic_vector(0, 8)) then
				if (clk_cnt = 76 * 80 * 100 - 1) then
					clk_cnt := 0;
					frame := frame + 1;
					if (frame > 10) then
						--if zero symbol continued more than 10 frames, assume pilot mode.
						pilot_only <= '1';
					end if;
				else
					clk_cnt := clk_cnt + 1;
				end if;
			else
				clk_cnt := 0;
				frame := 0;
				pilot_only <= '0';
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.motorf.all;

entity sync_carrier is
	port (
	signal clk80m		: in std_logic;
	signal indata		: in std_logic_vector(17 downto 0);
	signal symbol_num : in std_logic_vector(7 downto 0);
	signal symbol_cnt : in std_logic_vector(15 downto 0);
	signal pilot_only	: in std_logic;
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
signal cos_1 : signed(15 downto 0) := (others => '0');
signal sin_l : signed(15 downto 0) := (others => '0');
signal cos_l : signed(15 downto 0) := (others => '0');

signal sync_lock : std_logic_vector(31 downto 0) := (others => '0');
signal reg_sync : std_logic;

signal pk_cnt : std_logic_vector(23 downto 0) := (others => '0');
signal minus_peak : signed(17 downto 0) := (others => '0');
signal plus_peak : signed(17 downto 0) := (others => '0');
signal peak_2_peak : signed(18 downto 0) := (others => '0');


signal pre_gated_lpf : signed(31 downto 0) := (others => '0');
signal gated_lpf : signed(31 downto 0) := (others => '0');
signal lpf_out_sum : signed(31 downto 0) := (others => '0');
signal lpf_out_offset : signed(31 downto 0) := (others => '0');

signal pilog_nco_freq : signed(31 downto 0) := (others => '0');
signal upconv_nco_freq : signed(31 downto 0) := (others => '0');

signal multi_i : signed(31 downto 0) := (others => '0');

component cordic_nco
	PORT
	(
		clk : in std_logic;
		frq : in std_logic_vector( 31 downto 0 );
		sin : out signed( 15 downto 0 );
		cos : out signed( 15 downto 0 )
	);
end component;

component multi_0
	PORT
	(
		clock		: IN STD_LOGIC ;
		dataa		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;

begin

	seq_cnt_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			seq <= seq + 1;
		end if;
	end process;

	pre_saw_p : process (clk80m)
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
			elsif (saw_chk > 0 and saw_chk < 1023 and saw_chk - 1 /= nco_chk and saw_chk /= nco_chk and saw_chk + 1 /= nco_chk ) then
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
			elsif (saw_chk = 1023 and nco_chk > 0 and nco_chk < 1022) then
				sync_lock <= (others => '0');
			elsif (sync_lock < "11101110011010110010100000000000") then
				--11101110011010110010100000000000 is 1000 * 1000 * 100 * 40. 
				--since it is larger than 4GB, the compiler complaints...
				sync_lock <= sync_lock + 1;
			end if;
		end if;
	end process;

	synchronized <= reg_sync;
	sync_signal_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (sync_lock > 10000) then
				reg_sync <= seq(25);
			else
				reg_sync <= '0';
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
				pre_gated_lpf <= sign_rshift_32(multi_i, 7);
			elsif (peak_2_peak > 8192 * 4) then
				pre_gated_lpf <= sign_rshift_32(multi_i, 6);
			elsif (peak_2_peak > 4096 * 4) then
				pre_gated_lpf <= sign_rshift_32(multi_i, 5);
			elsif (peak_2_peak > 2048 * 4) then
				pre_gated_lpf <= sign_rshift_32(multi_i, 4);
			elsif (peak_2_peak > 2048 * 2) then
				pre_gated_lpf <= sign_rshift_32(multi_i, 3);
			elsif (peak_2_peak > 2048) then
				pre_gated_lpf <= sign_rshift_32(multi_i, 2);
			else
				pre_gated_lpf <= sign_rshift_32(multi_i, 1);
			end if;
		end if;
	end process;

	gate_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (pilot_only = '1') then
				gated_lpf <= sign_rshift_32(pre_gated_lpf, 3);
			elsif (symbol_cnt > 6 * 80 and symbol_cnt < 6 * 80 + 64 * 80 and symbol_num = 1) then
				gated_lpf <= sign_rshift_32(pre_gated_lpf, 3);
			elsif (symbol_cnt > 6 * 80 and symbol_cnt < 6 * 80 + 64 * 80 and symbol_num /= 0) then
				gated_lpf <= pre_gated_lpf;
			else
				gated_lpf <= (others => '0');
			end if;
		end if;
	end process;

	lpf_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (symbol_cnt = 6 * 80) then
				lpf_out_sum <= gated_lpf;
			elsif (seq(3 downto 0) = 0) then
				lpf_out_sum <= lpf_out_sum + gated_lpf;
			end if;
		end if;
	end process;

	offset_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (pilot_only = '1' and lpf_out_offset > 2147480 and reg_sync = '0') then
				--2147480 = 40kHz. sweep +/- 40 kHz
				lpf_out_offset <= conv_signed(-2147480, 32);
			elsif (pilot_only = '1' and seq(3 downto 0) = 0 and reg_sync = '0') then
				lpf_out_offset <= lpf_out_offset + 1;
			elsif (symbol_cnt = 64 * 80 + 6 * 80 and lpf_out_sum > 0) then
				lpf_out_offset <= lpf_out_offset + 395;
			elsif (symbol_cnt = 64 * 80 + 6 * 80 and lpf_out_sum < 0) then
				lpf_out_offset <= lpf_out_offset - 395;
			end if;
		end if;
	end process;

	multipler_p : process (clk80m)
	variable tmp_mul : signed(33 downto 0);
	begin
		if (rising_edge(clk80m)) then
			tmp_mul := signed(indata) * cos_1;
			multi_i <= tmp_mul(33 downto 2);
		end if;
	end process;

	--//325kHz + 4kHz
	pilog_nco_freq <= conv_signed(17448304 - 53, 32) + lpf_out_offset + gated_lpf;
	pilot_nco_inst1 : cordic_nco PORT MAP (
		clk => clk80m,
		frq => std_logic_vector(pilog_nco_freq),
		sin => sin_1,
		cos => cos_1
	);

	--//upconv + 175KHz
	upconv_nco_freq <= conv_signed(9395240 + 53, 32) - lpf_out_offset - gated_lpf;
	out_nco_inst2 : cordic_nco PORT MAP (
		clk => clk80m,
		frq => std_logic_vector(upconv_nco_freq),
		sin => sin_l,
		cos => cos_l
	);

	multipler_ip_inst : multi_0 PORT MAP (
		clock => clk80m,
		dataa => STD_LOGIC_VECTOR(indata(17 downto 2)),
		datab => STD_LOGIC_VECTOR(cos_l),
		result => outdata
	);

end rtl;

