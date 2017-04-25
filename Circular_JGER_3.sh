#!/bin/bash

dir_data=/home/jean-guillaume/Bureau/Travaux/Salmonella/Plasmidome



#======================================================================================#
##Circular analysis etape 3
#======================================================================================#
echo -e "   Circular analysis, troisieme etape $(date)   \n" | tee -a "$dir_data/summary.txt"


rm $dir_data/Plasmids_only_circular.tsv

tail -n +2 $dir_data/All_Plasmids.circular.txt | while read line; 
do 
identity=$(echo $line | awk '{print $3}' | sed 's/(/ /' | awk '{print $2}' | sed 's/%)//');
echo $line | awk -videntity="$identity" '{if($6>=500&&identity>=99) print $0}' >> $dir_data/Plasmids_only_circular.tsv;
done


sed -i '1icontig_name\tlength_alignment\tidentity_alignment\tsimilarity_alignment\tgaps_alignment\tscores_alignment' $dir_data/Plasmids_only_circular.tsv;
sed -i 's/ /\t/g' $dir_data/Plasmids_only_circular.tsv



echo "***Circular analysis, troisieme etape DONE!! $(date)***" | tee -a "$dir_data/summary.txt"
#======================================================================================#
echo -e "#===================================================================================#\n" | tee -a "$dir_data/summary.txt"

echo -e "Have done M. Emond-R\n"

echo "Have a good day"
