// RISC-V SiMPLE SV -- instruction decoder
// BSD 3-Clause License
// (c) 2017-2019, Arthur Matos, Marcus Vinicius Lamar, Universidade de Brasília,
//                Marek Materzok, University of Wrocław

`ifndef RVSIMPLE_INSTRUCTION_DECODER_H
`define RVSIMPLE_INSTRUCTION_DECODER_H

`include "config.sv"
`include "constants.sv"
`include "metron_tools.sv"

module instruction_decoder
(
   input logic clock,
   input logic[31:0] inst,
   output logic[6:0] inst_opcode,
   output logic[2:0] inst_funct3,
   output logic[6:0] inst_funct7,
   output logic[4:0] inst_rd,
   output logic[4:0] inst_rs1,
   output logic[4:0] inst_rs2
);
 /*public:*/
   /*logic<32> inst;*/

  always_comb begin inst_opcode = inst[6:0]; end
  always_comb begin inst_funct3 = inst[14:12]; end
  always_comb begin inst_funct7 = inst[31:25]; end
  always_comb begin inst_rd = inst[11:7]; end
  always_comb begin inst_rs1 = inst[19:15]; end
  always_comb begin inst_rs2 = inst[24:20]; end
endmodule;

`endif  // RVSIMPLE_INSTRUCTION_DECODER_H

