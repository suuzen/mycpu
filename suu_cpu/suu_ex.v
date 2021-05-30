
module ex (
    input       wire            rst,
    
//与id_ex相连    
    input       wire[7:0]       i_ex_aluop,
    input       wire[31:0]       i_ex_rs_data,
    input       wire[31:0]       i_ex_rt_data,
    input       wire[4:0]       i_ex_w_reg_addr,
    input       wire            i_ex_wd,

//与ex_men相连
    output      reg[31:0]       w_reg_data,
    output      reg[4:0]        w_reg_addr,
    output      reg             wd       

);

always @ (*) begin
    if(rst) begin
        w_reg_data      <=      32'h0;
        w_reg_addr      <=      5'h0;
        wd              <=      1'b0;
    end 
    else begin               // addu, ori, beq, and, or, xor, lui, sll
        case( i_ex_aluop )
            8'b00100001:    w_reg_data <=  i_ex_rs_data + i_ex_rt_data;           //addu
            8'b00001101:    w_reg_data <=  i_ex_rs_data | i_ex_rt_data;           //ori
      //    8'b00000100:    w_reg_data <=                                         //beq(不用)
            8'b00100100:    w_reg_data <=  i_ex_rs_data & i_ex_rt_data;           //and
            8'b00100101:    w_reg_data <=  i_ex_rs_data | i_ex_rt_data;           //or
            8'b00100110:    w_reg_data <=  i_ex_rs_data ^ i_ex_rt_data;           //xor
            8'b00001111:    w_reg_data <=  i_ex_rt_data;                          //lui
            8'b00000000:    w_reg_data <=  i_ex_rt_data << i_ex_rs_data;          //sll

        endcase
        wd          <=      i_ex_wd;
        w_reg_addr  <=      i_ex_w_reg_addr;
    
    end
 end

endmodule