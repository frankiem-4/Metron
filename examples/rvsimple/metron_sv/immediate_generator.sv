// RISC-V SiMPLE SV -- immediate generator
// BSD 3-Clause License
// (c) 2017-2019, Arthur Matos, Marcus Vinicius Lamar, Universidade de Brasília,
//                Marek Materzok, University of Wrocław

`ifndef IMMEDIATE_GENERATOR_H
`define IMMEDIATE_GENERATOR_H

`include "config.sv"
`include "constants.sv"
`include "metron_tools.sv"

module immediate_generator (
  // input signals
  input logic[31:0] inst,
  // output signals
  output logic[31:0] immediate
);
 /*public:*/

  // clang-format off
  // Immediate format
  //       31.............30........20.19........12.11.....11.10.........5.4..........1.0.....0
  // I = { {21{inst[31]}},                                     inst[30:25], inst[24:20]         };
  // S = { {21{inst[31]}},                                     inst[30:25], inst[11:7]          };
  // B = { {20{inst[31]}}, inst[7],                            inst[30:25], inst[11:8],   1'b0  };
  // U = { {1{inst[31]}},  inst[30:20], inst[19:12],                                      12'b0 };
  // J = { {12{inst[31]}},              inst[19:12], inst[20], inst[30:25], inst[24:21],  1'b0  };
  // clang-format on

  always_comb begin : tock
    import rv_constants::*;
    // clang-format off
    immediate = 32'b0;
    case (7'(inst))  // Opcode
      OPCODE_LOAD,
      OPCODE_LOAD_FP,
      OPCODE_OP_IMM,
      OPCODE_JALR: // I-type immediate
        immediate = {{21 {inst[31]}}, inst[30:25], inst[24:20]};
      OPCODE_STORE_FP,
      OPCODE_STORE: // S-type immediate
        immediate = {{21 {inst[31]}}, inst[30:25], inst[11:7]};
      OPCODE_BRANCH: // B-type immediate
        immediate = {{20 {inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
      OPCODE_AUIPC,
      OPCODE_LUI: // U-type immediate
        immediate = {inst[31], inst[30:20], inst[19:12], 12'b0};
      OPCODE_JAL: // J-type immediate
        immediate = {{12 {inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0};
      default: immediate = 32'b0;
    endcase
    // clang-format on
  end
endmodule

`endif // IMMEDIATE_GENERATOR_H
