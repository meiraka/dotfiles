set makeprg=go\ test\ ./...
let &errorformat = '%Z%f:%l:%m,%A%.%#--- FAIL: %m (%.%#)%.%#,%-G%.%#'


