
module men (
    input      wire        rst,

//��ex_men����
    input       wire[31:0]  i_w_reg_data,
    input       wire[4:0]   i_w_reg_addr,
    input       wire        i_wd,
    //���ڼ���ָ��ʹ洢ָ��ô�
    input       wire[7:0]   i_men_aluop,
    input       wire[31:0]  i_men_inst_addr,
    input       wire[31:0]  i_men_data_use,
//��RAM��������÷ô�����
    input       wire[31:0]  men_data_i,     //�Ӵ洢����ȡ��������

//��Ĵ�������
    output      reg[31:0]   w_reg_data,
    output      reg[4:0]    w_reg_addr,
    output      reg         wd,

    //������洢������
    output      reg         men_ce_o,   //�ж��Ƿ���ʴ洢��
    output      reg         men_we_o,   //�ж��Ǽ���ָ��Ǵ洢ָ��
    output      reg[3:0]    men_sel_o,  //ѡȡ��Ҫ���ֽڣ����ڰ��֡��ֺ��ֽڵ�ѡȡ��
    output      reg[31:0]   o_men_inst_addr,    //���ʴ洢���ĵ�ַ
    output      reg[31:0]   men_data_o          //��д��洢��������

);

always @ (*) begin
    if(rst) begin
        w_reg_data      <=      32'h0;
        w_reg_addr      <=      5'h0;
        wd              <=      1'b0;
        men_ce_o        <=      1'b0;
        men_we_o        <=      1'b0;
        men_sel_o       <=      4'h0;
        o_men_inst_addr <=      32'h0;
        men_data_o      <=      32'h0;

    end
    else begin
       w_reg_data       <=      i_w_reg_data;
       w_reg_addr       <=      i_w_reg_addr;
       wd               <=      i_wd;
       case(i_men_aluop)
            8'b00101000: begin  //sb
                men_ce_o                <=  1'b1;
                men_we_o                <=  1'b1;
                o_men_inst_addr         <=  i_men_inst_addr;
                men_data_o              <=  { i_men_data_use[7:0],i_men_data_use[7:0],i_men_data_use[7:0],i_men_data_use[7:0] };
                //sbָ��ֻҪ��С�ֽڵ�����
                case(i_men_inst_addr[1:0])   //00  01  10   11  С��ģʽ��С������ӦС��ַ������11��Ӧ����ַ��men_sel_o �������Ҷ�Ӧ�ĵ�ַ�ɸߵ���
                    2'b00:  begin
                        men_sel_o       <=  4'b0001;    //00ʱ��С����ѡ��λ����С���ұ�һλ
                    end
                    2'b01:  begin
                        men_sel_o       <=  4'b0010;
                    end
                    2'b10:  begin
                        men_sel_o       <=  4'b0100;
                    end 
                    2'b11:  begin
                        men_sel_o       <=  4'b1000;
                    end
                    default:    begin
                        men_sel_o       <=  4'b0000;
                    end
                endcase
            end
            8'b00100000: begin  //lb
                men_ce_o                <=  1'b1;
                men_we_o                <=  1'b0;
                o_men_inst_addr         <=  i_men_inst_addr;
                //
                case(i_men_inst_addr[1:0])   //00  01  10   11  С��ģʽ��С������ӦС��ַ������11��Ӧ����ַ��men_sel_o �������Ҷ�Ӧ�ĵ�ַ�ɸߵ���
                    2'b00:  begin
                        w_reg_data      <=  { { 24{men_data_i[7]} },men_data_i[7:0]};
                        men_sel_o       <=  4'b0001;    //00ʱ��С����ѡ��λ����С���ұ�һλ
                    end
                    2'b01:  begin
                        w_reg_data      <=  { { 24{men_data_i[15]} },men_data_i[15:8]};
                        men_sel_o       <=  4'b0010;
                    end
                    2'b10:  begin
                        w_reg_data      <=  { { 24{men_data_i[23]} },men_data_i[23:16]};
                        men_sel_o       <=  4'b0100;
                    end 
                    2'b11:  begin
                        w_reg_data      <=  { { 24{men_data_i[31]} },men_data_i[31:24]};
                        men_sel_o       <=  4'b1000;
                    end
                    default:    begin
                        w_reg_data      <=  32'h0;
                        men_sel_o       <=  4'b0000;
                    end
                endcase
            end
            8'b00100011: begin    //lw
                men_ce_o                <=  1'b1;
                men_we_o                <=  1'b0;
                o_men_inst_addr         <=  i_men_inst_addr;
                w_reg_data              <=  men_data_i;
                men_sel_o               <=  4'b1111;    
            end
            8'b00101011: begin   //sw
                men_ce_o                <=  1'b1;
                men_we_o                <=  1'b1;
                o_men_inst_addr         <=  i_men_inst_addr;
                men_data_o              <=  i_men_data_use;
                men_sel_o               <=  4'b1111;    
            end
           default: begin
                men_ce_o        <=      1'b0;
                men_we_o        <=      1'b0;
                men_sel_o       <=      4'h0;
                o_men_inst_addr         <=  i_men_inst_addr;
                men_data_o      <=      32'h0;
           end      
       endcase
   end

end     
endmodule