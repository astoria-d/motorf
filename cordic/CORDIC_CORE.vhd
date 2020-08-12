    library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.all;

    entity CORDIC_CORE is
        generic(
        N               :integer                        ;--�V�t�g��
        ANGLE_TABLE     :std_logic_vector(16 downto 0)  );--�p�x�Q�ƃe�[�u��
        port(
        i_clk   :in     std_logic                       ;--�N���b�N
        i_tgt   :in     std_logic_vector(17 downto 0)   ;--�ڕW�p�x
        i_ena   :in     std_logic                       ;--�C�l�[�u��
        i_pol   :in     std_logic                       ;--�o�͋ɐ����]�t���O
        i_ang   :in     std_logic_vector(17 downto 0)   ;--���݊p�x
        i_x     :in     std_logic_vector(15 downto 0)   ;--���WX
        i_y     :in     std_logic_vector(15 downto 0)   ;--���WY
        o_tgt   :out    std_logic_vector(17 downto 0)   ;--
        o_ena   :out    std_logic                       ;--
        o_pol   :out    std_logic                       ;--
        o_ang   :out    std_logic_vector(17 downto 0)   ;--
        o_x     :out    std_logic_vector(15 downto 0)   ;--
        o_y     :out    std_logic_vector(15 downto 0)   );--
    end entity;

architecture rtl of CORDIC_CORE is
    signal  tgt     :std_logic_vector(17 downto 0)  :=(others=>'0') ;
    signal  ena     :std_logic                      :='0'           ;
    signal  pol     :std_logic                      :='0'           ;
    signal  cd      :std_logic                      :='0'           ;
    signal  ang     :std_logic_vector(17 downto 0)  :=(others=>'0') ;
    signal  x       :std_logic_vector(15 downto 0)  :=(others=>'0') ;
    signal  y       :std_logic_vector(15 downto 0)  :=(others=>'0') ;

    signal  ang_tbl :std_logic_vector(17 downto 0)  ;
    signal  sft_x   :std_logic_vector(15 downto 0)  ;
    signal  sft_y   :std_logic_vector(15 downto 0)  ;

begin

    --����FF
    process(i_clk)begin
        if Rising_edge(i_clk) then
            if(i_ena='1')then
                tgt <=i_tgt;
                ena <='1';

                if(i_ang(i_ang'high)='1')then --MSB���P�͕����Ȃ̂ŏ�ɑ���
                    cd  <='0';--�p�x��������
                else
                    if(i_ang>=i_tgt)then
                        cd  <='1';--�p�x��������
                    else
                        cd  <='0';--�p�x��������
                    end if;
                end if;
                x   <=i_x;
                y   <=i_y;
                ang <=i_ang;
                pol <=i_pol;
            else
                tgt <=(others=>'0');
                ena <='0';
                cd  <='0';
                x   <=(others=>'0');
                y   <=(others=>'0');
                ang <=(others=>'0');
                pol <='0';
            end if;
        end if;
    end process;

    --�V�t�g
    GEN:for i in 0 to 15 generate
        GENIF:if i >=(15-N)generate
            sft_x(i)    <=x(15);
            sft_y(i)    <=y(15);
        end generate;

        GENIF2:if i <(15-N)generate
            sft_x(i)    <=x(i+N+1);
            sft_y(i)    <=y(i+N+1);
        end generate;
    end generate;

    --����bit�t��
    ang_tbl <='0' & ANGLE_TABLE;

    --�ڕW�p�x
    o_tgt   <=tgt;

    --�C�l�[�u��
    o_ena   <=ena;
    o_pol   <=pol;

    --���݊p�x
    o_ang   <=  ang - ang_tbl when(cd='1')else
                ang + ang_tbl;

    --X���W
    o_x     <=  x - sft_y   when(cd='0')else
                x + sft_y;

    --Y���W
    o_y     <=  y + sft_x   when(cd='0')else
                y - sft_x;

end architecture;
