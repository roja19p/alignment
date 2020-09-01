#!/bin/bash


python3 $HOME/Word_Grouping/E_Sanity_Check.py $1
echo "\n\n SANITY CHECK DONE "
python3 $HOME/Word_Grouping/E_Grouping_Word_Dependency_Sanity.py $1
echo "\n\n ENGLISH GROUPING DONE "
python3 $HOME/Word_Grouping/H_Grouping_Word.py $1
echo "\n\n HINDI GROUPING DONE "
