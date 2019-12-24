from pyswip import Prolog
import os
import sys

f = open("test.out", 'w')
sys.stdout = f
program = Prolog()
program.consult("eval.pl")
for root,dirs,files in os.walk('.'):
    for dir in dirs:
        dirname = os.path.join(root,dir)
        for r,d,f in os.walk(dir):
            for fi in f:
                filename  = os.path.join(dirname,fi)
                print(filename)
                res = list(program.query("main('" + filename +"')."))
