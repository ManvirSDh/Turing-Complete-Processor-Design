module ALU_tb();

	reg [15:0] aIn, bIn;
	reg [1:0] op;
	wire [15:0] out;
	wire Z;
    reg err = 1'b0;

	ALU DUT(aIn, bIn, op, out, Z);

    task outChecker (input [15:0] expectedOut);
    begin
        $display("expecting output %b, actual output is %b", expectedOut, out);
        if (out !== expectedOut) begin
            err = 1'b1;
            $display("Error!");
        end
    end
    endtask

    task statusChecker (input expectedStatus);
    begin
        $display("expecting Z %b, actual status is %b", expectedStatus, Z);
        if (Z !== expectedStatus) begin
            err = 1'b1;
            $display("Error!");
        end
    end
    endtask

	initial begin
		//test addition
		aIn = 16'b0000000000011111; //31
		bIn = 16'b0000000000001011; //11
		op = 2'b00; //addition
		#10;
		$display("31 + 11");
        outChecker(16'd42);
        statusChecker(1'b0);

		//test subtraction
		aIn = 16'b0000000000011111; //31
		bIn = 16'b0000000000001011; //11
		op = 2'b01; //subtraction
		#10;
		$display("31 - 11"); 
        outChecker(16'd20);
        statusChecker(1'b0);
		
		//test and
		aIn = 16'b0000000000011111; //31
		bIn = 16'b0000000000001011; //11
		op = 2'b10; //and
		#10;
		$display("ANDing 31 and 11", out);
        outChecker(16'b0000000000001011);
        statusChecker(1'b0);
		
		//test not b
		aIn = 16'b0000000000011111; //31
		bIn = 16'b0000000000001011; //11
		op = 2'b11; //not B
		#10;
		$display("NOTing 11 in binary");
        outChecker(16'b1111111111110100);
        statusChecker(1'b0);

        //test result equal to 0
        aIn = 16'b0000000000011111; //31
        bIn = 16'b0000000000011111; //31
        op = 2'b01; //subtraction
        #10;
        $display("31 - 31, result should be 0");
        outChecker(16'd0);
        statusChecker(1'b1);

		//test negative numbers addition
		aIn = -16'd6;
        bIn = -16'd24;
        op = 2'b00;
		#10
		$display("Adding negative numbers, -6 + -24");
		outChecker(-16'd30);
        statusChecker(1'b0);

		//test negative numbers addition, crossing zero
		aIn = -16'd6;
        bIn = 16'd24;
        op = 2'b00;
		#10
		$display("Adding negative numbers, -6 + -24");
		outChecker(16'd18);
        statusChecker(1'b0);

		//test addition above 16 bit int limit
		aIn = 16'b1111111111111111; //65535
		bIn = 16'b0000000000000001; //1
		op = 2'b00; //addition
		#10;
		$display("Adding beyond 16 bits binary limit");
        outChecker(16'd0);
        statusChecker(1'b1);


		//test aubtracting two values that the result is negativce
		aIn = 16'b000000000000001; //1
		bIn = 16'b0000000000000010; //2
		op = 2'b01; //subtraction
		#10;
		$display("Subtraction with negative result");
        outChecker(16'b1111111111111111);
        statusChecker(1'b0);


        if (err == 1)
        begin
            $display("ERRRROR!!!!!!");
        end
		$stop;
	end
endmodule