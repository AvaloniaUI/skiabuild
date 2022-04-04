project(
    'avalonia.skia',
    ['c','cpp']
)

sk_dep = dependency('skia', static: true)

cpp = meson.get_compiler('cpp')

lib = shared_library(
   'avalonia.skia',
   ['testlib.cpp'],
   dependencies: [sk_dep],
   install: true,
)

testprog = executable(
    'testprog',
    ['testprog.c'],
    link_with: lib,
    install: true
)
