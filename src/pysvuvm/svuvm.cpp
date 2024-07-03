#include <dlfcn.h>
#include <libgen.h>
#include <pybind11/pybind11.h>
#include <pybind11/embed.h>
#include "svdpi.h"

extern "C" {

namespace py = pybind11;
#if defined(VCS) || defined(VCSMX) || defined(XCELIUM) || defined(NCSC)
#include "uvm_dpi.h"    
#endif
void wait_unit(int n);
void start_seq(const char* seq_name, const char* sqr_name);
void write_reg(int address, int data);
void read_reg(int address, int *data);

int read_reg_wrap(int address) {
    int data;
    read_reg(address, &data);
    return data;
}

#if defined(VCS) || defined(VCSMX) || defined(XCELIUM) || defined(NCSC)
PYBIND11_MODULE(uvmdpi, m) {
    m.attr("UVM_INFO") = M_UVM_INFO;
    m.attr("UVM_WARNING") = M_UVM_WARNING;
    m.attr("UVM_ERROR") = M_UVM_ERROR;
    m.attr("UVM_FATAL") = M_UVM_FATAL;

    m.attr("UVM_NONE") = M_UVM_NONE;
    m.attr("UVM_LOW") = M_UVM_LOW;
    m.attr("UVM_MEDIUM") = M_UVM_MEDIUM;
    m.attr("UVM_HIGH") = M_UVM_HIGH;
    m.attr("UVM_FULL") = M_UVM_FULL;
    m.attr("UVM_DEBUG") = M_UVM_DEBUG;

    // Binding functions
    m.def("uvm_report", &m_uvm_report_dpi, "report function", py::arg("severity"), py::arg("id"), py::arg("message"), py::arg("verbosity"), py::arg("file"), py::arg("linenum"));

    m.def("int_str_max", &int_str_max, "Find the maximum of integers represented as strings.");

    m.def("uvm_re_match", &uvm_re_match, "Match a regular expression against a string.",
          py::arg("re"), py::arg("str"));

    m.def("uvm_glob_to_re", &uvm_glob_to_re, "Convert a glob pattern into a regular expression.",
          py::return_value_policy::reference);

    m.def("uvm_hdl_check_path", &uvm_hdl_check_path, "Check if a path exists in the HDL model.",
          py::arg("path"));

    m.def("uvm_hdl_read", &uvm_hdl_read, "Read data from a path in the HDL model.",
          py::arg("path"), py::arg("value"));

    m.def("uvm_hdl_deposit", &uvm_hdl_deposit, "Deposit data at a path in the HDL model.",
          py::arg("path"), py::arg("value"));

    m.def("uvm_hdl_force", &uvm_hdl_force, "Force a value at a path in the HDL model.",
          py::arg("path"), py::arg("value"));

    m.def("uvm_hdl_release_and_read", &uvm_hdl_release_and_read, "Release and read data from a path in the HDL model.",
          py::arg("path"), py::arg("value"));

    m.def("uvm_hdl_release", &uvm_hdl_release, "Release a path in the HDL model.",
          py::arg("path"));

    m.def("push_data", &push_data, "Push data to a specified level.",
          py::arg("lvl"), py::arg("entry"), py::arg("cmd"));

    m.def("walk_level", &walk_level, "Walk through a hierarchy at a given level.",
          py::arg("lvl"), py::arg("argc"), py::arg("argv"), py::arg("cmd"));

    m.def("uvm_dpi_get_next_arg_c", &uvm_dpi_get_next_arg_c, "Get the next argument from the command line.",
          py::arg("init"));

    m.def("uvm_dpi_get_tool_name_c", &uvm_dpi_get_tool_name_c, "Get the name of the current tool.",
          py::return_value_policy::reference);

    m.def("uvm_dpi_get_tool_version_c", &uvm_dpi_get_tool_version_c, "Get the version of the current tool.",
          py::return_value_policy::reference);

    m.def("uvm_dpi_regcomp", &uvm_dpi_regcomp, "Compile a regular expression.",
          py::arg("pattern"), py::return_value_policy::take_ownership);

    m.def("uvm_dpi_regexec", &uvm_dpi_regexec, "Execute a compiled regular expression against a string.",
          py::arg("re"), py::arg("str"));

    m.def("uvm_dpi_regfree", &uvm_dpi_regfree, "Free a compiled regular expression.",
          py::arg("re"));
}
#endif

PYBIND11_MODULE(svuvm, m) {
    m.doc() = "svuvm api module";

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
