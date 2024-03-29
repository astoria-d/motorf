library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sshift is 
	generic (reg_size : integer := 18; shift_size : integer := 10);
	PORT
	(
		indata : in signed(reg_size - 1 downto 0);
		outdata : out signed(reg_size - 1 downto 0)
	);
end sshift;

architecture rtl of sshift is

constant fill_zero : signed (shift_size - 1 downto 0) := (others => '0');
constant fill_one : signed (shift_size - 1 downto 0) := (others => '1');

begin

	outdata <= fill_zero & indata(reg_size - 1 downto shift_size) when indata(reg_size - 1) = '0' else
					fill_one & indata(reg_size - 1 downto shift_size);

end rtl;

----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity cordic_nco is 
	PORT
	(
		clk : in std_logic;
		frq : in std_logic_vector(31 downto 0);
		sin : out signed(15 downto 0);
		cos : out signed(15 downto 0)
	);
end cordic_nco;

architecture rtl of cordic_nco is

component sshift
	generic (reg_size : integer := 18; shift_size : integer := 10);
	PORT
	(
		indata : in signed(reg_size - 1 downto 0);
		outdata : out signed(reg_size - 1 downto 0)
	);
end component;

signal phase32 : std_logic_vector (31 downto 0);

signal judge0 : std_logic;
signal judge1 : std_logic;
signal judge2 : std_logic;
signal judge3 : std_logic;
signal judge4 : std_logic;
signal judge5 : std_logic;
signal judge6 : std_logic;
signal judge7 : std_logic;
signal judge8 : std_logic;
signal judge9 : std_logic;
signal judge10 : std_logic;
signal judge11 : std_logic;
signal judge12 : std_logic;
signal judge13 : std_logic;
signal judge14 : std_logic;
signal judge15 : std_logic;
signal judge16 : std_logic;
signal judge17 : std_logic;


signal phase0 : std_logic_vector (18 downto 0);
signal phase1 : std_logic_vector (18 downto 0);
signal phase2 : std_logic_vector (18 downto 0);
signal phase3 : std_logic_vector (18 downto 0);
signal phase4 : std_logic_vector (18 downto 0);
signal phase5 : std_logic_vector (18 downto 0);
signal phase6 : std_logic_vector (18 downto 0);
signal phase7 : std_logic_vector (18 downto 0);
signal phase8 : std_logic_vector (18 downto 0);
signal phase9 : std_logic_vector (18 downto 0);
signal phase10 : std_logic_vector (18 downto 0);
signal phase11 : std_logic_vector (18 downto 0);
signal phase12 : std_logic_vector (18 downto 0);
signal phase13 : std_logic_vector (18 downto 0);
signal phase14 : std_logic_vector (18 downto 0);
signal phase15 : std_logic_vector (18 downto 0);
signal phase16 : std_logic_vector (18 downto 0);
signal phase17 : std_logic_vector (18 downto 0);

signal temp0 : signed (18 downto 0);
signal temp1 : signed (18 downto 0);
signal temp2 : signed (18 downto 0);
signal temp3 : signed (18 downto 0);
signal temp4 : signed (18 downto 0);
signal temp5 : signed (18 downto 0);
signal temp6 : signed (18 downto 0);
signal temp7 : signed (18 downto 0);
signal temp8 : signed (18 downto 0);
signal temp9 : signed (18 downto 0);
signal temp10 : signed (18 downto 0);
signal temp11 : signed (18 downto 0);
signal temp12 : signed (18 downto 0);
signal temp13 : signed (18 downto 0);
signal temp14 : signed (18 downto 0);
signal temp15 : signed (18 downto 0);
signal temp16 : signed (18 downto 0);

signal x0 : signed (18 downto 0);
signal x1 : signed (18 downto 0);
signal x2 : signed (18 downto 0);
signal x3 : signed (18 downto 0);
signal x4 : signed (18 downto 0);
signal x5 : signed (18 downto 0);
signal x6 : signed (18 downto 0);
signal x7 : signed (18 downto 0);
signal x8 : signed (18 downto 0);
signal x9 : signed (18 downto 0);
signal x10 : signed (18 downto 0);
signal x11 : signed (18 downto 0);
signal x12 : signed (18 downto 0);
signal x13 : signed (18 downto 0);
signal x14 : signed (18 downto 0);
signal x15 : signed (18 downto 0);
signal x16 : signed (18 downto 0);
signal x17 : signed (18 downto 0);

