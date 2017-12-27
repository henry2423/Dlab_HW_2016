
module debounce(input  clk, input btn_input, output btn_output);



parameter DEBOUNCE_PERIOD = 1000000; // 20 msec @ 50MHz 


reg [20:0] counter;
reg debounced_btn_state;
reg pressed;

assign btn_output = debounced_btn_state;

always@(posedge clk) begin
  if (btn_input == 0) begin
    counter <= 0;
    pressed <= 0;
  end else begin
    counter <= counter + 1;
    pressed <= (debounced_btn_state == 1)? 1 : 0;
  end
end

always@(posedge clk) begin
  // wait until the button is pressed continuously for 20 msec
  if (counter == DEBOUNCE_PERIOD && pressed == 0)
    debounced_btn_state <= 1;
  else
    debounced_btn_state <= (btn_input == 0)? 0 : btn_output;
end

/*
reg debounced_btn_state;
assign btn_output = debounced_btn_state;

parameter delay = 20;
reg clicked;
reg  [delay-1:0]  bounce;


always @(posedge clk)
	begin
      if (btn_input)
      begin
          bounce <= {bounce == 20'b11111111111111111111} ? bounce : bounce+1;
          if(&bounce && clicked == 0)
          begin
            clicked <= 1'b1;
            debounced_btn_state <= 1;
          end
		  end

      else if (~btn_input)
      begin
            bounce <= 0;
            clicked <= 0;
            debounced_btn_state <= 0;
      end
	end



endmodule
*/
/*
reg btn_click;
parameter delay = 20;
reg [delay-1:0] bounce;

reg debounced_btn_state;
assign btn_output = debounced_btn_state;

always @(posedge clk) begin
    if (btn_input == 0) begin
        bounce <= 0;
        btn_click <= 0;
        debounced_btn_state <= 0;
    end else if(btn_input == 1) begin
        if( &bounce && btn_click == 0) begin
            btn_click <= 1'b1;
            debounced_btn_state <= 1'b1;
        end else
            debounced_btn_state <= 0;
            bounce <= {bounce == 20'b11111111111111111111} ? bounce : bounce+1;
    end
end
*/