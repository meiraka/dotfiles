set makeprg=go\ test\ ./...
let &errorformat = '%A%.%#--- FAIL: %m (%.%#)%.%#,%Z%f:%l:%m,%f:%l:%c:%m,%-G%.%#'


