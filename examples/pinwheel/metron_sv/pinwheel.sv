`include "metron_tools.sv"
`include "constants.sv"

module Pinwheel (
  // global clock
  input logic clock,
  // output signals
  output logic[31:0] bus_address,
  output logic[31:0] bus_write_data,
  output logic bus_write_enable,
  // output registers
  output logic[31:0] bus_read_data,
  output logic[3:0] bus_byte_enable,
  output logic bus_read_enable,
  output logic[31:0] pc,
  // tock() ports
  input logic tock_reset
);
 /*public:*/
  initial begin
    string s;
    pc = 0;
    regs[0] = 32'd0;

    $value$plusargs("text_file=%s", s);
    $readmemh(s, text_mem);

    $value$plusargs("data_file=%s", s);
    $readmemh(s, data_mem);
  end

  always_comb begin : tock
    tick_reset = tock_reset;
  end


  //----------------------------------------

 /*private:*/
  localparam int OP_ALU    = 5'b01100;
  localparam int OP_ALUI   = 5'b00100;
  localparam int OP_LOAD   = 5'b00000;
  localparam int OP_STORE  = 5'b01000;
  localparam int OP_BRANCH = 5'b11000;
  localparam int OP_JAL    = 5'b11011;
  localparam int OP_JALR   = 5'b11001;
  localparam int OP_LUI    = 5'b01101;
  localparam int OP_AUIPC  = 5'b00101;

  always_ff @(posedge clock) begin : tick
    if (tick_reset) begin
      pc <= 0;
      regs[0] <= 32'd0;
      bus_read_data <= 0;
      bus_address <= 0;
      bus_write_data <= 0;
      bus_byte_enable <= 0;
      bus_read_enable <= 0;
      bus_write_enable <= 0;
    end else begin
      logic[31:0] inst;
      logic[4:0] op;
      logic[4:0] rd;
      logic[2:0] f3;
      logic[4:0] r1;
      logic[4:0] r2;
      logic[6:0] f7;
      logic[31:0] imm_b;
      logic[31:0] imm_i;
      logic[31:0] imm_j;
      logic[31:0] imm_s;
      logic[31:0] imm_u;
      logic[31:0] ra;
      logic[31:0] rb;
      logic[2:0] alu_op;
      inst = text_mem[pc[15:2]];

      op = inst[6:2];
      rd = inst[11:7];
      f3 = inst[14:12];
      r1 = inst[19:15];
      r2 = inst[24:20];
      f7 = inst[31:25];

      imm_b = {{20 {inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'd0};
      imm_i = {{21 {inst[31]}}, inst[30:25], inst[24:20]};
      imm_j = {{12 {inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1'd0};
      imm_s = {{21 {inst[31]}}, inst[30:25], inst[11:7]};
      imm_u = {inst[31], inst[30:20], inst[19:12], 12'd0};

      bus_address <= 0;
      bus_write_enable <= 0;
      bus_write_data <= 0;

      ra = regs[r1];
      rb = (op == RV32I_OP_OPIMM) ? imm_i : regs[r2];
      //logic<32> rc = 0;
      //logic<32> alu_result;
      //logic<1>  writeback = false;
      //logic<32> data_in;
      alu_op = f3;

      //----------
      // Metron simulates this a few percent faster if we don't have ALU and
      // ALUI in the same branch, but then we duplicate the big ALU switch...

      if (op == OP_ALU || op == OP_ALUI) begin
        logic[31:0] alu_result;

        // clang-format off
        case (alu_op)
          0: alu_result = (op == OP_ALU) && f7[5] ? ra - rb : ra + rb;
          1: alu_result = ra << 5'(rb);
          2: alu_result = $signed(ra) < $signed(rb);
          3: alu_result = ra < rb;
          4: alu_result = ra ^ rb;
          5: begin
            // FIXME BUG Verilator isn't handling this ternary expression
            // correctly.
            // alu_result = f7[5] ? sra(op_a, b5(op_b)) : b32(op_a >> b5(op_b));
            // break;
            if (f7[5]) begin
              alu_result = ($signed(ra) >>> 5'(rb));
            end else begin
              alu_result = ra >> 5'(rb);
            end
          end
          6: alu_result = ra | rb;
          7: alu_result = ra & rb;
        endcase
        // clang-format on

        if (rd) regs[rd] <= alu_result;
        pc <= pc + 4;
      end

      //----------

      else if (op == OP_LOAD) begin
        logic[31:0] imm;
        logic[31:0] addr;
        logic[31:0] data;
        imm = {{21 {inst[31]}}, inst[30:25], inst[24:20]};
        addr = regs[r1] + imm;
        data = data_mem[addr[16:2]] >> (8 * 2'(addr));

        // clang-format off
        case (f3)
          0: data = $signed(8'(data));
          1: data = $signed(16'(data));
          4: data = 8'(data);
          5: data = 16'(data);
        endcase
        // clang-format on

        if (rd) regs[rd] <= data;
        pc <= pc + 4;
      end

      //----------

      else if (op == OP_STORE) begin
        logic[31:0] imm;
        logic[31:0] addr;
        logic[31:0] data;
        logic[31:0] mask;
        logic[14:0] phys_addr;
        imm = {{21 {inst[31]}}, inst[30:25], inst[11:7]};
        addr = regs[r1] + imm;
        data = regs[r2] << (8 * 2'(addr));

        mask = 0;
        if (f3 == 0) mask = 32'h000000FF << (8 * 2'(addr));
        if (f3 == 1) mask = 32'h0000FFFF << (8 * 2'(addr));
        if (f3 == 2) mask = 32'hFFFFFFFF;

        phys_addr = addr[16:2];
        data_mem[phys_addr] <= (data_mem[phys_addr] & ~mask) | (data & mask);

        pc <= pc + 4;

        bus_address <= addr;
        bus_write_enable <= 1;
        bus_write_data <= regs[r2];
      end

      //----------

      else if (op == OP_BRANCH) begin
        logic[31:0] op_a;
        logic[31:0] op_b;
        logic take_branch;
        op_a = regs[r1];
        op_b = regs[r2];

        // clang-format off
        case (f3)
          0: take_branch = op_a == op_b;
          1: take_branch = op_a != op_b;
          4: take_branch = $signed(op_a) < $signed(op_b);
          5: take_branch = $signed(op_a) >= $signed(op_b);
          6: take_branch = op_a < op_b;
          7: take_branch = op_a >= op_b;
          // KCOV_OFF
          default: take_branch = 1'bx;
          // KCOV_ON
        endcase
        // clang-format on

        if (take_branch) begin
          logic[31:0] imm;
          imm =
              {{20 {inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'd0};
          pc <= pc + imm;
        end else begin
          pc <= pc + 4;
        end
      end

      //----------

      else if (op == OP_JAL) begin
        logic[31:0] imm;
        imm = {{12 {inst[31]}}, inst[19:12], inst[20],
                            inst[30:25], inst[24:21], 1'd0};
        if (rd) regs[rd] <= pc + 4;
        pc <= pc + imm;
      end

      //----------

      else if (op == OP_JALR) begin
        logic[31:0] rr1;
        logic[31:0] imm;
        rr1 = regs[r1];  // Lol, Metron actually found a bug - gotta
                                   // read r1 before writing
        imm = {{21 {inst[31]}}, inst[30:25], inst[24:20]};
        if (rd) regs[rd] <= pc + 4;
        pc <= rr1 + imm;
      end

      //----------

      else if (op == OP_LUI) begin
        logic[31:0] imm;
        imm = {inst[31], inst[30:20], inst[19:12], 12'd0};
        if (rd) regs[rd] <= imm;
        pc <= pc + 4;
      end

      //----------

      else if (op == OP_AUIPC) begin
        logic[31:0] imm;
        imm = {inst[31], inst[30:20], inst[19:12], 12'd0};
        if (rd) regs[rd] <= pc + imm;
        pc <= pc + 4;
      end
    end
  end
  logic tick_reset;

  logic[31:0] text_mem[32 * 1024];
  logic[31:0] data_mem[32 * 1024];
  logic[31:0] regs[32];
endmodule
