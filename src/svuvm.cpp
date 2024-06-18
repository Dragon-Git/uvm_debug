#include <dlfcn.h>
#include <libgen.h>
#include <pybind11/pybind11.h>
#include <pybind11/embed.h>
#include "svdpi.h"

extern "C" {

namespace py = pybind11;

void wait_unit(int n);
void start_seq(const char* seq_name, const char* sqr_name);
void write_reg(int address, int data);
void read_reg(int address, int *data);

PYBIND11_MODULE(svuvm, m) {
    m.doc() = "svuvm api module";

    m.def("wait_unit", &wait_unit, "wait unit time");
    m.def("start_seq", &start_seq, "start seq on sqr");
    m.def("write_reg", &write_reg, "write register");
    m.def("read_reg", &read_reg, "read data");

}

void py_func(const char* mod_name, const char* func_name, const char* mod_paths) {
    Dl_info dl_info;
    char *dir_path;
    py::scoped_interpreter guard{}; // start the interpreter and keep it alive

    py::module_ sys = py::module_::import("sys");
    py::list path = sys.attr("path");
    if (dladdr((void*)py_func, &dl_info)) {
        dir_path = dirname(const_cast<char*>(dl_info.dli_fname));
        path.attr("append")(dir_path);
    }
    if(strcmp(mod_paths, "") != 0) {
        path.attr("append")(mod_paths);
    }
    py::print(path);
    py::module_ py_seq_mod = py::module_::import(mod_name);
    py_seq_mod.attr(func_name)();
}


}