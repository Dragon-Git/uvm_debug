 package svuvm_pkg;

    `ifndef NOUVM
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `endif

    task wait_unit(int n);
    `ifndef NOUVM
        #n;
    `endif
        $display("inside sv task in %d", $time);
    endtask:wait_unit

    `ifndef NOUVM
    task start_seq(string seq_name, string sqr_name);
        uvm_root top = uvm_root::get();
        uvm_factory factory = uvm_factory::get();
        uvm_object obj;
        uvm_co7mponent comp;
        uvm_sequence seq;
        uvm_sequencer sqr;
 
        obj = factory.create_object_by_name(seq_name, "", seq_name);
        if (obj == null)  begin
            factory.print(1);
            `uvm_fatal("svuvm_pkg", $sformatf("can not create %0s seq", seq_name))
        end
        if (!$cast(seq, obj))  begin
            `uvm_fatal("svuvm_pkg", $sformatf("cast failed - %0s is not a uvm_sequence", seq_name))
        end
        comp = top.find(sqr_name);
        if (comp == null)  begin
            top.print_topology();
            `uvm_fatal("svuvm_pkg", $sformatf("can not find %0s seq", sqr_name))
        end
        if (!$cast(sqr, comp))  begin
            `uvm_fatal("svuvm_pkg", $sformatf("cast failed - %0s is not a uvm_sequencer", sqr_name))
        end

        seq.start(sqr);
    endtask:start_seq
    `else
    task start_seq(string seq_name, string sqr_name);
        $display("Not implemented in NOUVM defined");
    endtask:start_seq
    `endif

    export "DPI-C" task wait_unit;
    export "DPI-C" task start_seq;

    import "DPI-C" context task py_func(input string mod_name, string func_name = "main", string mod_paths = "");
    task call_py_func(input string mod_name, string func_name = "main", string mod_paths = "");
        py_func(mod_name, func_name, mod_paths);
    endtask:call_py_func

endpackage