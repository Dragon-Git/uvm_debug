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
        return NULL;
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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>
#include <unistd.h>

// 新增辅助函数以从/proc/self/maps获取自身路径
char* getSelfPathLinux(void) {
    FILE* maps = fopen("/proc/self/maps", "r");
    if (!maps) {
        perror("Failed to open /proc/self/maps");
        return NULL;
    }

    char line[1024];
    while (fgets(line, sizeof(line), maps)) {
        if (strstr(line, "[stack]") || strstr(line, "[vdso]") ||
            strstr(line, "[vvar]") || strstr(line, "[vsyscall]")) {
            continue; // 跳过特殊段
        }

        char* begin = strchr(line, '/');
        if (begin) {
            char* path = strdup(begin);
            fclose(maps);
            return path;
        }
    }

    fclose(maps);
    perror("Failed to find executable path in /proc/self/maps");
    return NULL;
}

extern "C" {

// ... 其余原有C语言代码保持不变 ...

void py_func(const char* mod_name, const char* func_name, const char* mod_paths) {
    Dl_info dl_info;
    char* dir_path = NULL;
    // ... 其他初始化代码 ...

    // 在Linux环境下使用新方法获取路径
#ifdef __linux__
    dir_path = getSelfPathLinux();
    if (!dir_path) {
        fprintf(stderr, "Unable to determine executable path.\n");
        return;
    }
#else
    // macOS等其他系统保持原有逻辑
    if (dladdr((void*)py_func, &dl_info)) {
        dir_path = strdup(dirname(dl_info.dli_fname));
    }
#endif

    // 添加路径到Python模块搜索路径...
    // 注意：这里需要将C++的path.append调用转换为相应的C API调用或逻辑处理
    // 假设这部分逻辑已根据实际使用的Python嵌入API进行调整

    // 释放分配的内存
    free(dir_path);

    // ... 其余原有代码 ...
}

} // extern "C"