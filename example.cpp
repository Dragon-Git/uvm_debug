#include <pybind11/pybind11.h>
#include <pybind11/embed.h> // everything needed for embedding
#include "svdpi.h"
namespace py = pybind11;

extern "C" void body() {
    py::scoped_interpreter guard{}; // start the interpreter and keep it alive

    py::module_ sys = py::module_::import("sys");
    py::print(sys.attr("path"));
    py::module_ run = py::module_::import("run");
    py::object result = run.attr("add")(1, 2);
    int n = result.cast<int>();
    assert(n == 3);
}

int add(int i, int j) {
    return i + j;
}

PYBIND11_MODULE(example, m) {
    m.doc() = "pybind11 example plugin"; // 可选模块文档字符串

    m.def("add", &add, "A function which adds two numbers");
}