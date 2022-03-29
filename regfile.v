module regfile(data_in, writenum, write, readnum, clk, data_out);
    input [15:0] data_in;
    input [2:0] writenum, readnum;
    input write, clk;
    output [15:0] data_out;
    reg [15:0] data_out;
    
    wire [15:0] R0, R1, R2, R3, R4, R5, R6, R7;

    wire [7:0] decoded_writenum = 1 << writenum;
    wire [7:0] decoded_readnum = 1 << readnum;

    VDFFE #(16) r0(clk, decoded_writenum[0] & write, data_in, R0);
    VDFFE #(16) r1(clk, decoded_writenum[1] & write, data_in, R1);
    VDFFE #(16) r2(clk, decoded_writenum[2] & write, data_in, R2);
    VDFFE #(16) r3(clk, decoded_writenum[3] & write, data_in, R3);
    VDFFE #(16) r4(clk, decoded_writenum[4] & write, data_in, R4);
    VDFFE #(16) r5(clk, decoded_writenum[5] & write, data_in, R5);
    VDFFE #(16) r6(clk, decoded_writenum[6] & write, data_in, R6);
    VDFFE #(16) r7(clk, decoded_writenum[7] & write, data_in, R7);

     always @(*) begin
         case (decoded_readnum)
           8'b00000001 : data_out = R0;
           8'b00000010 : data_out = R1;
           8'b00000100 : data_out = R2;
           8'b00001000 : data_out = R3;
           8'b00010000 : data_out = R4;
           8'b00100000 : data_out = R5;
           8'b01000000 : data_out = R6;
           8'b10000000 : data_out = R7;
           default: data_out = {16{1'bx}};
        endcase
    end
endmodule

module VDFFE(clk, en, in, out);
    parameter k = 1;
    input clk, en;
    input [k-1:0] in;
    output reg [k-1:0] out;

    wire [k-1:0] next_out;
    assign next_out = en? in : out;

    always @(posedge clk) begin
        out = next_out;
    end
endmodule

