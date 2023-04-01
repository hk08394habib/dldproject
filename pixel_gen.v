`timescale 1ns / 1ps
module make_current_pixel(input clk_d, input [9:0] x_loc, input [9:0] y_loc, input video_on, output [3:0]red, output [3:0]green, output [3:0]blue);

	wire [19:0] ram_addr;//since we have 20 bit array 
	wire [11:0] ram_read;//since the stored value is 12 bits
	reg [11:0] ram_write;//in case we need to write. no use for now. 
	reg ram_writeenable = 0;

	assign ram_addr = {row, column}; //hpos gives row vpos gives column

	wire [9:0]row = x_loc;
	wire [9:0]column = y_loc;
	
	//RAM_init initializeram(.clk_d(clk_d));
	RAM_sync ram(.clk_d(clk_d),.dout(ram_read), .din(ram_write), .addr(ram_addr), .we(ram_writeenable));
	/*
	initial begin
		$display("%12b",ram_read[11:0]);
	end*/

	wire [11:0] color = ram_read[11:0];
	//when video_on is 0 then set rgb to black 
	assign blue = color[3:0] && video_on;
	assign green = color[7:4] && video_on;
	assign red = color[11:8] && video_on;

endmodule
