`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:51:51 10/16/2015 
// Design Name: 
// Module Name:    data_template 
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
module data_template(input clk, input rst, output [31:0] sum);

	wire [7:0] in0, in1, in2, in3, in4, in5, in6, in7;
    reg [7:0] data0[0:31];
	reg [7:0] data1[0:31];
	reg [7:0] data2[0:31];
	reg [7:0] data3[0:31];
	reg [7:0] data4[0:31];
	reg [7:0] data5[0:31];
	reg [7:0] data6[0:31];
	reg [7:0] data7[0:31];
    reg data_available;
    reg [4:0] selector;
	reg [7:0] tempdata[0:7];

    assign in0 = data0[31];
    assign in1 = data1[31];
    assign in2 = data2[31];
    assign in3 = data3[31];
    assign in4 = data4[31];
    assign in5 = data5[31];
    assign in6 = data6[31];
    assign in7 = data7[31];

    integer i;




	adder_tree add (
		.clk(clk),
		.rst(rst),
		.in_valid(data_available),
		.in0(in0),
		.in1(in1),
		.in2(in2),
		.in3(in3),
		.in4(in4),
		.in5(in5),
		.in6(in6),
		.in7(in7),
		.sum(sum)
	);

  always @(posedge clk)
    if (rst) begin
        data_available <= 1;
        selector <= 31;
        `include "data.dat"
    end
	else begin
        if(selector == 0)
            data_available <= 0;
        if(selector >= 0) begin
			tempdata[0] <= data0[31];
            tempdata[1] <= data1[31];
            tempdata[2] <= data2[31];
            tempdata[3] <= data3[31];
            tempdata[4] <= data4[31];
            tempdata[5] <= data5[31];
            tempdata[6] <= data6[31];
            tempdata[7] <= data7[31];
            for ( i=31 ; i>0 ; i=i-1 ) begin
				data0[i]<=data0[i-1];
                data1[i]<=data1[i-1];
                data2[i]<=data2[i-1];
                data3[i]<=data3[i-1];
                data4[i]<=data4[i-1];
                data5[i]<=data5[i-1];
                data6[i]<=data6[i-1];
                data7[i]<=data7[i-1];
            end
            data0[0] <= tempdata[0];
            data1[0] <= tempdata[1];
            data2[0] <= tempdata[2];
            data3[0] <= tempdata[3];
            data4[0] <= tempdata[4];
            data5[0] <= tempdata[5];
            data6[0] <= tempdata[6];
            data7[0] <= tempdata[7];

            
            selector <= selector - 1;
        end
            
    end

endmodule

module normalizer(input clk, input rst, output [7:0] led);

    wire [31:0] sum;
    reg [31:0] avg;


    
    assign led[0] = avg[8];
    assign led[1] = avg[9];
    assign led[2] = avg[10];
    assign led[3] = avg[11];
    assign led[4] = avg[12];
    assign led[5] = avg[13];
    assign led[6] = avg[14];
    assign led[7] = avg[15];
    
	

    data_template data ( 
        .clk(clk),
        .rst(rst),
        .sum(sum)
    );

    always @(posedge clk) begin
        if (rst) begin
            // reset
            avg <= 0;
        end
        else begin
            if(sum != 0)
                begin
                   avg <= sum + 128;
                end
            else
                avg <= avg;
        end
    end

endmodule



