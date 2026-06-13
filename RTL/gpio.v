module gpio(

input clk,
input rst,

input gpio_sel,

input we,
input re,

input [31:0] addr,
input [31:0] wdata,

output reg [31:0] rdata,

input [7:0] sw,
output reg [7:0] led

);

reg [7:0] data_reg;
reg [7:0] dir_reg;

always @(posedge clk)
begin

if(rst)
begin

data_reg<=0;
dir_reg<=0;

end

else if(gpio_sel && we)

begin

case(addr[3:2])

2'b00:
data_reg<=wdata[7:0];

2'b01:
dir_reg<=wdata[7:0];

endcase

end

end

always @(*)

begin

if(gpio_sel && re)

begin

case(addr[3:2])

2'b00:
rdata={24'b0,data_reg};

2'b01:
rdata={24'b0,dir_reg};

default:
rdata=0;

endcase

end

else

rdata=0;

end

always @(*)
begin
    led = sw;
end

endmodule
