project(
    'avalonia.skia',
    ['c','cpp']
)

sk_dep = dependency('skia', static: true)

cpp = meson.get_compiler('cpp')

avalonia_skia_lib = shared_library(
   'avalonia.skia',
   ['avalonia.skia.cpp'],
   dependencies: [sk_dep],
   install: true,
)

testprog = executable(
    'avalonia.skia.testprog',
    ['testprog.c'],
    link_with: avalonia_skia_lib,
    install: true
)
