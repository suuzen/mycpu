
module ex (
    input       wire            rst,
    
//��id_ex����
    input       wire[7:0]       i_ex_aluop,
    input       wire[31:0]       i_ex_rs_data,
    input       wire[31:0]       i_ex_rt_data,
    input       wire[4:0]       i_ex_w_reg_addr,
    input       wire            i_ex_wd,
    input       wire            ex_inst_in_delayslot,  ////�������ָ���Ƿ�Ϊ�ӳٲ�ָ��
    input       wire[31:0]      ex_inst,  //����ʱ���ڻ�ȡ���������в���

//��ex_men����
    output      reg[31:0]       w_reg_data,
    output      reg[4:0]        w_reg_addr,
    output      reg             wd,       
//���ڼ��أ��洢ָ��(���ݸ��ô�׶�)
    output      wire[7:0]       o_ex_aluop,  //���ڷô�׶��жϼ��غʹ洢ָ��
    output      wire[31:0]      men_inst_addr,  //�����ڴ�ĵ�ַ
    output      wire[31:0]      men_data_use   //�ô�ʱ�洢ָ��洢�����ݻ����ָ����ص�Ŀ�ļĴ���
);

assign  o_ex_aluop      =   i_ex_aluop;
assign  men_inst_addr   =   i_ex_rs_data +{{16{ex_inst[15]}},ex_inst[15:0]};    //�õ��洢ָ��ͼ���ָ������Ĵ洢��ַ
assign  men_data_use    =   i_ex_rt_data;   //�洢ָ����Ҫ�洢��ĳ�Ĵ����е�����

wire[31:0]  buma    =   (~i_ex_rt_data)+1;
always @ (*) begin
    if(rst) begin
        w_reg_data      <=      32'h0;
        w_reg_addr      <=      5'h0;
        wd              <=      1'b0;
    end 
    else if( ex_inst_in_delayslot == 1'b1) begin
        w_reg_data      <=      32'h0;
        w_reg_addr      <=      5'h0;
        wd              <=      1'b0;
    end
    else begin               // addu, ori, beq, and, or, xor, lui, sll
        case( i_ex_aluop )
            8'b00100001:    w_reg_data <=  i_ex_rs_data + i_ex_rt_data;           //addu
            8'b00100010:    w_reg_data <=  i_ex_rs_data + buma;                  //sub
            8'b00001001:    w_reg_data <=  i_ex_rs_data + i_ex_rt_data;          //addiu
            8'b00001100:    w_reg_data <=  i_ex_rs_data & i_ex_rt_data;           //andi
            8'b00001101:    w_reg_data <=  i_ex_rs_data | i_ex_rt_data;           //ori
      //    8'b00000100:    w_reg_data <=                                         //beq(û�õ�)
      //    8'b00000101:    w_reg_data <=                                         //bne(û�õ�)
      //    8'b00000001:    w_reg_data <=                                         //bgez(û�õ�)
            8'b00100100:    w_reg_data <=  i_ex_rs_data & i_ex_rt_data;           //and
            8'b00100101:    w_reg_data <=  i_ex_rs_data | i_ex_rt_data;           //or
            8'b00100110:    w_reg_data <=  i_ex_rs_data ^ i_ex_rt_data;           //xor
            8'b00001111:    w_reg_data <=  i_ex_rt_data;                          //lui
            8'b00000000:    w_reg_data <=  i_ex_rt_data << i_ex_rs_data[4:0];     //sll
            8'b00000001:    w_reg_data <=  i_ex_rt_data >> i_ex_rs_data[4:0];     //srlv
            8'b00101000:    w_reg_data <=  32'h0;                                 //sb(Ҳû�õ�)
            8'b00100000:    w_reg_data <=  32'h0;                                 //lb(�˴���δ�ô棬�޷��ó���д��Ĵ�������)
            8'b00100011:    w_reg_data <=  32'h0;                                 //lw(�˴���δ�ô棬�޷��ó���д��Ĵ�������) 
            8'b00101011:    w_reg_data <=  32'h0;                                 //sw(û�õ�) 
            default:    begin
                
            end
        endcase
        wd          <=      i_ex_wd;
        w_reg_addr  <=      i_ex_w_reg_addr;
    
    end
 end

endmodule