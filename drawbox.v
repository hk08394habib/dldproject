`timescale 1ms / 1ms


module drawbox(
	input [9:0]xpos, //for the player
	input [9:0]ypos,
	input [9:0]hpos, //for the beam
	input [9:0]vpos,
	input [9:0]width,
	input [9:0]height,
	output gfx);
	
	wire [9:0]hdiff = hpos - xpos;
	wire [9:0]vdiff = vpos - ypos;

	assign gfx = (hdiff < width) && (vdiff < height);
endmodule

/*
module test();
	reg clk = 0;

	always
		#1 clk = ~clk;

	wire h_sync,v_sync,video_on;
	wire p1gfx;
	wire [9:0]hpos,vpos;
	wire[9:0]p1xpos,p1ypos,p1width,p1height;

	assign p1xpos = 100;
	assign p1ypos = 100;
	assign p1width = 100;
	assign p1height = 100;

	gen_sync sync(.clk(clk),.h_sync(h_sync),.v_sync(v_sync), .video_on(video_on), .x_loc(hpos), .y_loc(vpos));
	drawbox p1(.xpos(p1xpos),.ypos(p1ypos),.hpos(hpos),.vpos(vpos),.width(p1width),.height(p1height),.gfx(p1gfx));
	
	wire kickgfx;
	wire[9:0]kxpos,kypos,kwidth,kheight;

	assign kxpos = 90;
	assign kypos = 90;
	assign kwidth = 20;
	assign kheight = 20;
	
	wire collision;

	drawbox kick(.xpos(kxpos),.ypos(kypos),.hpos(hpos),.vpos(vpos),.width(kwidth),.height(kheight),.gfx(kgfx));
	
	assign collision = kgfx && p1gfx;


	initial begin
		$dumpvars;
		#10000000 $finish;
	end
endmodule
*/

