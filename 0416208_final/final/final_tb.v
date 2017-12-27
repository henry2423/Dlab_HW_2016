module average_tb;

	// Inputs
	reg clk;
	reg rst;

	wire zero_flag;
	wire [8:0] reg1;
	wire [8:0] reg2;
	wire [8:0] reg3;
	wire [8:0] reg4;

	

	//parameter        CYCLE        = 10;
	always begin #5 clk = ~clk; end

	// Instantiate the Unit Under Test (UUT)
	final_project pj (
		.clk(clk), 
		.reset(rst), 
		.zero_flag(zero_flag),
		.reg1(reg1),
		.reg2(reg2),
		.reg3(reg3),
		.reg4(reg4)
	);



	initial begin
		$dumpfile("proj.vcd");
    	$dumpvars;
		// Initialize Inputs
		clk = 0;
		rst = 1;

		#10; 
		rst = 0;
		
		#400;
		$finish;

	end
      
endmodule