#if 0

#include "ibex/ibex_alu.h"
#include "ibex/ibex_multdiv_slow.h"
#include "ibex/ibex_pkg.h"
#include "rvsimple/rtl/adder.h"
#include "rvsimple/rtl/alu.h"
#include "rvsimple/rtl/alu_control.h"
#include "rvsimple/rtl/config.h"
#include "rvsimple/rtl/constants.h"
#include "rvsimple/rtl/control_transfer.h"
#include "rvsimple/rtl/data_memory_interface.h"
#include "rvsimple/rtl/example_data_memory.h"
#include "rvsimple/rtl/example_data_memory_bus.h"
#include "rvsimple/rtl/example_text_memory.h"
#include "rvsimple/rtl/example_text_memory_bus.h"
#include "rvsimple/rtl/immediate_generator.h"
#include "rvsimple/rtl/instruction_decoder.h"
#include "rvsimple/rtl/multiplexer.h"
#include "rvsimple/rtl/multiplexer2.h"
#include "rvsimple/rtl/multiplexer4.h"
#include "rvsimple/rtl/multiplexer8.h"
#include "rvsimple/rtl/regfile.h"
#include "rvsimple/rtl/register.h"
#include "rvsimple/rtl/riscv_core.h"
#include "rvsimple/rtl/singlecycle_control.h"
#include "rvsimple/rtl/singlecycle_ctlpath.h"
#include "rvsimple/rtl/singlecycle_datapath.h"
#include "rvsimple/rtl/toplevel.h"
#endif

#include "example_uart/rtl/uart_hello.h"
#include "example_uart/rtl/uart_rx.h"
#include "example_uart/rtl/uart_top.h"
#include "example_uart/rtl/uart_tx.h"


void blah() {
  static uart_top<3> top;
  top.tick(0);
}