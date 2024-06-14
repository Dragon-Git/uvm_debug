#include <pybind11/pybind11.h>
#include <pybind11/embed.h>
#include "svdpi.h"

extern "C" {

namespace py = pybind11;

void wait_unit(int n);
void start_seq(const char* seq_name, const char* sqr_name);

PYBIND11_MODULE(svuvm, m) {
    m.doc() = "svuvm api module";

    m.def("wait_unit", &wait_unit, "wait unit time");
    m.def("start_seq", &start_seq, "start seq on sqr");
}

void py_func(const char* mod_name, const char* func_name, const char* mod_paths) {
    py::scoped_interpreter guard{}; // start the interpreter and keep it alive

    if(mod_paths && *mod_paths != "\0") {
        py::module_ sys = py::module_::import("sys");
        py::list path = sys.attr("path");
        path.attr("append")(mod_paths);
        }
    py::module_ py_seq_mod = py::module_::import(mod_name);
    py_seq_mod.attr(func_name)();
}


}