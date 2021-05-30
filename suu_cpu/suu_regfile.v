
module regfile (
    input       wire            rst,
    input       wire            clk,
//与id相连(两个�?)
    input       wire[4:0]       r_addr_1,
    input       wire[4:0]       r_addr_2,
    input       wire            rd_1,
    input       wire            rd_2, 

    output      reg[31:0]      rdata_1,
    output      reg[31:0]      rdata_2, 

//与men_wb相连（一个写�?
    input       wire[31:0]      wdata,
    input       wire[4:0]       w_addr,
    input       wire            wd

);

//32位寄存器
reg[31:0] regs[0:31];
//写操�?
always @ (posedge clk)   begin
    if(( rst == 1'b0 )&&( wd == 1'b1 )&&( w_addr != 5'h0 )) begin
        regs[w_addr] = wdata;
    end
end

//读操�?1
always @ (*) begin
    if(rst == 1'b1) begin
		rdata_1 <= 32'h0;
    end else if( (rd_1 == 1'b1) && (r_addr_1 == 5'h0)) begin
        rdata_1 <= 32'h0;
    end else if( (rd_1 == 1'b1) && (r_addr_1 == w_addr) && (wd == 1'b1)) begin
        rdata_1 <= wdata;
    end  else if(rd_1 == 1'b1) begin
         rdata_1 <= regs[r_addr_1];
    end
    else begin
        rdata_1 = 32'h0;
    end
end

//读操�?2
always @ (*) begin
    if(rst == 1'b1) begin
		rdata_2 <= 32'h0;
    end else if( (rd_2 == 1'b1) && (r_addr_2 == 5'h0)) begin
        rdata_2 <= 32'h0;
    end else if((rd_2 == 1'b1) && (r_addr_2 == w_addr) && (wd == 1'b1)) begin
        rdata_2 <= wdata;
    end else if(rd_2 ==1'b1) begin
        rdata_2 <= regs[r_addr_2];
    end
    else begin
        rdata_2 = 32'h0;
    end 

end





endmodule