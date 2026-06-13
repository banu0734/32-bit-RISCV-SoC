module soc_top(

input clk,
input rst,

input [7:0] sw,
input rx,

output [7:0] led,
output tx

);

//===================
// CPU-ROM
//===================

wire [31:0] pc;
wire [31:0] instruction;
wire [6:0] opcode;

wire [4:0] rd;
wire [4:0] rs1;
wire [4:0] rs2;

wire [2:0] funct3;
wire [6:0] funct7;
wire [31:0] immediate;

wire [31:0] read_data1;
wire [31:0] read_data2;

wire RegWrite;
wire ALUSrc;

wire [1:0] ALUOp;

wire [3:0] alu_ctrl;

wire [31:0] alu_result;

wire zero;

wire [31:0] mem_addr;
wire [31:0] mem_wdata;

wire [31:0] mem_rdata;

wire MemRead;
wire MemWrite;

riscv_cpu cpu0(

.clk(clk),
.rst(rst),

.instruction(instruction),

.pc(pc),

.opcode(opcode),

.rd(rd),
.rs1(rs1),
.rs2(rs2),

.funct3(funct3),
.funct7(funct7),

.immediate(immediate),

.read_data1(read_data1),
.read_data2(read_data2),

.RegWrite(RegWrite),

.ALUSrc(ALUSrc),

.ALUOp(ALUOp),

.alu_ctrl(alu_ctrl),

.alu_result(alu_result),

.zero(zero),

.mem_addr(mem_addr),
.mem_wdata(mem_wdata),

.mem_rdata(mem_rdata),

.MemRead(MemRead),

.MemWrite(MemWrite)

);
//===================
// BUS
//===================

wire rom_sel;
wire ram_sel;
wire gpio_sel;
wire uart_sel;
wire timer_sel;

bus bus0(
.addr(mem_addr),
.rom_sel(rom_sel),
.ram_sel(ram_sel),
.gpio_sel(gpio_sel),
.uart_sel(uart_sel),
.timer_sel(timer_sel)
);

//===================
// RAM
//===================


ram ram0(

.clk(clk),

.we(MemWrite),

.addr(mem_addr),

.wdata(mem_wdata),

.rdata(mem_rdata)

);

//===================
// GPIO
//===================

wire [31:0] gpio_rdata;

gpio gpio0(

.clk(clk),
.rst(rst),

.gpio_sel(gpio_sel),

.we(1'b0),
.re(1'b0),

.addr(32'b0),

.wdata(32'b0),

.rdata(gpio_rdata),

.sw(sw),

.led(led)

);

//===================
// UART
//===================

uart uart0(
.clk(clk),
.rst(rst),
.rx(rx),
.tx(tx)
);

//===================
// TIMER
//===================

wire tick;

timer timer0(
.clk(clk),
.rst(rst),
.tick(tick)
);

//===================
// ROM
//===================

rom rom0(

.addr(pc),

.instruction(instruction)

);
endmodule
