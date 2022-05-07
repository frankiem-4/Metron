`include "metron_tools.sv"

// Nesting submod calls should put all the nested input bindings above the call.

module Submod1
(
  input logic clock,
  input logic[7:0] tock_add_one_a,
  output logic[7:0] tock_add_one_ret
);
/*public:*/
  function logic[7:0] tock_add_one(logic[7:0] a);
    tock_add_one = a + 1;
  endfunction

  always_comb begin
    tock_add_one_ret = tock_add_one(tock_add_one_a);
  end


  always_ff @(posedge clock) begin
  end

endmodule

module Submod2
(
  input logic clock,
  input logic[7:0] tock_add_two_a,
  output logic[7:0] tock_add_two_ret
);
/*public:*/
  function logic[7:0] tock_add_two(logic[7:0] a);
    tock_add_two = a + 1;
  endfunction

  always_comb begin
    tock_add_two_ret = tock_add_two(tock_add_two_a);
  end


  always_ff @(posedge clock) begin
  end

endmodule

module Module
(
  input logic clock,
  input logic[7:0] tock_old_counter,
  output logic[7:0] tock_ret
);
/*public:*/

  function logic[7:0] tock(logic[7:0] old_counter);
    logic[7:0] new_counter;
    // Two bindings should end up here.submod2_tock_add_two_a = tock_old_counter;
    submod1_tock_add_one_a = submod2_tock_add_two;

    new_counter = submod1_tock_add_one;
    tock = new_counter;
  endfunction

/*private:*/

  Submod1 submod1(
    // Inputs
    .clock(clock),
    .tock_add_one_a(submod1_tock_add_one_a),
    // Outputs
    .tock_add_one_ret(submod1_tock_add_one_ret)
  );
  logic[7:0] submod1_tock_add_one_a;
  logic[7:0] submod1_tock_add_one_ret;

  Submod2 submod2(
    // Inputs
    .clock(clock),
    .tock_add_two_a(submod2_tock_add_two_a),
    // Outputs
    .tock_add_two_ret(submod2_tock_add_two_ret)
  );
  logic[7:0] submod2_tock_add_two_a;
  logic[7:0] submod2_tock_add_two_ret;


  always_comb begin
    tock_ret = tock(tock_old_counter);
  end


  always_ff @(posedge clock) begin
  end

endmodule