signal y0 : signed (18 downto 0);
signal y1 : signed (18 downto 0);
signal y2 : signed (18 downto 0);
signal y3 : signed (18 downto 0);
signal y4 : signed (18 downto 0);
signal y5 : signed (18 downto 0);
signal y6 : signed (18 downto 0);
signal y7 : signed (18 downto 0);
signal y8 : signed (18 downto 0);
signal y9 : signed (18 downto 0);
signal y10 : signed (18 downto 0);
signal y11 : signed (18 downto 0);
signal y12 : signed (18 downto 0);
signal y13 : signed (18 downto 0);
signal y14 : signed (18 downto 0);
signal y15 : signed (18 downto 0);
signal y16 : signed (18 downto 0);
signal y17 : signed (18 downto 0);

signal shift10_x : signed (18 downto 0);
signal shift11_x : signed (18 downto 0);
signal shift12_x : signed (18 downto 0);
signal shift13_x : signed (18 downto 0);
signal shift14_x : signed (18 downto 0);
signal shift15_x : signed (18 downto 0);
signal shift16_x : signed (18 downto 0);
signal shift17_x : signed (18 downto 0);

signal shift10_y : signed (18 downto 0);
signal shift11_y : signed (18 downto 0);
signal shift12_y : signed (18 downto 0);
signal shift13_y : signed (18 downto 0);
signal shift14_y : signed (18 downto 0);
signal shift15_y : signed (18 downto 0);
signal shift16_y : signed (18 downto 0);
signal shift17_y : signed (18 downto 0);

signal reg_sin : signed(15 downto 0);
signal reg_cos : signed(15 downto 0);

