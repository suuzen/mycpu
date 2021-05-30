module sopc (
    input wire clk,
    input wire rst
);
    wire[31:0] inst_addr;
    wire[31:0] inst;
    wire       rom_ce;

    cpu cpu0 (
        .clk(clk),
        .rst(rst),
        .rom_data_i(inst),
        .rom_addr_o(inst_addr),
        .rom_ce(rom_ce)
    );

    inst_rom inst_rom0 (
        .addr(inst_addr),
        .ce(rom_ce),
        .inst(inst)
    );
endmodule