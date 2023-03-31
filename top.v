`timescale 1ns / 1ps
module top(input clk, output v_sync, output h_sync, output [3:0]red, output [3:0]green, output [3:0]blue);
    wire [9:0]h_count;
    wire [9:0]v_count;
    wire [9:0]x_loc;
    wire [9:0]y_loc;
   
    wire v_trig;
    wire v_enable;
    wire clk_d;
    wire video_on;
   
    clk_div clkdiv(clk,clk_d);
   
    h_counter hcounter(clk_d,h_count,v_trig);
    v_counter vcounter(clk_d,v_trig,v_count);        
    vga_sync vga_syncing(h_count, v_count, h_sync, v_sync, video_on, x_loc, y_loc);
		make_current_pixel pixelmake(.clk_d(clk_d), .x_loc(x_loc), .y_loc(y_loc), .video_on(video_on), .red(red), .green(green), .blue(blue));
endmodule
