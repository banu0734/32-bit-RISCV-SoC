module control_unit(

input [6:0] opcode,

output reg RegWrite,
output reg MemRead,
output reg MemWrite,
output reg ALUSrc,
output reg MemToReg,
output reg Branch,
output reg Jump,
output reg [1:0] ALUOp

);

always @(*)

begin
Jump = 0;
RegWrite=0;
MemRead=0;
MemWrite=0;
ALUSrc=0;
MemToReg=0;
Branch=0;
ALUOp=2'b00;

case(opcode)

7'b0110011:   // R-Type
begin
RegWrite=1;
ALUSrc=0;
ALUOp=2'b10;
end

7'b0010011:   // ADDI
begin
RegWrite=1;
ALUSrc=1;
ALUOp=2'b00;
end

7'b0000011:   // LOAD
begin
RegWrite=1;
MemRead=1;
MemToReg=1;
ALUSrc=1;
ALUOp=2'b00;
end

7'b0100011:   // STORE
begin
MemWrite=1;
ALUSrc=1;
ALUOp=2'b00;
end

7'b1100011:   // BRANCH
begin
Branch=1;
ALUOp=2'b01;
end

7'b1101111:   // JAL
begin
    RegWrite = 1;
    Jump     = 1;
    ALUSrc   = 0;
    ALUOp    = 2'b00;
end

7'b1100111:   // JALR
begin
    RegWrite = 1;
    Jump     = 1;
    ALUSrc   = 1;
    ALUOp    = 2'b00;
end

default:
begin
end

endcase

end

endmodule