begin

	phase_p : process (clk)
	begin
		if (rising_edge(clk)) then
			phase32 <= phase32 + frq;
			phase0 <= phase32(31 downto 13);
			phase1 <= phase0;
			phase2 <= phase1;
			phase3 <= phase2;
			phase4 <= phase3;
			phase5 <= phase4;
			phase6 <= phase5;
			phase7 <= phase6;
			phase8 <= phase7;
			phase9 <= phase8;
			phase10 <= phase9;
			phase11 <= phase10;
			phase12 <= phase11;
			phase13 <= phase12;
			phase14 <= phase13;
			phase15 <= phase14;
			phase16 <= phase15;
			phase17 <= phase16;
		end if;
	end process;

	step0 : process (clk)
	begin
		if (rising_edge(clk)) then
			temp0 <= to_signed(65536, temp0'length);
			x0 <= to_signed(131072, x0'length);
			y0 <= to_signed(131072, y0'length);
		end if;
	end process;

	judge1 <= '0' when (temp0 < 0) else
				'0' when (signed("00" & phase0(16 downto 0)) >= temp0) else
				'1';
	step1 : process (clk)
	begin
		if (rising_edge(clk)) then
			if (judge1 = '1') then
				temp1 <= temp0 - to_signed(38688, temp1'length);
				x1 <= x0 + y0 / 2;
				y1 <= y0 - x0 / 2;
			else
				temp1 <= temp0 + to_signed(38688, temp1'length);
				x1 <= x0 - y0 / 2;
				y1 <= y0 + x0 / 2;
			end if;
		end if;
	end process;

	judge2 <= '0' when (temp1 < 0) else
				'0' when (signed("00" & phase1(16 downto 0)) >= temp1) else
				'1';
	step2 : process (clk)
	begin
		if (rising_edge(clk)) then
			if (judge2 = '1') then
				temp2 <= temp1 - to_signed(20441, temp2'length);
				x2 <= x1 + y1 / 4;
				y2 <= y1 - x1 / 4;
			else
				temp2 <= temp1 + to_signed(20441, temp2'length);
				x2 <= x1 - y1 / 4;
				y2 <= y1 + x1 / 4;
			end if;
		end if;
	end process;

	judge3 <= '0' when (temp2 < 0) else
				'0' when (signed("00" & phase2(16 downto 0)) >= temp2) else
				'1';
	step3 : process (clk)
	begin
		if (rising_edge(clk)) then
			if (judge3 = '1') then
				temp3 <= temp2 - to_signed(10376, temp3'length);
				x3 <= x2 + y2 / 8;
				y3 <= y2 - x2 / 8;
			else
				temp3 <= temp2 + to_signed(10376, temp3'length);
				x3 <= x2 - y2 / 8;
				y3 <= y2 + x2 / 8;
			end if;
		end if;
	end process;

	judge4 <= '0' when (temp3 < 0) else
				'0' when (signed("00" & phase3(16 downto 0)) >= temp3) else
				'1';
	step4 : process (clk)
	begin
		if (rising_edge(clk)) then
			if (judge4 = '1') then
				temp4 <= temp3 - to_signed(5208, temp4'length);
				x4 <= x3 + y3 / 16;
				y4 <= y3 - x3 / 16;
			else
				temp4 <= temp3 + to_signed(5208, temp4'length);
				x4 <= x3 - y3 / 16;
				y4 <= y3 + x3 / 16;
			end if;
		end if;
	end process;

	judge5 <= '0' when (temp4 < 0) else
				'0' when (signed("00" & phase4(16 downto 0)) >= temp4) else
				'1';
	step5 : process (clk)
	begin
		if (rising_edge(clk)) then
			if(judge5 = '1') then
				temp5 <= temp4 - to_signed(2606, temp4'length);
				x5 <= x4 + y4 / 32;
				y5 <= y4 - x4 / 32;
			else
				temp5 <= temp4 + to_signed(2606, temp4'length);
				x5 <= x4 - y4 / 32;
				y5 <= y4 + x4 / 32;
			end if;
		end if;
	end process;

	judge6 <= '0' when (temp5 < 0) else
				'0' when (signed("00" & phase5(16 downto 0)) >= temp5) else
				'1';
	step6 : process (clk)
	begin
		if (rising_edge(clk)) then
			if (judge6 = '1') then
				temp6 <= temp5 - to_signed(1303, temp6'length);
				x6 <= x5 + y5 / 64;
				y6 <= y5 - x5 / 64;
			else
				temp6 <= temp5 + to_signed(1303, temp6'length);
				x6 <= x5 - y5 / 64;
				y6 <= y5 + x5 / 64;
			end if;
		end if;
	end process;

	judge7 <= '0' when (temp6 < 0) else
				'0' when (signed("00" & phase6(16 downto 0)) >= temp6) else
				'1';
	step7 : process (clk)
	begin
		if (rising_edge(clk)) then
			if (judge7 ='1') then
				temp7 <= temp6 - to_signed(651, temp7'length);
				x7 <= x6 + y6 / 128;
				y7 <= y6 - x6 / 128;
			else
				temp7 <= temp6 + to_signed(651, temp7'length);
				x7 <= x6 - y6 / 128;
				y7 <= y6 + x6 / 128;
			end if;
		end if;
	end process;

	judge8 <= '0' when (temp7 < 0) else
				'0' when (signed("00" & phase7(16 downto 0)) >= temp7) else
				'1';
	step8 : process (clk)
	begin
		if (rising_edge(clk)) then
			if (judge8 = '1') then
				temp8 <= temp7 - to_signed(325, temp8'length);
				x8 <= x7 + y7 / 256;
				y8 <= y7 - x7 / 256;
			else
				temp8 <= temp7 + to_signed(325, temp8'length);
				x8 <= x7 - y7 / 256;
				y8 <= y7 + x7 / 256;
			end if;
		end if;
	end process;

	judge9 <= '0' when (temp8 < 0) else
				'0' when (signed("00" & phase8(16 downto 0)) >= temp8) else
				'1';
	step9 : process (clk)
	begin
		if (rising_edge(clk)) then
			if (judge9 = '1') then
				temp9 <= temp8 - to_signed(162, temp9'length);
				x9 <= x8 + y8 / 512;
				y9 <= y8 - x8 / 512;
			else
				temp9 <= temp8 + to_signed(162, temp9'length);
				x9 <= x8 - y8 / 512;
				y9 <= y8 + x8 / 512;
			end if;
		end if;
	end process;

	judge10 <= '0' when (temp9 < 0) else
				'0' when (signed("00" & phase9(16 downto 0)) >= temp9) else
				'1';
	shift10_y_inst : sshift generic map (19, 10) port map (y9, shift10_y);
	shift10_x_inst : sshift generic map (19, 10) port map (x9, shift10_x);
	step10 : process (clk)
	begin
		if (rising_edge(clk)) then
			if(judge10 = '1') then
				temp10 <= temp9 - to_signed(81, temp10'length);
				x10 <= x9 + shift10_y;
				y10 <= y9 - shift10_x;
			else
				temp10 <= temp9 + to_signed(81, temp10'length);
				x10 <= x9 - shift10_y;
				y10 <= y9 + shift10_x;
			end if;
		end if;
	end process;

	judge11 <= '0' when (temp10 < 0) else
				'0' when (signed("00" & phase10(16 downto 0)) >= temp10) else
				'1';
	shift11_y_inst : sshift generic map (19, 11) port map (y10, shift11_y);
	shift11_x_inst : sshift generic map (19, 11) port map (x10, shift11_x);
	step11 : process (clk)
	begin
		if (rising_edge(clk)) then
			if(judge11 = '1') then
				temp11 <= temp10 - to_signed(40, temp11'length);
				x11 <= x10 + shift11_y;
				y11 <= y10 - shift11_x;
			else
				temp11 <= temp10 + to_signed(40, temp11'length);
				x11 <= x10 - shift11_y;
				y11 <= y10 + shift11_x;
			end if;
		end if;
	end process;

	judge12 <= '0' when (temp11 < 0) else
				'0' when (signed("00" & phase11(16 downto 0)) >= temp11) else
				'1';
	shift12_y_inst : sshift generic map (19, 12) port map (y11, shift12_y);
	shift12_x_inst : sshift generic map (19, 12) port map (x11, shift12_x);
	step12 : process (clk)
	begin
		if (rising_edge(clk)) then
			if (judge12 = '1') then
				temp12 <= temp11 - to_signed(20, temp12'length);
				x12 <= x11 + shift12_y;
				y12 <= y11 - shift12_x;
			else
				temp12 <= temp11 + to_signed(20, temp12'length);
				x12 <= x11 - shift12_y;
				y12 <= y11 + shift12_x;
			end if;
		end if;
	end process;

	judge13 <= '0' when (temp12 < 0) else
				'0' when (signed("00" & phase12(16 downto 0)) >= temp12) else
				'1';
	shift13_y_inst : sshift generic map (19, 13) port map (y12, shift13_y);
	shift13_x_inst : sshift generic map (19, 13) port map (x12, shift13_x);
	step13 : process (clk)
	begin
		if (rising_edge(clk)) then
			if (judge13 = '1') then
				temp13 <=temp12 - to_signed(10, temp13'length);
				x13 <= x12 + shift13_y;
				y13 <= y12 - shift13_x;
			else
				temp13 <= temp12 + to_signed(10, temp13'length);
				x13 <= x12 - shift13_y;
				y13 <= y12 + shift13_x;
			end if;
		end if;
	end process;

	judge14 <= '0' when (temp13 < 0) else
				'0' when (signed("00" & phase13(16 downto 0)) >= temp13) else
				'1';
	shift14_y_inst : sshift generic map (19, 14) port map (y13, shift14_y);
	shift14_x_inst : sshift generic map (19, 14) port map (x13, shift14_x);
	step14 : process (clk)
	begin
		if (rising_edge(clk)) then
			if(judge14 = '1') then
				temp14 <= temp13 - to_signed(5, temp14'length);
				x14 <= x13 + shift14_y;
				y14 <= y13 - shift14_x;
			else
				temp14 <= temp13 + to_signed(5, temp14'length);
				x14 <= x13 - shift14_y;
				y14 <= y13 + shift14_x;
			end if;
		end if;
	end process;

	judge15 <= '0' when (temp14 < 0) else
				'0' when (signed("00" & phase14(16 downto 0)) >= temp14) else
				'1';
	shift15_y_inst : sshift generic map (19, 15) port map (y14, shift15_y);
	shift15_x_inst : sshift generic map (19, 15) port map (x14, shift15_x);
	step15 : process (clk)
	begin
		if (rising_edge(clk)) then
			if (judge15 = '1') then
				temp15 <= temp14 - to_signed(2, temp15'length);
				x15 <= x14 + shift15_y;
				y15 <= y14 - shift15_x;
			else
				temp15 <= temp14 + to_signed(2, temp15'length);
				x15 <= x14 - shift15_y;
				y15 <= y14 + shift15_x;
			end if;
		end if;
	end process;

	judge16 <= '0' when (temp15 < 0) else
				'0' when (signed("00" & phase15(16 downto 0)) >= temp15) else
				'1';
	shift16_y_inst : sshift generic map (19, 16) port map (y15, shift16_y);
	shift16_x_inst : sshift generic map (19, 16) port map (x15, shift16_x);
	step16 : process (clk)
	begin
		if (rising_edge(clk)) then
			if(judge16 = '1') then
				temp16 <= temp15 - to_signed(1, temp16'length);
				x16 <= x15 + shift16_y;
				y16 <= y15 - shift16_x;
			else
				temp16 <= temp15 + to_signed(1, temp16'length);
				x16 <= x15 - shift16_y;
				y16 <= y15 + shift16_x;
			end if;
		end if;
	end process;

	judge17 <= '0' when (temp16 < 0) else
				'0' when (signed("00" & phase16(16 downto 0)) >= temp16) else
				'1';
	shift17_y_inst : sshift generic map (19, 17) port map (y16, shift17_y);
	shift17_x_inst : sshift generic map (19, 17) port map (x16, shift17_x);
	step17 : process (clk)
	begin
		if (rising_edge(clk)) then
			if (judge17 = '1') then
				x17 <= x16 + shift17_y;
				y17 <= y16 - shift17_x;
			else
				x17 <= x16 - shift17_y;
				y17 <= y16 + shift17_x;
			end if;
		end if;
	end process;

	cos <= reg_cos;
	sin <= reg_sin;
	step18 : process (clk)
	begin
		if (rising_edge(clk)) then
			if (phase17(18 downto 17) = "00") then
				reg_cos <= x17(18 downto 3);
				reg_sin <= y17(18 downto 3);
			elsif (phase17(18 downto 17) = "01") then
				reg_cos <= -y17(18 downto 3);
				reg_sin <= x17(18 downto 3);
			elsif (phase17(18 downto 17) = "10") then
				reg_cos <= -x17(18 downto 3);
				reg_sin <= -y17(18 downto 3);
			else
				reg_cos <= y17(18 downto 3);
				reg_sin <= -x17(18 downto 3);
			end if;
		end if;
	end process;

end rtl;




----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity nco_1mhz is 
	PORT
	(
		clk80m : in std_logic;
		sin : out std_logic_vector( 13 downto 0 );
		cos : out std_logic_vector( 13 downto 0 )
	);
end nco_1mhz;

architecture rtl of nco_1mhz is

component cordic_nco
	PORT
	(
		clk : in std_logic;
		frq : in std_logic_vector( 31 downto 0 );
		sin : out signed( 15 downto 0 );
		cos : out signed( 15 downto 0 )
	);
end component;

component MY_NCO
	PORT
	(
		clk : in std_logic;
		frq : in std_logic_vector( 31 downto 0 );
		sin : out signed( 15 downto 0 );
		cos : out signed( 15 downto 0 )
	);
end component;

signal sin_16 : signed(15 downto 0);
signal cos_16 : signed(15 downto 0);

begin

	sin <= std_logic_vector(sin_16(15 downto 2));
	cos <= std_logic_vector(cos_16(15 downto 2));
--	cordic_nco_inst : MY_NCO PORT MAP (
	cordic_nco_inst : cordic_nco PORT MAP (
		clk	=> clk80m,
		frq	=> conv_std_logic_vector(53687091, 32),
		sin	=> sin_16,
		cos	=> cos_16
	);

end rtl;
