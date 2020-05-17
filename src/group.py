import sys


with open(sys.argv[1]) as f:
    lines = f.readlines()

snt_grp = []
for l in lines:
    grps = ' '.join(l.strip(')\n ').split()[2:])
    snt_grp.append("(("+grps+"))")

print(str(sys.argv[2]) +'\t' +'\t'.join(snt_grp))
