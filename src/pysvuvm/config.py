import sys
import sysconfig
from pathlib import Path

getvar = sysconfig.get_config_var
pyver = getvar('VERSION')
so_name = "svuvm" + getvar("EXT_SUFFIX")

so_file = Path(__file__).parent.parent / so_name
sv_file = Path(__file__).parent / "svuvm_pkg.sv"

print(f'{sv_file} {so_file}')