
module men (
    input      wire        rst,

//与ex_men相连
    input       wire[31:0]  i_w_reg_data,
    input       wire[4:0]   i_w_reg_addr,
    input       wire        i_wd,

    output      reg[31:0]   w_reg_data,
    output      reg[4:0]    w_reg_addr,
    output      reg         wd

);

always @ (*) begin
    if(rst) begin
        w_reg_data      <=      32'h0;
        w_reg_addr      <=      5'h0;
        wd              <=      1'b0;
    
    end
    else begin
       w_reg_data       <=      i_w_reg_data;
       w_reg_addr       <=      i_w_reg_addr;
       wd               <=      i_wd;
   
   end

end     
endmodule