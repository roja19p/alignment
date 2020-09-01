source activate irshad_parser
cd $HOME_anu_test
echo "Remove out files ..."
shell_scripts/remove_out-files.sh

echo "Compiling Anusaaraka dictionaries and source files ..."
shell_scripts/anu_compile.sh

cd $HOME_anu_test/miscellaneous/SMT/MINION/alignment/
echo "Compiling Alignment related dictionaries ..."
sh minion_compile.sh

cd $HOME_anu_test/miscellaneous/SMT/phrasal_alignment
echo "Compiling Phrasal related dictionaries ..."
sh compile.sh

conda deactivate
