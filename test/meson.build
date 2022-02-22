project(
    'avalonia.skia',
    ['c','cpp']
)

gl_dep = dependency('gl', required: true)
fc_dep = dependency('fontconfig', static: true)
sk_dep = dependency('skia', static: true)

cpp = meson.get_compiler('cpp')

# sk_dep = declare_dependency(
#     dependencies : cpp.find_library('skia', dirs : meson.current_source_dir()+'/../out/skia/sysroot/usr/local/lib64'),
#     include_directories : include_directories('../out/skia/sysroot/usr/local/include/skia')
# )

lib = shared_library(
   'avalonia.skia',
   ['testlib.cpp'],
   dependencies: [fc_dep, gl_dep, sk_dep],
   install: true,
)

testprog = executable(
    'testprog',
    ['testprog.c'],
    link_with: lib,
    install: true
)
