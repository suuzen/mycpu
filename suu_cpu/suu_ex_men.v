
module ex_men (
    input       wire            rst,
    input       wire            clk,

//��ex����
    //���ڶ�д�Ĵ���
    input       wire[31:0]      ex_w_reg_data,
    input       wire[4:0]       ex_w_reg_addr,
    input       wire            ex_wd,
    //���ڼ���ָ��ʹ洢ָ��ô�
    input       wire[7:0]       ex_men_aluop_i,
    input       wire[31:0]      i_ex_men_inst_addr,
    input       wire[31:0]      i_ex_men_data_use,

//��men����
    output      reg[31:0]       men_w_reg_data,
    output      reg[4:0]        men_w_reg_addr,
    output      reg             men_wd,
    //���ڼ���ָ��ʹ洢ָ��ô�
    output      reg[7:0]       ex_men_aluop_o,
    output      reg[31:0]      o_ex_men_inst_addr,
    output      reg[31:0]      o_ex_men_data_use

);

always @ ( posedge clk) begin
    if(rst) begin
        men_w_reg_data      <=      32'h0;
        men_w_reg_addr      <=      5'h0;
        men_wd              <=      1'b0;
        ex_men_aluop_o      <=      8'h0;
        o_ex_men_inst_addr  <=      32'h0;
        o_ex_men_data_use   <=      32'h0;
    end
    else begin
       men_w_reg_data       <=      ex_w_reg_data;
       men_w_reg_addr       <=      ex_w_reg_addr;
       men_wd               <=      ex_wd;
       ex_men_aluop_o       <=      ex_men_aluop_i;
        o_ex_men_inst_addr  <=      i_ex_men_inst_addr;
        o_ex_men_data_use   <=      i_ex_men_data_use;
   end

end    

endmodule