`timescale 1ns / 1ps 

module fighting(
		input clk,
		input [7:0]pb,
		output h_sync, 
		output v_sync,
		output [2:0]rgb);

	wire video_on;
	wire [9:0] hpos;
	wire [9:0] vpos;

	reg [9:0] p1_hpos = 128;
	reg [9:0] p1_vpos = 400;

	reg [9:0] p2_hpos = 10;
	reg [9:0] p2_vpos = 400;

	localparam plength = 40;
	localparam pwidth = 20;
	
	wire [9:0]dx1,dy1;
	wire [9:0]dx2,dy2;
	reg [9:0]nf1,nf2;


	//switches as seperate controls for green and red
	moving movelogicp1(
		clk,
		pb[3:0],
		dx1,
		dy1);

	moving movelogicp2(
		clk,
		pb[7:4],
		dx2,
		dy2);

	gen_sync sync(.clk(clk),.h_sync(h_sync),.v_sync(v_sync), .video_on(video_on), .x_loc(hpos), .y_loc(vpos));

	always @(posedge v_sync)
	begin
		p1_hpos <= p1_hpos + dx1;
		p1_vpos <= p1_vpos + dy1 + nf1 + 1; //constant gravity

		p2_hpos <= p2_hpos + dx2;
		p2_vpos <= p2_vpos + dy2 + nf2 + 1;
	end

	always @(posedge p1_grounded)
	begin
		nf1 <= -1; //normal force pushing up
	end

	always @(posedge p2_grounded)
	begin
		nf2 <= -1;
	end

	wire p1_grounded = (p1_vpos >= (640 - plength));
	wire p2_grounded = (p2_vpos >= (640 - plength));

	
	wire [9:0] p1_hdiff = hpos - p1_hpos;
	wire [9:0] p1_vdiff = vpos - p1_vpos;

	wire [9:0] p2_hdiff = hpos - p2_hpos;
	wire [9:0] p2_vdiff = vpos - p2_vpos;

	wire p1gfx = (p1_hdiff < pwidth) && (p1_vdiff < plength);
	wire p2gfx = (p2_hdiff < pwidth) && (p2_vdiff < plength);

	wire grid_gfx = (((hpos & 7) == 0) && ((vpos & 7)==0));

	wire r = video_on && (p1gfx);
	wire b = video_on  && (p2gfx);
	wire g = video_on && (grid_gfx);


	assign rgb = {b,g,r};
endmodule

module moving(
		input clk,
		input [3:0]pb,
		output reg [9:0]dx,
		output reg [9:0]dy);
		always @(posedge clk)
		begin
			case (pb)
				4'b0001 : begin
					dx <= 1;
					dy <= 0;
				end

				4'b0010 : begin
					dx <= 0;
					dy <= -1;
				end

				4'b1000 : begin
					dx <= 0;
					dy <= 1;
				end

				4'b0100 : begin
					dx <= -1;
					dy <= 0;
				end
				default : begin
					dx <= 0;
					dy <= 0;
				end
			endcase
		end
	endmodule
