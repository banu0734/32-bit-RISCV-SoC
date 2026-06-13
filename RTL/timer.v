module timer(
    input clk,
    input rst,
    output reg tick
);

reg [23:0] count;

always @(posedge clk)
begin

if(rst)
begin
count <= 0;
tick <= 0;
end

else
begin

if(count == 24'd10)
begin
count <= 0;
tick <= ~tick;
end

else
count <= count + 1;

end

end
endmodule
