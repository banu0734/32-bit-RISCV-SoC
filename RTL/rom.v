module rom(

    input  [31:0] addr,
    output [31:0] instruction

);

reg [31:0] memory [0:255];

integer i;

initial
begin

    // Initialize all locations with NOP
    for(i=0; i<256; i=i+1)
        memory[i] = 32'h00000013;

    //--------------------------------------------------
    // Test Program
    //--------------------------------------------------
    // ADDI x1,x0,5
    memory[0] = 32'h00500093;
    
    // ADDI x2,x0,10
    memory[1] = 32'h00A00113;
    
    // ADD x3,x1,x2
    memory[2] = 32'h002081B3;
    
    // SW x3,0(x0)
    memory[3] = 32'h00302023;
    
    // LW x4,0(x0)
    memory[4] = 32'h00002203;
    
    // BEQ x3,x4,+8
    memory[5] = 32'h00418463;
    
    // ADDI x5,x0,1 (should be skipped)
    memory[6] = 32'h00100293;
    
    // JAL x6,+8
    memory[7] = 32'h0080036F;
    
    // ADDI x7,x0,2 (should be skipped)
    memory[8] = 32'h00200393;
    
    // NOP
    memory[9] = 32'h00000013;
    
    // NOP
    memory[10] = 32'h00000013;
    //--------------------------------------------------
    // Extra NOPs
    //--------------------------------------------------

    memory[4] = 32'h00000013;
    memory[5] = 32'h00000013;
    memory[6] = 32'h00000013;
    memory[7] = 32'h00000013;

end

// Word Addressing
assign instruction = memory[addr[9:2]];

endmodule
