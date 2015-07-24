git clone https://github.com/soumith/badmm.torch
cd badmm.torch

luarocks make

th test.lua


To debug in gdb if needed:

gdb luajit
r test.lua