module inst_rom (
    input       wire            ce,
    input       wire[31:0]      addr,
    output      reg[31:0]       inst

);
    wire[31:0]  inst_men[0:131070];  //һ�п�Ϊ32λ�����Ϊ2��17�η�����131070
    
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
            inst <= inst_men[addr[18:2]]; //PC���ֽ�Ѱַ��PC=PC+4 ��Ӧһ��ָ��Ҫ����4����������λ,������0��1����
        end
    end
    
endmodule
