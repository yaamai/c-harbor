from contextlib import contextmanager, ExitStack
import os
import shutil

@contextmanager
def copy(*args, **kwds):
    try:
        print("copy.start", args)
        yield
        print("copy.end", args)
    finally:
        print("copy.finally", args)

@contextmanager
def may_raise(*args, **kwargs):
    try:
        print("raise.start", args)
        if len(args) > 0 and args[0] == 100:
            raise Exception()
        yield
    finally:
        print("raise.finally", args)

@contextmanager
def copy_file(src, dest):
    try:
        shutil.copy(src, dest)
        yield
    finally:
        os.remove(dest)

@contextmanager
def replace_file(target, data):
    try:
        shutil.move(target, target+".org")
        with open(target, "w") as f:
            f.write(data)
        yield
    finally:
        os.remove(target)
        shutil.move(target+".org", target)


with ExitStack() as stack:
    stack.enter_context(copy_file("A", "B"))
    breakpoint()
    stack.enter_context(replace_file("A", "BBB"))
    breakpoint()
    stack.enter_context(may_raise(100))
    raise Exception()
