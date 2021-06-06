
module men (
    input      wire        rst,

//与ex_men相连
    input       wire[31:0]  i_w_reg_data,
    input       wire[4:0]   i_w_reg_addr,
    input       wire        i_wd,
    //用于加载指令和存储指令访存
    input       wire[7:0]   i_men_aluop,
    input       wire[31:0]  i_men_inst_addr,
    input       wire[31:0]  i_men_data_use,
//与RAM相连，获得访存数据
    input       wire[31:0]  men_data_i,     //从存储器中取出的数据

//与寄存器相连
    output      reg[31:0]   w_reg_data,
    output      reg[4:0]    w_reg_addr,
    output      reg         wd,

    //用于与存储器连接
    output      reg         men_ce_o,   //判断是否访问存储器
    output      reg         men_we_o,   //判断是加载指令还是存储指令
    output      reg[3:0]    men_sel_o,  //选取需要的字节（用于半字、字和字节的选取）
    output      reg[31:0]   o_men_inst_addr,    //访问存储器的地址
    output      reg[31:0]   men_data_o          //待写入存储器的数据

);

always @ (*) begin
    if(rst) begin
        w_reg_data      <=      32'h0;
        w_reg_addr      <=      5'h0;
        wd              <=      1'b0;
        men_ce_o        <=      1'b0;
        men_we_o        <=      1'b0;
        men_sel_o       <=      4'h0;
        o_men_inst_addr <=      32'h0;
        men_data_o      <=      32'h0;

    end
    else begin
       w_reg_data       <=      i_w_reg_data;
       w_reg_addr       <=      i_w_reg_addr;
       wd               <=      i_wd;
       case(i_men_aluop)
            8'b00101000: begin  //sb
                men_ce_o                <=  1'b1;
                men_we_o                <=  1'b1;
                o_men_inst_addr         <=  i_men_inst_addr;
                men_data_o              <=  { i_men_data_use[7:0],i_men_data_use[7:0],i_men_data_use[7:0],i_men_data_use[7:0] };
                //sb指令只要最小字节的数据
                case(i_men_inst_addr[1:0])   //00  01  10   11  小端模式下小的数对应小地址，所以11对应最大地址，men_sel_o 从左向右对应的地址由高到底
                    2'b00:  begin
                        men_sel_o       <=  4'b0001;    //00时最小所以选择位置最小的右边一位
                    end
                    2'b01:  begin
                        men_sel_o       <=  4'b0010;
                    end
                    2'b10:  begin
                        men_sel_o       <=  4'b0100;
                    end 
                    2'b11:  begin
                        men_sel_o       <=  4'b1000;
                    end
                    default:    begin
                        men_sel_o       <=  4'b0000;
                    end
                endcase
            end
            8'b00100000: begin  //lb
                men_ce_o                <=  1'b1;
                men_we_o                <=  1'b0;
                o_men_inst_addr         <=  i_men_inst_addr;
                //
                case(i_men_inst_addr[1:0])   //00  01  10   11  小端模式下小的数对应小地址，所以11对应最大地址，men_sel_o 从左向右对应的地址由高到底
                    2'b00:  begin
                        w_reg_data      <=  { { 24{men_data_i[7]} },men_data_i[7:0]};
                        men_sel_o       <=  4'b0001;    //00时最小所以选择位置最小的右边一位
                    end
                    2'b01:  begin
                        w_reg_data      <=  { { 24{men_data_i[15]} },men_data_i[15:8]};
                        men_sel_o       <=  4'b0010;
                    end
                    2'b10:  begin
                        w_reg_data      <=  { { 24{men_data_i[23]} },men_data_i[23:16]};
                        men_sel_o       <=  4'b0100;
                    end 
                    2'b11:  begin
                        w_reg_data      <=  { { 24{men_data_i[31]} },men_data_i[31:24]};
                        men_sel_o       <=  4'b1000;
                    end
                    default:    begin
                        w_reg_data      <=  32'h0;
                        men_sel_o       <=  4'b0000;
                    end
                endcase
            end
            8'b00100011: begin    //lw
                men_ce_o                <=  1'b1;
                men_we_o                <=  1'b0;
                o_men_inst_addr         <=  i_men_inst_addr;
                w_reg_data              <=  men_data_i;
                men_sel_o               <=  4'b1111;    
            end
            8'b00101011: begin   //sw
                men_ce_o                <=  1'b1;
                men_we_o                <=  1'b1;
                o_men_inst_addr         <=  i_men_inst_addr;
                men_data_o              <=  i_men_data_use;
                men_sel_o               <=  4'b1111;    
            end
           default: begin
                men_ce_o        <=      1'b0;
                men_we_o        <=      1'b0;
                men_sel_o       <=      4'h0;
                o_men_inst_addr         <=  i_men_inst_addr;
                men_data_o      <=      32'h0;
           end      
       endcase
   end

end     
endmodule