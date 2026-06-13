module uart(
    input clk,
    input rst,
    input rx,
    output tx
);

assign tx = rx;

endmodule
