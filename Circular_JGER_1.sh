#!/bin/bash

dir_data=/home/jean-guillaume/Bureau/Travaux/Salmonella/Plasmidome



#======================================================================================#
##Circular analysis etape 1
#======================================================================================#
echo -e "   Circular analysis $(date)   \n" | tee -a "$dir_data/summary.txt"


while read serotype;
do
rm -R $dir_data/$serotype/Circular_JGER/;
done < $dir_data/ListeRep.txt


while read serotype;
do
echo $serotype | tee -a "$dir_data/summary.txt"
mkdir $dir_data/$serotype/Circular_JGER/;
while read plasmid; 
do 
number1=$(seq_length.py $dir_data/$serotype/fasta/$plasmid.fasta | awk '{print $2}'); 
number2=$(expr $number1 - 300) ; 
water -asequence $dir_data/$serotype/fasta/$plasmid.fasta -bsequence $dir_data/$serotype/fasta/$plasmid.fasta $plasmid.circular.out -adirectory3 $dir_data/$serotype/Circular_JGER/ -sbegin1 1 -send1 300 -sbegin2 $number2 -send2 $number1 -gapopen 10 -gapextend 5 &>> $dir_data/summary.txt; 
done < $dir_data/$serotype/ListePlasmids.$serotype.txt;
done < $dir_data/ListeRep.txt



echo "***Circular analysis DONE!! $(date)***" | tee -a "$dir_data/summary.txt"
#======================================================================================#
echo -e "#===================================================================================#\n" | tee -a "$dir_data/summary.txt"

echo -e "Have done M. Emond-R\n"

echo "Have a good day"
