module ALU_tb;
    reg [15:0] Ain, Bin;
    reg [1:0] ALUop;
    wire [15:0] out;
    wire Z;
    reg err;

    ALU DUT(Ain, Bin, ALUop, out, Z);


    task out_checker;
        input [15:0] expected_out;
    begin
        if(out !== expected_out) begin
            $display("ERROR ** out is %b, expected %b", out, expected_out);
            err = 1'b1;
        end else begin
            $display("CORRECT ** out is %b, expected %b", out, expected_out);
        end
    end
    endtask
    

    task Z_checker;
        input expected_Z;
    begin
        if(Z !== expected_Z) begin
            $display("ERROR ** Z is %b, expected %b", Z, expected_Z);
            err = 1'b1;
        end else begin
            $display("CORRECT ** Z is %b, expected %b", Z, expected_Z);
        end
    end
    endtask

    initial begin
        //25 + 42, ALUop = 2'b00
        err = 1'b0;
        Ain = 16'd25; 
        Bin = 16'd42; #5;
        ALUop = 2'b00; #5;
        out_checker(16'd67);
        Z_checker(1'b0); #20;

        //42 - 25, ALUop = 2'b01
        Ain = 16'd42;
        Bin = 16'd25; #5;
        ALUop = 2'b01; #5;
        out_checker(16'd17);
        Z_checker(1'b0); #20;

        //25 - 42, ALUop = 2'b01
        Ain = 16'd25;
        Bin = 16'd42; #5;
        ALUop = 2'b01; #5;
        out_checker(-16'd17);
        Z_checker(1'b0); #20;

        //25 & 42, ALUop = 2'b10
        Ain = 16'd25;
        Bin = 16'd42; #5;
        ALUop = 2'b10; #5;
        out_checker(16'd8);
        Z_checker(1'b0); #20;

        //~16'b0000000010110110, ALUop = 2'b11
        Bin = 16'b0000000010110110; #5;
        ALUop = 2'b11; #5;
        out_checker(16'b1111111101001001);
        Z_checker(1'b0);

        //Z = 1, 25 - 25, ALUop = 1'b01
        Ain = 16'd25;
        Bin = 16'd25; #5;
        ALUop = 2'b01; #5;
        out_checker(16'd0);
        Z_checker(1'b1);

        //negative numbers addition
        Ain = -16'd6;
        Bin = -16'd24; #5;
        ALUop = 2'b00; #5;
        out_checker(-16'd30);
        Z_checker(1'b0);

        if(err)
            $display("ERROR ** ONE OR MORE TESTCASES FAILED");
        else
            $display("ALL TEST CASES PASSED");

        $stop;

    end
endmodule

