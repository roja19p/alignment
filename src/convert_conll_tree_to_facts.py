import sys
import pandas as pd


data = pd.read_csv(sys.argv[1],sep='\t',header=None)

A_id = data[0].tolist()
Wds = data[1].tolist()
Cat = data[3].tolist()
H_id = data[6].tolist()
R_id = data[7].tolist()

for i in range(0, len(A_id)):
    print('(id-word-cat-head_id-rel', A_id[i], Wds[i], Cat[i], H_id[i], R_id[i], ')')


