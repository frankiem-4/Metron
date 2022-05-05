`include "metron_tools.sv"

// All the combos of tasks/funcs should work from ticks and tocks.

module Module
(
  input logic clock,
  output logic[7:0] my_sig,
  input logic[7:0] public_task_x,
  input logic[7:0] public_func_x,
  output logic[7:0] public_func_ret
);
/*public:*/


  always_comb begin /*tock*/
    public_task_x = public_func(17);
    /*public_task(public_func(17))*/;
    /*tick()*/;
  end

  always_comb begin /*public_task*/
    my_sig = public_task_x + 7;
  end

  function logic[7:0] public_func(logic[7:0] x);
    public_func = my_reg + private_func(5);
  endfunction
  always_comb public_func_ret = public_func(public_func_x);

/*private:*/

  always_comb begin /*tick*/
    private_task_x = private_func(33);
    /*private_task(private_func(33))*/;
  end

  logic[7:0] private_task_x;
  always_ff @(posedge clock) begin /*private_task*/
    my_reg <= my_reg + private_func(16);
  end

  function logic[7:0] private_func(logic[7:0] y);
    private_func = my_reg + y;
  endfunction

  logic[7:0] my_reg;
endmodule

