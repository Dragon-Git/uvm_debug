 package uvm_sv_pkg;

    task wait_unit(int n);
        #n;
        $display("inside sv task in %d", $time);
    endtask
    export "DPI-C" task wait_unit;

    import "DPI-C" context task py_func(input string mod_name, string func_name, string mod_paths);

endpackage