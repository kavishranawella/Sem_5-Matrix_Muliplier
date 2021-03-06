module decoder_4to16 (in_sig, out_sig); 

 
input [3:0] in_sig;
output reg [14:0] out_sig;

	always @(in_sig)
	begin
		case (in_sig)
			4'b0000  : out_sig <= 15'b000000000000000;
			4'b0001  : out_sig <= 15'b000000000000001;
			4'b0010  : out_sig <= 15'b000000000000010;
			4'b0011  : out_sig <= 15'b000000000000100;
			4'b0100  : out_sig <= 15'b000000000001000;
			4'b0101  : out_sig <= 15'b000000000010000;
			4'b0110  : out_sig <= 15'b000000000100000;
			4'b0111  : out_sig <= 15'b000000001000000;
			4'b1000  : out_sig <= 15'b000000010000000;
			4'b1001  : out_sig <= 15'b000000100000000;
			4'b1010  : out_sig <= 15'b000001000000000;
			4'b1011  : out_sig <= 15'b000010000000000;
			4'b1100  : out_sig <= 15'b000100000000000;
			4'b1101  : out_sig <= 15'b001000000000000;
			4'b1110  : out_sig <= 15'b010000000000000;
			4'b1111  : out_sig <= 15'b100000000000000;
			default  : out_sig <= 15'b000000000000000; 
		endcase
	end

endmodule
