import sys
import sysconfig
from pathlib import Path

getvar = sysconfig.get_config_var
pyver = getvar('VERSION')

so_file = Path(__file__).parent.parent / f"svuvm{getvar("EXT_SUFFIX")}"
sv_file = Path(__file__).parent / "svuvm_pkg.sv"

libs = []
libs.append('-lpython' + pyver + sys.abiflags)
libs.extend(getvar('LIBS').split() + getvar('SYSLIBS').split())

if not getvar('Py_ENABLE_SHARED'):
    libs.insert(0, '-L' + getvar('LIBPL'))
ldflags = ' '.join(libs)

print(f'{sv_file} {so_file} -LDFLAGS "{ldflags}"')