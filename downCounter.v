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
module downCounter(
	input clk,
	input trig,
	output reg [23:0]count = 24'hFFFFFF,
	output reg doCount = 0);
	
	always @(posedge clk) begin 
		if (trig)
			doCount = 1;
		if (doCount)
			count = count -1;
		if (count == 0) begin
			doCount = 0;
			count = 24'hFFFFFF;
		end
	end 

endmodule




