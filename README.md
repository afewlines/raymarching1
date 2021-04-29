# pymarch, a raymarching renderer

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

-----

## links
kutztown csc department r&t presentation: [google slides link](https://docs.google.com/presentation/d/1HdBvRuaL9f4JIk-j4Zb_dHTzz1knB4vra6_DgHQGZx8/edit?usp=sharing)

shadertoy prototypes: [spatial warping](https://www.shadertoy.com/view/ttyBzV), [material testing](https://www.shadertoy.com/view/3lyBzc), [smooth min](https://www.shadertoy.com/view/NsjXRz)
