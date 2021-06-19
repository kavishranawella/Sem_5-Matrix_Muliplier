module tb_mux();
 
	reg [15:0] in0; 
	reg [15:0] in1;
	reg [15:0] in2;
	reg [15:0] in3; 
	reg [3:0] sel;
	wire [15:0] out;
 
	mux_16 DUT (.in0(in0), .in1(in1), .in2(in2), .in3(in3), .in4(in0), .in5(in1), .in6(in2), .in7(in3), .in8(in0), .in9(in1), .in10(in2), .in11(in3), .in12(in0), .in13(in1), .in14(in2), .in15(in3), .sel(sel), .out(out));
 
	initial begin
		in0 = 16'b0000000000000001;
		in1 = 16'b0000000000000010;
		in2 = 16'b0000000000000100;
		in3 = 16'b0000000000001000;
		
		#100	
		sel = 4'b0011;
		#200
		
		sel = 4'b0000;
		#1
		if (out == 16'b0000000000000001)
			$display("line 0 okay now");
		else 
			$display("line 0 not working");
		#100
		
		sel = 4'b0001;
		#1
		if (out == 16'b0000000000000010)
			$display("line 1 okay");
		else 
			$display("line 1 not working");
		#100
		
		sel = 4'b0010;
		if (out == 16'b0000000000000100)
			$display("line 2 okay");
		else 
			$display("line 2 not working new");
		#100
		
		sel = 4'b0011;
		if (out == 16'b0000000000001000)
			$display("line 3 okay");
		else 
			$display("line 3 not working");
		#100
		    
		$finish;
	end
 
endmodule