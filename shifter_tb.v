module shifter_tb();
    reg [15:0] in;
    reg [1:0] shift;
    wire [15:0] out;

    reg err = 1'b0;

    shifter DUT(in, shift, out);

    task outChecker (input [15:0] expectedOut);
    begin
        $display("expecting output %b, actual output is %b", expectedOut, out);
        if (out !== expectedOut) begin
            err = 1'b1;
            $display("Error!");
        end
    end
    endtask

    initial begin

        //no shift
        in = 16'd100; 
        shift = 2'b00; //no shift
        #10;
        $display("testing unchanging shift");
        outChecker(16'd100);


        //shift to the left
        in = 16'd100;
        shift = 2'b01; //shift left
        #10;
        $display("doubling 100");
        outChecker(16'd200);

        //shift to the left, cutting off the MSB
        in = 16'b1000000000000000;
        shift = 2'b01; //shift left
        #10;
        $display("shifting 1000000000000000 to the left");
        outChecker(16'd0);
        

        //shift to the right
        in = 16'd100; 
        shift = 2'b10; //shift right
        #10; 
        $display("halving 100");
        outChecker(16'd50);

        //shift to the right
        in = 16'd99; 
        shift = 2'b10; //shift right
        #10; 
        $display("halving 99");
        outChecker(16'd49);

        //shift to the right
        in = 16'd1; 
        shift = 2'b10; //shift right
        #10; 
        $display("halving 1");
        outChecker(16'd0);


        //shift right and copy MSB
        in = 16'b1000000000000000;
        shift = 2'b11; //shift right 1 and copy MSB
        #10; 
        $display("shift right and copy MSB of 1000000000000000");
        outChecker(16'b1100000000000000);

        //shift right and copy MSB
        in = 16'b0000000000000001;
        shift = 2'b11; //shift right 1 and copy MSB
        #10; 
        $display("shift right and copy MSB of 0000000000000001");
        outChecker(16'd0);


        if (err == 1) begin
            $display("~~~~~~~~~~~~~ERROR!~~~~~~~~~~~~~");
        end
        $stop;
    end
		
endmodule