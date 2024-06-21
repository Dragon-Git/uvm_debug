module top ();
    `ifndef NOUVM
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `endif
    import svuvm_pkg::*;
    initial begin
        call_py_func("run", "main", dirname(`__FILE__));
        $finish;
    end
endmodule