`include "metron_tools.sv"

// Make sure our built-in functions translate.

module Module
(
  input logic clock
);
/*public:*/

  function void tock();
    logic[7:0] src;
    logic[7:0] a;
    logic[7:0] b;
    logic[7:0] e;
    logic[7:0] c;
    logic[7:0] d;
    src = 100;
    a = $signed(src);
    b = $unsigned(src);
    e = $signed(2'(src));
    c = $clog2(100);
    d = 2**(4);
  endfunction

  always_comb begin
    tock();
  end


  always_ff @(posedge clock) begin
  end


endmodule
