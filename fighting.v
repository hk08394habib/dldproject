`timescale 1ns / 1ps 

module fighting(
		input clk,
		input vauxp6,
	  input vauxn6,
	  input vauxp7,
	  input vauxn7,
    input vauxp15,
    input vauxn15,
    input vauxp14,
    input vauxn14,
		output h_sync, 
		output v_sync,
		output reg [11:0]rgb,
		output [15:0]led);
///////// XADC
//


	wire video_on;
	wire [9:0] hpos;
	wire [9:0] vpos;

	assign led[0] = kingkicked;
	assign led[15] = leekicked;

	assign led[1] = kinghitflag;
	assign led[14] = leehitflag;

	assign led[2] = kinghit;
	assign led[13] = leehit;

	assign led[8] = endflag;

	wire signed [10:0]dx1,dy1;
	wire signed [10:0]dx2,dy2;
	

	//HEALTH
	reg signed [10:0] p1health = 11'd300,p2health = 11'd300;
	reg signed [10:0]p1healthxpos = 0,p1healthypos=0,p2healthxpos=11'd339,p2healthypos=0;
	wire p1healthgfx,p2healthgfx;
	wire [9:0] healthheight = 40;


	drawbox p1healthbar(.xpos(p1healthxpos),.ypos(p1healthypos),.hpos(hpos),.vpos(vpos),.width(p1health[9:0]),.height(healthheight),.gfx(p1healthgfx));
	drawbox p2healthbar(.xpos(p2healthxpos),.ypos(p2healthypos),.hpos(hpos),.vpos(vpos),.width(p2health[9:0]),.height(healthheight),.gfx(p2healthgfx));

	reg [20:0]leeHitFlagCooldown = 0;
	reg [20:0]KingHitFlagCooldown = 0;

	always @(posedge clk) begin

		if ((kinghit == 1)) 
			kinghitflag = 1;
		if ((leehit == 1)) 
			leehitflag = 1;

		if (leehitflag)
			leeHitFlagCooldown <= leeHitFlagCooldown + 1;
		if (kinghitflag)
			KingHitFlagCooldown <= KingHitFlagCooldown + 1;
	end

	always @(negedge leeHitFlagCooldown[20])
		leehitflag = 0;
		
	always @(negedge KingHitFlagCooldown[20])
		kinghitflag = 0;
		
	wire endflag;
	assign endflag = (p1health <=0 || p2health <=0) ? 1 : 0 ;

	always @(posedge kinghitflag)
			p1health <= p1health - 11'd100;
	always @(posedge leehitflag)  begin
			p2health <= p2health - 11'd100;
			p2healthxpos <= p2healthxpos + 11'd100;
		end

	gen_sync sync(.clk(clk),.h_sync(h_sync),.v_sync(v_sync), .video_on(video_on), .x_loc(hpos), .y_loc(vpos));

	reg kinghitflag = 0;
	reg leehitflag = 0;

	//MOVEMENT	
	//
	//
	
   
   wire enable;  
   wire ready;
   wire [15:0] data;   
   reg [6:0] Address_in;     
   


   xadc_wiz_0  XLXI_7 (.daddr_in(Address_in), //addresses can be found in the artix 7 XADC user guide DRP register space
                     .dclk_in(clk), 
                     .den_in(enable), 
                     .di_in(), 
                     .dwe_in(), 
                     .busy_out(),                    
                     .vauxp6(vauxp6),
                     .vauxn6(vauxn6),
                     .vauxp7(vauxp7),
                     .vauxn7(vauxn7),
                     .vauxp14(vauxp14),
                     .vauxn14(vauxn14),
                     .vauxp15(vauxp15),
                     .vauxn15(vauxn15),
                     .vn_in(), 
                     .vp_in(), 
                     .alarm_out(), 
                     .do_out(data), 
                     //.reset_in(),
                     .eoc_out(enable),
                     .channel_out(),
                     .drdy_out(ready));
                     
         
    
	reg [1:0]flip=0;
	reg [32:0]delay=0;

	wire leekicked,kingkicked;

	
	always @(posedge clk) begin
		if (delay == 1000000000) begin
		flip = flip + 1;
		delay = 0;
	end else
		delay = delay + 1;
	end

	always @(posedge clk) begin
		case (flip) 

				0: begin
        Address_in <= 8'h16;
        //Vrx <= data[15:12];
        //Vry <= 4'b0;
				if (data[15:12] > 8) begin
					dx1 <= 11'd1;
					leekicked <= 0;
				end
				if (data[15:12] < 8) begin
					dx1 <= -11'd1;
					leekicked <= 0;
				end
				if (data[15:12] == 8)
					dx1 <= 0;
					leekicked <=0;
        end
        
        1: begin
        Address_in <= 8'h1e;
        //Vry<=data[15:12];
        //Vrx<=4'b0;
				if (data[15:12] > 8) begin
					dy1 <= 11'd1;
					leekicked <= 0;
				end
				if (data[15:12] < 8)
					leekicked <= 1;
				if (data[15:12] == 8) begin
					dy1 <= 11'd5;
					leekicked <= 0;
				end
        end

				2: begin
        Address_in <= 8'h17;
        //Vrx <= data[15:12];
        //Vry <= 4'b0;
				if (data[15:12] > 8) begin
					dx2 <= 11'd1;
					kingkicked <= 0;
				end
				if (data[15:12] < 8) begin
					dx2 <= -11'd1;
					kingkicked <= 0;
				end
				if (data[15:12] == 8) begin
					dx2 <= 0;
					kingkicked <= 0;
				end
        end
        
        3: begin
        Address_in <= 8'h1f;
        //Vry<=data[15:12];
        //Vrx<=4'b0;
				if (data[15:12] > 8) begin
					dy2 <= 11'd1;
					kingkicked <= 0;
				end
				if (data[15:12] < 8) begin
					dy2 <= -11'd1
					kingkicked <= 1;
				end
				if (data[15:12] == 8) begin
					dy2 <= 11'd5;
					kingkicked <= 0;
				end
		endcase

		end

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


	//PLAYERS DRAW
	reg signed [10:0] kingx = 11'd300; 
	reg signed [10:0] kingy = 11'd100;

	reg signed [10:0] leex = 11'd400;
	reg signed [10:0] leey = 11'd100;
	
	wire availkingkickon,availkingneutral;
	wire availleekick,availleeneutral;

	wire [11:0]kingkickgfx;
	wire [11:0]leekickgfx;
	wire [11:0]kingneutralgfx;
	wire [11:0]leeneutralgfx;

	wire kinghit,leehit;

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
	
	
	//GFX

	//TODO: Set game over screen when health goes to 0
	always @(posedge clk)
		if (video_on == 1 ) begin
			if (leehitflag || kinghitflag) begin
				rgb <= 12'b000000101010;
			end else begin
					if (kinggfx && kingrgbgfx != 12'b110001111101) 
						rgb <= kingrgbgfx;
					else if (leegfx && leergbgfx != 12'b110001111101)
						rgb <= leergbgfx;
					else if (p1healthgfx || p2healthgfx) 
						rgb <= 12'b000000001111;
					else begin
						rgb <= 12'b100101010111;
					end
		end
	end else begin 
		rgb <= 12'b0;
	end
endmodule
