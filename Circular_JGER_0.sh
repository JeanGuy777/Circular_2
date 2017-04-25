#!/bin/bash

dir_data=$1

if [ -z "$dir_data" ]; 
then
echo -e "\n#======================================================================================================#\n"
echo "./Circular_JGER_0 /home/jgemr/path/to/the/file/containing/the/contigs/where/you/want/to/do/the/analysis"
echo -e "\n#======================================================================================================#\n"
exit 1;
fi

rm $dir_data/summary.txt

#======================================================================================#
##Circular analysis etape 0
#======================================================================================#
echo -e "   Circular analysis $(date)   \n" | tee -a "$dir_data/summary.txt"


rm -R $dir_data/All_plasmids/fasta;
mkdir $dir_data/All_plasmids/fasta;


grep '>' $dir_data/All_plasmids/All_Salmonella_plasmids.fasta | sed 's/>//' > $dir_data/All_plasmids/ListePlasmids.txt;


while read plasmid;
do
samtools faidx $dir_data/All_plasmids/All_Salmonella_plasmids.fasta $plasmid > $dir_data/All_plasmids/fasta/$plasmid.fasta;
done < $dir_data/All_plasmids/ListePlasmids.txt;


cp $dir_data/Clustering_files/*.cluster.txt $dir_data/


ls $dir_data/ | grep 'cluster' | sed 's/\.cluster\.txt//' > $dir_data/ListeRep.txt;


while read serotype;
do
rm -R $dir_data/$serotype/;
done < $dir_data/ListeRep.txt


while read serotype;
do
mkdir -p $dir_data/$serotype/fasta;
mv $dir_data/$serotype.cluster.txt $dir_data/$serotype/;
sed 's/_/\t/' $dir_data/$serotype/$serotype.cluster.txt | awk '{print $2}' | while read isolate;
do 
grep -w $isolate /home/jean-guillaume/Bureau/Travaux/Salmonella/03aout2016/metadata_isolates.csv;
done | sort -Vk1,1 > $dir_data/$serotype/$serotype.metadata.tsv;
while read line;
do
genome=$(echo $line | awk '{print $8}');
grep $genome $dir_data/All_plasmids/ListePlasmids.txt >> $dir_data/$serotype/ListePlasmids.$serotype.txt;
done < $dir_data/$serotype/$serotype.metadata.tsv;
while read plasmid;
do cp $dir_data/All_plasmids/fasta/$plasmid.fasta $dir_data/$serotype/fasta/$plasmid.fasta;
done < $dir_data/$serotype/ListePlasmids.$serotype.txt

sed -i '1iIsolateID\tOriginalID\tSpecies\tSerotype\tSource_category\tHost_species\tSource\tSequencing_File_Name1' $dir_data/$serotype/$serotype.metadata.tsv

done < $dir_data/ListeRep.txt;



echo "***Circular analysis DONE!! $(date)***" | tee -a "$dir_data/summary.txt"
#======================================================================================#
echo -e "#===================================================================================#\n" | tee -a "$dir_data/summary.txt"

echo -e "Have done M. Emond-R\n"

echo "Have a good day"
