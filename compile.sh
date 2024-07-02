#!/bin/bash
# g++ -O3 -Wall -shared -std=c++17 -fPIC  -undefined dynamic_lookup $(python3 -m pybind11 --includes) src/svuvm.cpp -o svuvm$(python3-config --extension-suffix) $(python3-config --ldflags --embed) -I inc
verilator -j $(nproc) --vpi --binary +define+UVM_NO_DPI -top top -Mdir build \
+incdir+$PWD/uvm-verilator/src $PWD/uvm-verilator/src/uvm_pkg.sv \
$(python -m pysvuvm.config) -LDFLAGS "$(python3-config --ldflags --embed)" \
$PWD/test/api.sv \
-Wno-lint -Wno-style -Wno-SYMRSVDWORD -Wno-IGNOREDRETURN -Wno-CONSTRAINTIGN -Wno-ZERODLY \

# $PWD/uvm-verilator/src/dpi/uvm_dpi.cc \
# -CFLAGS "-I$PWD/uvm-verilator/src/dpi -I$PWD/inc" \
# -DUVM_CMDLINE_NO_DPI -DUVM_REGEX_NO_DPI -DUVM_HDL_NO_DPI \

./build/Vtop