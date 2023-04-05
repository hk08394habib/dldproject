`timescale 1ns / 1ps

module hours(
    input inc_hours,        // From minutes
    input reset,
    output [3:0] hours
    );
    
    reg [3:0] hrs_ctr = 12;
    
    always @(negedge inc_hours or posedge reset) begin
        if(reset)
            hrs_ctr <= 12;
        else
            if(hrs_ctr == 12)
                hrs_ctr <= 1;
            else
                hrs_ctr <= hrs_ctr + 1;
    end
    
    assign hours = hrs_ctr;
    
endmodule




`timescale 1ns / 1ps

module minutes(
    input inc_minutes,      // From seconds
    input reset,
    output inc_hours,       // To hours
    output [5:0] minutes   
    );
    
    reg [5:0] min_ctr = 0;
    
    always @(negedge inc_minutes or posedge reset) begin
        if(reset)
            min_ctr <= 0;
        else
            if(min_ctr == 59)
                min_ctr <= 0;
            else
                min_ctr <= min_ctr + 1;
    end
    
    assign inc_hours = (min_ctr == 59) ? 1 : 0;
    assign minutes = min_ctr;
    
endmodule



`timescale 1ns / 1ps

module seconds(
    input clk_1Hz,      
    input reset,
    output inc_minutes  // To minutes
    );
    
    reg [5:0] sec_ctr = 0;
    
    always @(posedge clk_1Hz or posedge reset) begin
        if(reset)
            sec_ctr <= 0;
        else
            if(sec_ctr == 59) 
                sec_ctr <= 0;
            else
                sec_ctr <= sec_ctr + 1;
    end
    
    assign inc_minutes = (sec_ctr == 59) ? 1 : 0;
    
endmodule


