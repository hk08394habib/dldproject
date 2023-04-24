`timescale 1ns / 1ps
module vga_sync(input [9:0]h_count, input [9:0]v_count, output h_sync, output v_sync, output video_on, output [9:0]x_loc, output [9:0]y_loc);
    //horizontal
    localparam HD = 640;
    localparam HF = 16; //RB
    //localparam HB = 49; //LB
    localparam HR = 96;
   
    //vertical
    localparam VD = 490;
    localparam VF = 10; //TB
    //localparam VB = 33; //BB
    localparam VR = 2;

    assign v_sync = (v_count < (VD + VF)) || (v_count >= (VD + VF + VR));
    assign h_sync = (h_count < (HD + HF)) || (h_count >= (HD + HF + HR));
    assign video_on = (h_count < HD) & (v_count < VD); //when should we display
    
		//increment x and y

    assign y_loc = v_count; 
    assign x_loc = h_count;
endmodule

