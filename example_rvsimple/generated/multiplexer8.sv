// RISC-V SiMPLE SV -- multiplexer module
// BSD 3-Clause License
// (c) 2017-2019, Arthur Matos, Marcus Vinicius Lamar, Universidade de Brasília,
//                Marek Materzok, University of Wrocław

`ifndef RVSIMPLE_MULTIPLEXER8_H
`define RVSIMPLE_MULTIPLEXER8_H

`include "config.sv"
`include "constants.sv"
`include "metron_tools.sv"

module multiplexer8
#(parameter int WIDTH = 32)
(
  input logic clock,
  input logic[2:0] sel,
  input logic[WIDTH-1:0] in0,
  input logic[WIDTH-1:0] in1,
  input logic[WIDTH-1:0] in2,
  input logic[WIDTH-1:0] in3,
  input logic[WIDTH-1:0] in4,
  input logic[WIDTH-1:0] in5,
  input logic[WIDTH-1:0] in6,
  input logic[WIDTH-1:0] in7,
  output logic[WIDTH-1:0] out
);
 /*public:*/

  always_comb begin
    case (sel) 
      /*case*/ 0:  out = in0;
      /*case*/ 1:  out = in1;
      /*case*/ 2:  out = in2;
      /*case*/ 3:  out = in3;
      /*case*/ 4:  out = in3;
      /*case*/ 5:  out = in3;
      /*case*/ 6:  out = in3;
      /*case*/ 7:  out = in3;
      default: out = WIDTH'(1'bx);
    endcase
  end
endmodule

`endif  // RVSIMPLE_MULTIPLEXER2_H

