#!/usr/bin/env python

import sys
import os


print("Assembling\n")

cmd = "nasm -felf64 {0}.nasm -o {0}.o".format(sys.argv[1][0:-5])

os.system(cmd)

print("Linking\n")

cmd = "ld {0}.o -o {0}".format(sys.argv[1][0:-5])

os.system(cmd)

print("Done..")




