`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:43:16 10/20/2015 
// Design Name: 
// Module Name:    lab5 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// matrix_additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module lab6(
    input clk,
    input reset,
    input button,
    input rx,
    output tx,
    output [7:0] led
    );

localparam [1:0] S_IDLE = 2'b00, S_Waitmatrix_aIT = 2'b01, S_SEND = 2'b10, S_INCR = 2'b11;
localparam MEM_SIZE = 130;

// declare system variables
wire btn_pressed;
reg [7:0] send_counter;
reg [1:0] Q, Q_next;
reg [7:0] data[0:MEM_SIZE-1];
integer idx;

// declare Umatrix_aRT signals
wire transmit;
wire received;
wire [7:0] rx_byte;
reg  [7:0] rx_temp;
wire [7:0] tx_byte;
wire is_receiving;
wire is_transmitting;
wire recv_error;

assign led = { 7'b0, button };
assign tx_byte = data[send_counter];

debounce btn_db(
    .clk(clk),
    .btn_input(button),
    .btn_output(btn_pressed)
    );

uart uart(
    .clk(clk),
    .rst(reset),
    .rx(rx),
    .tx(tx),
    .transmit(transmit),
    .tx_byte(tx_byte),
    .received(received),
    .rx_byte(rx_byte),
    .is_receiving(is_receiving),
    .is_transmitting(is_transmitting),
    .recv_error(recv_error)
    );

wire [7:0] receive_correct;
assign receive_correct=rx_byte-48;
// Initializes the "Hello, World! " string
/*always begin
  data[ 0] = 8'h48;
  data[ 1] = 8'h65;
  data[ 2] = 8'h6C;
  data[ 3] = 8'h6C;
  data[ 4] = 8'h6F;
  data[ 5] = 8'h2C;
  data[ 6] = 8'h20;
  data[ 7] = 8'h57;
  data[ 8] = 8'h6F;
  data[ 9] = 8'h72;
  data[10] = 8'h6C;
  data[11] = 8'h64;
  data[12] = 8'h21;
  data[13] = 8'h20;
  data[14] = 8'h0;  // end of string
  for (idx = 15; idx < MEM_SIZE; idx = idx + 1) data[idx] = 8'h0;
end
*/
// ------------------------------------------------------------------------
// FSM of the "Hello, World!" transmission controller

always @(posedge clk) begin
  if (reset) Q <= S_IDLE;
  else Q <= Q_next;
end

always @(*) begin // FSM next-state logic
  case (Q)
    S_IDLE: // wait for button click
      if (btn_pressed == 1) Q_next = S_Waitmatrix_aIT;
      else Q_next = S_IDLE;
    S_Waitmatrix_aIT: // wait for the transmission of current data byte begins
      if (is_transmitting == 1) Q_next = S_SEND;
      else Q_next = S_Waitmatrix_aIT;
    S_SEND: // wait for the transmission of current data byte finishes
      if (is_transmitting == 0) Q_next = S_INCR; // transmit next character
      else Q_next = S_SEND;
    S_INCR:
      if (tx_byte == 8'h0) Q_next = S_IDLE; // string transmission ends
      else Q_next = S_Waitmatrix_aIT;
  endcase
end

// FSM output logics
assign transmit = (Q == S_Waitmatrix_aIT)? 1 : 0;

// FSM-controlled send_counter incrementing data path
always @(posedge clk) begin
  if (reset || (Q == S_IDLE))
    send_counter <= 0;
  else if (Q == S_INCR)
    send_counter <= send_counter + 1;
end

// End of the FSM of the "Hello, World! " transmission controller
// ------------------------------------------------------------------------

// ------------------------------------------------------------------------
// The following logic stores the Umatrix_aRT input in a temporary buffer
// You must replace this code by your own code to store multiple
// bytes of data.
//
integer counter=0;
integer i=0, j=0;
reg rx_receiving_done;
reg [7:0]matrix_a[0:15];
reg [7:0]matrix_v[0:3];
reg [7:0]matrix_b[0:15];
always @(posedge clk) begin
  if (reset) begin
    rx_temp <= 8'b0;
    i = 0;
    for(j=0; j<16; j=j+1)
    begin
      matrix_a[j] <= 8'b0;
    end
    for(j=0; j<4; j=j+1)
    begin
      matrix_v[j] <= 8'b0;
    end
    for(j=0; j<16; j=j+1)
    begin
      matrix_b[j] <= 8'b0;
    end
    rx_receiving_done = 0;
		counter = 0;
  end else if (received) begin
    case(counter)
      0:
      begin
        rx_temp <= rx_temp + receive_correct*100;
        counter=counter+1;
      end
      1:
      begin
        rx_temp <= rx_temp + receive_correct*10;
        counter=counter+1;
      end
      2:
      begin
        rx_temp <= rx_temp + receive_correct;
        counter=counter+1;
      end
    endcase
  end else if(counter==3) begin
    counter=0;
    if(i<=15)
      begin
      matrix_a[i]<=rx_temp;
      i=i+1;
      end
    else if(i<=19)
      begin
      matrix_v[i-16]<=rx_temp;
      i=i+1;
      end
    else if(i<=35)
      begin
      matrix_b[i-20]<=rx_temp;
      i=i+1;
      end

    if(i==36)
      rx_receiving_done = 1;
    rx_temp<=0;
  end
end





reg [19:0] ans_a [0:3];
reg [19:0] ans_b [0:15];
integer matrixA_pos , part_b_pos , matrix_a_part_b_pos , matrix_b_part_b_pos , part_a_pos, matrixV_pos;

always @(posedge clk) begin
  
  if(reset) begin
  matrixA_pos <= 0;
  part_b_pos <= 0;
  matrix_a_part_b_pos <= 0;
  matrix_b_part_b_pos <= 0;
  part_a_pos <= 0;
	matrixV_pos <= 0;
  for(j=0; j<4; j=j+1)
  begin
    ans_a[j] <= 8'b0;
  end

  for(j=0; j<16; j=j+1)
  begin
    ans_b[j] <= 8'b0;
  end

end else if(rx_receiving_done == 1) begin

  if(matrixA_pos<=15) begin
    //ans_a[part_a_pos] <= matrix_a[matrixA_pos] * matrix_v[0] + matrix_a[matrixA_pos+1] * matrix_v[1] + matrix_a[matrixA_pos+2] * matrix_v[2] + matrix_a[matrixA_pos+3] * matrix_v[3];
		ans_a[part_a_pos] <= ans_a[part_a_pos] + matrix_a[matrixA_pos] * matrix_v[matrixV_pos];
		
		if(matrixV_pos == 3)	begin
				matrixV_pos <= 0;
				part_a_pos <= part_a_pos + 1;
		end else begin
				matrixV_pos <= matrixV_pos + 1;
				part_a_pos <= part_a_pos;
		end


		matrixA_pos <= matrixA_pos + 1;
	end
  else if(matrix_a_part_b_pos<=15) begin
    ans_b[part_b_pos] <= matrix_a[matrix_a_part_b_pos] * matrix_b[matrix_b_part_b_pos] + matrix_a[ matrix_a_part_b_pos + 1] * matrix_b[matrix_b_part_b_pos + 4] + matrix_a[matrix_a_part_b_pos + 2] * matrix_b[matrix_b_part_b_pos + 8] + matrix_a[matrix_a_part_b_pos + 3] * matrix_b[matrix_b_part_b_pos+ 12];

    if(matrix_b_part_b_pos<3)begin
      part_b_pos <= part_b_pos + 1;
      matrix_b_part_b_pos <= matrix_b_part_b_pos + 1;
    end else if(matrix_b_part_b_pos==3) begin
      part_b_pos <= part_b_pos + 1;
      matrix_b_part_b_pos <= 0;
      matrix_a_part_b_pos <= matrix_a_part_b_pos + 4;
    end
		
		
  end
	
	/*
  part_a_pos = part_a_pos + 1;
  matrixA_pos = matrixA_pos + 4;
	*/
end
end




always @(posedge clk) begin
  if(reset) begin 
	
			for (idx = 0; idx < MEM_SIZE; idx = idx + 1) begin 
				data[idx] <= 8'h0;
      end
				
  end
  else if(part_b_pos>=15) begin

      data[0]<= (ans_a[0][19:16]>9 )? ans_a[0][19:16]+55: ans_a[0][19:16]+48;
      data[1]<= (ans_a[0][15:12]>9 )? ans_a[0][15:12]+55: ans_a[0][15:12]+48;
      data[2]<= (ans_a[0][11:8]>9 )? ans_a[0][11:8]+55: ans_a[0][11:8]+48;
			//data[3]<= (ans_a[0][7:4] <= 4'd9 && ans_a[0][7:4] >= 4'd0)? ans_a[0][7:4]+48: ans_a[0][7:4]+d55;
      data[3]<= (ans_a[0][7:4]>9 )? ans_a[0][7:4]+55: ans_a[0][7:4]+48;
      data[4]<= (ans_a[0][3:0]>9 )? ans_a[0][3:0]+55: ans_a[0][3:0]+48;
      data[5]<=13;
      data[6]<=10;
      data[7]<= (ans_a[1][19:16]>9 )? ans_a[1][19:16]+55: ans_a[1][19:16]+48;
      data[8]<= (ans_a[1][15:12]>9 )? ans_a[1][15:12]+55: ans_a[1][15:12]+48;
      data[9]<= (ans_a[1][11:8]>9 )? ans_a[1][11:8]+55: ans_a[1][11:8]+48;
      data[10]<= (ans_a[1][7:4]>9 )? ans_a[1][7:4]+55: ans_a[1][7:4]+48;
      data[11]<= (ans_a[1][3:0]>9 )? ans_a[1][3:0]+55: ans_a[1][3:0]+48;
      data[12]<=13;
      data[13]<=10;
      data[14]<= (ans_a[2][19:16]>9 )? ans_a[2][19:16]+55: ans_a[2][19:16]+48;
      data[15]<= (ans_a[2][15:12]>9 )? ans_a[2][15:12]+55: ans_a[2][15:12]+48;
      data[16]<= (ans_a[2][11:8]>9 )? ans_a[2][11:8]+55: ans_a[2][11:8]+48;
      data[17]<= (ans_a[2][7:4]>9 )? ans_a[2][7:4]+55: ans_a[2][7:4]+48;
      data[18]<= (ans_a[2][3:0]>9 )? ans_a[2][3:0]+55: ans_a[2][3:0]+48;
      data[19]<=13;
      data[20]<=10;
      data[21]<= (ans_a[3][19:16]>9 )? ans_a[3][19:16]+55: ans_a[3][19:16]+48;
      data[22]<= (ans_a[3][15:12]>9 )? ans_a[3][15:12]+55: ans_a[3][15:12]+48;
      data[23]<= (ans_a[3][11:8]>9 )? ans_a[3][11:8]+55: ans_a[3][11:8]+48;
      data[24]<= (ans_a[3][7:4]>9 )? ans_a[3][7:4]+55: ans_a[3][7:4]+48;
      data[25]<= (ans_a[3][3:0]>9 )? ans_a[3][3:0]+55: ans_a[3][3:0]+48;
      data[26]<=13;
      data[27]<=10;
            
      data[28]<= (ans_b[0][19:16]>9 )? ans_b[0][19:16]+55: ans_b[0][19:16]+48;
      data[29]<= (ans_b[0][15:12]>9 )? ans_b[0][15:12]+55: ans_b[0][15:12]+48;
      data[30]<= (ans_b[0][11:8]>9 )? ans_b[0][11:8]+55: ans_b[0][11:8]+48;
      data[31]<= (ans_b[0][7:4]>9 )? ans_b[0][7:4]+55: ans_b[0][7:4]+48;
      data[32]<= (ans_b[0][3:0]>9 )? ans_b[0][3:0]+55: ans_b[0][3:0]+48;
      data[33]<= 32;
      data[34]<= (ans_b[1][19:16]>9 )? ans_b[1][19:16]+55: ans_b[1][19:16]+48;
      data[35]<= (ans_b[1][15:12]>9 )? ans_b[1][15:12]+55: ans_b[1][15:12]+48;
      data[36]<= (ans_b[1][11:8]>9 )? ans_b[1][11:8]+55: ans_b[1][11:8]+48;
      data[37]<= (ans_b[1][7:4]>9 )? ans_b[1][7:4]+55: ans_b[1][7:4]+48;
      data[38]<= (ans_b[1][3:0]>9 )? ans_b[1][3:0]+55: ans_b[1][3:0]+48;
      data[39]<= 32;
      data[40]<= (ans_b[2][19:16]>9 )? ans_b[2][19:16]+55: ans_b[2][19:16]+48;
      data[41]<= (ans_b[2][15:12]>9 )? ans_b[2][15:12]+55: ans_b[2][15:12]+48;
      data[42]<= (ans_b[2][11:8]>9 )? ans_b[2][11:8]+55: ans_b[2][11:8]+48;
      data[43]<= (ans_b[2][7:4]>9 )? ans_b[2][7:4]+55: ans_b[2][7:4]+48;
      data[44]<= (ans_b[2][3:0]>9 )? ans_b[2][3:0]+55: ans_b[2][3:0]+48;
      data[45]<= 32;
      data[46]<= (ans_b[3][19:16]>9 )? ans_b[3][19:16]+55: ans_b[3][19:16]+48;
      data[47]<= (ans_b[3][15:12]>9 )? ans_b[3][15:12]+55: ans_b[3][15:12]+48;
      data[48]<= (ans_b[3][11:8]>9 )? ans_b[3][11:8]+55: ans_b[3][11:8]+48;
      data[49]<= (ans_b[3][7:4]>9 )? ans_b[3][7:4]+55: ans_b[3][7:4]+48;
      data[50]<= (ans_b[3][3:0]>9 )? ans_b[3][3:0]+55: ans_b[3][3:0]+48;
      data[51]<= 13;
      data[52]<= 10;
      data[53]<= (ans_b[4][19:16]>9 )? ans_b[4][19:16]+55: ans_b[4][19:16]+48;
      data[54]<= (ans_b[4][15:12]>9 )? ans_b[4][15:12]+55: ans_b[4][15:12]+48;
      data[55]<= (ans_b[4][11:8]>9 )? ans_b[4][11:8]+55: ans_b[4][11:8]+48;
      data[56]<= (ans_b[4][7:4]>9 )? ans_b[4][7:4]+55: ans_b[4][7:4]+48;
      data[57]<= (ans_b[4][3:0]>9 )? ans_b[4][3:0]+55: ans_b[4][3:0]+48;
      data[58]<= 32;
      data[59]<= (ans_b[5][19:16]>9 )? ans_b[5][19:16]+55: ans_b[5][19:16]+48;
      data[60]<= (ans_b[5][15:12]>9 )? ans_b[5][15:12]+55: ans_b[5][15:12]+48;
      data[61]<= (ans_b[5][11:8]>9 )? ans_b[5][11:8]+55: ans_b[5][11:8]+48;
      data[62]<= (ans_b[5][7:4]>9 )? ans_b[5][7:4]+55: ans_b[5][7:4]+48;
      data[63]<= (ans_b[5][3:0]>9 )? ans_b[5][3:0]+55: ans_b[5][3:0]+48;
      data[64]<= 32;
      data[65]<= (ans_b[6][19:16]>9 )? ans_b[6][19:16]+55: ans_b[6][19:16]+48;
      data[66]<= (ans_b[6][15:12]>9 )? ans_b[6][15:12]+55: ans_b[6][15:12]+48;
      data[67]<= (ans_b[6][11:8]>9 )? ans_b[6][11:8]+55: ans_b[6][11:8]+48;
      data[68]<= (ans_b[6][7:4]>9 )? ans_b[6][7:4]+55: ans_b[6][7:4]+48;
      data[69]<= (ans_b[6][3:0]>9 )? ans_b[6][3:0]+55: ans_b[6][3:0]+48;
      data[70]<= 32;
      data[71]<= (ans_b[7][19:16]>9 )? ans_b[7][19:16]+55: ans_b[7][19:16]+48;
      data[72]<= (ans_b[7][15:12]>9 )? ans_b[7][15:12]+55: ans_b[7][15:12]+48;
      data[73]<= (ans_b[7][11:8]>9 )? ans_b[7][11:8]+55: ans_b[7][11:8]+48;
      data[74]<= (ans_b[7][7:4]>9 )? ans_b[7][7:4]+55: ans_b[7][7:4]+48;
      data[75]<= (ans_b[7][3:0]>9 )? ans_b[7][3:0]+55: ans_b[7][3:0]+48;
      data[76]<= 13;
      data[77]<= 10;
      data[78]<= (ans_b[8][19:16]>9 )? ans_b[8][19:16]+55: ans_b[8][19:16]+48;
      data[79]<= (ans_b[8][15:12]>9 )? ans_b[8][15:12]+55: ans_b[8][15:12]+48;
      data[80]<= (ans_b[8][11:8]>9 )? ans_b[8][11:8]+55: ans_b[8][11:8]+48;
      data[81]<= (ans_b[8][7:4]>9 )? ans_b[8][7:4]+55: ans_b[8][7:4]+48;
      data[82]<= (ans_b[8][3:0]>9 )? ans_b[8][3:0]+55: ans_b[8][3:0]+48;
      data[83]<= 32;
      data[84]<= (ans_b[9][19:16]>9 )? ans_b[9][19:16]+55: ans_b[9][19:16]+48;
      data[85]<= (ans_b[9][15:12]>9 )? ans_b[9][15:12]+55: ans_b[9][15:12]+48;
      data[86]<= (ans_b[9][11:8]>9 )? ans_b[9][11:8]+55: ans_b[9][11:8]+48;
      data[87]<= (ans_b[9][7:4]>9 )? ans_b[9][7:4]+55: ans_b[9][7:4]+48;
      data[88]<= (ans_b[9][3:0]>9 )? ans_b[9][3:0]+55: ans_b[9][3:0]+48;
      data[89]<= 32;
      data[90]<= (ans_b[10][19:16]>9 )? ans_b[10][19:16]+55: ans_b[10][19:16]+48;
      data[91]<= (ans_b[10][15:12]>9 )? ans_b[10][15:12]+55: ans_b[10][15:12]+48;
      data[92]<= (ans_b[10][11:8]>9 )? ans_b[10][11:8]+55: ans_b[10][11:8]+48;
      data[93]<= (ans_b[10][7:4]>9 )? ans_b[10][7:4]+55: ans_b[10][7:4]+48;
      data[94]<= (ans_b[10][3:0]>9 )? ans_b[10][3:0]+55: ans_b[10][3:0]+48;
      data[95]<= 32;
      data[96]<= (ans_b[11][19:16]>9 )? ans_b[11][19:16]+55: ans_b[11][19:16]+48;
      data[97]<= (ans_b[11][15:12]>9 )? ans_b[11][15:12]+55: ans_b[11][15:12]+48;
      data[98]<= (ans_b[11][11:8]>9 )? ans_b[11][11:8]+55: ans_b[11][11:8]+48;
      data[99]<= (ans_b[11][7:4]>9 )? ans_b[11][7:4]+55: ans_b[11][7:4]+48;
      data[100]<= (ans_b[11][3:0]>9 )? ans_b[11][3:0]+55: ans_b[11][3:0]+48;
      data[101]<= 13;
      data[102]<= 10;
      data[103]<= (ans_b[12][19:16]>9 )? ans_b[12][19:16]+55: ans_b[12][19:16]+48;
      data[104]<= (ans_b[12][15:12]>9 )? ans_b[12][15:12]+55: ans_b[12][15:12]+48;
      data[105]<= (ans_b[12][11:8]>9 )? ans_b[12][11:8]+55: ans_b[12][11:8]+48;
      data[106]<= (ans_b[12][7:4]>9 )? ans_b[12][7:4]+55: ans_b[12][7:4]+48;
      data[107]<= (ans_b[12][3:0]>9 )? ans_b[12][3:0]+55: ans_b[12][3:0]+48;
      data[108]<= 32;
      data[109]<= (ans_b[13][19:16]>9 )? ans_b[13][19:16]+55: ans_b[13][19:16]+48;
      data[110]<= (ans_b[13][15:12]>9 )? ans_b[13][15:12]+55: ans_b[13][15:12]+48;
      data[111]<= (ans_b[13][11:8]>9 )? ans_b[13][11:8]+55: ans_b[13][11:8]+48;
      data[112]<= (ans_b[13][7:4]>9 )? ans_b[13][7:4]+55: ans_b[13][7:4]+48;
      data[113]<= (ans_b[13][3:0]>9 )? ans_b[13][3:0]+55: ans_b[13][3:0]+48;
      data[114]<= 32;
      data[115]<= (ans_b[14][19:16]>9 )? ans_b[14][19:16]+55: ans_b[14][19:16]+48;
      data[116]<= (ans_b[14][15:12]>9 )? ans_b[14][15:12]+55: ans_b[14][15:12]+48;
      data[117]<= (ans_b[14][11:8]>9 )? ans_b[14][11:8]+55: ans_b[14][11:8]+48;
      data[118]<= (ans_b[14][7:4]>9 )? ans_b[14][7:4]+55: ans_b[14][7:4]+48;
      data[119]<= (ans_b[14][3:0]>9 )? ans_b[14][3:0]+55: ans_b[14][3:0]+48;
      data[120]<= 32;
      data[121]<= (ans_b[15][19:16]>9 )? ans_b[15][19:16]+55: ans_b[15][19:16]+48;
      data[122]<= (ans_b[15][15:12]>9 )? ans_b[15][15:12]+55: ans_b[15][15:12]+48;
      data[123]<= (ans_b[15][11:8]>9 )? ans_b[15][11:8]+55: ans_b[15][11:8]+48;
      data[124]<= (ans_b[15][7:4]>9 )? ans_b[15][7:4]+55: ans_b[15][7:4]+48;
      data[125]<= (ans_b[15][3:0]>9 )? ans_b[15][3:0]+55: ans_b[15][3:0]+48;  
			data[126]<= 13;
      data[127]<= 10;
			data[128]<= 0;
    end
end



endmodule


