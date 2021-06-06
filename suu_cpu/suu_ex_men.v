
module ex_men (
    input       wire            rst,
    input       wire            clk,

//与ex相连
    //用于读写寄存器
    input       wire[31:0]      ex_w_reg_data,
    input       wire[4:0]       ex_w_reg_addr,
    input       wire            ex_wd,
    //用于加载指令和存储指令访存
    input       wire[7:0]       ex_men_aluop_i,
    input       wire[31:0]      i_ex_men_inst_addr,
    input       wire[31:0]      i_ex_men_data_use,

//与men相连
    output      reg[31:0]       men_w_reg_data,
    output      reg[4:0]        men_w_reg_addr,
    output      reg             men_wd,
    //用于加载指令和存储指令访存
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