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
    wire [63:0] seldata;
    reg [4:0] selector;

    assign in0 = seldata[7:0];
    assign in1 = seldata[15:8];
    assign in2 = seldata[23:16];
    assign in3 = seldata[31:24];
    assign in4 = seldata[39:32];
    assign in5 = seldata[47:40];
    assign in6 = seldata[55:48];
    assign in7 = seldata[63:56];

    mux muti(
        .in0({data0[0],data1[0],data2[0],data3[0],data4[0],data5[0],data6[0],data7[0] }),
        .in1({data0[1],data1[1],data2[1],data3[1],data4[1],data5[1],data6[1],data7[1] }), 
        .in2({data0[2],data1[2],data2[2],data3[2],data4[2],data5[2],data6[2],data7[2] }), 
        .in3({data0[3],data1[3],data2[3],data3[3],data4[3],data5[3],data6[3],data7[3] }), 
        .in4({data0[4],data1[4],data2[4],data3[4],data4[4],data5[4],data6[4],data7[4] }), 
        .in5({data0[5],data1[5],data2[5],data3[5],data4[5],data5[5],data6[5],data7[5] }), 
        .in6({data0[6],data1[6],data2[6],data3[6],data4[6],data5[6],data6[6],data7[6] }), 
        .in7({data0[7],data1[7],data2[7],data3[7],data4[7],data5[7],data6[7],data7[7] }), 
        .in8({data0[8],data1[8],data2[8],data3[8],data4[8],data5[8],data6[8],data7[8] }),  
        .in9({data0[9],data1[9],data2[9],data3[9],data4[9],data5[9],data6[9],data7[9] }), 
        .in10({data0[10],data1[10],data2[10],data3[10],data4[10],data5[10],data6[10],data7[10] }), 
        .in11({data0[11],data1[11],data2[11],data3[11],data4[11],data5[11],data6[11],data7[11] }), 
        .in12({data0[12],data1[12],data2[12],data3[12],data4[12],data5[12],data6[12],data7[12] }), 
        .in13({data0[13],data1[13],data2[13],data3[13],data4[13],data5[13],data6[13],data7[13] }), 
        .in14({data0[14],data1[14],data2[14],data3[14],data4[14],data5[14],data6[14],data7[14] }), 
        .in15({data0[15],data1[15],data2[15],data3[15],data4[15],data5[15],data6[15],data7[15] }), 
        .in16({data0[16],data1[16],data2[16],data3[16],data4[16],data5[16],data6[16],data7[16] }), 
        .in17({data0[17],data1[17],data2[17],data3[17],data4[17],data5[17],data6[17],data7[17] }), 
        .in18({data0[18],data1[18],data2[18],data3[18],data4[18],data5[18],data6[18],data7[18] }), 
        .in19({data0[19],data1[19],data2[19],data3[19],data4[19],data5[19],data6[19],data7[19] }), 
        .in20({data0[20],data1[20],data2[20],data3[20],data4[20],data5[20],data6[20],data7[20] }), 
        .in21({data0[21],data1[21],data2[21],data3[21],data4[21],data5[21],data6[21],data7[21] }), 
        .in22({data0[22],data1[22],data2[22],data3[22],data4[22],data5[22],data6[22],data7[22] }), 
        .in23({data0[23],data1[23],data2[23],data3[23],data4[23],data5[23],data6[23],data7[23] }), 
        .in24({data0[24],data1[24],data2[24],data3[24],data4[24],data5[24],data6[24],data7[24] }), 
        .in25({data0[25],data1[25],data2[25],data3[25],data4[25],data5[25],data6[25],data7[25] }), 
        .in26({data0[26],data1[26],data2[26],data3[26],data4[26],data5[26],data6[26],data7[26] }), 
        .in27({data0[27],data1[27],data2[27],data3[27],data4[27],data5[27],data6[27],data7[27] }), 
        .in28({data0[28],data1[28],data2[28],data3[28],data4[28],data5[28],data6[28],data7[28] }), 
        .in29({data0[29],data1[29],data2[29],data3[29],data4[29],data5[29],data6[29],data7[29] }), 
        .in30({data0[30],data1[30],data2[30],data3[30],data4[30],data5[30],data6[30],data7[30] }), 
        .in31({data0[31],data1[31],data2[31],data3[31],data4[31],data5[31],data6[31],data7[31] }), 
        .sel(selector), 
        .out(seldata)
    );



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
        selector <= 0;
        `include "data.dat"
    end
	else begin
        if(selector == 31)
            data_available <= 0;
        if(selector < 31)
            selector <= selector +1;
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

module mux (in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, sel, out);

    input [63:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31;
    input [4:0] sel;
    output reg [63:0] out;


    always @(in0 or in1 or in2 or in3 or in4 or in5 or in6 or in7 or in8 or in9 or in10 or in11 or in12 or in13 or in14 or in15 or in16 or in17 or in18 or in19 or in20 or in21 or in22 or in23 or in24 or in25 or in26 or in27 or in28 or in29 or in30 or in31 or sel)
        case (sel)
            5'd0 : out = in0;
            5'd1 : out = in1;
            5'd2 : out = in2;
            5'd3 : out = in3;
            5'd4 : out = in4;
            5'd5 : out = in5;
            5'd6 : out = in6;
            5'd7 : out = in7;
            5'd8 : out = in8;
            5'd9 : out = in9;
            5'd10 : out = in10;
            5'd11 : out = in11;
            5'd12 : out = in12;
            5'd13 : out = in13;
            5'd14 : out = in14;
            5'd15 : out = in15;
            5'd16 : out = in16;
            5'd17 : out = in17;
            5'd18 : out = in18;
            5'd19 : out = in19;
            5'd20 : out = in20;
            5'd21 : out = in21;
            5'd22 : out = in22;
            5'd23 : out = in23;
            5'd24 : out = in24;
            5'd25 : out = in25;
            5'd26 : out = in26;
            5'd27 : out = in27;
            5'd28 : out = in28;
            5'd29 : out = in29;
            5'd30 : out = in30;
            5'd31 : out = in31;

        endcase
endmodule 



