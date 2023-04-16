`timescale 1ns / 1ps 

module fighting(
		input clk,
		input [15:0]sw,
		output h_sync, 
		output v_sync,
		output [2:0]rgb,
		output [15:0]led);

	wire video_on;
	wire [9:0] hpos;
	wire [9:0] vpos;

	wire signed [10:0]dx1,dy1;
	wire signed [10:0]dx2,dy2;

	//switches as seperate controls 
	moving movelogicp1(
		.clk(clk),
		.sw(sw[2:0]), //right side of board is p1
		.dx(dx1),
		.dy(dy1));

	moving movelogicp2(
		.clk(clk),
		.sw(sw[14:12]), //left side of board is p2
		.dx(dx2),
		.dy(dy2));

	//display kick when button is pressed
	wire p1kickbutton = sw[3];
	wire p2kickbutton = sw[15];
	reg signed [10:0] p1health = 10'd300,p2health = 10'd300;
	reg signed [10:0]p1healthxpos = 0,p1healthypos=0,p2healthxpos=10'd339,p2healthypos=0;
	wire p1healthgfx,p2healthgfx;
	wire [9:0] healthheight = 40;


	drawbox p1healthbar(.xpos(p1healthxpos[9:0]),.ypos(p1healthypos[9:0]),.hpos(hpos),.vpos(vpos),.width(p1health[9:0]),.height(healthheight),.gfx(p1healthgfx));
	drawbox p2healthbar(.xpos(p2healthxpos[9:0]),.ypos(p2healthypos[9:0]),.hpos(hpos),.vpos(vpos),.width(p2health[9:0]),.height(healthheight),.gfx(p2healthgfx));

	//
	//TODO: Perhaps create master display module with mux to create priority between
	//display modules. Thus modules only have to send their personal display and
	//it will be handled by the master module.
	//
	//This will allow for more modularity and also backgrounds and sprites
	//
	//
	//
	//TODO: Create reset activated by sw[8] or when either health goes to 0

	gen_sync sync(.clk(clk),.h_sync(h_sync),.v_sync(v_sync), .video_on(video_on), .x_loc(hpos), .y_loc(vpos));

	reg p1hitflag = 0;
	reg p2hitflag = 0;

	always @(posedge clk) begin //create one signal if player was hit in the current frame
		if ((p1hit == 1) && (p1hitflag == 0)) 
			p1hitflag = 1;
		if ((p2hit == 1) && (p2hitflag == 0)) 
			p2hitflag = 1;
	end


	always @(negedge v_sync)
	begin

		//No collisions with borders
		
		if ((p1_hpos + dx1 + pwidth< 640) && (p1_hpos + dx1> 0)) 
		p1_hpos <= p1_hpos + dx1;
		if ((p2_hpos + dx2 + pwidth< 640) && (p2_hpos + dx2> 0)) 
		p2_hpos <= p2_hpos + dx2;

		if (( p1_vpos + dy1 + pheight< 480) && ( p1_vpos + dy1 > 0)) 
		p1_vpos <= p1_vpos + dy1; 
		if (( p2_vpos + dy2 + pheight< 480) && ( p2_vpos + dy2 > 0)) 
		p2_vpos <= p2_vpos + dy2; 

		p1hitflag = 0; //Reset hitflag
		p2hitflag = 0;

	end

	always @(posedge p1hitflag) //not working for some reason 
		//If hit then reduce health
			p1health <= p1health - 11'd100;
	always @(posedge p2hitflag) 
			p2health <= p2health - 11'd100;
			//p2healthxpos <= p2healthxpos + 11'd100;


	//draw the players
	reg signed [10:0] p1_hpos = 11'd300; 
	reg signed [10:0] p1_vpos = 11'd100;

	reg signed [10:0] p2_hpos = 11'd400;
	reg signed [10:0] p2_vpos = 11'd100;
	
	reg signed [10:0] pheight = 11'd200;
	reg signed [10:0] pwidth = 11'd100;


	wire p1gfx,p2gfx;

	drawbox p1(.xpos(p1_hpos[9:0]),.ypos(p1_vpos[9:0]),.hpos(hpos),.vpos(vpos),.width(pwidth[9:0]),.height(pheight[9:0]),.gfx(p1gfx));
	drawbox p2(.xpos(p2_hpos[9:0]),.ypos(p2_vpos[9:0]),.hpos(hpos),.vpos(vpos),.width(pwidth[9:0]),.height(pheight[9:0]),.gfx(p2gfx));

	//TODO: Add punching

	//kicking
	wire p1kickbg,p2kickbg;

	reg signed [10:0]kheight = 10'd20;
	reg signed [10:0]kwidth = 10'd100;


	wire signed [10:0]p1kick_hpos,p1kick_vpos;
	assign p1kick_hpos = p1_hpos + pwidth;
	assign p1kick_vpos = p1_vpos + pheight - kheight;

	wire signed [10:0]p2kick_hpos,p2kick_vpos;
	assign p2kick_hpos = p2_hpos - kwidth;
	assign p2kick_vpos = p2_vpos + pheight - kheight;

	drawbox p1kick(.xpos(p1kick_hpos[9:0]),.ypos(p1kick_vpos[9:0]),.hpos(hpos),.vpos(vpos),.width(kwidth[9:0]),.height(kheight[9:0]),.gfx(p1kickbg));
	drawbox p2kick(.xpos(p2kick_hpos[9:0]),.ypos(p2kick_vpos[9:0]),.hpos(hpos),.vpos(vpos),.width(kwidth[9:0]),.height(kheight[9:0]),.gfx(p2kickbg));
	
	
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
	//TODO: make this a mux with ternary operator i.e. ?
	/*assign r = video_on (((p1hit || p2hit)) || (p1healthgfx || p2healthgfx));
	assign g = video_on  && (p1gfx);
	assign b = video_on && (((p2gfx || p1kickgfx || p2kickgfx)));*/

	assign r = video_on && (((p1hit || p2hit)) || (p1healthgfx || p2healthgfx));
	assign g = video_on  && (p1gfx || p1kickgfx);
	assign b = video_on && (((p2gfx || p2kickgfx)));

	assign rgb = {b,g,r};

endmodule



module moving(
		input clk,
		input [2:0]sw,
		output reg [10:0]dx,
		output reg [10:0]dy);

		always @(posedge clk)
		begin
			case (sw)
				4'b001 : begin
					dx <= 11'd1;
					dy <= 11'd1;
				end

				4'b010 : begin
					dx <= -11'd1;
					dy <= 11'd1;
				end

				4'b100 : begin
					dx <= 11'd0;
					dy <= -11'd5;
				end

				default : begin //by default, you have gravity pulling down on you (increasing y corresponds to moving downwards)
					dx <= 11'd0;
					dy <= 11'd1;
				end

			endcase

		end
	endmodule
