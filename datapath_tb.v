module datapath_tb;
    reg [15:0] datapath_in;
    reg clk, vsel, asel, bsel, loada, loadb, loadc, loads, write;
    reg [1:0] shift, ALUop;
    reg [2:0] readnum, writenum;
    wire Z_out;
    wire [15:0] datapath_out;
    reg err;

    datapath DUT(.clk (clk), .readnum (readnum), .vsel (vsel), .loada (loada), 
                .loadb (loadb), .shift (shift), .asel (asel), .bsel (bsel), 
                .ALUop (ALUop), .loadc (loadc), .loads (loads), .writenum (writenum), 
                .write (write), .datapath_in (datapath_in), .Z_out (Z_out), .datapath_out (datapath_out));

    task datapath_out_checker;
        input [15:0] expected_datapath_out;
    begin
        if(datapath_out !== expected_datapath_out) begin
            $display("ERROR ** datapath_out is %b, expected %b", datapath_out, expected_datapath_out);
            err = 1'b1;
        end else begin
            $display("CORRECT ** datapath_out is %b, expected %b", datapath_out, expected_datapath_out);
        end
    end
    endtask


    task Z_out_checker;
        input expected_Z_out;
    begin
        if(Z_out !== expected_Z_out) begin
            $display("ERROR ** Z_out is %b, expected %b", Z_out, expected_Z_out);
            err = 1'b1;
        end else begin
            $display("CORRECT ** Z_out is %b, expected %b", Z_out, expected_Z_out);
        end
    end
    endtask

    initial begin
        err = 1'b0;
        ///////////////////////////////////MOV R0, #7
        //write 'd7 to R0 
        vsel = 1'b1;
        write = 1'b1;
        datapath_in = 16'd7; #5;
        writenum = 3'd0;
        clk = 1'b1; #5;
        clk = 1'b0; #5;
        if(DUT.REGFILE.R0 !== 16'd7) begin
            $display("ERROR ** value in R0 is %b, expected %b", DUT.REGFILE.R0, 16'd7);
            err = 1'b1;
        end else begin
            $display("CORRECT ** value in R0 is %b, expected %b", DUT.REGFILE.R1, 16'd7);
        end


        ///////////////////////////////////MOV R1, #2
        //write 'd0 to R1
        vsel = 1'b1;
        write = 1'b1;
        datapath_in = 16'd2;
        writenum = 3'd1;
        clk = 1'b1; #5;
        clk = 1'b0; #5;
        if(DUT.REGFILE.R1 !== 16'd2) begin
            $display("ERROR ** value in R1 is %b, expected %b", DUT.REGFILE.R1, 16'd2);
            err = 1'b1;
        end else begin
            $display("CORRECT ** value in R1 is %b, expected %b", DUT.REGFILE.R1, 16'd2);
        end

        ///////////////////////////////////ADD R2, R1, R0, LSL#1
        //load value in R1 in A
        readnum = 3'd1;
        loada = 1'b1; #5;
        clk = 1'b1; #5;
        clk = 1'b0; #5;
        loada = 1'b0;
        readnum = 3'bxxx; #5;

        //load value in R0 in B
        readnum = 3'd0;
        loadb = 1'b1; #5;
        clk = 1'b1; #5;
        clk = 1'b0; #5;
        loadb = 1'b0;
        readnum = 3'bxxx; #5;

        //shift value in B left by 1 bit and add that value to the value in A and load that value into C
        shift = 2'b01;
        asel = 1'b0;
        bsel = 1'b0;
        ALUop = 2'b00;
        loads = 1'b1; #5;
        clk = 1'b1; #5;
        clk = 1'b0; #5;
        loads = 1'b0;
        Z_out_checker(1'b0);
        loadc = 1'b1; #5;
        clk = 1'b1; #5;
        clk = 1'b0; #5;
        datapath_out_checker(16'd16);
        loadc = 1'b0;

        //write value C to R2
        vsel = 1'b0;
        write = 1'b1;
        writenum = 3'd2;
        clk = 1'b1; #5;
        clk = 1'b0; #5;
        if(DUT.REGFILE.R2 !== 16'd16) begin
            $display("ERROR ** value in R2 is %b, expected %b", DUT.REGFILE.R2, 16'd16);
            err = 1'b1;
        end else begin
            $display("CORRECT ** value in R2 is %b, expected %b", DUT.REGFILE.R2, 16'd16);
        end

        ///////////////////////////////////MOV R3, R0
        //load value in R0 in B
        readnum = 3'd0;
        loadb = 1'b1; #5;
        clk = 1'b1; #5;
        clk = 1'b0; #5;
        loadb = 1'b0;
        readnum = 3'bxxx; #5;

        //set Ain = 0 and Bin = value in R0 and add. load the result into C
        shift = 2'b00;
        asel = 1'b1;
        bsel = 1'b0;
        ALUop = 2'b00;
        loads = 1'b1; #5;
        clk = 1'b1; #5;
        clk = 1'b0; #5;
        loads = 1'b0;
        Z_out_checker(1'b0);
        loadc = 1'b1; #5;
        clk = 1'b1; #5;
        clk = 1'b0; #5;
        datapath_out_checker(16'd7);
        loadc = 1'b0;

        //write value in C to R3
        vsel = 1'b0;
        write = 1'b1;
        writenum = 3'd3;
        clk = 1'b1; #5;
        clk = 1'b0; #5;
        if(DUT.REGFILE.R3 !== 16'd7) begin
            $display("ERROR ** value in R3 is %b, expected %b", DUT.REGFILE.R3, 16'd7);
            err = 1'b1;
        end else begin
            $display("CORRECT ** value in R3 is %b, expected %b", DUT.REGFILE.R3, 16'd7);
        end

        ///////////////////////////////////MVN R4, R1
        //load value in R1 in B
        readnum = 3'd1;
        loadb = 1'b1; #5;
        clk = 1'b1; #5;
        clk = 1'b0; #5;
        loadb = 1'b0;
        readnum = 3'bxxx; #5;

        //set Ain = 0 and Bin = value in R1 and add. load the result into C
        shift = 2'b00;
        asel = 1'b1;
        bsel = 1'b0;
        ALUop = 2'b11;
        loads = 1'b1; #5;
        clk = 1'b1; #5;
        clk = 1'b0; #5;
        loads = 1'b0;
        Z_out_checker(1'b0);
        loadc = 1'b1; #5;
        clk = 1'b1; #5;
        clk = 1'b0; #5;
        datapath_out_checker(16'b1111111111111101);
        loadc = 1'b0;

        //write value in C to R4
        vsel = 1'b0;
        write = 1'b1;
        writenum = 3'd4;
        clk = 1'b1; #5;
        clk = 1'b0; #5;
        if(DUT.REGFILE.R4 !== 16'b1111111111111101) begin
            $display("ERROR ** value in R4 is %b, expected %b", DUT.REGFILE.R4, 16'b1111111111111101);
            err = 1'b1;
        end else begin
            $display("CORRECT ** value in R4 is %b, expected %b", DUT.REGFILE.R4, 16'b1111111111111101);
        end


        ///////////////////////////////////SUB R5, R3, R1, LSR#1
        //load value in R3 in A
        readnum = 3'd3;
        loada = 1'b1; #5;
        clk = 1'b1; #5;
        clk = 1'b0; #5;
        loada = 1'b0;
        readnum = 3'bxxx; #5;

        //load value in R0 in B
        readnum = 3'd1;
        loadb = 1'b1; #5;
        clk = 1'b1; #5;
        clk = 1'b0; #5;
        loadb = 1'b0;
        readnum = 3'bxxx; #5;

        //shift value in B left by 1 bit and add that value to the value in A and load that value into C
        shift = 2'b10;
        asel = 1'b0;
        bsel = 1'b0;
        ALUop = 2'b01;
        loads = 1'b1; #5;
        clk = 1'b1; #5;
        clk = 1'b0; #5;
        loads = 1'b0;
        Z_out_checker(1'b0);
        loadc = 1'b1; #5;
        clk = 1'b1; #5;
        clk = 1'b0; #5;
        datapath_out_checker(16'd6);
        loadc = 1'b0;

        //write value C to R5
        vsel = 1'b0;
        write = 1'b1;
        writenum = 3'd5;
        clk = 1'b1; #5;
        clk = 1'b0; #5;
        if(DUT.REGFILE.R5 !== 16'd6) begin
            $display("ERROR ** value in R5 is %b, expected %b", DUT.REGFILE.R5, 16'd6);
            err = 1'b1;
        end else begin
            $display("CORRECT ** value in R5 is %b, expected %b", DUT.REGFILE.R5, 16'd66);
        end

        if(err)
            $display("ERROR ** ONE OR MORE TESTCASES FAILED");
        else
            $display("ALL TEST CASES PASSED");

        $stop;


    end
endmodule 
