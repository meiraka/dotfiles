set makeprg=go\ test\ ./...
let &errorformat = '%Z%f:%l:%m,%A%.%#--- FAIL: %m (%.%#)%.%#,%f:%l:%c:%m,%-G%.%#'


