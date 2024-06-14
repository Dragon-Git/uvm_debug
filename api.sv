module top ();
    import uvm_pkg::*;
    import sv_uvm_pkg::*;
    `include "uvm_macros.svh"
    initial begin
        call_py_func("run");
    end
endmodule