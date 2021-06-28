module demux_8 (clk, in, out0, out1, out2, out3, sel); 

input clk;
input [7:0] in; 
output reg [7:0] out0;
output reg [7:0] out1;
output reg [7:0] out2; 
output reg [7:0] out3;
input [1:0] sel;

	always @(posedge clk)
	begin
		case (sel)
		
			2'b00: 
			begin
				out0 <= in;
				out1 <= out1;
				out2 <= out2;
				out3 <= out3;
			end
			
			2'b01:  
			begin
				out0 <= out0;
				out1 <= in;
				out2 <= out2;
				out3 <= out3;
			end
			
			2'b10:  
			begin
				out0 <= out0;
				out1 <= out1;
				out2 <= in;
				out3 <= out3;
			end
			
			2'b11:  
			begin
				out0 <= out0;
				out1 <= out1;
				out2 <= out2;
				out3 <= in;
			end
			
			default: 
			begin
				out0 <= out0;
				out1 <= out1;
				out2 <= out2;
				out3 <= out3;
			end
			
		endcase
	end

endmodule
