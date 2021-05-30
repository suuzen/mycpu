
module cpu (
    input       wire            clk,
    input       wire            rst,

//与指令存储器相连
    input       wire[31:0]      rom_data_i,     

    output      wire             rom_ce,      //片�??
    output      wire[31:0]       rom_addr_o  //欲从指令寄存器取出的地址

);


assign rom_ce =rom_ce_1;
//pc
wire[31:0]  pc;

//if_id
wire[31:0]  id_pc;
wire[31:0]  id_inst;

//id
wire[7:0]   aluop;
wire[31:0]   rs_data;
wire[31:0]   rt_data;
wire[4:0]   w_reg_addr_1;
wire        wd;

wire[4:0]   reg_addr_1;
wire[4:0]   reg_addr_2;
wire        reg_rd_1;
wire        reg_rd_2;
wire        next_inst_in_delayslot_1;
wire        now_inst_in_delayslot_1;
//用于分支预测改变PC
wire[31:0]  branch_offset;
wire        branch_flag;

//regfile
wire[31:0]  rdata_1;
wire[31:0]  rdata_2;

//id_ex
wire[7:0]   ex_aluop;
wire[31:0]   ex_rs_data;
wire[31:0]   ex_rt_data;
wire[4:0]   ex_w_reg_addr;
wire        ex_wd;
wire        next_inst_in_delayslot_2;
wire        now_inst_in_delayslot_2;

//ex
wire[31:0]  w_reg_data_1;
wire[4:0]   w_reg_addr_2;
wire        wd_1;

//ex_men
wire[31:0]  men_w_reg_data;
wire[4:0]   men_w_reg_addr;
wire        men_wd;

//men
wire[31:0]  w_reg_data_2;
wire[4:0]   w_reg_addr_3;
wire        wd_2;

//men_wb
wire[31:0]  wdata;
wire[4:0]   addr;
wire        wd_3;


//例化PC
pc pc0 (
    .rst(rst),
    .clk(clk),
    .branch_flag_i(branch_flag),
    .branch_target_address_i(branch_offset),
    .pc(pc),
    .ce(rom_ce_1)
);

assign rom_addr_o = pc;


//例化if_id
if_id if_id(
    .rst(rst),
    .clk(clk),
    .if_pc(pc),
    .if_inst(rom_data_i),
    .id_pc(id_pc),
    .id_inst(id_inst)
);
//例化id
id id1(
    .rst(rst),
    .pc_id(id_pc),
    .inst_id(id_inst),

    .reg_data_1(rdata_1),
    .reg_data_2(rdata_2),
    
    //数据前推
    .ex_data(w_reg_data_1),
    .ex_wd_i(wd_1),
    .ex_addr_i(w_reg_addr_2),
    .men_data(w_reg_data_2),
    .men_wd_i(wd_2),
    .men_addr_i(w_reg_addr_3),

    .now_inst_in_delayslot_i(next_inst_in_delayslot_2),

    .aluop(aluop),
    .rs_data(rs_data),
    .rt_data(rt_data),
    .w_reg_addr(w_reg_addr_1),
    .wd(wd),
    .next_inst_in_delayslot_o(next_inst_in_delayslot_1),
    .now_inst_in_delayslot_o(now_inst_in_delayslot_1),

    .reg_addr_1(reg_addr_1),
    .reg_addr_2(reg_addr_2),
    .reg_rd_1(reg_rd_1),
    .reg_rd_2(reg_rd_2),

    .branch_flag_o(branch_flag),
    .branch_target_address_o(branch_offset)

);
//例化regfile
regfile regfile1(
    .rst(rst),
    .clk(clk),

    .r_addr_1(reg_addr_1),
    .r_addr_2(reg_addr_2),
    .rd_1(reg_rd_1),
    .rd_2(reg_rd_2),

    .rdata_1(rdata_1),
    .rdata_2(rdata_2),

    .wdata(wdata),
    .w_addr(addr),
    .wd(wd_3)

);
//例化id_ex
id_ex id_ex1(
    .rst(rst),
    .clk(clk),

    .id_aluop(aluop),
    .id_rs_data(rs_data),
    .id_rt_data(rt_data),
    .id_w_reg_addr(w_reg_addr_1),
    .id_wd(wd),
    .next_id_ex_inst_in_delayslot_i(next_inst_in_delayslot_1),
    .now_id_ex_inst_in_delayslot_i(now_inst_in_delayslot_1),

    .ex_aluop(ex_aluop),
    .ex_rs_data(ex_rs_data),
    .ex_rt_data(ex_rt_data),
    .ex_w_reg_addr(ex_w_reg_addr),
    .ex_wd(ex_wd),
    .next_id_ex_inst_in_delaylot_o(next_inst_in_delayslot_2),
    .now_id_ex_inst_in_delaylot_o(now_inst_in_delayslot_2)

);
//例化ex
ex ex1(
    .rst(rst),
    .i_ex_aluop(ex_aluop),
    .i_ex_rs_data(ex_rs_data),
    .i_ex_rt_data(ex_rt_data),
    .i_ex_w_reg_addr(ex_w_reg_addr),
    .i_ex_wd(ex_wd),
    .ex_inst_in_delayslot(now_inst_in_delayslot_2),
    
    .w_reg_data(w_reg_data_1),
    .w_reg_addr(w_reg_addr_2),
    .wd(wd_1)
   
);
//例化ex_men
ex_men ex_men1(
    .rst(rst),
    .clk(clk),

    .ex_w_reg_data(w_reg_data_1),
    .ex_w_reg_addr(w_reg_addr_2),
    .ex_wd(wd_1),

    .men_w_reg_data(men_w_reg_data),
    .men_w_reg_addr(men_w_reg_addr),
    .men_wd(men_wd)

);
//例化men
men men1(
    .rst(rst),
    .i_w_reg_data(men_w_reg_data),
    .i_w_reg_addr(men_w_reg_addr),
    .i_wd(men_wd),

    .w_reg_data(w_reg_data_2),
    .w_reg_addr(w_reg_addr_3),
    .wd(wd_2)

);
//例化men_wb
men_wb men_wb1(
    .rst(rst),
    .clk(clk),

    .men_wdata(w_reg_data_2),
    .men_addr(w_reg_addr_3),
    .men_wd(wd_2),

    .wdata(wdata),
    .addr(addr),
    .wd(wd_3)
);

endmodule
