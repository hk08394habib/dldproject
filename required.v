`timescale 1ns / 1ps
module clk_div(clk,clk_d);
    parameter div_value=1;
    input clk;
    output clk_d;
    reg clk_d;
    reg count;
   
    initial
    begin
    clk_d=0;
    count=0;
    end
    always @(posedge clk)
        begin
            if (count==div_value)
                count <= 0;
            else
                count <= count+1 ;
        end
    always @(posedge clk)
        begin
            if (count==div_value)
                clk_d <= ~clk_d;
        end                        
   
endmodule
module h_counter(clk,count,trig_v); //mod 900
    input clk;
    output [9:0] count;
    output trig_v;
    reg [9:0] count;
    reg trig_v;
    initial count=0;
    initial trig_v=0;
always @ (posedge clk)
    begin
       if (count < 799)
         begin
         trig_v=0;
           count <= count + 1;
         end
       else
         begin
           trig_v<=1;
           count<=0;
         end
end                              
endmodule


module v_counter(clk,enable_v,v_count); //mod 525
    input clk;
    input enable_v;
    output [9:0] v_count;
    reg [9:0] v_count;
    initial v_count=0;
always @ (posedge clk)
    begin
    if (enable_v==1)
        begin
       if (v_count < 524)
         begin
           v_count <= v_count + 1;
         end
        else
            begin
                v_count <= 0;
            end
        end        
end                              
endmodule

module vga_sync(input [9:0]h_count, input [9:0]v_count, output h_sync, output v_sync, output video_on, output [9:0]x_loc, output [9:0]y_loc);
    //horizontal
    localparam HD = 640;
    localparam HF = 16; //RB
    localparam HB = 49; //LB
    localparam HR = 96;
   
    //vertical
    localparam VD = 490;
    localparam VF = 10; //TB
    localparam VB = 33; //BB
    localparam VR = 2;

    assign v_sync = (v_count < (VD + VF)) || (v_count >= (VD + VF + VR));
    assign h_sync = (h_count < (HD + HF)) || (h_count >= (HD + HF + HR));
    assign video_on = (h_count < HD) & (v_count < VD); //when should we display
    
		//increment x and y

    assign y_loc = v_count; 
    assign x_loc = h_count;
endmodule

module gen_sync(input clk, output h_sync, output v_sync, output video_on, output [9:0]x_loc, output [9:0]y_loc);
		wire [9:0]h_count;
		wire v_trig;
		wire [9:0]v_count;
    clk_div clkdiv(clk,clk_d);//create compatible clock, after taking clock input from basys3 board
   //iterate over the screen
    h_counter hcounter(clk_d,h_count,v_trig);
    v_counter vcounter(clk_d,v_trig,v_count);        
    vga_sync vga_syncing(h_count, v_count, h_sync, v_sync, video_on, x_loc, y_loc); //look at when to display screen
endmodule



