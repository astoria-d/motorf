library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.conv_std_logic_vector;

entity moto_nco is 
	PORT
	(
		clk : in std_logic;
		frq : in std_logic_vector( 31 downto 0 );
		sin : out std_logic_vector( 15 downto 0 );
		cos : out std_logic_vector( 15 downto 0 )
	);
end moto_nco;

architecture rtl of moto_nco is

signal phase32 : std_logic_vector(31 downto 0) := conv_std_logic_vector(0, 32);

signal judge0 : integer range 0 to 1;
signal phase0 : std_logic_vector(18 downto 0);
signal temp0 : signed(18 downto 0);
signal x0 : signed(18 downto 0);
signal y0 : signed(18 downto 0);

signal judge1 : integer range 0 to 1;
signal phase1 : std_logic_vector(18 downto 0);
signal temp1 : signed(18 downto 0);
signal x1 : signed(18 downto 0);
signal y1 : signed(18 downto 0);


function rshift(op1 : in std_logic_vector; op2 : in std_logic_vector) return std_logic_vector is
variable temp : std_logic_vector (op1'range);
begin
	 return temp;
end rshift;

begin

   pipeline : process (clk)
	use ieee.std_logic_unsigned.all;
   begin
		if (rising_edge(clk)) then
			phase32 <= 	phase32 + frq;
			phase0 <= phase32(31 downto 13);
			phase1 <= phase0;
		end if;
	end process;

--///  step0 ////
--always@(posedge clk)begin
--	temp0 <= 	65536;	
--	x0 <= 131072;
--	y0 <= 131072;
--end
   step0 : process (clk)
	use ieee.std_logic_arith.conv_std_logic_vector;
   begin
		if (rising_edge(clk)) then
			temp0 <= to_signed(65536, 19);
			x0 <= to_signed(131072, 19);
			y0 <= to_signed(131072, 19);
		end if;
	end process;

--
--///  step1 ////
--always@(phase0[16:0] or temp0)begin
--	if(temp0<0)
--		judge1 <= 0;
--	else if(phase0[16:0]>=temp0)
--		judge1 <= 0;
--	else
--		judge1 <= 1;		
--end
	step1_jdg : process (phase0(16 downto 0), temp0)
	begin
		if (temp0 < 0) then
			judge1 <= 0;
		elsif (signed("00" & phase0(16 downto 0)) >= temp0) then
			judge1 <= 0;
		else
			judge1 <= 1;
		end if;
	end process;

--
--always@(posedge clk)begin
--	if(judge1==1)begin
--		temp1 <=temp0-38688;	
--		x1 <= x0 + y0/2;
--		y1 <= y0 - x0/2;		
--	end
--	else begin
--		temp1 <=temp0+38688;
--		x1 <= x0 - y0/2;
--		y1 <= y0 + x0/2;
--	end
--end
   step1 : process (clk)
	variable sft_x : signed(18 downto 0);
	variable sft_y : signed(18 downto 0);
   begin
		if (rising_edge(clk)) then

--for use ieee.std_logic_arith.all;
--			sft_x := SHR(x0, conv_std_logic_vector(1, 19));
--			sft_y := SHR(y0, conv_std_logic_vector(1, 19));

--old. not supported.
--https://stackoverflow.com/questions/36021163/sra-not-working-in-vhdl
--			sft_x := (x0 sra 1);
--			sft_y := (y0 sra 1);

			sft_x := shift_right(x0, 1);
			sft_y := shift_right(y0, 1);
			if (judge1 = 1) then
				temp1 <= temp0 - to_signed(38688, 19);
				x1 <= x0 + sft_x;
				y1 <= y0 - sft_y;
			else
				temp1 <= temp0 + to_signed(38688, 19);
				x1 <= x0 - sft_x;
				y1 <= y0 + sft_y;
			end if;
		end if;
	end process;

end rtl;
