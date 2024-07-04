 package python_bridge_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

//------------------------------------------------------------------------------
// Group: Factory
//
// Provides ability to set type and instance overrides for simple classes
// (non-parameterized).
//------------------------------------------------------------------------------

function automatic void _print_factory (int all_types=1);
  uvm_factory factory = uvm_factory::get();
  factory.print(all_types);
endfunction


function automatic void _set_factory_inst_override (string requested_type,
                                                        string override_type,
                                                        string contxt);
  uvm_factory factory = uvm_factory::get();
  factory.set_inst_override_by_name(requested_type,override_type,contxt);
endfunction


function automatic void _set_factory_type_override (string requested_type,
                                                        string override_type,
                                                        bit replace=1);
  uvm_factory factory = uvm_factory::get();
  factory.set_type_override_by_name(requested_type,override_type,replace);
endfunction


function automatic void _debug_factory_create (string requested_type,
                                                   string contxt="");
  uvm_factory factory = uvm_factory::get();
  factory.debug_create_by_name(requested_type,contxt,"");
endfunction


function automatic void _find_factory_override (string requested_type,
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


// TOPOLOGY
// --------

function automatic void _print_topology(string contxt);
  uvm_root top = uvm_root::get();
  uvm_component comps[$];
  uvm_printer uvm_default_printer = uvm_printer::get_default();
  if (contxt == "")
    comps.push_back(top);
  else begin
    top.find_all(contxt,comps);
    `uvm_error("UVMC_PRINT_TOPOLOGY",
               {"No components found at context ", contxt})
    return;
  end

  foreach (comps[i]) begin
    string name = comps[i].get_full_name();
    if (name == "")
      name = "uvm_top";
    `uvm_info("TRACE/UVMC_CMD/PRINT_TOPOLOGY",
              {"Topology for component ",name,":"},UVM_NONE)
    comps[i].print(uvm_default_printer);
    $display();
  end
endfunction

//------------
// uvm event
//------------

    // Wrapper for wait_on
    virtual task wait_on(string ev_name, bit delta = 0);
        uvm_event_pool event_pool = uvm_event_pool::get_global_pool();
        uvm_event ev = event_pool.get(ev_name);
        ev.wait_on(delta);
    endtask

    // Wrapper for wait_off
    virtual task wait_off(string ev_name, bit delta = 0);
        uvm_event_pool event_pool = uvm_event_pool::get_global_pool();
        uvm_event ev = event_pool.get(ev_name);
        ev.wait_off(delta);
    endtask

    // Wrapper for wait_trigger
    virtual task wait_trigger(string ev_name);
        uvm_event_pool event_pool = uvm_event_pool::get_global_pool();
        uvm_event ev = event_pool.get(ev_name);
        ev.wait_trigger();
    endtask

    // Wrapper for wait_ptrigger
    virtual task wait_ptrigger(string ev_name);
        uvm_event_pool event_pool = uvm_event_pool::get_global_pool();
        uvm_event ev = event_pool.get(ev_name);
        ev.wait_ptrigger();
    endtask

    // Wrapper for wait_trigger_data
    virtual task wait_trigger_data(string ev_name, output uvm_object data);
        uvm_event_pool event_pool = uvm_event_pool::get_global_pool();
        uvm_event ev = event_pool.get(ev_name);
        ev.wait_trigger_data(data);
    endtask

    // Wrapper for wait_ptrigger_data
    virtual task wait_ptrigger_data(string ev_name, output uvm_object data);
        uvm_event_pool event_pool = uvm_event_pool::get_global_pool();
        uvm_event ev = event_pool.get(ev_name);
        ev.wait_ptrigger_data(data);
    endtask

    // Wrapper for get_trigger_time
    virtual function time get_trigger_time(string ev_name);
        uvm_event_pool event_pool = uvm_event_pool::get_global_pool();
        uvm_event ev = event_pool.get(ev_name);
        return ev.get_trigger_time();
    endfunction

    // Wrapper for is_on
    virtual function bit is_on(string ev_name);
        uvm_event_pool event_pool = uvm_event_pool::get_global_pool();
        uvm_event ev = event_pool.get(ev_name);
        return ev.is_on();
    endfunction

    // Wrapper for is_off
    virtual function bit is_off(string ev_name);
        uvm_event_pool event_pool = uvm_event_pool::get_global_pool();
        uvm_event ev = event_pool.get(ev_name);
        return ev.is_off();
    endfunction

    // Wrapper for reset
    virtual function void reset(string ev_name, bit wakeup = 0);
        uvm_event_pool event_pool = uvm_event_pool::get_global_pool();
        uvm_event ev = event_pool.get(ev_name);
        ev.reset(wakeup);
    endfunction

    // Wrapper for cancel
    virtual function void cancel(string ev_name);
        uvm_event_pool event_pool = uvm_event_pool::get_global_pool();
        uvm_event ev = event_pool.get(ev_name);
        ev.cancel();
    endfunction

    // Wrapper for get_num_waiters
    virtual function int get_num_waiters(string ev_name);
        uvm_event_pool event_pool = uvm_event_pool::get_global_pool();
        uvm_event ev = event_pool.get(ev_name);
        return ev.get_num_waiters();
    endfunction

    // Wrapper for trigger
    virtual function void trigger(string ev_name, uvm_object data=null);
        uvm_event_pool event_pool = uvm_event_pool::get_global_pool();
        uvm_event ev = event_pool.get(ev_name);
        ev.trigger(data);
    endfunction

    // Wrapper for get_trigger_data
    virtual function uvm_object get_trigger_data(string ev_name);
        uvm_event_pool event_pool = uvm_event_pool::get_global_pool();
        uvm_event ev = event_pool.get(ev_name);
        return ev.get_trigger_data();
    endfunction

    // Wrapper for get_default_data
    virtual function uvm_object get_default_data(string ev_name);
        uvm_event_pool event_pool = uvm_event_pool::get_global_pool();
        uvm_event ev = event_pool.get(ev_name);
        return ev.get_default_data();
    endfunction

    // Wrapper for set_default_data
    virtual function void set_default_data(string ev_name, uvm_object data);
        uvm_event_pool event_pool = uvm_event_pool::get_global_pool();
        uvm_event ev = event_pool.get(ev_name);
        ev.set_default_data(data);
    endfunction


// custom task
    task wait_unit(int n);
    `ifndef VERILATOR
        #n;
    `endif
        $display("inside sv task in %d", $time);
    endtask:wait_unit

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
    export "DPI-C" function _print_factory;
    export "DPI-C" function _set_factory_inst_override;
    export "DPI-C" function _set_factory_type_override;
    export "DPI-C" function _debug_factory_create;
    export "DPI-C" function _find_factory_override;
    export "DPI-C" function _print_topology;

// uvm_event
export "DPI-C" task wait_on;
export "DPI-C" task wait_off;
export "DPI-C" task wait_trigger;
export "DPI-C" task wait_ptrigger;
export "DPI-C" task wait_trigger_data;
export "DPI-C" task wait_ptrigger_data;

export "DPI-C" function get_trigger_time;
export "DPI-C" function is_on;
export "DPI-C" function is_off;
export "DPI-C" function reset;
export "DPI-C" function cancel;
export "DPI-C" function get_num_waiters;
export "DPI-C" function trigger;
export "DPI-C" function get_trigger_data;
export "DPI-C" function get_default_data;
export "DPI-C" function set_default_data;

    export "DPI-C" task wait_unit;
    export "DPI-C" task start_seq;
    export "DPI-C" task write_reg;
    export "DPI-C" task read_reg;

    import "DPI-C" pure function string dirname(string file_path);
    import "DPI-C" context task py_func(input string mod_name, string func_name = "main", string mod_paths = "");
    task call_py_func(input string mod_name, string func_name = "main", string mod_paths = "");
        py_func(mod_name, func_name, mod_paths);
    endtask:call_py_func

endpackage