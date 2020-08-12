    library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;


    entity CORDIC_POST is
        port(
        i_clk   :in     std_logic                       ;--クロック
        i_tgt   :in     std_logic_vector(17 downto 0)   ;--目標角度
        i_ena   :in     std_logic                       ;--イネーブル
        i_pol   :in     std_logic                       ;--出力極性反転フラグ
        i_y     :in     std_logic_vector(15 downto 0)   ;--座標Y
        o_ena   :out    std_logic                       ;--
        o_sin   :out    std_logic_vector(15 downto 0)   );--
    end entity;

architecture rtl of CORDIC_POST is
    ----------------------------------------------------------------
    --SIGNAL
    ----------------------------------------------------------------
    signal  ena :std_logic                      :='0'           ;
    signal  pol :std_logic                      :='0'           ;
    signal  y   :std_logic_vector(15 downto 0)  :=(others=>'0') ;

    signal  ena1:std_logic                      :='0'           ;
    signal  sin :std_logic_vector(15 downto 0)  :=(others=>'0') ;

begin

    --Stage0
    process(i_clk)begin
        if Rising_edge(i_clk) then
            if(i_ena='1')then
                ena <='1'   ;
                pol <=i_pol ;
                y   <=i_y   ;
            else
                ena <='0'           ;
                pol <='0'           ;
                y   <=(others=>'0') ;
            end if;
        end if;
    end process;

    --Stage1
    process(i_clk)begin
        if Rising_edge(i_clk) then
            ena1<=ena;

            if(pol='0')then
                sin <=y     ;
            else
                sin <=(not y) + 1;
            end if;
        end if;
    end process;

    o_ena   <=ena1;
    o_sin   <=sin;

end architecture;
