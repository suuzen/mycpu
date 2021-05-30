

module id (
    input   wire        rst,

//与if_id相连    
    input   wire[31:0]  pc_id,
    input   wire[31:0]  inst_id,

//与寄存器相连（从寄存器输入）    
    input   wire[31:0]  reg_data_1,
    input   wire[31:0]  reg_data_2,

//数据前推ex模块
    input   wire[31:0]  ex_data,     //ex要写入某个寄存器的数�??
    input   wire        ex_wd_i,     //ex是否要写入数�??
    input   wire[4:0]   ex_addr_i,   //ex待写入的寄存器的地址
//数据前推men模块
    input   wire[31:0]  men_data,    //men要写入某个寄存器的数�??
    input   wire        men_wd_i,    //men是否要写入数�??
    input   wire[4:0]   men_addr_i,  //men待写入的寄存器的地址

//与id_ex相连模块  用于判断由上�?条指令的id_ex阶段传来的本条指令是否为延迟槽指�?
    input   wire        now_inst_in_delayslot_i,

//与id/ex 连接
    output  reg[7:0]    aluop,          // 用以区别不同指令
  //output  wire[7:0]   alusel,        指令类型
    output  reg[31:0]    rs_data,       //源操作数1 
    output  reg[31:0]    rt_data,       //源操作数2
    output  reg[4:0]    w_reg_addr,    //写地�???
    output  reg         wd,            //是否�???
    output  reg         next_inst_in_delayslot_o,  //用于判断下一条指令是否为延迟槽指�?
    output  reg         now_inst_in_delayslot_o,  //输出 now_inst_in_delayslot_i 给执行阶段判断本条指令是否为延迟槽指�?

 //与寄存器连接（输出给寄存器）
    output  reg[4:0]    reg_addr_1,    //寄存器地�???1
    output  reg[4:0]    reg_addr_2,    //寄存器地�???2
    output  reg         reg_rd_1,      //是否 读地�???1      
    output  reg         reg_rd_2,      //是否 读地�???2  

//与PC相连
    output  reg         branch_flag_o,            //是否转移指令pc改变
    output  reg[31:0]   branch_target_address_o
);

 reg[31:0] imm_1;    //源操作数rs的立即数
 reg[31:0] imm_2;    //源操作数rt的立即数

wire[31:0] imm_sll2_signedext;  //实现转移指令的移�?
wire[31:0] pc_id_4;

