#include <pybind11/pybind11.h>
#include <pybind11/embed.h>
#include "svdpi.h"

extern "C" {

namespace py = pybind11;

void wait_unit(int n);

PYBIND11_MODULE(svuvm, m) {
    m.doc() = "svuvm api module";

    m.def("wait_unit", &wait_unit, "wait unit time");
}

void py_func(const char* py_seq) {
    py::scoped_interpreter guard{}; // start the interpreter and keep it alive

    py::module_ py_seq_mod = py::module_::import(py_seq);
    py_seq_mod.attr("main")();
}


}