#include <pybind11/pybind11.h>
#include <pybind11/embed.h> // everything needed for embedding
#include "svdpi.h"

extern "C" {

namespace py = pybind11;

void wait_unit();

PYBIND11_MODULE(svuvm, m) {
    m.doc() = "pybind11 example plugin"; // 可选模块文档字符串

    m.def("wait_unit", &wait_unit, "wait unit time");
}

void body(const char* py_seq) {
    py::scoped_interpreter guard{}; // start the interpreter and keep it alive

    py::module_ py_seq = py::module_::import(py_seq);
    py_seq.attr("main")();
}


}