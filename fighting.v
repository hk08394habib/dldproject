`timescale 1ns / 1ps 

module fighting(
		input clk,
		input [9:0]sw,
		output h_sync, 
		output v_sync,
		output [2:0]rgb);

	wire video_on;
	wire [9:0] hpos;
	wire [9:0] vpos;

	wire [9:0]dx1,dy1;
	wire [9:0]dx2,dy2;

	//switches as seperate controls 
	moving movelogicp1(
		.clk(clk),
		.sw(sw[3:0]),
		.dx(dx1),
		.dy(dy1));

	moving movelogicp2(
		.clk(clk),
		.sw(sw[7:4]),
		.dx(dx2),
		.dy(dy2));

	//TODO: Add health
	//
	//TODO: Add health-bar module (call drawbox at top of scree, with width
	//proportional to the health of current character)
	//
	//TODO: Perhaps create master display module with mux to create priority between
	//display modules. Thus modules only have to send their personal display and
	//it will be handled by the master module.
	//
	//This will allow for more modularity and also backgrounds and sprites
	//
	//
	//
	//
	//TODO: Add jumping

	gen_sync sync(.clk(clk),.h_sync(h_sync),.v_sync(v_sync), .video_on(video_on), .x_loc(hpos), .y_loc(vpos));



	always @(negedge v_sync)
	//TODO: Add gravity & detect collision with the screen border
	//TODO: Don't allow players to pass through each other
	begin
		p1_hpos <= p1_hpos + dx1;
		p1_vpos <= p1_vpos + dy1; 

		p2_hpos <= p2_hpos + dx2;
		p2_vpos <= p2_vpos + dy2;
	end

	//draw the players
	reg [9:0] p1_hpos = 10;
	reg [9:0] p1_vpos = 200;

	reg [9:0] p2_hpos = 300;
	reg [9:0] p2_vpos = 200;
	
	reg [9:0]pheight = 200;
	reg [9:0]pwidth = 100;


	wire p1gfx,p2gfx;

	drawbox p1(.xpos(p1_hpos),.ypos(p1_vpos),.hpos(hpos),.vpos(vpos),.width(pwidth),.height(pheight),.gfx(p1gfx));
	drawbox p2(.xpos(p2_hpos),.ypos(p2_vpos),.hpos(hpos),.vpos(vpos),.width(pwidth),.height(pheight),.gfx(p2gfx));


	//kicking
	wire p1kickbg,p2kickbg;

	reg [9:0]kheight = 20;
	reg [9:0]kwidth = 100;


	wire [9:0]p1kick_hpos,p1kick_vpos;
	assign p1kick_hpos = p1_hpos + pwidth;
	assign p1kick_vpos = p1_vpos + pheight -kheight;

	wire [9:0]p2kick_hpos,p2kick_vpos;
	assign p2kick_hpos = p2_hpos - kwidth;
	assign p2kick_vpos = p2_vpos + pheight - kheight;

	drawbox p1kick(.xpos(p1kick_hpos),.ypos(p1kick_vpos),.hpos(hpos),.vpos(vpos),.width(kwidth),.height(kheight),.gfx(p1kickbg));
	drawbox p2kick(.xpos(p2kick_hpos),.ypos(p2kick_vpos),.hpos(hpos),.vpos(vpos),.width(kwidth),.height(kheight),.gfx(p2kickbg));
	
	//display kick when button is pressed
	wire p1kickbutton = sw[8];
	wire p2kickbutton = sw[9];
	
	wire p1kickgfx;
	assign p1kickgfx = p1kickbutton && p1kickbg;
	
	wire p2kickgfx;
	assign p2kickgfx = p2kickbutton && p2kickbg;
	
	//hit detection 
	wire p1hit;
	assign p1hit = p2kickgfx && p1gfx;

	wire p2hit;
	assign p2hit = p1kickgfx && p2gfx;

	//display gfx
	wire r,g,b;
	assign r = video_on && ((p1gfx) || (p1hit || p2hit));
	assign g = video_on  && (p2gfx) || (p1hit || p2hit);
	assign b = video_on && ((p1kickgfx || p2kickgfx) || (p1hit || p2hit));

	assign rgb = {b,g,r};
endmodule



module moving(
		input clk,
		input [3:0]sw,
		output reg [9:0]dx,
		output reg [9:0]dy);

		always @(posedge clk)
		begin
			case (sw)
				4'b0001 : begin
					dx <= 1;
					dy <= 0;
				end

				4'b0010 : begin
					dx <= -1;
					dy <= 0;
				end

				4'b0100 : begin
					dx <= 0;
					dy <= 1;
				end

				4'b1000 : begin
					dx <= 0;
					dy <= -1;
				end

				default : begin
					dx <= 0;
					dy <= 0;
				end

			endcase

		end
	endmodule
