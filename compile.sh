#!/bin/bash
# g++ -O3 -Wall -shared -std=c++17 -fPIC  -undefined dynamic_lookup $(python3 -m pybind11 --includes) src/svuvm.cpp -o svuvm$(python3-config --extension-suffix) $(python3-config --ldflags --embed) -I inc
verilator -j $(nproc) --vpi --binary +define+NOUVM -top top -Mdir build \
$(python -m pysvuvm.config) -LDFLAGS "$(python3-config --ldflags --embed)" \
$PWD/test/api.sv \
$PWD/uvm-verilator/src/uvm.sv +incdir+$PWD/uvm-verilator/src \
-DUVM_NO_DPI \
-Wno-lint -Wno-style -Wno-SYMRSVDWORD -Wno-IGNOREDRETURN -Wno-CONSTRAINTIGN -Wno-ZERODLY \
--debug --gdbbt
# $PWD/uvm-verilator/src/dpi/uvm_dpi.cc \
# -CFLAGS "-I$PWD/uvm-verilator/src/dpi -I$PWD/inc" \
# -DUVM_CMDLINE_NO_DPI -DUVM_REGEX_NO_DPI -DUVM_HDL_NO_DPI \

./build/Vtop