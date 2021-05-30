
module men_wb (
    input       wire        rst,
    input       wire        clk,

//与men相连
    input       wire[31:0]        men_wdata,
    input       wire[4:0]         men_addr,
    input       wire              men_wd,

//与regfile相连
    output      reg[31:0]         wdata,
    output      reg[4:0]          addr,
    output      reg               wd

);
    
always @ ( posedge clk) begin
    if( rst ) begin
        wdata       <=      32'h0;
        addr        <=      5'h0;
        wd          <=      1'b0;
    end
    else begin
        wdata       <=      men_wdata;
        addr        <=      men_addr;
        wd          <=      men_wd;
    end

end 

endmodule