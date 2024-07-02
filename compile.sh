#!/bin/bash
# g++ -O3 -Wall -shared -std=c++17 -fPIC  -undefined dynamic_lookup $(python3 -m pybind11 --includes) src/svuvm.cpp -o svuvm$(python3-config --extension-suffix) $(python3-config --ldflags --embed) -I inc
verilator --binary +define+NOUVM -top top \
$(python -m pysvuvm.config) -LDFLAGS "$(python3-config --ldflags --embed)" \
$PWD/test/api.sv \
$PWD/uvm-verilator/src/uvm.sv +incdir+$PWD/uvm-verilator/src \
-Wno-fatal -Wno-lint

./obj_dir/Vtop