if exists("g:loaded_demoplugin")
    finish
endif
let g:loaded_demoplugin = 1

lua require("demo_plugin").say_hi()
command! -nargs=0 SayHi lua require("demo_plugin").say_hi()