assign imm_sll2_signedext = {{14{inst_id[15]}}, inst_id[15:0], 2'b00 };  //指令中的offset左移两位再符号扩展至32�?

assign pc_id_4 = pc_id + 4;  //延迟槽指令的PC

always @ (*) begin
    if(rst) begin
        aluop           <=    8'h0;   
        w_reg_addr      <=    5'h0;  
        wd              <=    1'h0;  
        reg_addr_1      <=    5'h0;  
        reg_addr_2      <=    5'h0;  
        reg_rd_1        <=    1'h0;  
        reg_rd_2        <=    1'h0;  
        imm_1           <=    32'h0;
        imm_2           <=    32'h0;
        branch_flag_o   <=    1'h0;
        branch_target_address_o <= 32'h0;
        next_inst_in_delayslot_o    <= 1'h0;

    end
    if(inst_id[31:26]==6'h0 && inst_id[10:0]==11'h21) begin //addu
        aluop     <= { 2'h0,inst_id[5:0] };
        reg_addr_1<= inst_id[25:21];
        reg_addr_2<= inst_id[20:16];
        reg_rd_1  <= 1'b1;
        reg_rd_2  <= 1'b1;
        w_reg_addr<= inst_id[15:11]; // the address of register to be written
        wd        <= 1'b1;
        branch_target_address_o <= 32'h0;
        next_inst_in_delayslot_o    <= 1'h0;
        branch_flag_o   <=    1'h0;

    end else if(inst_id[31:26]==6'hd) begin //ori
        aluop     <= { 2'h0,inst_id[31:26] };
        reg_addr_1<= inst_id[25:21];
        reg_addr_2<= inst_id[20:16];
        reg_rd_1  <= 1'b1;
        reg_rd_2  <= 1'b0;                                  // reg_rd_1�?? reg_red_2  �??0时表示使用立即数
        imm_2     <= {16'h0, inst_id[15:0]};
        w_reg_addr<= inst_id[20:16]; // the address of register to be written
        wd        <= 1'b1;
        branch_target_address_o <= 32'h0;
        next_inst_in_delayslot_o    <= 1'h0;
        branch_flag_o   <=    1'h0;

    end else if(inst_id[31:26]==6'h4) begin //beq
        aluop     <= { 2'h0,inst_id[31:26] };
        reg_addr_1<= inst_id[25:21];
        reg_addr_2<= inst_id[20:16];
        reg_rd_1  <= 1'b0;
        reg_rd_2  <= 1'b0;
        imm_1     <= 32'h0; 
        imm_2     <= 32'h0; 
        w_reg_addr<= 5'h0; //not used
        wd        <= 1'b0;
        if(rt_data == rs_data) begin//branch on equal
            branch_target_address_o     <= pc_id_4 + imm_sll2_signedext;
            branch_flag_o               <= 1'h1;
            next_inst_in_delayslot_o    <= 1'h1;
        end
//add new
    end else if(inst_id[31:26]==6'h0 && inst_id[10:0]==11'h24) begin //and
        aluop     <= { 2'h0,inst_id[5:0] };
        reg_addr_1<= inst_id[25:21];
        reg_addr_2<= inst_id[20:16];
        reg_rd_1  <= 1'b1;
        reg_rd_2  <= 1'b1;
        w_reg_addr<= inst_id[15:11]; // the address of register to be written
        wd        <= 1'b1;
        branch_target_address_o <= 32'h0;
        next_inst_in_delayslot_o    <= 1'h0;
        branch_flag_o   <=    1'h0;

    end else if(inst_id[31:26]==6'h0 && inst_id[10:0]==11'h25) begin //or
        aluop     <= { 2'h0,inst_id[5:0] };
        reg_addr_1<= inst_id[25:21];
        reg_addr_2<= inst_id[20:16];
        reg_rd_1  <= 1'b1;
        reg_rd_2  <= 1'b1;
        w_reg_addr<= inst_id[15:11]; // the address of register to be written
        wd        <= 1'b1;
        branch_target_address_o <= 32'h0;
        next_inst_in_delayslot_o    <= 1'h0;
        branch_flag_o   <=    1'h0;

    end else if(inst_id[31:26]==6'h0 && inst_id[10:0]==11'h26) begin //xor (异或)
        aluop     <= { 2'h0,inst_id[5:0] };
        reg_addr_1<= inst_id[25:21];
        reg_addr_2<= inst_id[20:16];
        reg_rd_1  <= 1'b1;
        reg_rd_2  <= 1'b1; 
        w_reg_addr<= inst_id[15:11]; // the address of register to be written
        wd        <= 1'b1;
        branch_target_address_o <= 32'h0;
        next_inst_in_delayslot_o    <= 1'h0;
        branch_flag_o   <=    1'h0;

    end else if(inst_id[31:21]==11'h1e0) begin //lui (立即数加载到寄存器高�???)
        aluop            <= { 2'h0,inst_id[31:26] };
        reg_addr_1       <= inst_id[25:21];
        reg_addr_2       <= inst_id[20:16];
        reg_rd_1         <= 1'b0;
        reg_rd_2         <= 1'b0;
        imm_1            <= 32'h0;
        imm_2            <= {inst_id[15:0],16'h0};    //�???终数
        w_reg_addr       <= inst_id[20:16]; // the address of register to be written
        wd               <= 1'b1;
        branch_target_address_o <= 32'h0;
        next_inst_in_delayslot_o    <= 1'h0;
        branch_flag_o   <=    1'h0;

    end else if(inst_id[31:21]==11'h0 && inst_id[5:0]==6'h0) begin //sll (逻辑左移)
        aluop            <= { 2'h0,inst_id[5:0] };
        reg_addr_1       <= inst_id[25:21];
        reg_addr_2       <= inst_id[20:16];
        reg_rd_1         <= 1'b0;
        reg_rd_2         <= 1'b1;
        imm_1            <= inst_id[10:6];
        w_reg_addr       <= inst_id[15:11];   // the address of register to be written
        wd               <= 1'b1;
        branch_target_address_o <= 32'h0;
        next_inst_in_delayslot_o    <= 1'h0;
        branch_flag_o   <=    1'h0;
        
        end  
    end
                //aluop 用于后面执行时区分不同的指令

    //给操作数rs和rt赋�?�（分为数据前推、访存�?�立即数，访存和立即数�?�过reg_rd_1和reg_rd_2判断�??
    always @ (*) begin
        if( rst ) begin
            rs_data   <=   32'h0;
        end else if( reg_rd_1 == 1'b1 && ex_wd_i == 1'b1 && reg_addr_1 == ex_addr_i ) begin
            rs_data   <=   ex_data;        
        end else if( reg_rd_1 == 1'b1 && men_wd_i == 1'b1 && reg_addr_1 == men_addr_i ) begin
            rs_data   <=   men_data; 
        end else if( reg_rd_1 == 1'b1) begin
            rs_data   <=   reg_data_1;
        end else if( reg_rd_1 == 1'b0) begin
            rs_data   <=   imm_1;
        end else  begin
            rs_data   <=   32'h0;
        end
    end

    always @ (*) begin
        if( rst ) begin
            rt_data   <=   32'h0;
        end else if( reg_rd_2 == 1'b1 && ex_wd_i == 1'b1 && reg_addr_2 == ex_addr_i ) begin
            rt_data   <=   ex_data;        
        end else if( reg_rd_2 == 1'b1 && men_wd_i == 1'b1 && reg_addr_2 == men_addr_i ) begin
            rt_data   <=   men_data; 
        end else if( reg_rd_2 == 1'b1) begin
            rt_data   <=   reg_data_2;
        end else if( reg_rd_2 == 1'b0) begin
            rt_data   <=   imm_2;
        end else  begin
            rt_data   <=   32'h0;
           end
    end

    //用于传�?�当前指令是否为延迟槽指�?
    always @ (*) begin
        if( rst ) begin
            now_inst_in_delayslot_o     <= 1'h0;
        end
        else begin
                    now_inst_in_delayslot_o     <=  now_inst_in_delayslot_i;
        end
    end
endmodule