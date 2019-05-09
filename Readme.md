# Frizlab’s Conf
Use at your own risks.

Heavily based on [wincent’s conf](https://github.com/wincent/wincent) for the
Ansible setup.

Run `./run-ansible help` for info. Note that Python3 is required for all of this
to work:
```
Ansible works fine with Python 2, and Python 2 is the only Python
installed on macOS by default. Would it make sense to use Python2
instead of Python 3? Yes. However I consider Python 2 as obsolete
(and so does Python: https://www.python.org/dev/peps/pep-0373/).
Thus, I force the usage of Python 3 whenever I can…

AFAIK, there should only be the inventory.py script (in this repo) and
the virtualenv setup (in run-ansible) that should have to be modified
to have everything working with Python2, if need be.
```

## .bash_profile, .bashrc & .profile

### Docs
- man bash, § INVOCATION
- https://unix.stackexchange.com/a/119675
- https://superuser.com/a/789705
- https://kb.iu.edu/d/abdy
- https://github.com/rbenv/rbenv/wiki/unix-shell-initialization

### Roles

#### `.bash_profile`
Should contain only bash-specific conf that is propagated to its children.
For instance, exported env variables, exported functions (this is possible with
bash with `export -f func_name`).

It is important to know aliases cannot be exported.

#### `.profile`
Should contain only POSIX-compliant conf that is propagated to its children.

**Important**: In theory [it is not possible to export a function in a POSIX
shell](https://stackoverflow.com/a/29239838), though `bash --posix` does not
complain when doing it, for whatever reason, neither on Debian, nor on macOS!

#### `.bashrc`
Should contain only bash-specific conf that cannot be propagated to children.
Aliases might fall into this category, but you might want to put them in `.shrc`
if they’re POSIX-compliant.

#### `.shrc`
(Not a standard file per-se.)  
Should contain only POSIX-compliant conf that cannot be propagated to children
(e.g. aliases).


### Scenarios
All login shells are considered interactive.  
All of this has been tested on macOS and Debian. On both, the shell is `bash`,
even when launching an `sh` shell. However, when `bash` is launched as `sh`, it
tries and mimic the startup behavior of `sh`, while still conforming to the
POSIX standard (says the man of bash).

#### bash, login
- `.bash_profile`
  - imports `.profile`
  - …
  - imports `.bashrc`
    - imports `.shrc`
    - …

#### bash, non-login, interactive
- `.bashrc`
  - imports `.shrc`
  - …

#### sh, login
- `.profile`
  - …
  - imports `.shrc` via the `ENV` variable, only if it is not already set

#### sh, non-login, interactive
- `.shrc` via the `ENV` variable, only if the login shell above had set it

#### bash --posix
Does not load anything unless the `ENV` var is set, in which case it loads the
file in `$ENV` (in theory; not the behavior observed on macOS; untested on
Debian).
