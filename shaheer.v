`timescale 1ns / 1ps

module digits10_array(digit, yofs, bits);
 
  input [3:0] digit;          // digit 0-9
  input [2:0] yofs;           // vertical offset (0-4)
  output [4:0] bits;          // output (5 bits)

  reg [4:0] bitarray[0:35][0:4]; // ROM array (16 x 5 x 5 bits)

  assign bits = bitarray[digit][yofs];    // assign module output
 
  integer i,j;
 
  initial begin/*{w:5,h:5,count:10}*/
    bitarray[0][0] = 5'b11111;
    bitarray[0][1] = 5'b10001;
    bitarray[0][2] = 5'b10001;
    bitarray[0][3] = 5'b10001;
    bitarray[0][4] = 5'b11111;

    bitarray[1][0] = 5'b01100;
    bitarray[1][1] = 5'b00100;
    bitarray[1][2] = 5'b00100;
    bitarray[1][3] = 5'b00100;
    bitarray[1][4] = 5'b11111;

    bitarray[2][0] = 5'b11111;
    bitarray[2][1] = 5'b00001;
    bitarray[2][2] = 5'b11111;
    bitarray[2][3] = 5'b10000;
    bitarray[2][4] = 5'b11111;

    bitarray[3][0] = 5'b11111;
    bitarray[3][1] = 5'b00001;
    bitarray[3][2] = 5'b11111;
    bitarray[3][3] = 5'b00001;
    bitarray[3][4] = 5'b11111;

    bitarray[4][0] = 5'b10001;
    bitarray[4][1] = 5'b10001;
    bitarray[4][2] = 5'b11111;
    bitarray[4][3] = 5'b00001;
    bitarray[4][4] = 5'b00001;

    bitarray[5][0] = 5'b11111;
    bitarray[5][1] = 5'b10000;
    bitarray[5][2] = 5'b11111;
    bitarray[5][3] = 5'b00001;
    bitarray[5][4] = 5'b11111;

    bitarray[6][0] = 5'b11111;
    bitarray[6][1] = 5'b10000;
    bitarray[6][2] = 5'b11111;
    bitarray[6][3] = 5'b10001;
    bitarray[6][4] = 5'b11111;

    bitarray[7][0] = 5'b11111;
    bitarray[7][1] = 5'b00001;
    bitarray[7][2] = 5'b00001;
    bitarray[7][3] = 5'b00001;
    bitarray[7][4] = 5'b00001;

    bitarray[8][0] = 5'b11111;
    bitarray[8][1] = 5'b10001;
    bitarray[8][2] = 5'b11111;
    bitarray[8][3] = 5'b10001;
    bitarray[8][4] = 5'b11111;

    bitarray[9][0] = 5'b11111;
    bitarray[9][1] = 5'b10001;
    bitarray[9][2] = 5'b11111;
    bitarray[9][3] = 5'b00001;
    bitarray[9][4] = 5'b11111;
   
    bitarray[10][0] = 5'b00100; //A
    bitarray[10][1] = 5'b01010;
    bitarray[10][2] = 5'b11111;
    bitarray[10][3] = 5'b10001;
    bitarray[10][4] = 5'b10001;
   
    bitarray[11][0] = 5'b11110; //B
    bitarray[11][1] = 5'b10001;
    bitarray[11][2] = 5'b11110;
    bitarray[11][3] = 5'b10001;
    bitarray[11][4] = 5'b11110;
   
    bitarray[12][0] = 5'b11111;//C
    bitarray[12][1] = 5'b10000;
    bitarray[12][2] = 5'b10000;
    bitarray[12][3] = 5'b10000;
    bitarray[12][4] = 5'b11111;
   
    bitarray[13][0] = 5'b11110; //D
    bitarray[13][1] = 5'b10001;
    bitarray[13][2] = 5'b10001;
    bitarray[13][3] = 5'b10001;
    bitarray[13][4] = 5'b11110;
   
    bitarray[14][0] = 5'b11111; //E
    bitarray[14][1] = 5'b10000;
    bitarray[14][2] = 5'b11111;
    bitarray[14][3] = 5'b10000;
    bitarray[14][4] = 5'b11111;
   
    bitarray[15][0] = 5'b11111; //F
    bitarray[15][1] = 5'b10000;
    bitarray[15][2] = 5'b11111;
    bitarray[15][3] = 5'b10000;
    bitarray[15][4] = 5'b10000;
   
    bitarray[16][0] = 5'b11111; //G
    bitarray[16][1] = 5'b10000;
    bitarray[16][2] = 5'b10111;
    bitarray[16][3] = 5'b10001;
    bitarray[16][4] = 5'b11111;

    bitarray[17][0] = 5'b10001; //H
    bitarray[17][1] = 5'b10001;
    bitarray[17][2] = 5'b11111;
    bitarray[17][3] = 5'b10001;
    bitarray[17][4] = 5'b10001;
   
    bitarray[18][0] = 5'b11111; //I
    bitarray[18][1] = 5'b00100;
    bitarray[18][2] = 5'b00100;
    bitarray[18][3] = 5'b00100;
    bitarray[18][4] = 5'b11111;
   
    bitarray[19][0] = 5'b11111; //J
    bitarray[19][1] = 5'b00010;
    bitarray[19][2] = 5'b10010;
    bitarray[19][3] = 5'b10010;
    bitarray[19][4] = 5'b11110;
   
    bitarray[20][0] = 5'b10010; //K
    bitarray[20][1] = 5'b10100;
    bitarray[20][2] = 5'b11000;
    bitarray[20][3] = 5'b10100;
    bitarray[20][4] = 5'b10010;
   
    bitarray[21][0] = 5'b10000; //L
    bitarray[21][1] = 5'b10000;
    bitarray[21][2] = 5'b10000;
    bitarray[21][3] = 5'b10000;
    bitarray[21][4] = 5'b11111;
   
    bitarray[22][0] = 5'b10001; //M
    bitarray[22][1] = 5'b11011;
    bitarray[22][2] = 5'b10101;
    bitarray[22][3] = 5'b10001;
    bitarray[22][4] = 5'b10001;
   
    bitarray[23][0] = 5'b10001; //N
    bitarray[23][1] = 5'b11001;
    bitarray[23][2] = 5'b10101;
    bitarray[23][3] = 5'b10011;
    bitarray[23][4] = 5'b10001;
   
    bitarray[24][0] = 5'b01110; //O
    bitarray[24][1] = 5'b10001;
    bitarray[24][2] = 5'b10001;
    bitarray[24][3] = 5'b10001;
    bitarray[24][4] = 5'b01110;
   
    bitarray[25][0] = 5'b11111; //P
    bitarray[25][1] = 5'b10001;
    bitarray[25][2] = 5'b11111;
    bitarray[25][3] = 5'b10000;
    bitarray[25][4] = 5'b10000;
   
    bitarray[26][0] = 5'b01110; //Q
    bitarray[26][1] = 5'b10001;
    bitarray[26][2] = 5'b10101;
    bitarray[26][3] = 5'b10011;
    bitarray[26][4] = 5'b01111;
   
    bitarray[27][0] = 5'b11110; //R
    bitarray[27][1] = 5'b10001;
    bitarray[27][2] = 5'b11110;
    bitarray[27][3] = 5'b10100;
    bitarray[27][4] = 5'b10010;
   
    bitarray[28][0] = 5'b11111; //S
    bitarray[28][1] = 5'b10000;
    bitarray[28][2] = 5'b11111;
    bitarray[28][3] = 5'b00001;
    bitarray[28][4] = 5'b11111;
   
    bitarray[29][0] = 5'b11111; //T
    bitarray[29][1] = 5'b00100;
    bitarray[29][2] = 5'b00100;
    bitarray[29][3] = 5'b00100;
    bitarray[29][4] = 5'b00100;
   
    bitarray[30][0] = 5'b10001; //U
    bitarray[30][1] = 5'b10001;
    bitarray[30][2] = 5'b10001;
    bitarray[30][3] = 5'b10001;
    bitarray[30][4] = 5'b11111;
   
    bitarray[31][0] = 5'b10001; //V
    bitarray[31][1] = 5'b10001;
    bitarray[31][2] = 5'b10001;
    bitarray[31][3] = 5'b01010;
    bitarray[31][4] = 5'b00100;
       
    bitarray[32][0] = 5'b10001; //W
    bitarray[32][1] = 5'b10001;
    bitarray[32][2] = 5'b10101;
    bitarray[32][3] = 5'b11011;
    bitarray[32][4] = 5'b10001;
   
    bitarray[33][0] = 5'b10001; //X
    bitarray[33][1] = 5'b01010;
    bitarray[33][2] = 5'b00100;
    bitarray[33][3] = 5'b01010;
    bitarray[33][4] = 5'b10001;
   
    bitarray[34][0] = 5'b10001; //Y
    bitarray[34][1] = 5'b01010;
    bitarray[34][2] = 5'b00100;
    bitarray[34][3] = 5'b00100;
    bitarray[34][4] = 5'b00100;
   
    bitarray[35][0] = 5'b11111; //Z
    bitarray[35][1] = 5'b00010;
    bitarray[35][2] = 5'b00100;
    bitarray[35][3] = 5'b01000;
    bitarray[35][4] = 5'b11111;
   
  end
endmodule


`timescale 1ns / 1ps

module test_numbers_top(clk, reset, hsync, vsync, rgb);
 
  input clk, reset;
  output hsync, vsync;
  output [2:0] rgb;

  wire display_on;
  wire [8:0] hpos;
  wire [8:0] vpos;
 
  hvsync_generator hvsync_gen(
    .clk(clk),
    .reset(reset),
    .hsync(hsync),
    .vsync(vsync),
    .display_on(display_on),
    .hpos(hpos),
    .vpos(vpos)
  );
 
  wire [3:0] digit = hpos[7:4];
  wire [2:0] xofs = hpos[3:1];
  wire [2:0] yofs = vpos[3:1];
  wire [4:0] bits;
 
  digits10_array numbers(
    .digit(digit),
    .yofs(yofs),
    .bits(bits)
  );

  wire r = display_on && 0;
  wire g = display_on && bits[xofs ^ 3'b111];
  wire b = display_on && 0;
  assign rgb = {b,g,r};

endmodule
