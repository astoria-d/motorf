    library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;


    entity CORDIC_PRE is
        port(
        i_clk   :in     std_logic                       ;--クロック
        i_tgt   :in     std_logic_vector(18 downto 0)   ;--目標角度0～360°(整数9bit 小数10bit)
        i_ena   :in     std_logic                       ;--イネーブル
        o_tgt   :out    std_logic_vector(16 downto 0)   ;--目標角度0～90°(整数7bit 小数10bit)
        o_ena   :out    std_logic                       ;--イネーブル
        o_pol   :out    std_logic                       );--出力極性フラグ()
    end entity;

architecture rtl of CORDIC_PRE is
    ----------------------------------------------------------------
    --CONSTANT
    ----------------------------------------------------------------
    --90,180,270度を固定少数10bitにした値
    constant    DEG90   :std_logic_vector(18 downto 0)  :=conv_std_logic_vector(90 ,9) & conv_std_logic_vector(0,10);
    constant    DEG180  :std_logic_vector(18 downto 0)  :=conv_std_logic_vector(180,9) & conv_std_logic_vector(0,10);
    constant    DEG270  :std_logic_vector(18 downto 0)  :=conv_std_logic_vector(270,9) & conv_std_logic_vector(0,10);
    constant    DEG360  :std_logic_vector(18 downto 0)  :=conv_std_logic_vector(360,9) & conv_std_logic_vector(0,10);

    constant    ANG90   :std_logic_vector(16 downto 0)  :=conv_std_logic_vector(90 ,7) & conv_std_logic_vector(0,10);
    ----------------------------------------------------------------
    --SIGNAL
    ----------------------------------------------------------------
    signal  d0_ena  :std_logic                      :='0'           ;
    signal  d0_tgt  :std_logic_vector(18 downto 0)  :=(others=>'0') ;

    signal  d1_ena  :std_logic                      :='0'           ;--
    signal  d1_pol  :std_logic                      :='0'           ;--出力極性反転フラグ(180°以上で負数に反転させる)
    signal  d1_rvs  :std_logic                      :='0'           ;--角度90°反転
    signal  nom_ang :std_logic_vector(18 downto 0)  :=(others=>'0') ;--0～90°にノーマライズした角度

    signal  d2_ena  :std_logic                      :='0'           ;--
    signal  d2_pol  :std_logic                      :='0'           ;--
    signal  tgt_ang :std_logic_vector(16 downto 0)  :=(others=>'0') ;--

begin

    --Stage0
    process(i_clk)begin
        if Rising_edge(i_clk) then
            --入力FF
            d0_ena  <=i_ena;
            d0_tgt  <=i_tgt;
        end if;
    end process;

    --Stage1
    process(i_clk)begin
        if Rising_edge(i_clk) then

            if(d0_tgt>=DEG360)then
                d1_ena  <='0';--360°以降は無効入力としてENAを落とす
            else
                d1_ena  <=d0_ena;
            end if;

            if(d0_tgt>=DEG360)then
                d1_pol  <='0';
                d1_rvs  <='0';
                nom_ang <=(others=>'0');--360°以上が入力されたら0°として処理する
            elsif(d0_tgt>=DEG270)then
                d1_pol  <='1';
                d1_rvs  <='1';
                nom_ang <=d0_tgt - DEG270;
            elsif(d0_tgt>=DEG180)then
                d1_pol  <='1';
                d1_rvs  <='0';
                nom_ang <=d0_tgt - DEG180;
            elsif(d0_tgt>=DEG90)then
                d1_pol  <='0';
                d1_rvs  <='1';
                nom_ang <=d0_tgt - DEG90;
            else
                d1_pol  <='0';
                d1_rvs  <='0';
                nom_ang <=d0_tgt;
            end if;
        end if;
    end process;

    --Stage2
    process(i_clk)begin
        if Rising_edge(i_clk) then
            d2_ena  <=d1_ena;
            d2_pol  <=d1_pol;
            --90°反転フラグが立っていたら
            if(d1_rvs='0')then
                tgt_ang <=nom_ang(16 downto 0);
            else
                tgt_ang <=ANG90 - nom_ang(16 downto 0);
            end if;

        end if;
    end process;

    o_ena   <=d2_ena    ;
    o_pol   <=d2_pol    ;
    o_tgt   <=tgt_ang   ;
end architecture;
