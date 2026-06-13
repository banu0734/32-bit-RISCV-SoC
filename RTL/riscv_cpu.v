module riscv_cpu(

input clk,
input rst,

input [31:0] instruction,

output reg [31:0] pc,

output [6:0] opcode,
output [4:0] rd,
output [4:0] rs1,
output [4:0] rs2,
output [2:0] funct3,
output [6:0] funct7,

output [31:0] immediate,

output [31:0] read_data1,
output [31:0] read_data2,

output RegWrite,
output ALUSrc,
output [1:0] ALUOp,

output [3:0] alu_ctrl,

output [31:0] alu_result,

output zero,

output [31:0] mem_addr,
output [31:0] mem_wdata,

input [31:0] mem_rdata,

output MemRead,
output MemWrite
);

//===========================
// Internal Wires
//===========================

wire [31:0] immediate_i;

wire RegWrite_i;
wire MemRead_i;
wire MemWrite_i;
wire ALUSrc_i;
wire MemToReg_i;
wire Branch_i;
wire Jump_i;
wire [1:0] ALUOp_i;

wire [31:0] read_data1_i;
wire [31:0] read_data2_i;

wire [3:0] alu_ctrl_i;

wire [31:0] alu_result_i;
wire zero_i;

wire [31:0] alu_b;
wire [31:0] write_back;
wire [31:0] pc_plus4;
//===========================
// Instruction Decoder
//===========================

instruction_decoder decoder(

.instruction(instruction),

.opcode(opcode),
.rd(rd),
.funct3(funct3),
.rs1(rs1),
.rs2(rs2),
.funct7(funct7)

);

//===========================
// Immediate Generator
//===========================

immediate_generator imm(

.instruction(instruction),

.immediate(immediate_i)

);

//===========================
// Control Unit
//===========================

control_unit ctrl(

.opcode(opcode),

.RegWrite(RegWrite_i),

.MemRead(MemRead_i),

.MemWrite(MemWrite_i),

.ALUSrc(ALUSrc_i),

.MemToReg(MemToReg_i),

.Branch(Branch_i),

.Jump(Jump_i),

.ALUOp(ALUOp_i)

);

//===========================
// Register File
//===========================

register_file rf(

.clk(clk),

.we(RegWrite_i),

.rs1(rs1),
.rs2(rs2),
.rd(rd),

.write_data(write_back),

.read_data1(read_data1_i),
.read_data2(read_data2_i)

);

//===========================
// ALU Control
//===========================

alu_control alu_ctrl0(

.ALUOp(ALUOp_i),

.funct3(funct3),

.funct7(funct7),

.alu_ctrl(alu_ctrl_i)

);

//===========================
// ALU Input Select
//===========================

assign alu_b = ALUSrc_i ? immediate_i : read_data2_i;

//===========================
// ALU
//===========================

alu alu0(

.a(read_data1_i),

.b(alu_b),

.alu_ctrl(alu_ctrl_i),

.result(alu_result_i),

.zero(zero_i)

);
//===========================
// Memory Interface
//===========================

assign mem_addr  = alu_result_i;

assign mem_wdata = read_data2_i;

assign MemRead   = MemRead_i;

assign MemWrite  = MemWrite_i;
assign pc_plus4 = pc + 32'd4;

// Write Back MUX

assign write_back =Jump_i ? pc_plus4 :MemToReg_i ? mem_rdata :alu_result_i;
//===========================
// Debug Outputs
//===========================

assign immediate = immediate_i;

assign read_data1 = read_data1_i;
assign read_data2 = read_data2_i;

assign RegWrite = RegWrite_i;
assign ALUSrc = ALUSrc_i;
assign ALUOp = ALUOp_i;

assign alu_ctrl = alu_ctrl_i;

assign alu_result = alu_result_i;

assign zero = zero_i;
wire [31:0] jump_target;

assign jump_target = read_data1_i + immediate_i;
//===========================
// Program Counter
//===========================

always @(posedge clk)
begin

    if(rst)
        pc <= 0;

    else if(Jump_i)
        pc <= jump_target;

    else if(Branch_i && zero_i)
        pc <= pc + immediate_i;

    else
        pc <= pc + 4;

end
endmodule
