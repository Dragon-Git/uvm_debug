#include <dlfcn.h>
#include <libgen.h>
#include <pybind11/pybind11.h>
#include <pybind11/embed.h>
#include "svdpi.h"

extern "C" {

namespace py = pybind11;

#include "uvm_dpi.h"

void wait_unit(int n);
void start_seq(const char* seq_name, const char* sqr_name);
void write_reg(int address, int data);
void read_reg(int address, int *data);

int read_reg_wrap(int address) {
    int data;
    read_reg(address, &data);
    return data;
}

PYBIND11_MODULE(svuvm, m) {
    m.doc() = "svuvm api module";

    m.def("uvm_report", &m_uvm_report_dpi, "uvm report by dpi");
    m.def("wait_unit", &wait_unit, "wait unit time");
    m.def("start_seq", &start_seq, "start seq on sqr");
    m.def("write_reg", &write_reg, "write register");
    m.def("read_reg", &read_reg_wrap, "read data");

}

void py_func(const char* mod_name, const char* func_name, const char* mod_paths) {
    char *dir_path;
    py::scoped_interpreter guard{}; // start the interpreter and keep it alive

    py::module_ sys = py::module_::import("sys");
    py::list path = sys.attr("path");

#ifdef __linux__
    FILE* maps = fopen("/proc/self/maps", "r");
    if (!maps) {
        perror("Failed to open /proc/self/maps");
        return;
    }

    char self_addr_str[20];
    snprintf(self_addr_str, sizeof(self_addr_str), "%p", (void*)py_func);

    char line[256];
    while (fgets(line, sizeof(line), maps)) {
        if (strstr(line, self_addr_str)) {
            char* sopath = strchr(line, ' ');
            if (sopath) {
                sopath = strtok(sopath, "\n");
                fclose(maps);
                dir_path = dirname(sopath);
                path.attr("append")(dir_path);
            }
        }
    }    
#elif defined(__APPLE__)
    Dl_info dl_info;
    if (dladdr((void*)py_func, &dl_info)) {
        dir_path = dirname(const_cast<char*>(dl_info.dli_fname));
        path.attr("append")(dir_path);
    }
#else
#error Platform not supported.
#endif

    if(strcmp(mod_paths, "") != 0) {
        path.attr("append")(mod_paths);
    }
    py::print(path);
    py::module_ py_seq_mod = py::module_::import(mod_name);
    py_seq_mod.attr(func_name)();
}

}
