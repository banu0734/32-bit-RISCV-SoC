`timescale 1ns/1ps

module cpu_tb;

//====================================
// Inputs
//====================================

reg clk;
reg rst;

//====================================
// CPU Outputs
//====================================

wire [31:0] pc;
wire [31:0] instruction;

// Decoder

wire [6:0] opcode;

wire [4:0] rd;
wire [4:0] rs1;
wire [4:0] rs2;

wire [2:0] funct3;
wire [6:0] funct7;

// Immediate

wire [31:0] immediate;

// Register File

wire [31:0] read_data1;
wire [31:0] read_data2;

// Control Unit

wire RegWrite;
wire ALUSrc;

wire [1:0] ALUOp;

// ALU Control

wire [3:0] alu_ctrl;

// ALU

wire [31:0] alu_result;
wire zero;

// RAM
wire        MemWrite;
wire        MemRead;

wire [31:0] mem_addr;
wire [31:0] mem_wdata;
wire [31:0] mem_rdata;

//====================================
// CPU
//====================================

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

//====================================
// ROM
//====================================

rom rom0(

.addr(pc),

.instruction(instruction)

);

ram ram0(

.clk(clk),

.we(MemWrite),

.addr(mem_addr),

.wdata(mem_wdata),

.rdata(mem_rdata)

);
//====================================
// Clock Generation
//====================================

always #5 clk = ~clk;

//====================================
// Stimulus
//====================================

initial
begin

clk = 0;
rst = 1;

#20;

rst = 0;

#50;

$finish;

end

endmodule
