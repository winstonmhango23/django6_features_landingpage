#!/usr/bin/env python
import os
import sys

if __name__ == "__main__":
    os.chdir("landingpage")
    os.execv(sys.executable, [sys.executable, "manage.py"] + sys.argv[1:])