#!/bin/bash

dir_data=/home/jean-guillaume/Bureau/Travaux/Salmonella/Plasmidome



#======================================================================================#
##Circular analysis etape 4 --> je veux trouver le nombre de plasmides pouvant etre circulatise!! Tres important cette information.
#======================================================================================#
echo -e "   Circular analysis etape 4 --> All plasmids $(date)   \n" | tee -a "$dir_data/summary.txt"


rm -R $dir_data/All_plasmids/Circular_JGER/
rm $dir_data/All_plasmids/All_Plasmids.circular.txt
mkdir $dir_data/All_plasmids/Circular_JGER/


while read plasmid;
do
number1=$(seq_length.py $dir_data/All_plasmids/fasta/$plasmid.fasta | awk '{print $2}'); 
number2=$(expr $number1 - 300) ; 
water -asequence $dir_data/All_plasmids/fasta/$plasmid.fasta -bsequence $dir_data/All_plasmids/fasta/$plasmid.fasta $plasmid.circular.out -adirectory3 $dir_data/All_plasmids/Circular_JGER/ -sbegin1 1 -send1 300 -sbegin2 $number2 -send2 $number1 -gapopen 10 -gapextend 5 &>> $dir_data/summary.txt; 
done < $dir_data/All_plasmids/ListePlasmids.txt;


while read plasmid; 
do
length1=$(grep 'Length' $dir_data/All_plasmids/Circular_JGER/$plasmid.circular.out | sed 's/# Length: //');
identity=$(grep 'Identity' $dir_data/All_plasmids/Circular_JGER/$plasmid.circular.out | sed 's/# Identity://' | sed 's/ //g');
similarity=$(grep 'Similarity' $dir_data/All_plasmids/Circular_JGER/$plasmid.circular.out | sed 's/# Similarity://' | sed 's/ //g');
gaps=$(grep 'Gaps' $dir_data/All_plasmids/Circular_JGER/$plasmid.circular.out | sed 's/# Gaps://' | sed 's/ //g');
scores=$(grep 'Score' $dir_data/All_plasmids/Circular_JGER/$plasmid.circular.out | sed 's/# Score: //');
echo $plasmid | awk -vlength1="$length1" -videntity="$identity" -vsimilarity="$similarity" -vgaps="$gaps" -vscores="$scores"  '{print $1 "\t" length1 "\t" identity "\t" similarity "\t" gaps "\t" scores}' 
done < $dir_data/All_plasmids/ListePlasmids.txt | sort -Vk6,6 > $dir_data/All_plasmids/All_Plasmids.circular.txt

sed -i '1icontig_name\tlength_alignment\tidentity_alignment\tsimilarity_alignment\tgaps_alignment\tscores_alignment' $dir_data/All_plasmids/All_Plasmids.circular.txt



echo "***Circular analysis DONE!! $(date)***" | tee -a "$dir_data/summary.txt"
#======================================================================================#
echo -e "#===================================================================================#\n" | tee -a "$dir_data/summary.txt"

echo -e "Have done M. Emond-R\n"

echo "Have a good day"
