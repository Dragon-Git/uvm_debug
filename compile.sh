#!/bin/bash
# g++ -O3 -Wall -shared -std=c++17 -fPIC  -undefined dynamic_lookup $(python3 -m pybind11 --includes) src/svuvm.cpp -o svuvm$(python3-config --extension-suffix) $(python3-config --ldflags --embed) -I inc
verilator --binary +define+NOUVM -top top test/svuvm_pkg.sv test/api.sv $(python -c "import sysconfig; print(sysconfig.get_path('svuvm'))")/svuvm.cpython-312-darwin.so -LDFLAGS "$(python3-config --ldflags --embed)"
./obj_dir/Vtop