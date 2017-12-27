`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:24:04 11/04/2016 
// Design Name: 
// Module Name:    lab3 
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
module lab3(
    input clk,
    input reset,
    input btn_east,
    input btn_west,
    output reg [7:0] led
    );

	//reg [7:0] counter;
	reg east_clicked;
	reg west_clicked;

	parameter delay = 20;

	/*
	assign led[0] = counter[0];
	assign led[1] = counter[1];
	assign led[2] = counter[2];
	assign led[3] = counter[3];
	assign led[4] = counter[3];
	assign led[5] = counter[3];
	assign led[6] = counter[3];
	assign led[7] = counter[3];
	*/

 
	reg  [delay-1:0]  bounce_west;
	reg  [delay-1:0]  bounce_east;


	always @(posedge reset or posedge clk) begin
   		if (reset == 1)
   		begin
      		led <= 8'd0;
      		west_clicked <= 0;
      		east_clicked <= 0;
      		bounce_west <= 0;
      		bounce_east <= 0;
      	end
      	else 
      		begin
       		if (btn_west)
				begin
					bounce_west <= {bounce_west == 20'b11111111111111111111} ? bounce_west : bounce_west+1;
					if(&bounce_west && led != 8'b00000111 && west_clicked == 0)
					begin
					   west_clicked <= 1'b1;
					   led <= led + 1;
					end
					else
					   led <= led;
					
		    	end

    		else if (btn_east)
				begin
		    		bounce_east <= {bounce_east == 20'b11111111111111111111} ? bounce_east : bounce_east+1;
					if(&bounce_east && led != 8'b11111000 && east_clicked == 0)
					begin
						east_clicked <= 1'b1;
						led <= led - 1;
					end
					else
					   led <= led;
		    	end
		    else if (~btn_east || ~btn_west)
		      	begin
		      		if(&bounce_west)
		      			bounce_west <= 0;
		      		if(&bounce_east)
		      			bounce_east <= 0;
						
		      			west_clicked <= 0;
		      			east_clicked <=0;
		        end

      			
      		end
	      	

    end










endmodule
