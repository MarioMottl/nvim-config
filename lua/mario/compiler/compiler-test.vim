if exists("current_compiler")
  finish
endif

let current_compiler = "compiler-test"

CompilerSet makeprg=echo\ Hello\ World
CompilerSet errorformat=%m
