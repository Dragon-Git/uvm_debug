module top ();
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import svuvm_pkg::*;
    initial begin
        call_py_func("run", "main", dirname(`__FILE__));
        $finish;
    end
endmodule