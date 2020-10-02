$HOME/ace-0.9.31/ace -g $HOME/ace-0.9.31/erg-2018-x86-64-0.9.31.dat -1Tf $1  > $1_mrs.txt

python3 S15.py  $1_mrs.txt > $1.txt
