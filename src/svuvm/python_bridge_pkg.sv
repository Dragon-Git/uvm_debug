package python_bridge_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    //------------------------------------------------------------------------------
    // Group: Factory
    //
    // Provides ability to set type and instance overrides for simple classes
    // (non-parameterized).
    //------------------------------------------------------------------------------

    `ifndef VERILATOR
    function automatic void print_factory (int all_types=1);
        uvm_factory factory = uvm_factory::get();
        factory.print(all_types);
    endfunction

    function automatic void set_factory_inst_override (string requested_type,
                                                            string override_type,
                                                            string contxt);
        uvm_factory factory = uvm_factory::get();
        factory.set_inst_override_by_name(requested_type,override_type,contxt);
    endfunction

    function automatic void set_factory_type_override (string requested_type,
                                                            string override_type,
                                                            bit replace=1);
        uvm_factory factory = uvm_factory::get();
        factory.set_type_override_by_name(requested_type,override_type,replace);
    endfunction

    function automatic void debug_factory_create (string requested_type,
                                                       string contxt="");
        uvm_factory factory = uvm_factory::get();
        factory.debug_create_by_name(requested_type,contxt,"");
    endfunction

    function automatic void find_factory_override (string requested_type,
                                                        string contxt,
                                                        output string override_type);
        uvm_object_wrapper wrapper;
        uvm_factory factory = uvm_factory::get();
        wrapper = factory.find_override_by_name(requested_type, contxt);
        if (wrapper == null)
            override_type = requested_type;
        else
            override_type = wrapper.get_type_name();
    endfunction

    //------------------------------------------------------------------------------
    // Group: Topology
    //
    // Provides ability to wait for UVM phase transitions.
    //------------------------------------------------------------------------------

    function automatic void print_topology(string contxt);
        uvm_root top = uvm_root::get();
        uvm_component comps[$];
        if (contxt == "")
            comps.push_back(top);
        else begin
            top.find_all(contxt,comps);
            `uvm_error("_PRINT_TOPOLOGY", {"No components found at context ", contxt})
            return;
        end

        foreach (comps[i]) begin
            string name = comps[i].get_full_name();
            if (name == "")
                name = "uvm_top";
            `uvm_info("TRACE/UVMC_CMD/PRINT_TOPOLOGY", {"Topology for component ",name,":"},UVM_NONE)
            comps[i].print();
            $display();
        end
    endfunction

    //------------
    // uvm event
    //------------

    // Wrapper for wait_on
    task wait_on(string ev_name, bit delta = 0);
        uvm_event ev = uvm_event_pool::get_global(ev_name);
        ev.wait_on(delta);
    endtask

    // Wrapper for wait_off
    task wait_off(string ev_name, bit delta = 0);
        uvm_event ev = uvm_event_pool::get_global(ev_name);
        ev.wait_off(delta);
    endtask

    // Wrapper for wait_trigger
    task wait_trigger(string ev_name);
        uvm_event ev = uvm_event_pool::get_global(ev_name);
        ev.wait_trigger();
    endtask

    // Wrapper for wait_ptrigger
    task wait_ptrigger(string ev_name);
        uvm_event ev = uvm_event_pool::get_global(ev_name);
        ev.wait_ptrigger();
    endtask

    // Wrapper for wait_trigger_data
    task wait_trigger_data(string ev_name, output uvm_object data);
        uvm_event ev = uvm_event_pool::get_global(ev_name);
        ev.wait_trigger_data(data);
    endtask

    // Wrapper for wait_ptrigger_data
    task wait_ptrigger_data(string ev_name, output uvm_object data);
        uvm_event ev = uvm_event_pool::get_global(ev_name);
        ev.wait_ptrigger_data(data);
    endtask

    // Wrapper for get_trigger_time
    function longint get_trigger_time(string ev_name);
        uvm_event ev = uvm_event_pool::get_global(ev_name);
        return ev.get_trigger_time();
    endfunction

    // Wrapper for is_on
    function bit is_on(string ev_name);
        uvm_event ev = uvm_event_pool::get_global(ev_name);
        return ev.is_on();
    endfunction

    // Wrapper for is_off
    function bit is_off(string ev_name);
        uvm_event ev = uvm_event_pool::get_global(ev_name);
        return ev.is_off();
    endfunction

    // Wrapper for reset
    function void reset(string ev_name, bit wakeup = 0);
        uvm_event ev = uvm_event_pool::get_global(ev_name);
        ev.reset(wakeup);
    endfunction

    // Wrapper for cancel
    function void cancel(string ev_name);
        uvm_event ev = uvm_event_pool::get_global(ev_name);
        ev.cancel();
    endfunction

    // Wrapper for get_num_waiters
    function int get_num_waiters(string ev_name);
        uvm_event ev = uvm_event_pool::get_global(ev_name);
        return ev.get_num_waiters();
    endfunction

    // Wrapper for trigger
    function void trigger(string ev_name);
        uvm_event ev = uvm_event_pool::get_global(ev_name);
        ev.trigger();
    endfunction
    /*
    // Wrapper for get_trigger_data
    function uvm_object get_trigger_data(string ev_name);
        uvm_event ev = uvm_event_pool::get_global(ev_name);
        return ev.get_trigger_data();
    endfunction

    // Wrapper for get_default_data
    function uvm_object get_default_data(string ev_name);
        uvm_event ev = uvm_event_pool::get_global(ev_name);
        return ev.get_default_data();
    endfunction

    // Wrapper for set_default_data
    function void set_default_data(string ev_name, uvm_object data);
        uvm_event ev = uvm_event_pool::get_global(ev_name);
        ev.set_default_data(data);
    endfunction
    */

    function void set_config_int(string contxt, string inst_name, string field_name, longint unsigned value);
        uvm_root top = uvm_root::get();
        uvm_component comp = top.find(contxt);
        uvm_config_db#(uvm_bitstream_t)::set(comp, inst_name, field_name, value);
    endfunction

    function longint get_config_int(string contxt, string inst_name, string field_name);
        uvm_root top = uvm_root::get();
        uvm_component comp = top.find(contxt);
        uvm_config_db#(uvm_bitstream_t)::get(comp, inst_name, field_name, get_config_int);
    endfunction

    function void set_config_string (string contxt, string inst_name, string field_name, string value);
        uvm_root top = uvm_root::get();
        uvm_component comp = top.find(contxt);
        uvm_config_db #(string)::set(comp, inst_name, field_name, value);
    endfunction

    function string get_config_string (string contxt, string inst_name, string field_name);
        uvm_root top = uvm_root::get();
        uvm_component comp = top.find(contxt);
        uvm_config_db #(string)::get(comp, inst_name, field_name, get_config_string);
    endfunction
    `endif //VERILATOR

    // custom task
    task wait_unit(int n);
    `ifndef VERILATOR
        #n;
    `endif
        $display("inside sv task in %d", $time);
    endtask:wait_unit

    task stop();
        $stop;
    endtask:stop

    task start_seq(string seq_name, string sqr_name);
        uvm_root top = uvm_root::get();
        uvm_factory factory = uvm_factory::get();
        uvm_object obj;
        uvm_component comp;
        uvm_sequence_base seq;
        uvm_sequencer_base sqr;
 
        obj = factory.create_object_by_name(seq_name, "", seq_name);
        if (obj == null)  begin
            factory.print(1);
            `uvm_fatal("python_bridge_pkg", $sformatf("can not create %0s seq", seq_name))
        end
        if (!$cast(seq, obj))  begin
            `uvm_fatal("python_bridge_pkg", $sformatf("cast failed - %0s is not a uvm_sequence", seq_name))
        end
        comp = top.find(sqr_name);
        if (comp == null)  begin
            top.print_topology();
            `uvm_fatal("python_bridge_pkg", $sformatf("can not find %0s seq", sqr_name))
        end
        if (!$cast(sqr, comp))  begin
            `uvm_fatal("python_bridge_pkg", $sformatf("cast failed - %0s is not a uvm_sequencer", sqr_name))
        end

    `ifndef VERILATOR
        seq.start(sqr);
    `endif
    endtask:start_seq

    task write_reg(input int address, input int data);
        // Placeholder for actual implementation
        $display("Writing to register %h: %h", address, data);
    endtask:write_reg

    task read_reg(input int address, output int data);
        // Placeholder for actual implementation
        data = 32'hDEADBEEF; // Example dummy read value
        $display("Reading from register %h: %h", address, data);
    endtask:read_reg

    // export
    `ifndef VERILATOR
    export "DPI-C" function print_factory;
    export "DPI-C" function set_factory_inst_override;
    export "DPI-C" function set_factory_type_override;
    export "DPI-C" function debug_factory_create;
    export "DPI-C" function find_factory_override;
    export "DPI-C" function print_topology;

    // uvm_event
    export "DPI-C" task wait_on;
    export "DPI-C" task wait_off;
    export "DPI-C" task wait_trigger;
    export "DPI-C" task wait_ptrigger;
    //export "DPI-C" task wait_trigger_data;
    //export "DPI-C" task wait_ptrigger_data;

    export "DPI-C" function get_trigger_time;
    export "DPI-C" function is_on;
    export "DPI-C" function is_off;
    export "DPI-C" function reset;
    export "DPI-C" function cancel;
    export "DPI-C" function get_num_waiters;
    export "DPI-C" function trigger;
    //export "DPI-C" function get_trigger_data;
    //export "DPI-C" function get_default_data;
    //export "DPI-C" function set_default_data;

    export "DPI-C" function set_config_int;
    export "DPI-C" function get_config_int;
    export "DPI-C" function set_config_string;
    export "DPI-C" function get_config_string;
    `endif //VERILATOR

    export "DPI-C" task wait_unit;
    export "DPI-C" task stop;
    export "DPI-C" task start_seq;
    export "DPI-C" task write_reg;
    export "DPI-C" task read_reg;

    import "DPI-C" pure function string dirname(string file_path);
    import "DPI-C" context task py_func(input string mod_name, string func_name = "main", string mod_paths = "");
    task call_py_func(input string mod_name, string func_name = "main", string mod_paths = "");
        py_func(mod_name, func_name, mod_paths);
    endtask:call_py_func

endpackage