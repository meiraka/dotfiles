"""
pretty vim interface.

Copyright 2014 mei raka
"""

import re
import vim

_pyfuncs = {}


class _Function(object):

    """Represent vim function as callable object."""

    def __init__(self, name):
        """Convert vim function str to Function."""
        self.name = name

    def __call__(self, *args):
        """Execute vim function by python."""
        vim.evaled_args = u', '.join(_py2vimliteral(i) for i in args)
        cmd = u'let s:funcret = %s(%s)' % (self.name, vim.evaled_args)
        vim.command(cmd)
        ret = vim.eval('s:funcret')
        vim.command('unlet s:funcret')
        return ret


class _Command(object):

    """Represent vim command as callable object."""

    def __init__(self, name):
        self.name = name

    def __call__(self, *args):
        fixed_args = u' '.join(args)
        vim.command('%s %s' % (self.name, fixed_args))


def _py2vimliteral(python_value):
    if type(python_value) == unicode:
        return u'"%s"' % python_value.replace(u'"', u'\\"')
    elif type(python_value) == str:
        return u'"%s"' % python_value.replace(u'"', u'\\"')
    elif type(python_value) in [int, float]:
        return unicode(python_value)
    elif type(python_value) == bool:
        return str(int(python_value))
    elif type(python_value) == list:
        return '[%s]' % ','.join([_py2vimliteral(i) for i in python_value])
    elif type(python_value) == dict:
        return '{%s}' % ','.join(
            ['%s:%s' % (_py2vimliteral(k), _py2vimliteral(v))
                for k, v in python_value.iteritems()])
    else:
        raise ValueError(python_value)


class _Commands(object):
    def __getattr__(self, name):
        return _Command(name)

commands = _Commands()


class _Functions(object):
    def __init__(self, prefix=u''):
        self.__dict__['_prefix'] = prefix
        self.__dict__['_cache'] = {}

    def __getattr__(self, name):
        return self._cache.setdefault(
            self._prefix + name, _Function(self._prefix + name))

    def __setattr__(self, name, func):
        if self._prefix in (u'', u'v'):
            return
        _pyfuncs.setdefault(self._prefix, {})[name] = func
        command = '''function! %s%s(...)
python << EOP
import viimproved
args = []
if not viimproved.vim.eval('a:0') == '0':
    args = viimproved.vim.eval('a:000')
viimproved._pyfuncs['%s']['%s'](*args)
EOP
endfunction''' % (self._prefix, name, self._prefix, name)
        vim.command(command)

functions = _Functions()


class _Variables(object):
    def __init__(self, prefix=u'g:'):
        self.__dict__['_prefix'] = prefix

    def __getattr__(self, name):
        return vim.eval(u'%s%s' % (self._prefix, name))

    def __setattr__(self, name, value):
        return commands.let(u'%s%s=%s' % (self._prefix,
                                          name,
                                          _py2vimliteral(value)))

variables = _Variables('v:')


class _Scope(object):
    def __init__(self, prefix):
        self._prefix = prefix
        self.functions = _Functions(prefix)
        self.variables = _Variables(prefix)

local = _Scope(u's:')
globals = _Scope(u'g:')
buffer = _Scope(u'b:')


class _AutoloadFunctions(object):
    def __init__(self):
        self.autoloads = {}

    def __getattr__(self, name):
        return self.autoloads.setdefault(name,
                                         _Scope(name + u'#'))

autoloads = _AutoloadFunctions()


class _Settings(object):
    def __getattr__(self, name):
        return vim.eval('&{0}'.format(name))

    def __setattr__(self, name, value):
        if value is True:
            commands.set(name)
        elif value is False:
            commands.set('no' + name)
        else:
            commands.set(name + '=' + unicode(value))

settings = _Settings()


class _AutoCommands(object):
    class _RawAutoCommands(object):
        def __init__(self):
            self._funcs = []
            self._func_count = 0

        def bind(self, event, pattern, func, args=None, nested=False):
            """bind function to vim events."""
            nested = 'nested' if nested else ''
            args = [] if args is None else args
            if type(func) == _Function or type(func) == _Command:
                self._funcs.append((event, pattern, nested, func, args))
            else:
                name = 'PyAutocmd_%s_%s_%s_%i' % (event,
                                                  pattern.replace('*', 'p'),
                                                  func.__name__,
                                                  self._func_count)
                name = re.sub(re.compile("[!-/:-@[-`{-~\s]"), '_', name)

                def wrap_func():
                    func(*args)
                setattr(globals.functions, name, wrap_func)
                self._funcs.append((event, pattern, nested,
                                    getattr(globals.functions, name), []))

        def update(self):
            """Update autocmd."""
            vim.command('augroup pyvim')
            vim.command('autocmd!')
            for event, pattern, nested, func, args in self._funcs:
                if type(func) == _Command:
                    cmd = 'autocmd %s %s %s %s %s' % (
                        event, pattern, nested, func.name, ' '.join(
                          i for i in args))
                    vim.command(cmd)
                elif type(func) == _Function:
                    cmd = 'autocmd %s %s %s :call %s(%s)' % (
                        event, pattern, nested, func.name, ' ,'.join(
                          _py2vimliteral(i) for i in args))
                    vim.command(cmd)
            vim.command('augroup END')

    def __init__(self):
        self._raw = _AutoCommands._RawAutoCommands()

    def bind(self, event, pattern, func, args=None, nested=False):
        self._raw.bind(event, pattern, func, args=args, nested=nested)
        self._raw.update()

    def unbind(event, pattern, func, nested=''):
        pass

autocmd = _AutoCommands()
