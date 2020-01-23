import sys


with open(sys.argv[1]) as f:
    lines = f.readlines()

snt_grp = []
for l in lines:
    grps = l.split('  ')[1].strip(')\n ')
    snt_grp.append("(("+grps+"))")

print(str(sys.argv[2]) +'\t' +'\t'.join(snt_grp))
