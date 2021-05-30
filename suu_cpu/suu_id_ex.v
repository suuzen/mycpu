

module id_ex(
    input       wire            rst,
    input       wire            clk,

// ��id����
    input       wire[7:0]       id_aluop,
  //input       wire[7:0]       id_alusel,
    input       wire[31:0]       id_rs_data,
    input       wire[31:0]       id_rt_data,
    input       wire[4:0]       id_w_reg_addr,
    input       wire            id_wd,
    input       wire            next_id_ex_inst_in_delayslot_i,  //��һ��ָ���Ƿ�Ϊ�ӳ�ָ���Ҫ������һ��ָ�������׶�
    input       wire            now_id_ex_inst_in_delayslot_i,   //������׶δ����ĵ�ǰ�׶��Ƿ�Ϊ�ӳٲ�,����ִ�н׶δ���

    output      reg[7:0]       ex_aluop,
  //output      reg[7:0]       ex_alusel,                           //�ӳٲ�ͳһ��ִ�н׶δ���
    output      reg[31:0]       ex_rs_data,
    output      reg[31:0]       ex_rt_data,
    output      reg[4:0]       ex_w_reg_addr,
    output      reg            ex_wd,
    output      reg            next_id_ex_inst_in_delaylot_o,    //��һ��ָ���Ƿ�Ϊ�ӳ�ָ�������һ��ָ�������׶�
    output      reg            now_id_ex_inst_in_delaylot_o
);

always @ ( posedge clk) begin
    if(rst) begin
        ex_aluop                            <=       8'h0;
        ex_rs_data                          <=       5'h0;
        ex_rt_data                          <=       5'h0;
        ex_w_reg_addr                       <=       5'h0;
        ex_wd                               <=       1'b0;
        next_id_ex_inst_in_delaylot_o       <=       1'h0;
        now_id_ex_inst_in_delaylot_o        <=       1'h0;

    end
    else begin
        ex_aluop                            <=      id_aluop;
        ex_rs_data                          <=      id_rs_data;          
        ex_rt_data                          <=      id_rt_data;      
        ex_w_reg_addr                       <=      id_w_reg_addr;
        ex_wd                               <=      id_wd;
        next_id_ex_inst_in_delaylot_o       <=      next_id_ex_inst_in_delayslot_i;
        now_id_ex_inst_in_delaylot_o        <=      now_id_ex_inst_in_delayslot_i;
    end

 end

endmodule