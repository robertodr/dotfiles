if exists("g:loaded_hindent") || !executable("hindent")
    finish
endif
let g:loaded_hindent = 1

function! FormatHaskell()
    if !empty(v:char)
        return 1
    else
        let l:filter = "hindent --style " . g:hindent_style
        let l:command = v:lnum.','.(v:lnum+v:count-1).'!'.l:filter
        execute l:command
    endif
endfunction

if !exists("g:hindent_style")
    let g:hindent_style = "chris-done"
    "let g:hindent_style = "johan-tibell"
    "let g:hindent_style = "gibiansky"

endif

setlocal formatexpr=FormatHaskell()

