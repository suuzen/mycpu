module sopc (
    input wire clk,
    input wire rst
);
    wire[31:0] inst_rom_addr;
    wire[31:0] inst;
    wire       rom_ce;

    wire[31:0]  inst_ram_addr;
    wire        ram_ce;
    wire        ram_we;
    wire[3:0]   ram_sel;
    wire[31:0]  inst_ram_data_i;
    wire[31:0]  inst_ram_data_o;
    
    cpu cpu0 (
        .clk(clk),
        .rst(rst),
        .rom_data_i(inst),
        .rom_addr_o(inst_rom_addr),
        .rom_ce(rom_ce),
        .ram_data_i(inst_ram_data_i),
        .ram_data_o(inst_ram_data_o),
        .ram_ce(ram_ce),
        .ram_we(ram_we),
        .ram_sel(ram_sel),
        .ram_addr_o(inst_ram_addr)
    );

    inst_rom inst_rom0 (
        .addr(inst_rom_addr),
        .ce(rom_ce),
        .inst(inst)
    );
    
    inst_ram inst_ram0 (
        .clk(clk),
        .ce(ram_ce),
        .we(ram_we),
        .addr(inst_ram_addr),
        .sel(ram_sel),
        .data_i(inst_ram_data_o),
        .data_o(inst_ram_data_i)
    );
endmodule