// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vbasic_lockstep.h for the primary calling header

#ifndef VERILATED_VBASIC_LOCKSTEP___024ROOT_H_
#define VERILATED_VBASIC_LOCKSTEP___024ROOT_H_  // guard

#include "verilated.h"

class Vbasic_lockstep__Syms;
VL_MODULE(Vbasic_lockstep___024root) {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clock,0,0);
    VL_OUT8(done,0,0);
    CData/*0:0*/ __Vclklast__TOP__clock;
    VL_OUT(result,31,0);
    IData/*31:0*/ Module__DOT__counter;

    // INTERNAL VARIABLES
    Vbasic_lockstep__Syms* vlSymsp;  // Symbol table

    // CONSTRUCTORS
    Vbasic_lockstep___024root(const char* name);
    ~Vbasic_lockstep___024root();
    VL_UNCOPYABLE(Vbasic_lockstep___024root);

    // INTERNAL METHODS
    void __Vconfigure(Vbasic_lockstep__Syms* symsp, bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);


#endif  // guard
