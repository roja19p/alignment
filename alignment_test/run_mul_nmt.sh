MYPATH=`pwd`
rm -f diff
DATE="$(date +'%d_%m_%Y')"
echo $DATE

cd $HOME_anu_tmp/tmp/$1_tmp
mkdir mul_nmts
mkdir outputs
#echo "000000.wx" > sent_num.txt_tmp
ls $MYPATH/mul_nmt_files/*.wx > sent_num.txt_tmp
sed -i 's/.*\///g' sent_num.txt_tmp
sed -i 's/.wx//g' sent_num.txt_tmp
sort -u -n sent_num.txt_tmp > sent_num.txt
sed  -i '1i 00000' sent_num.txt

mkdir -p outputs
mkdir -p mul_nmts

exec 3<dir_names.txt
exec 4<sent_num.txt

while read line  <&3 && read line1 <&4
do
	echo $line
	cd $line
	sh $HOME_alignment/shell_scripts/mul_nmt.sh $line1 $MYPATH 
	#$1 $line
	cp $line1 ../mul_nmts/
	grep "^ENG" $line1 > h_sentence
	grep "NMT" $line1 >> h_sentence
	cp p3_alignment_utf8.csv ../outputs/p3_align_"$line"_"$DATE".csv
	cd ..
done	
