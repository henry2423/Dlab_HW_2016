`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:46:11 01/05/2017 
// Design Name: 
// Module Name:    data_memory 
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
module data_memory( 
		input reset,
		input clk,
		output [8:0] reg1,
		output [8:0] reg2,
		output [8:0] reg3,
		output [8:0] reg4,
		// if you need more I/O you can add more here
		input [19:0] instruction,
		output zero_flag
		); 

reg    [8:0] register [3:0];



assign reg1 = register[0];
assign reg2 = register[1];
assign reg3 = register[2];
assign reg4 = register[3];

/*
	You need to put your code here
*/
//I/O ports
wire signed [7:0]  src1_i;
wire signed [7:0]  src2_i;
wire  [3:0]   ctrl_i;

assign zero_flag = (register[src1_i]==0)? 1:0;




//Internal signals
assign ctrl_i = instruction [19:16] ;
assign src1_i = instruction [15:8] ;
assign src2_i = instruction [7:0] ;


wire [8:0] add_sum;
wire [8:0] addi_sum;
wire [8:0] sub_sum;
wire [8:0] subi_sum;
wire add_carry;
wire addi_carry;
wire sub_carry;
wire subi_carry;



addi add(
	.a(register[src1_i][7:0]),
	.b(register[src2_i][7:0]),
	.sum(add_sum), 
	.carry_out(add_carry)
	);

addi addi(		
	.a(register[src1_i][7:0]),
	.b(src2_i),
	.sum(addi_sum), 
	.carry_out(addi_carry)
	);

subtract sub(
	.a(register[src1_i][7:0]),
	.b(register[src2_i][7:0]),
	.sum(sub_sum), 
	.carry_out(sub_carry)
	);

subtract subi(		
	.a(register[src1_i][7:0]),
	.b(src2_i),
	.sum(subi_sum), 
	.carry_out(subi_carry)
	);

reg result;


//Main function
/*your code here*/
always @( posedge clk )
if(reset) begin
	register[0] <= 0;
	register[1] <= 0;
	register[2] <= 0;	
	register[3] <= 0;
	result <= 0;

end else begin
	case(ctrl_i)
	    4'b0000:	//null
					result <= 0;
	    4'b0010:	//add
	    			register[src1_i] <= {add_carry,add_sum};     
	    4'b0011:	//addi
	                register[src1_i] <= {addi_carry,addi_sum}; 
	    4'b0100:	//sub
	               	register[src1_i] <= {sub_carry,sub_sum};
	    4'b0101:	//subi
	                register[src1_i] <= {subi_carry,subi_sum}; 	//becasue src2_i already 2's como
	    4'b1110:	//and
	                register[src1_i] <= register[src1_i] & register[src2_i];
	    4'b1100:	//or
	    			register[src1_i] <= register[src1_i] | register[src2_i];
	    4'b1010:	//xor
	                register[src1_i] <= register[src1_i] ^ register[src2_i];
	    4'b1000:	//not
	                register[src1_i] <= ~(register[src1_i]);
	    default:
					result <= 0;
  	endcase
end

endmodule


module subtract(a, b, sum, carry_out);
	input [7:0] a, b;
	output [8:0] sum;
	output carry_out;

	wire [8:0] s_com;
	wire cin, z;
	assign s_com = 9'd1;
	assign cin = 1'b0;
	wire [8:0]ta, tb, tc, td;
	assign ta[0] = a[0];
	assign ta[1] = a[1];
	assign ta[2] = a[2];
	assign ta[3] = a[3];
	assign ta[4] = a[4];
	assign ta[5] = a[5];
	assign ta[6] = a[6];
	assign ta[7] = a[7];
	assign ta[8] = a[7];

	assign tb[0] = b[0];
	assign tb[1] = b[1];
	assign tb[2] = b[2];
	assign tb[3] = b[3];
	assign tb[4] = b[4];
	assign tb[5] = b[5];
	assign tb[6] = b[6];
	assign tb[7] = b[7];
	assign tb[8] = b[7];
	Complement minuend(.M(tb), .S(tc));		//1's complement
	FullAdder fa(.A(tc), .B(s_com), .Cin(cin), .S(td), .Cout(z));  //2's complement

	FullAdder sum1(.A(ta), .B(td), .Cin(cin), .S(sum), .Cout(carry_out));

endmodule


module addi(a, b, sum, carry_out);
	input [7:0] a, b;
	output [8:0] sum;
	output carry_out;
	wire cin;
	assign cin = 1'b0;

	wire [8:0]aa, ab, tc, td;
	assign aa[0] = a[0];
	assign aa[1] = a[1];
	assign aa[2] = a[2];
	assign aa[3] = a[3];
	assign aa[4] = a[4];
	assign aa[5] = a[5];
	assign aa[6] = a[6];
	assign aa[7] = a[7];
	assign aa[8] = a[7];

	assign ab[0] = b[0];
	assign ab[1] = b[1];
	assign ab[2] = b[2];
	assign ab[3] = b[3];
	assign ab[4] = b[4];
	assign ab[5] = b[5];
	assign ab[6] = b[6];
	assign ab[7] = b[7];
	assign ab[8] = b[7];

	FullAdder sum2(.A(aa), .B(ab), .Cin(cin), .S(sum), .Cout(carry_out));

endmodule



module FullAdder(A, B, Cin, S, Cout);
	input [8:0] A, B;
	input Cin;
	output [8:0] S;
	output Cout;
	wire [7:0] t;


	FA_1bit FA0(.A(A[0]), .B(B[0]), .Cin(Cin), .S(S[0]), .Cout(t[0]));
	FA_1bit FA1(.A(A[1]), .B(B[1]), .Cin(t[0]), .S(S[1]), .Cout(t[1]));
	FA_1bit FA2(.A(A[2]), .B(B[2]), .Cin(t[1]), .S(S[2]), .Cout(t[2]));
	FA_1bit FA3(.A(A[3]), .B(B[3]), .Cin(t[2]), .S(S[3]), .Cout(t[3]));
	FA_1bit FA4(.A(A[4]), .B(B[4]), .Cin(t[3]), .S(S[4]), .Cout(t[4]));
	FA_1bit FA5(.A(A[5]), .B(B[5]), .Cin(t[4]), .S(S[5]), .Cout(t[5]));
	FA_1bit FA6(.A(A[6]), .B(B[6]), .Cin(t[5]), .S(S[6]), .Cout(t[6]));
	FA_1bit FA7(.A(A[7]), .B(B[7]), .Cin(t[6]), .S(S[7]), .Cout(t[7]));
	FA_1bit FA8(.A(A[8]), .B(B[8]), .Cin(t[7]), .S(S[8]), .Cout(Cout));

endmodule

// ----------------- A 1-bit full adder ----------------------------- 
module FA_1bit(A, B, Cin, S, Cout);
	input A, B, Cin;
	output S, Cout;
	assign S = Cin ^ A ^ B;
	assign Cout = (A & B) | (Cin & B) | (Cin & A);
	
endmodule


module Complement(M, S);
	input [8:0]M;
	output [8:0]S;
	assign S = ~M;
endmodule
