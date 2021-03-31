import glob
import platform
import sys


def main():
    # attempt to find/import built libraries

    try:
        _system = platform.system()
        if _system == "Linux":
            _system = "linux"
        elif _system == "Darwin":
            _system = "macosx"
        elif _system == "Windows":
            raise Exception("WINDOWS BUILD PATH NOT ADDED")

        g = glob.glob("build/lib.{}*".format(_system))
        if len(g) < 1:
            raise Exception(
                "COULD NOT FIND LIBRARY FOR {}".format(platform.system()))

        sys.path.append(g[0])

    except Exception:
        raise  # catching bare excepts is a no-no unless it just propogates
    else:
        # import the library
        import RenderManager

        # init the render manager
        # which takes care of creating window, starting threads
        # etc.
        renderer = RenderManager.RenderManager((1280, 720))
        renderer.start()


if __name__ == '__main__':
    main()
