# raymarching renderer

## environment
- python 3.8
    - mac: framework Python build
    - Cython
    - wxPython
    - ffmpeg

should work fine on mac, WSL, win 10. untested standard linux. may require xwindows server.

outputs .bmp files to ./out/bin for each frame, ./out/comp is an example ffmpeg call to make a video.

demo1_1early.mp4 is the first, early version of demo 1

## usage
to build & run: `python3.8 setup.py install`

to clean all: `python3.8 setup.py deepclean`

to run after compile: `python3.8 main.py`
