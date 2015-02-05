let $LANG="en_US.utf8"
let $LC_LANG="en_US.utf8"
let $LC_ALL="en_US.utf8"

python << EOP
import sys
import os
import time

start = time.time()
sys.path.append(os.path.expanduser('~/.vim/'))

if 'vimrc' not in sys.modules:
    try:	
        import vimrc
    except:
        pass
else:
    print 'reload'
    import vimrc
    reload(vimrc)
end = time.time()
EOP
