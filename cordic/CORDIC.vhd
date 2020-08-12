    library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
    use ieee.std_logic_unsigned.all;

entity CORDIC is
    port(
        i_clk   :in     std_logic                       ;--クロック
        i_theta :in     std_logic_vector(18 downto 0)   ;--目標角度0～360°(整数9bit 小数10bit)
        i_ena   :in     std_logic                       ;--イネーブル
        o_ena   :out    std_logic                       ;--イネーブル
        o_sin   :out    std_logic_vector(15 downto 0)   );--
end entity;

architecture rtl of CORDIC is
    ----------------------------------------------------
    --User type
    ----------------------------------------------------
    --コア間接続信号をまとめたタイプ
    type typ_LINK_CORE is record
        tgt :std_logic_vector(17 downto 0)  ;--
        ena :std_logic                      ;--
        pol :std_logic                      ;--
        ang :std_logic_vector(17 downto 0)  ;--
        x   :std_logic_vector(15 downto 0)  ;--
        y   :std_logic_vector(15 downto 0)  ;--
    end record;

    --コア間接続信号タイプのアレイ
    type typ_LINK_CORE_ARY is
        array(integer range<>) of typ_LINK_CORE;

    type typ_ANGLE_TABLE is
        array(integer range<>) of std_logic_vector(16 downto 0);
    ----------------------------------------------------
    --Signal
    ----------------------------------------------------
    signal  lnk :typ_LINK_CORE_ARY(0 to 15) ;


    constant    N           :integer :=15;--パイプライン段数
    constant    INIT_ANG    :std_logic_vector(17 downto 0):=conv_std_logic_vector(46080,18);
    constant    INIT_X      :std_logic_vector(15 downto 0):='0'&conv_std_logic_vector(621,15);
    constant    INIT_Y      :std_logic_vector(15 downto 0):='0'&conv_std_logic_vector(621,15);

    constant    ANGLE_TABLE :typ_ANGLE_TABLE(0 to N)
        :=  ("0"&x"B400"
            ,"0"&x"6A42"
            ,"0"&x"3825"
            ,"0"&x"1C80"
            ,"0"&x"0E4E"
            ,"0"&x"0728"
            ,"0"&x"0394"
            ,"0"&x"01CA"
            ,"0"&x"00E5"
            ,"0"&x"0072"
            ,"0"&x"0039"
            ,"0"&x"001C"
            ,"0"&x"000E"
            ,"0"&x"0007"
            ,"0"&x"0003"
            ,"0"&x"0001"
            );

begin
    --前処理部：角度0～90°正規化
    u_CORDIC_PRE:entity work.CORDIC_PRE
        port map
        (i_clk  =>i_clk
        ,i_tgt  =>i_theta
        ,i_ena  =>i_ena
        ,o_tgt  =>lnk(0).tgt(16 downto 0)
        ,o_ena  =>lnk(0).ena
        ,o_pol  =>lnk(0).pol
        );

    --初期値 
    lnk(0).tgt(17)  <='0'       ;
    lnk(0).ang      <='0'&ANGLE_TABLE(0);--INIT_ANG ;
    lnk(0).x        <=INIT_X    ;
    lnk(0).y        <=INIT_Y    ;

    --コアモジュールシリアル接続
    GEN_CORDIC: for i in 0 to N-1 generate
        u_CORDIC_CORE:entity work.CORDIC_CORE
            generic map
            (N              =>i
            ,ANGLE_TABLE    =>ANGLE_TABLE(i+1)
            )
            port map
            (i_clk  =>i_clk         
            ,i_tgt  =>lnk( i ).tgt  
            ,i_ena  =>lnk( i ).ena  
            ,i_pol  =>lnk( i ).pol  
            ,i_ang  =>lnk( i ).ang  
            ,i_x    =>lnk( i ).x    
            ,i_y    =>lnk( i ).y    
            ,o_tgt  =>lnk(i+1).tgt  
            ,o_ena  =>lnk(i+1).ena  
            ,o_pol  =>lnk(i+1).pol  
            ,o_ang  =>lnk(i+1).ang  
            ,o_x    =>lnk(i+1).x    
            ,o_y    =>lnk(i+1).y    
            );
    end generate;


    CORDIC_POST:entity work.CORDIC_POST
        port map
        (i_clk  =>i_clk
        ,i_tgt  =>lnk(N).tgt    
        ,i_ena  =>lnk(N).ena    
        ,i_pol  =>lnk(N).pol    
        ,i_y    =>lnk(N).y  
        ,o_ena  =>o_ena
        ,o_sin  =>o_sin
        );

end architecture;
