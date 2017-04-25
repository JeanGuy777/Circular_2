#!/bin/bash

dir_data=/home/jean-guillaume/Bureau/Travaux/Salmonella/Plasmidome



#======================================================================================#
##Circular analysis etape 2
#======================================================================================#
echo -e "   Circular analysis, deuxieme etape $(date)   \n" | tee -a "$dir_data/summary.txt"


rm $dir_data/All_Plasmids.circular.txt


while read serotype;
do
rm $dir_data/$serotype/$serotype.circular.contig.txt;
done < $dir_data/ListeRep.txt;


while read serotype;
do
while read plasmid; 
do
length1=$(grep 'Length' $dir_data/$serotype/Circular_JGER/$plasmid.circular.out | sed 's/# Length: //');
identity=$(grep 'Identity' $dir_data/$serotype/Circular_JGER/$plasmid.circular.out | sed 's/# Identity://' | sed 's/ //g');
similarity=$(grep 'Similarity' $dir_data/$serotype/Circular_JGER/$plasmid.circular.out | sed 's/# Similarity://' | sed 's/ //g');
gaps=$(grep 'Gaps' $dir_data/$serotype/Circular_JGER/$plasmid.circular.out | sed 's/# Gaps://' | sed 's/ //g');
scores=$(grep 'Score' $dir_data/$serotype/Circular_JGER/$plasmid.circular.out | sed 's/# Score: //');
echo $plasmid | awk -vlength1="$length1" -videntity="$identity" -vsimilarity="$similarity" -vgaps="$gaps" -vscores="$scores"  '{print $1 "\t" length1 "\t" identity "\t" similarity "\t" gaps "\t" scores}' 
done < $dir_data/$serotype/ListePlasmids.$serotype.txt | sort -Vk6,6 > $dir_data/$serotype/$serotype.circular.contig.txt
cat $dir_data/$serotype/$serotype.circular.contig.txt >> $dir_data/All_Plasmids.circular.txt
sed -i '1icontig_name\tlength_alignment\tidentity_alignment\tsimilarity_alignment\tgaps_alignment\tscores_alignment' $dir_data/$serotype/$serotype.circular.contig.txt
done < $dir_data/ListeRep.txt;


sort -Vk6,6 $dir_data/All_Plasmids.circular.txt > $dir_data/tmp
mv $dir_data/tmp $dir_data/All_Plasmids.circular.txt
sed -i 's/ /\t/g' $dir_data/All_Plasmids.circular.txt


sed -i '1icontig_name\tlength_alignment\tidentity_alignment\tsimilarity_alignment\tgaps_alignment\tscores_alignment' $dir_data/All_Plasmids.circular.txt



echo "***Circular analysis, deuxieme etape DONE!! $(date)***" | tee -a "$dir_data/summary.txt"
#======================================================================================#
echo -e "#===================================================================================#\n" | tee -a "$dir_data/summary.txt"

echo -e "Have done M. Emond-R\n"

echo "Have a good day"
