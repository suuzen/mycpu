
module ex (
    input       wire            rst,
    
//与id_ex相连
    input       wire[7:0]       i_ex_aluop,
    input       wire[31:0]       i_ex_rs_data,
    input       wire[31:0]       i_ex_rt_data,
    input       wire[4:0]       i_ex_w_reg_addr,
    input       wire            i_ex_wd,
    input       wire            ex_inst_in_delayslot,  ////处理该条指令是否为延迟槽指令
    input       wire[31:0]      ex_inst,  //加载时用于获取加载数进行操作

//与ex_men相连
    output      reg[31:0]       w_reg_data,
    output      reg[4:0]        w_reg_addr,
    output      reg             wd,       
//用于加载，存储指令(传递给访存阶段)
    output      wire[7:0]       o_ex_aluop,  //用于访存阶段判断加载和存储指令
    output      wire[31:0]      men_inst_addr,  //访问内存的地址
    output      wire[31:0]      men_data_use   //访存时存储指令存储的数据或加载指令加载的目的寄存器
);

assign  o_ex_aluop      =   i_ex_aluop;
assign  men_inst_addr   =   i_ex_rs_data +{{16{ex_inst[15]}},ex_inst[15:0]};    //得到存储指令和加载指令所需的存储地址
assign  men_data_use    =   i_ex_rt_data;   //存储指令需要存储的某寄存器中的内容

wire[31:0]  buma    =   (~i_ex_rt_data)+1;
always @ (*) begin
    if(rst) begin
        w_reg_data      <=      32'h0;
        w_reg_addr      <=      5'h0;
        wd              <=      1'b0;
    end 
    else if( ex_inst_in_delayslot == 1'b1) begin
        w_reg_data      <=      32'h0;
        w_reg_addr      <=      5'h0;
        wd              <=      1'b0;
    end
    else begin               // addu, ori, beq, and, or, xor, lui, sll
        case( i_ex_aluop )
            8'b00100001:    w_reg_data <=  i_ex_rs_data + i_ex_rt_data;           //addu
            8'b00100010:    w_reg_data <=  i_ex_rs_data + buma;                  //sub
            8'b00001001:    w_reg_data <=  i_ex_rs_data + i_ex_rt_data;          //addiu
            8'b00001100:    w_reg_data <=  i_ex_rs_data & i_ex_rt_data;           //andi
            8'b00001101:    w_reg_data <=  i_ex_rs_data | i_ex_rt_data;           //ori
      //    8'b00000100:    w_reg_data <=                                         //beq(没用到)
      //    8'b00000101:    w_reg_data <=                                         //bne(没用到)
      //    8'b00000001:    w_reg_data <=                                         //bgez(没用到)
            8'b00100100:    w_reg_data <=  i_ex_rs_data & i_ex_rt_data;           //and
            8'b00100101:    w_reg_data <=  i_ex_rs_data | i_ex_rt_data;           //or
            8'b00100110:    w_reg_data <=  i_ex_rs_data ^ i_ex_rt_data;           //xor
            8'b00001111:    w_reg_data <=  i_ex_rt_data;                          //lui
            8'b00000000:    w_reg_data <=  i_ex_rt_data << i_ex_rs_data[4:0];     //sll
            8'b00000001:    w_reg_data <=  i_ex_rt_data >> i_ex_rs_data[4:0];     //srlv
            8'b00101000:    w_reg_data <=  32'h0;                                 //sb(也没用到)
            8'b00100000:    w_reg_data <=  32'h0;                                 //lb(此处还未访存，无法得出待写入寄存器的数)
            8'b00100011:    w_reg_data <=  32'h0;                                 //lw(此处还未访存，无法得出待写入寄存器的数) 
            8'b00101011:    w_reg_data <=  32'h0;                                 //sw(没用到) 
            default:    begin
                
            end
        endcase
        wd          <=      i_ex_wd;
        w_reg_addr  <=      i_ex_w_reg_addr;
    
    end
 end

endmodule