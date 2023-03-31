`timescale 1ns / 1ps
module memory; //store screen in memory
	reg [11:0] screen[9:0][9:0];
endmodule

module pixel_create(input clk_d); //set defaults 
	integer i,j;
	initial begin 
		for (i=0; i <= 9; i = i + 1) begin 
			for (j=0; j <= 9; j = j + 1) begin 
				if (i % 3 == 0)
					memory.screen[i][j] = 12'b100000000001;
				else if (j % 3 == 0) begin
					memory.screen[i][j] = 12'b010101010101;
				end else
					memory.screen[i][j] = 12'b111111111111;
				$write("%12b ", memory.screen[i][j]);
			end 
			$display("\n");
			end
			end
endmodule

module make_current_pixel(input clk_d, input [9:0] x_loc, input [9:0] y_loc, input video_on, output reg [3:0]red, output reg [3:0]green, output reg [3:0]blue);
	reg [11:0] colors;
	always @(posedge clk_d) begin
		if (video_on == 1) begin //if video is supposed to be on, then read from memory
			colors = memory.screen[x_loc][y_loc];
			blue = colors[3:0];
			green = colors[7:4];
			red = colors[11:8];
		end else begin //otherwise assign black 
			blue <= 3'b000;
			green <= 3'b000;
			red <= 3'b000;
		end
		$display("%4b,%4b,%4b", red,green,blue);
	end 
endmodule

module t_cur_pix(); //test whether this works or not 
	wire [3:0] red;
	wire [3:0] green;
	wire [3:0] blue;
	reg [9:0] x_loc;
	reg [9:0] y_loc;
	reg video_on = 1;
	reg clk;
	wire clk_d;
	reg [9:0] c1,c2;
	reg stop = 0;

	initial begin 
		clk = 1'b0;
	end
	always 
		#5 clk <= ~clk;
	initial 
		#10000 $finish;
	clk_div dividedclock(.clk(clk),.clk_d(clk_d));
	pixel_create initiatepixels(.clk_d(clk_d));
	reg start = 1;
	always @(posedge clk) begin
		if (start) begin
			for (integer i = 0; i <= 9; i = i + 1) begin
				for (integer j = 0; j <= 9; j = j + 1) begin
					#100;
					c1 = j;
					c2 = i;
					$display("%12b,%2d,%2d", memory.screen[c1][c2],c1,c2);
				end
				end
		end else begin 
			$display("stopped");
		end
	end
	make_current_pixel test(.clk_d(clk_d), .x_loc(c1), .y_loc(c2), .video_on(video_on), .red(red),.green(green),.blue(blue));
endmodule
