module inst_rom (
    input       wire            ce,
    input       wire[31:0]      addr,
    output      reg[31:0]       inst

);
    wire[31:0]  inst_men[0:131070];  //一行宽为32位，深度为2的17次方，即131070
    
    assign inst_men[0]=32'h34080001;  //32'h34011100;
    assign inst_men[1]=32'h34090002;  //32'h34020020;
    assign inst_men[2]=32'b00000001001010000101000000100010;  //32'h3403ff00;
    assign inst_men[3]=32'b10100000000010100000000000000100;  //32'h3404ffff;
  //  assign inst_men[4]=32'h35490000;  //32'h3404ffff;
  //  assign inst_men[5]=32'h1000FFFC;  //32'h3404ffff;
  //  assign inst_men[6]=32'h34000000;  //32'h3404ffff;
  

    always @ (*) begin
        if(ce == 0) begin
            inst <= 32'h0;
        end else begin
            inst <= inst_men[addr[18:2]]; //PC按字节寻址，PC=PC+4 对应一条指令要除以4，即右移两位,故这里0和1不用
        end
    end
    
endmodule
