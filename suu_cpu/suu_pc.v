

module pc(
    input    wire           rst,
    input    wire           clk,
    input    wire[31:0]     offset,
    output   reg[31:0]     pc,
    output   reg           ce

);


always @ (posedge clk ) begin
    if(ce ==1'b0) begin
        pc <= 32'h0;
   end
   else begin
        pc <= pc + 4'h4 + offset ;
    end

end

	
	always @ (posedge clk) begin
		if (rst == 1'b1) begin
			ce <= 1'b0;
		end else begin
			ce <= 1'b1;
		end
	end

endmodule

	
