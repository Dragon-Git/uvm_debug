from glob import glob
from setuptools import setup
from pybind11.setup_helpers import Pybind11Extension, build_ext


class CustomExtension(Pybind11Extension):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        if "-fvisibility=hidden" in self.extra_compile_args:
            self.extra_compile_args.remove("-fvisibility=hidden")
        
class custom_build_ext(build_ext):  # noqa: N801
    """ Customized build_ext that remove some compile flags. """

    def build_extensions(self) -> None:
        """ Build extensions, remove some compile flags. """

        if "-bundle" in self.compiler.linker_so:
            self.compiler.linker_so.remove("-bundle")
        super().build_extensions()


ext_modules = [
    CustomExtension(
        "svuvm",
        sorted(glob("src/pysvuvm/*.cpp")),
        include_dirs=["inc"],
        cxx_std=20,
        extra_link_args=["-shared", "-fPIC"],
    ),
]

setup(cmdclass={"build_ext": custom_build_ext}, ext_modules=ext_modules)