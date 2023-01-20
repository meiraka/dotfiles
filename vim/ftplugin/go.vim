set makeprg=go\ test\ ./...\ -count\ 1
let &errorformat = '%-Gok %.%#s,%-Gok %.%#(cached),%-G? %.%#[no test files],%A%.%#--- FAIL: %m (%.%#)%.%#,%Z%f:%l:%m,%f:%l:%c:%m,%A%m(%.%#),%Z %#%f:%l +0x%.%#,%Z %#%f:%l'


