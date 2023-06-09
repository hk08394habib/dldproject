`timescale 1ns / 1ps
module gen_sync(input clk, output h_sync, output v_sync, output video_on, output [9:0]x_loc, output [9:0]y_loc);
		wire [9:0]h_count;
		wire v_trig;
		wire [9:0]v_count;
		wire clk_d;
    clk_div clkdiv(clk,clk_d);//create compatible clock, after taking clock input from basys3 board
   //iterate over the screen
    h_counter hcounter(clk_d,h_count,v_trig);
    v_counter vcounter(clk_d,v_trig,v_count);        
    vga_sync vga_syncing(h_count, v_count, h_sync, v_sync, video_on, x_loc, y_loc); //look at when to display screen
endmodule



