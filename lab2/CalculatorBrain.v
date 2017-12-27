`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:09:14 10/14/2016 
// Design Name: 
// Module Name:    CalculatorBrain 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module postfix(CLK, RESET, OP_MODE, IN_VALID, IN, OUT, OUT_VALID);
	input CLK;
   input RESET;
   input OP_MODE;
   input IN_VALID;
   input [3:0] IN;
	output reg [15:0] OUT;
   output reg OUT_VALID;
	
	

	reg [15:0] temp_out;
	
	
		   parameter N = 10;	reg  [15:0] qtop;	reg  [15:0] q [N-1:0];


	always @(negedge RESET ) begin
		begin
			OUT_VALID <= 1'b0;
			OUT = 0;
			qtop = 0;
		end
	end
	

	always @( posedge CLK ) begin
		if( IN_VALID == 1)
			begin
				if( OP_MODE == 0 )
					begin
						q[qtop] = IN;
						qtop = qtop + 1;
					end
				else if ( OP_MODE == 1)
					begin
						if( IN == 4'b0001)
							begin
								qtop = qtop - 1;
								temp_out = q[qtop];
								qtop = qtop - 1;
								temp_out = temp_out + q[qtop];
								q[qtop] = temp_out;
								qtop = qtop + 1;
							end
						else if (IN == 4'b0010)
							begin
								qtop = qtop - 1;
								temp_out = q[qtop];
								qtop = qtop - 1;
								temp_out = q[qtop] - temp_out;
								q[qtop] = temp_out;
								qtop = qtop + 1;
							end
						else if (IN == 4'b0100)
							begin
								qtop = qtop - 1;
								temp_out = q[qtop];
								qtop = qtop - 1;
								temp_out = q[qtop] * temp_out;
								q[qtop] = temp_out;
								qtop = qtop + 1;
							end
					end
				end
			else if (IN_VALID == 0 && qtop!=0)
				begin
					qtop = qtop - 1;
					OUT_VALID =1;
					OUT = q[qtop];
					qtop = 0;
				end
			else if(IN_VALID == 0 && qtop==0)
				begin
					OUT_VALID =0;
					OUT = 0;
				end
		end
		



endmodule
   
	
