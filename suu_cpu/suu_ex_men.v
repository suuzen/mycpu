
module ex_men (
    input       wire            rst,
    input       wire            clk,

//与ex相连
    input       wire[31:0]      ex_w_reg_data,
    input       wire[4:0]       ex_w_reg_addr,
    input       wire            ex_wd,

//与men相连
    output      reg[31:0]       men_w_reg_data,
    output      reg[4:0]        men_w_reg_addr,
    output      reg             men_wd

);

always @ ( posedge clk) begin
    if(rst) begin
        men_w_reg_data      <=      32'h0;
        men_w_reg_addr      <=      5'h0;
        men_wd              <=      1'b0;
    
    end
    else begin
       men_w_reg_data       <=      ex_w_reg_data;
       men_w_reg_addr       <=      ex_w_reg_addr;
       men_wd               <=      ex_wd;
   
   end

end    

endmodule