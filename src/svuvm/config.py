import sysconfig
from pathlib import Path

getvar = sysconfig.get_config_var
so_name = "svuvm" + getvar("EXT_SUFFIX")

so_file = Path(__file__).parent / so_name
sv_file = Path(__file__).parent / "python_bridge_pkg.sv"

print(f'{sv_file} {so_file}')