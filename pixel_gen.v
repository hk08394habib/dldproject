`timescale 1ns / 1ps
module RAM_sync(clk_d, addr, din, dout, we); //create RAM to store RGB values 
	parameter A = 20; //this gives the number of address BITS
	parameter D = 12; //this is the number of data BITS. 12 bit since we want to store RGB values

	input clk_d;
	input [A-1:0] addr;
	input [D-1:0] din;
	output reg [D-1:0] dout;
	input we;

	reg [D-1:0] memory [0:(1<<A)-1]; //create 2**A - 1 sized vector of width D
		/*for (integer i = 0; i < 2000; i = i + 1) begin 
			$display("%0h", memory[i]);
		end*/
	always @(posedge clk_d) begin
		if (we) //write if given instruction to write 
			memory[addr] <= din; 
		dout <= memory[addr];//always send out the read value
	end
endmodule

module RAM_init(input clk_d);
	//counting module 
	wire trig_v;
	wire [9:0]hcount;
	wire [9:0]vcount;

	h_counter counthorizontal(.clk(clk_d),.trig_v(trig_v),.count(hcount));
	v_counter countvertical(.clk(clk_d),.enable_v(trig_v),.v_count(vcount));


	//initialize and wire RAM
	wire [19:0] ram_addr;//since we have 20 bit array 
	wire [11:0] ram_read;//since the stored value is 12 bits
	reg [11:0] ram_write = 4'b0000; //default write value for now
	reg ram_writeenable = 1; //enable writing

	//we need to iterate over the RAM
	wire [9:0]row = hcount;
	wire [9:0]column = vcount;
	assign ram_addr = {row, column}; //hpos gives row vpos gives column
	
	RAM_sync raminit(.clk_d(clk_d),.dout(ram_read), .din(ram_write), .addr(ram_addr), .we(ram_writeenable));


	always @(posedge clk_d) begin 
		$display(ram_read, ram_write, ram_addr);
		/*if (vcount == 480) begin
			$display("done");
			$finish;
		end*/
	end

	always @(posedge clk_d) begin
		$display("hi");
	end

endmodule

module make_current_pixel(input clk_d, input [9:0] x_loc, input [9:0] y_loc, input video_on, output [3:0]red, output [3:0]green, output [3:0]blue);

	wire [19:0] ram_addr;//since we have 20 bit array 
	wire [11:0] ram_read;//since the stored value is 12 bits
	reg [11:0] ram_write;//in case we need to write. no use for now. 
	reg ram_writeenable = 0;

	assign ram_addr = {row, column}; //hpos gives row vpos gives column

	wire [9:0]row = x_loc;
	wire [9:0]column = y_loc;
	
	RAM_init initializeram(.clk_d(clk_d));
	RAM_sync ram(.clk_d(clk_d),.dout(ram_read), .din(ram_write), .addr(ram_addr), .we(ram_writeenable));

	initial begin
		$display("%12b",ram_read[11:0]);
	end

	wire [11:0] color = ram_read[11:0];
	//when video_on is 0 then set rgb to black 
	assign blue = color[3:0] && video_on;
	assign green = color[7:4] && video_on;
	assign red = color[11:7] && video_on;
endmodule
