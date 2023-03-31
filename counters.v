
`timescale 1ns / 1ps
module h_counter(clk,count,trig_v); //mod 800
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
