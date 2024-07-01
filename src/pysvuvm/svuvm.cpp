#include <dlfcn.h>
#include <libgen.h>
#ifdef __APPLE__
#include <mach-o/dyld.h>
#endif
#include <pybind11/pybind11.h>
#include <pybind11/embed.h>
#include "svdpi.h"

extern "C" {

namespace py = pybind11;

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
    uint32_t image_count = _dyld_image_count();
    Dl_info dl_info;

    for(uint32_t i=0; i<image_count; i++) {
        const char* image_name = _dyld_get_image_name(i);
        const struct mach_header* header = _dyld_get_image_header(i);

        if (dladdr(header, &dl_info) && (dl_info.dli_fbase == header)) {
            if (((intptr_t)py_func >= (intptr_t)header) && ((intptr_t)header + _dyld_get_image_vmaddr_slide(i)) > (intptr_t)py_func) {
                dir_path = dirname(const_cast<char*>(image_name));
                path.attr("append")(dir_path);
            }
        }
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
