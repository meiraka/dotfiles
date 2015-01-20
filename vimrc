let $LANG="en_US.utf8"
let $LC_LANG="en_US.utf8"
let $LC_ALL="en_US.utf8"

python << EOP
import sys
import os
import time

start = time.time()
sys.path.append(os.path.expanduser('~/.vim/'))
import vimrc
reload(vimrc)
end = time.time()
EOP
