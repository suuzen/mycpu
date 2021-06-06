
module cpu (
    input       wire            clk,
    input       wire            rst,

//与指令存储器相连
    input       wire[31:0]      rom_data_i,     

    output      wire             rom_ce,      //片选
    output      wire[31:0]       rom_addr_o,  //欲从指令寄存器取出的地址
//与数据存储器相连，未写统一编址
    input       wire[31:0]      ram_data_i,
    output      wire[31:0]      ram_data_o,
    output      wire            ram_ce,
    output      wire            ram_we,
    output      wire[3:0]       ram_sel,  
    output      wire[31:0]      ram_addr_o
);


assign rom_ce =rom_ce_1;
assign rom_addr_o = pc;

assign  ram_ce  =   men_ce_lh;
assign  ram_we  =   men_we_lh;
assign  ram_sel =   men_sel_lh;
assign  ram_addr_o =o_men_inst_addr_lh;
assign  ram_data_o =men_data_lh; 
//pc
wire[31:0]  pc;
wire        rom_ce_1;  

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
wire[31:0]  id_inst_lh;

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
wire[31:0]  id_ex_inst_lh;

//ex
wire[31:0]  w_reg_data_1;
wire[4:0]   w_reg_addr_2;
wire        wd_1;
wire[7:0]   o_ex_aluop_lh;
wire[31:0]  men_inst_addr_lh;
wire[31:0]  men_data_use_lh;

//ex_men
wire[31:0]  men_w_reg_data;
wire[4:0]   men_w_reg_addr;
wire        men_wd;
wire[7:0]   ex_men_aluop_lh;
wire[31:0]  ex_men_inst_addr_lh;
wire[31:0]  ex_men_data_use_lh;

//men
wire[31:0]  w_reg_data_2;
wire[4:0]   w_reg_addr_3;
wire        wd_2;
wire        men_ce_lh;
wire        men_we_lh;
wire[3:0]   men_sel_lh;
wire[31:0]  o_men_inst_addr_lh;
wire[31:0]  men_data_lh;

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

    .inst_o(id_inst_lh),

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
    .id_inst_i(id_inst_lh),

    .ex_aluop(ex_aluop),
    .ex_rs_data(ex_rs_data),
    .ex_rt_data(ex_rt_data),
    .ex_w_reg_addr(ex_w_reg_addr),
    .ex_wd(ex_wd),
    .next_id_ex_inst_in_delaylot_o(next_inst_in_delayslot_2),
    .now_id_ex_inst_in_delaylot_o(now_inst_in_delayslot_2),
    .id_inst_o(id_ex_inst_lh)

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
    .ex_inst(id_ex_inst_lh),

    .w_reg_data(w_reg_data_1),
    .w_reg_addr(w_reg_addr_2),
    .wd(wd_1),

    .o_ex_aluop(o_ex_aluop_lh),
    .men_inst_addr(men_inst_addr_lh),
    .men_data_use(men_data_use_lh)
   
);
//例化ex_men
ex_men ex_men1(
    .rst(rst),
    .clk(clk),

    .ex_w_reg_data(w_reg_data_1),
    .ex_w_reg_addr(w_reg_addr_2),
    .ex_wd(wd_1),

    .ex_men_aluop_i(o_ex_aluop_lh),
    .i_ex_men_inst_addr(men_inst_addr_lh),
    .i_ex_men_data_use(men_data_use_lh),

    .men_w_reg_data(men_w_reg_data),
    .men_w_reg_addr(men_w_reg_addr),
    .men_wd(men_wd),

    .ex_men_aluop_o(ex_men_aluop_lh),
    .o_ex_men_inst_addr(ex_men_inst_addr_lh),
    .o_ex_men_data_use(ex_men_data_use_lh)

);
//例化men
men men1(
    .rst(rst),
    .i_w_reg_data(men_w_reg_data),
    .i_w_reg_addr(men_w_reg_addr),
    .i_wd(men_wd),
    .i_men_aluop(ex_men_aluop_lh),
    .i_men_inst_addr(ex_men_inst_addr_lh),
    .i_men_data_use(ex_men_data_use_lh),

    .men_data_i(ram_data_i),

    .w_reg_data(w_reg_data_2),
    .w_reg_addr(w_reg_addr_3),
    .wd(wd_2),

    .men_ce_o(men_ce_lh),
    .men_we_o(men_we_lh),
    .men_sel_o(men_sel_lh),
    .o_men_inst_addr(o_men_inst_addr_lh),
    .men_data_o(men_data_lh)

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
