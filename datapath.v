module datapath(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, datapath_in, Z_out, datapath_out);
    input [15:0] datapath_in;
    input clk, vsel, asel, bsel, loada, loadb, loadc, loads, write;
    input [1:0] shift, ALUop;
    input [2:0] readnum, writenum;
    output Z_out;
    output [15:0] datapath_out;

    wire [15:0] data_in = vsel ? datapath_in : datapath_out;
    wire [15:0] data_out;
    
    regfile REGFILE(data_in, writenum, write, readnum, clk, data_out);

    wire [15:0] loada_out;
    wire [15:0] in;
    VDFFE #(16) A(clk, loada, data_out, loada_out);
    VDFFE #(16) B(clk, loadb, data_out, in);

    wire [15:0] sout;
    shifter U1(in, shift, sout);

    wire [15:0] Ain = asel ? {16{1'b0}} : loada_out;
    wire [15:0] Bin = bsel ? {{11{1'b0}}, datapath_in[4:0]} : sout;

    wire [15:0] out;
    wire Z;
    ALU U2(Ain, Bin, ALUop, out, Z);

    VDFFE #(1) status(clk, loads, Z, Z_out);
    VDFFE #(16) C(clk, loadc, out, datapath_out);
endmodule
