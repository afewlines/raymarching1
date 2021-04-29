import glob
import platform
import sys

_SYSTEMS = {
    'Linux': 'linux',
    'Darwin': 'macosx',
    'Windows': 'win',
}


def main():
    # attempt to find/import built libraries
    try:
        _sys = platform.system()
        g = glob.glob("./build/lib.{}*".format(_SYSTEMS[_sys]))
        if len(g) < 1:
            pass
            #raise Exception("COULD NOT FIND LIBRARY FOR {}".format(_sys))

        # sys.path.append(g[0])
        sys.path.append("./dist")

    except Exception:
        raise  # catching bare excepts is a no-no unless it just propogates
    else:
        # import the library
        from pymarch.RenderManager import RenderManager

        # init the render manager
        # which takes care of creating window, starting threads
        # etc.
        # ______________________________________________________
        # renderer = RenderManager((1920, 1080))
        # renderer = RenderManager((1280, 720))
        renderer = RenderManager((640, 480))
        # renderer = RenderManager((512, 512))
        # renderer = RenderManager((256, 256))  # tiny window gang
        renderer.start()


if __name__ == '__main__':
    main()
