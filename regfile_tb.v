module regfile_tb;
    reg [15:0] data_in;
    reg [2:0] writenum, readnum;
    reg write, clk, err;
    wire [15:0] data_out;
    //wire [15:0] R0, R1, R2, R3, R4, R5, R6, R7;
    
    regfile DUT(data_in, writenum, write, readnum, clk, data_out);
    wire [15:0] r0_val = DUT.R0;
    wire [15:0] r1_val = DUT.R1;
    wire [15:0] r2_val = DUT.R2;
    wire [15:0] r3_val = DUT.R3;
    wire [15:0] r4_val = DUT.R4;
    wire [15:0] r5_val = DUT.R5;
    wire [15:0] r6_val = DUT.R6;
    wire [15:0] r7_val = DUT.R7;

    task data_out_checker;
        input [15:0] expected_data_out;
    begin
        if(data_out !== expected_data_out) begin
            $display("ERROR ** data_out is %b, expected %b", data_out, expected_data_out);
            err = 1'b1;
        end else begin
            $display("CORRECT ** data_out is %b, expected %b", data_out, expected_data_out);
        end
    end
    endtask

    initial begin
        //write d'42 in R2 (MOV R2, #42)
        err = 1'b0;
        write = 1'b1;
        data_in = 16'd42;
        writenum = 3'd2;
        clk = 1'b1; #10;
        clk = 1'b0; #10;
        data_out_checker({16{1'bx}});

        //write d'25 in R5  (MOV R5, #25)
        write = 1'b1;
        data_in = 16'd25;
        writenum = 3'd5;
        clk = 1'b1; #10;
        clk = 1'b0; #10;
        data_out_checker({16{1'bx}});

        //read from R5
        write = 1'b0;
        readnum = 3'b101; #10;
        data_out_checker(16'd25);
        readnum = 3'bxxx; #10;

        //write d'400 to R7 and read from R2;
        write = 1'b1;
        data_in = 16'd400;
        writenum = 16'd7;
        readnum = 3'd2; #10;
        data_out_checker(16'd42);
        readnum = 3'bxxx; #10;
        clk = 1'b1; #10;
        clk = 1'b0; #10;
        write = 1'b0;


        if(err)
            $display("ERROR ** ONE OR MORE TESTCASES FAILED");
        else
            $display("ALL TEST CASES PASSED");

        $stop;


    end
endmodule
