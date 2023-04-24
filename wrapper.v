`timescale 1ns / 1ps
module wrapper( 
	input clk,
	input signed [10:0] sprite_x, //player
	input signed [10:0] sprite_y,
	input [9:0] x, //beam
	input [9:0] y,
	output [11:0]rgb,
	output sprite_on);

	localparam ROWWIDTH = 4;
	localparam COLUMNWIDTH = 3;

	reg [ROWWIDTH : 0]row = 0;
	reg [COLUMNWIDTH : 0]col = 0;
	
	wire clk_d;
	clk_div trackhpos(.clk(clk),.clk_d(clk_d));
	
	reg [3:0]coloffset=0;
	reg [3:0]rowoffset=0;
	reg [3:0]timesread=0;
	reg [3:0]duplicatedlines=0;

	wire signed [10:0]x_signed,y_signed;

	assign x_signed = {1'b0,x};
	assign y_signed = {1'b0,y};
	assign sprite_on = (x_signed - sprite_x < 100 && y_signed - sprite_y < 200 && x_signed - sprite_x >= 0 && y_signed - sprite_y >= 0) ? 1 : 0;

/*
	always @(negedge sprite_on) begin
		timesread = 0;
		duplicatedlines <= duplicatedlines + 1;
	end*/
	
	always @(posedge clk_d) begin

			if (sprite_on) begin
				timesread = timesread + 1;
			end

			if (timesread == 10) begin //once you've read the same col 10 times, now read the next entry
				col = col + 1;
				timesread = 0;
			end

			if (col == 10) begin
				duplicatedlines = duplicatedlines + 1;
				col = 0;
			end

			if (duplicatedlines == 10) begin //once you've done it 10 times, now read the next row entry
				duplicatedlines =0;
				row = row + 1;
			end

			if (row == 20) begin
				row = 0;
			end
		end
	

	test_rom test(.clk(clk),.row(row),.col(col),.color_data(rgb));

endmodule

