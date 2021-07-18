library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity test_lpf is
	port (
	signal clk80m       : in std_logic;
	signal reset        : in std_logic
	);
end test_lpf;

architecture stimulus of test_lpf is 

component wave_mem
	generic (mif_file : string := "null-file.mif");
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
end component;

component lpf_28tap
	port (
	signal clk80m		: in std_logic;
	signal indata       : in std_logic_vector(11 downto 0);
	signal outdata      : out std_logic_vector(15 downto 0)
	);
end component;

component lpf_fir
	port (
	signal clk			: in std_logic;
	signal indata     : in std_logic_vector(11 downto 0);
	signal outdata    : out std_logic_vector(15 downto 0)
	);
end component;

signal addr_cnt : std_logic_vector(8 downto 0);
signal mem_data_cos_cw : std_logic_vector(15 downto 0);
signal in_data1 : std_logic_vector(11 downto 0);
signal lp_filtered : std_logic_vector(15 downto 0);
signal lp_filtered_sample : std_logic_vector(15 downto 0);

begin

	--raw adc
	clk_80m_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (reset = '1') then
				addr_cnt <= (others => '0');
			else
			    if (addr_cnt < conv_std_logic_vector(379, 8)) then
    				addr_cnt <= addr_cnt + 1;
			    else
    				addr_cnt <= (others => '0');
			    end if;
			end if;
		end if;
	end process;
    in_data1 <= mem_data_cos_cw (15 downto 4);

	cos_cw_inst : wave_mem generic map ("wave-cos-cw.mif")
	PORT MAP (
		address   => addr_cnt,
		clock	=> clk80m,
		q	=> mem_data_cos_cw
	);

	lpf_inst : lpf_28tap
	PORT MAP (
		clk80m => clk80m,
		indata => in_data1,
		outdata => lp_filtered
	);

	lpf_sample_inst : lpf_fir
	PORT MAP (
		clk => clk80m,
		indata => in_data1,
		outdata => lp_filtered_sample
	);

end stimulus;

