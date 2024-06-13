 package uvm_sv_pkg;

    task wait_unit(int n);
        #n;
        $display("inside sv task in %d", $time);
    endtask

    task start_seq(string seq_name, string sqr_name);
        uvm_object obj;
        uvm_component comp;
        uvm_sequence seq;
        uvm_sequencer sqr;
        uvm_factory factory = uvm_factory::get();

        obj = factory.create_object_by_name(seq_name, "", seq_name);
        if (obj == null)  begin
            factory.print(1);
            `uvm_fatal(get_full_name(), $sformatf("can not create %0s seq", seq_name))
        end
        if (!$cast(seq, obj))  begin
            `uvm_fatal(get_full_name(), $sformatf("cast failed - %0s is not a uvm_sequence", seq_name))
        end
        seq.start(sqr);
    endtask

    export "DPI-C" task wait_unit;
    export "DPI-C" task start_seq;

    import "DPI-C" context task py_func(input string mod_name, string func_name, string mod_paths);

endpackage