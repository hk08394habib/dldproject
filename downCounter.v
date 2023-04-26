`timescale 1ns / 1ps
/*
module downCounter(
	input clk,
	input trig,
	output reg signed [20:0]count = 20'h00000);
	

	reg doCount = 0;
	reg negOne = -21'd1;
	always @(posedge clk) begin 
		if (trig)
			doCount = 1;
			count = 20'hFFFFF;
		if (doCount)
			count = count + negOne;
		if (count == 0); 
			doCount = 0;
	end 

endmodule
*/
/*
module downCounter(
	input clk,
	input trig,
	output done);
	
	reg countDown = 0
	reg [63:0]count = 64'hFFFFFFFFFFFFFFFF;

	assign done = ~countDown;

	always @(posedge clk) begin 

		if (trig == 1) begin

			countDown = 1;
			
		end

		if (countDown == 1) begin
			
			count = count - 64'h1;

		end

		if (count == 0) begin

			countDown = 0;
			count = 64'hFFFFFFFFFFFFFFFF;

		end

	end 
endmodule*/

module lock(
	input counting,
	input trig,
	output reg enableLock = 0);

	reg [11:0]count = 0;
	
	reg countFlag = 0;

	always @(posedge trig) begin
		enableLock <= 1;
		countFlag <= 1;
	end

	always @(posedge counting) begin 

		if (countFlag) 
			count <= count + 1;

		if (count == 1000) begin

			enableLock <= 0;
			count <= 0;
			countFlag <= 0;
		end

	end 

endmodule
