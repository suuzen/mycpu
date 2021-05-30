

module id_ex(
    input       wire            rst,
    input       wire            clk,

//与id相连
    input       wire[7:0]       id_aluop,
  //input       wire[7:0]       id_alusel,
    input       wire[31:0]       id_rs_data,
    input       wire[31:0]       id_rt_data,
    input       wire[4:0]       id_w_reg_addr,
    input       wire            id_wd,

    output      reg[7:0]       ex_aluop,
  //output      reg[7:0]       ex_alusel,
    output      reg[31:0]       ex_rs_data,
    output      reg[31:0]       ex_rt_data,
    output      reg[4:0]       ex_w_reg_addr,
    output      reg            ex_wd

);

always @ ( posedge clk) begin
    if(rst) begin
        ex_aluop        <=       8'h0;
        ex_rs_data      <=       5'h0;
        ex_rt_data      <=       5'h0;
        ex_w_reg_addr   <=       5'h0;
        ex_wd           <=       1'b0;
    end
    else begin
        ex_aluop        <=      id_aluop;
        ex_rs_data      <=      id_rs_data;          
        ex_rt_data      <=      id_rt_data;      
        ex_w_reg_addr   <=      id_w_reg_addr;
        ex_wd           <=      id_wd;
    end

 end

endmodule