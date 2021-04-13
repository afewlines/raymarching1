# import array
import glob
import os
import shutil
import sys

try:
    from setuptools import Extension, setup
finally:
    from Cython.Distutils import build_ext

# define the modules to build
# modules: ComputeWrapper, RenderManager, WindowManager
# ComputeWrapper compiles all cpp source used to compile
ext_modules = [
    Extension("ComputeWrapper",
              ["./c/DataStructures/vec3.cpp",
               "./c/DataStructures/vec2.cpp",
               "./c/Compute/RayMarchLib.cpp",
               "./c/Compute/Computer.cpp",
               "./py/compute/ComputeWrapper.pyx",
               ],
              language='c++',
              extra_compile_args=['-std=c++11']),

    Extension("RenderManager", ["./py/RenderManager.pyx"]),

    Extension("WindowManager", ["./py/window/WindowManager.pyx"]),
]

# process deepclean before setup,
# allows to finish with call to normal clean
if "deepclean" in sys.argv:
    for i in glob.glob("./build/**"):
        shutil.rmtree(i)

    for i in glob.glob("./py/**/*.c*", recursive=True):
        os.remove(i)

    # continue on to normal clean
    sys.argv[1] = "clean"

setup(cmdclass={'build_ext': build_ext},
      ext_modules=ext_modules, build_dir="build")


# if __name__ == '__main__' and "clean" not in sys.argv:
#     os.system("python3.8 main.py")
