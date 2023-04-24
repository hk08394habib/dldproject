`timescale 1ns / 1ps
/*
module moving(
		input clk,
		input [3:0]sw,
		output reg [10:0]dx,
		output reg [10:0]dy,
		output kickon);
		
		assign kickon = kicklock;

		reg kicklock = 0;
		reg jumplock = 0;


		reg [20:0]kickDownCounter=2**20 - 1;
		reg [20:0]jumpDownCounter=2**20 - 1;

		always @(posedge clk) begin

			kickDownCounter = kickDownCounter - 1;
			jumpDownCounter = jumpDownCounter - 1;

			if (kickDownCounter == 0) begin
				kickDownCounter <= 2 ** 20 - 1;
				kicklock = 0;
			end

			if (jumpDownCounter == 0) begin
				jumpDownCounter <= 2 ** 20 - 1;
				jumplock = 0;
			end


		end

		always @(posedge sw[1]) begin
			if (kicklock != 1) begin
				jumplock = 0;
				kicklock = 1;
			end
			end


		always @(posedge clk) begin
			case (sw) 
				4'b0001 : begin  //move right
					dx <= 11'd2;
					dy <= 11'd0;
					jumplock = 0;
					kicklock = 0;
				end

				4'b0100 : begin 
				if (jumplock != 1) begin
					dx <= 11'd0;
					dy <= -11'd5;
					jumplock = 1;
					kicklock = 0;
				end
				end

				4'b1000 : begin
				dx <= -11'd2;
				dy <= 11'd0;
				jumplock = 0;
				kicklock = 0;

			end

				default : begin
					if (sw[1] != 1) begin
						dx <= 11'd0;
						dy <= 11'd10;
					end
			end
		endcase
	end
	endmodule
*/



module moving(
		input clk,
		input [3:0]sw,
		output reg [10:0]dx,
		output reg [10:0]dy,
		output reg kickon=0);


		always @(posedge clk)
		begin
			case (sw)
				4'b0001 : begin //move right
					dx <= 11'd1;
					dy <= 11'd0;
					kickon <=0;
				end

				4'b0010 : begin //kick
					kickon <= 1;
				end

				4'b0100 : begin //jump
					dx <= 11'd0;
					dy <= -11'd5;
					kickon <=0;
				end

				4'b1000 : begin //move left
					dx <= -11'd1;
					dy <= 11'd1;
					kickon <=0;
				end


				default : begin //by default, you have gravity pulling down on you (increasing y corresponds to moving downwards)
					dx <= 11'd0;
					dy <= 11'd5;
					kickon <= 0;
				end

			endcase

		end
	endmodule
