`timescale 1ms / 1ms


module drawbox(
	input signed [10:0]xpos, //for the player
	input signed [10:0]ypos,
	input [9:0]hpos, //for the beam
	input [9:0]vpos,
	input [9:0]width,
	input [9:0]height,
	output gfx);
	
	wire [9:0]hdiff = hpos - xpos;
	wire [9:0]vdiff = vpos - ypos;

	assign gfx = (hdiff < width) && (vdiff < height);
endmodule

