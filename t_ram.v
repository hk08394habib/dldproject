module test();
	reg clk = 1'b0;
	wire clk_d;
	always 
		#5 clk <= ~clk;
	
	reg [11:0]write = 12'h123;
	wire [11:0]read;
	reg writeenable = 1;
	reg [19:0]address;
	clk_div clkd(clk,clk_d);

	RAM_sync ramtest(.clk_d(clk_d),.din(write),.dout(read),.we(writeenable),.addr(address));

	reg [5:0]counter = 1;
	always @(posedge clk_d) begin
		if (counter < 20)	
			counter <= counter + 1;
		if (counter == 20)
			counter <= 21;
		address <= counter;
	end

	initial begin 
		#1000
		$display("Start rereading");
		for (integer i = 1; i < 20; i = i + 1) begin
			#10 address <= i;
		end
		$finish;
	end 
	always @(address) begin 
		$display("address = %20b, read = %3h, write = %3h",address,read,write); //notice that you get read at clockcycle N at clockcycle N+1
	end

endmodule
