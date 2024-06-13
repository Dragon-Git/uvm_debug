module top ();
    task wait_unit();
        #1;
        $display("inside sv task in %d", $time);
    endtask
    export "DPI-C" task wait_unit;
    import "DPI-C" context task py_func(input string py_seq);
    initial begin
        py_func("run");
    end
endmodule