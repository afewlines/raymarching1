# import array
import glob
import os
import shutil
import sys

try:
    from setuptools import (Extension, find_namespace_packages, find_packages,
                            setup)
finally:
    from Cython.Build import cythonize
    from Cython.Distutils import build_ext

# define the modules to build
# modules: ComputeWrapper, RenderManager, WindowManager
# ComputeWrapper compiles all cpp source used to compile
ext_modules = [
    Extension("pymarch.world.WorldWrapper",
              ["./src/c/DataStructures/vec3.cpp",
               "./src/c/DataStructures/vec2.cpp",
               "./src/c/Objects/RenderableObject.cpp",
               "./src/c/Objects/RenderablePrimitives.cpp",
               "./src/c/Objects/World.cpp",
               "./src/pymarch/world/WorldWrapper.pyx",
               ],
              language='c++',
              include_dirs=["./src"],
              ),

    Extension("pymarch.compute.ComputeWrapper",
              ["./src/c/DataStructures/vec3.cpp",
               "./src/c/DataStructures/vec2.cpp",
               "./src/c/Compute/RayMarchLib.cpp",
               "./src/c/Compute/Computer.cpp",
               "./src/pymarch/compute/ComputeWrapper.pyx",
               ],
              language='c++',
              include_dirs=["./src"],
              ),

    Extension("pymarch.RenderManager", ["./src/pymarch/RenderManager.pyx"],),

    Extension("pymarch.WorldManager", ["./src/pymarch/WorldManager.pyx"],),

    Extension("pymarch.WindowManager", ["./src/pymarch/WindowManager.pyx"],),
]

# process deepclean before setup,
# allows to finish with call to normal clean
if "deepclean" in sys.argv:
    for i in glob.glob("./build/"):
        shutil.rmtree(i)

    for i in glob.glob("./dist/"):
        shutil.rmtree(i)

    for i in glob.glob("./src/*egg-info/"):
        shutil.rmtree(i)

    for i in glob.glob("./src/pymarch/**/*.c*", recursive=True):
        os.remove(i)

    # continue on to normal clean
    sys.argv[1] = "clean"
    sys.exit(0)

ext_modules = cythonize(ext_modules, include_path=["./src"])
packages = find_packages(where="./src")
package_data = {name: ['*.pxd', '*.pyx'] for name in packages}
# print(ext_modules)
# print(packages)
# print(package_data)
# input()
setup(name="python-raymarching",
      author="brad, seeker",
      ext_modules=ext_modules,
      packages=packages,
      package_dir={"": "./src"},
      package_data=package_data,
      zip_safe=False,
      )
