`timescale 1ns/1ps

module soc_tb;

reg clk;
reg rst;

reg [7:0] sw;
reg rx;

wire [7:0] led;
wire tx;

//====================
// DUT
//====================

soc_top dut(

.clk(clk),
.rst(rst),

.sw(sw),

.rx(rx),

.led(led),

.tx(tx)

);

//====================
// Clock
//====================

always #5 clk=~clk;

//====================
// Stimulus
//====================

initial
begin

clk=0;
rst=1;

sw=8'h00;
rx=1'b1;

#20;

rst=0;

#20;

sw=8'hAA;

#20;

sw=8'h55;

#200;

$finish;

end

endmodule
