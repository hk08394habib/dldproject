`timescale 1ns / 1ps 

module fighting(
		input clk,
		input [15:0]sw,
		output h_sync, 
		output v_sync,
		output reg [11:0]rgb,
		output [15:0]led);

	wire video_on;
	wire [9:0] hpos;
	wire [9:0] vpos;

	assign led[0] = kingkicked;
	assign led[15] = leekicked;

	assign led[1] = triggerKingInvincible;
	assign led[14] = triggerLeeInvincible;

	assign led[2] = kinghit;
	assign led[13] = leehit;

	assign led[3] = kingInvincible;
	assign led[12] = leeInvincible;

	reg endflag = 0;
	
	assign led[8] = endflag;

	reg triggerKingInvincible = 0;
	reg triggerLeeInvincible = 0;

	wire signed [10:0]dx1,dy1;
	wire signed [10:0]dx2,dy2;
	
	wire kinghit,leehit;

	wire kingkicked ,leekicked ;
	moving movelogicp1(
		.clk(clk),
		.sw(sw[3:0]), //right side of board is p1
		.dx(dx1),
		.dy(dy1),
		.kickon(kingkicked));

	moving movelogicp2(
		.clk(clk),
		.sw(sw[15:12]), //left side of board is p2
		.dx(dx2),
		.dy(dy2),
		.kickon(leekicked));

	//display kick when button is pressed
	//TODO: Set game over screen when health goes to 0
	reg signed [10:0] p1health = 11'd400,p2health = 11'd400;
	reg signed [10:0]p1healthxpos = 0,p1healthypos=0,p2healthxpos=11'd239,p2healthypos=0;
	wire p1healthgfx,p2healthgfx;
	wire [9:0] healthheight = 40;


	drawbox p1healthbar(.xpos(p1healthxpos),.ypos(p1healthypos),.hpos(hpos),.vpos(vpos),.width(p1health[9:0]),.height(healthheight),.gfx(p1healthgfx));
	drawbox p2healthbar(.xpos(p2healthxpos),.ypos(p2healthypos),.hpos(hpos),.vpos(vpos),.width(p2health[9:0]),.height(healthheight),.gfx(p2healthgfx));

	//TODO: Create reset activated by sw[8] or when either health goes to 0

	gen_sync sync(.clk(clk),.h_sync(h_sync),.v_sync(v_sync), .video_on(video_on), .x_loc(hpos), .y_loc(vpos));


	wire kingInvincible;
	wire leeInvincible;


	//CHANGE COUNTING TO V_SYNC CURRENTLY CONFIGURED FOR SIMULATION PURPOSES
	lock kingInvincibility(.trig(triggerKingInvincible),.counting(v_sync),.enableLock(kingInvincible));
	lock leeInvincibility(.trig(triggerLeeInvincible),.counting(v_sync),.enableLock(leeInvincible));

	wire hurtKing;
	wire hurtLee;


	//Do the same thing for "kingDoKick = (~kingCanKick) && availkingkick && kingkicked", in the mvmt module set a flag to do jump don't actually
	//In order to do this we use defparam (ideally)
	assign hurtKing = (~kingInvincible) && kinghit;
	assign hurtLee = (~leeInvincible) && leehit;

	always @(posedge hurtKing) begin 
				if (p1health > 0) begin 
					p1health = p1health - 11'd100;
					triggerKingInvincible = 1;
				end else if (p1health <= 0) begin
					endflag = 1;
		end
		triggerKingInvincible = 0;
	end

	always @(posedge hurtLee) begin
				if (p2health > 0 && p2healthxpos < 639) begin 
					p2health = p2health - 11'd100;
					p2healthxpos = p2healthxpos + 11'd100;
					triggerLeeInvincible = 1;
				end else if (p2health <= 0 || p2healthxpos >= 639) begin
					endflag = 1;
		end
		triggerLeeInvincible = 0;
	end


	always @(negedge v_sync)
	begin

		if ((kingx + dx1 + 200 < 640) && (kingx + dx1> 0)) 
		kingx <= kingx + dx1;
		if ((leex + dx2 + 200< 640) && (leex + dx2> 0)) 
		leex <= leex + dx2;

		if (( kingy + dy1 + 200< 480) && ( kingy + dy1 > 0)) 
		kingy <= kingy + dy1; 
		if (( leey + dy2 + 200< 480) && ( leey + dy2 > 0)) 
		leey <= leey + dy2; 


	end



	//draw the players
	reg signed [10:0] kingx = 11'd300; 
	reg signed [10:0] kingy = 11'd100;

	reg signed [10:0] leex = 11'd300;
	reg signed [10:0] leey = 11'd100;
	
	wire availkingkick,availkingneutral;
	wire availleekick,availleeneutral;

	wire [11:0]kingkickgfx;
	wire [11:0]leekickgfx;
	wire [11:0]kingneutralgfx;
	wire [11:0]leeneutralgfx;


	kingneutral_wrapper kingidling(.clk(clk),.sprite_x(kingx),.sprite_y(kingy), .x(hpos),.y(vpos),.rgb(kingneutralgfx),.sprite_on(availkingneutral));
	leeneutral_wrapper leeidling(.clk(clk),.sprite_x(leex),.sprite_y(leey), .x(hpos),.y(vpos),.rgb(leeneutralgfx),.sprite_on(availleeneutral));

	kingkick_wrapper kingkicking(.clk(clk),.sprite_x(kingx),.sprite_y(kingy), .x(hpos),.y(vpos),.rgb(kingkickgfx),.sprite_on(availkingkick));
	leekick_wrapper leekicking(.clk(clk),.sprite_x(leex),.sprite_y(leey), .x(hpos),.y(vpos),.rgb(leekickgfx),.sprite_on(availleekick));

	wire [11:0]kingrgbgfx,leergbgfx;
	wire kinggfx,leegfx;


	assign kingrgbgfx = (kingkicked) ? (kingkickgfx) : (kingneutralgfx);
	assign leergbgfx = (leekicked) ? (leekickgfx) : (leeneutralgfx);
	
	assign kinggfx = (kingkicked) ? (availkingkick) : (availkingneutral);
	assign leegfx = (leekicked) ? (availleekick) : (availleeneutral);

	assign kinghit = leekicked && availleekick && kinggfx;
	assign leehit = kingkicked && availkingkick && leegfx;
	
	
	//display gfx

	always @(posedge clk) begin
		if (video_on == 1) begin

				if (kinggfx && kingrgbgfx != 12'b110001111101)  begin
					if (kingInvincible == 1) 
						rgb <= 12'b111111111111;
					else
						rgb <= kingrgbgfx;
				end else if (leegfx && leergbgfx != 12'b110001111101) begin
					if (leeInvincible == 1) 
						rgb <= 12'b111111111111;
					else
						rgb <= leergbgfx;
				end else if (p1healthgfx || p2healthgfx) 
					rgb <= 12'b000000001111;
				else begin
					rgb <= 12'b100101010111;
				end
	end else begin 
		rgb <= 12'b0;
	end
end
endmodule


