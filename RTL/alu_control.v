module alu_control(

input [1:0] ALUOp,
input [2:0] funct3,
input [6:0] funct7,

output reg [3:0] alu_ctrl

);

always @(*)
begin

case(ALUOp)

2'b00:
alu_ctrl=4'b0000;

2'b01:
alu_ctrl=4'b0001;

2'b10:
begin

case({funct7,funct3})

10'b0000000000:
alu_ctrl=4'b0000;

10'b0100000000:
alu_ctrl=4'b0001;

10'b0000000111:
alu_ctrl=4'b0010;

10'b0000000110:
alu_ctrl=4'b0011;

10'b0000000100:
alu_ctrl=4'b0100;

default:
alu_ctrl=4'b0000;

endcase

end

default:
alu_ctrl=4'b0000;

endcase

end

endmodule
