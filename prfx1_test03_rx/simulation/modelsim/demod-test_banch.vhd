library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity testbench_prfx1_test01 is
end testbench_prfx1_test01;

architecture stimulus of testbench_prfx1_test01 is 

component prfx1_test03_rx
   port (
	signal clk16m     : in std_logic;
	signal adc 			: in std_logic_vector(11 downto 0);
	signal adc_clk		: out std_logic;

	signal spiclk		: out std_logic;
	signal sdi			: out std_logic;
	signal spics_pll	: out std_logic;

	signal sw1     	: in std_logic;
	signal sw2     	: in std_logic;
	signal led1			: out std_logic;
	signal led2			: out std_logic;
	signal led3			: out std_logic
	);
end component;


signal base_clk         : std_logic;
signal reset_input      : std_logic;

signal adc 			: std_logic_vector(11 downto 0);
signal adc_clk		: std_logic;

signal spiclk		: std_logic;
signal sdi			: std_logic;
signal spics_pll	: std_logic;

signal sw1			: std_logic;
signal sw2			: std_logic;
signal led1			: std_logic;
signal led2			: std_logic;
signal led3			: std_logic;

constant powerup_time   : time := 500 ns;
constant reset_time     : time := 1 us;

---clock frequency = 16,000,000 Hz
--constant base_clock_time : time := 62.5 ns;
constant base_clock_time : time := 62.5 ns;

begin

    sim_board : prfx1_test03_rx port map (
		clk16m		=> base_clk,
		adc 		=> adc,
		adc_clk		=> adc_clk,

		spiclk		=> spiclk,
		sdi			=> sdi,
		spics_pll	=> spics_pll,

		sw1     	=> reset_input,
		sw2     	=> '0',
		led1		=> led1,
		led2		=> led2,
		led3		=> led3
	);

    --- input reset.
    reset_p: process
    begin
        reset_input <= '0';
        wait for powerup_time;

        reset_input <= '1';
        wait for reset_time;

        reset_input <= '0';
        wait;
    end process;

    --- generate base clock.
    clock_p: process
    begin
        base_clk <= '1';
        wait for base_clock_time / 2;
        base_clk <= '0';
        wait for base_clock_time / 2;
    end process;

end stimulus;

-------------------------------


library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity debug_stub is 
	port (
	signal clk80m		: in std_logic;
	signal reset_n		: in std_logic;
	signal symbol_num : out std_logic_vector(7 downto 0);
	signal symbol_cnt : out std_logic_vector(15 downto 0);
	signal testdata		: out std_logic_vector(31 downto 0)
	);
end debug_stub;

architecture rtl of debug_stub is 

component input_data_mem
	generic (mif_file : string := "null-file.mif");
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;


signal work_cnt : std_logic_vector(15 downto 0);
signal work_num : std_logic_vector(7 downto 0);
signal in_rom_addr : std_logic_vector(10 downto 0);

begin

	count_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (reset_n = '0') then
				work_num <= "00000010";
				work_cnt <= (others => '0');
			else
				if (work_cnt = 6080 - 1) then
					work_cnt <= (others => '0');
				else
					work_cnt <= work_cnt + conv_std_logic_vector(1, work_cnt'length);
				end if;

				if (work_cnt = 6080 - 1) then
					if (work_num = 99) then
						work_num <= (others => '0');
					else
						work_num <= work_num + conv_std_logic_vector(1, work_num'length);
					end if;
				end if;
			end if;
		end if;
	end process;

	symbol_cnt <= work_cnt;
	symbol_num <= work_num;

	in_rom_addr_p : process (clk80m)
	variable tmp : integer;
	begin
		if (rising_edge(clk80m)) then
			tmp := (conv_integer(unsigned(work_num)) - 1) * 380 + conv_integer(unsigned(work_cnt)) / 16;
			in_rom_addr <= conv_std_logic_vector(tmp, in_rom_addr'length);
		end if;
	end process;

	input_data_inst : input_data_mem generic map ("demo-dinput.mif") PORT MAP ( address => in_rom_addr, clock => clk80m, q => testdata );

end rtl;

----------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY input_data_mem IS
	generic (mif_file : string := "null-file.mif");
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END input_data_mem;


ARCHITECTURE SYN OF input_data_mem IS

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (31 DOWNTO 0);

BEGIN
	q    <= sub_wire0(31 DOWNTO 0);

	altsyncram_component : altsyncram
	GENERIC MAP (
		address_aclr_a => "NONE",
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => mif_file,
		intended_device_family => "Cyclone IV E",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 2048,
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "CLOCK0",
		widthad_a => 11,
		width_a => 32,
		width_byteena_a => 1
	)
	PORT MAP (
		address_a => address,
		clock0 => clock,
		q_a => sub_wire0
	);



END SYN;
