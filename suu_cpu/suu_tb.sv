`timescale 1ns / 1ps
module tb;

reg clk_50;
reg rst;


initial begin 
    clk_50 = 1'b0;
    forever #10 clk_50 = ~clk_50;
end
initial begin
    rst = 1'b1;
    #195 rst = 1'b0; 
    #1000 $stop;
end

sopc sopc1(
    .clk(clk_50),
    .rst(rst)
);


endmodule