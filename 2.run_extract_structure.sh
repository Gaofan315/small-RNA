in=$1

cd predict_$in\.situ_out/predict/static/
gunzip targets.*.RNAfold.fa.gz
cat targets.*.RNAfold.fa >$in\.situ.targets.RNAfold.fa.all
cd ../../..
ln -s predict_$in\.situ_out/predict/static/$in\.situ.targets.RNAfold.fa.all ./
bedtools getfasta -name -s -fi hg19.fa -bed $in\.situ.sorted.bed -fo $in\.situ.fasta
perl 2.1.extract_structure.pl $in\.situ.sorted.bed $in\.situ.targets.RNAfold.fa.all $in\.situ.fasta
perl 2.2.get_priRNA.pl $in\.situ.sorted.bed.RNAfold $in\.situ.RNAfold.pri 2>log.pri 

cd predict_$in\.up_out/predict/static/
gunzip targets.*.RNAfold.fa.gz
cat targets.*.RNAfold.fa >$in\.up.targets.RNAfold.fa.all
cd ../../..
ln -s predict_$in\.up_out/predict/static/$in\.up.targets.RNAfold.fa.all ./
bedtools getfasta -name -s -fi hg19.fa -bed $in\.up.sorted.bed -fo $in\.up.fasta
perl 2.1.extract_structure.pl $in\.up.sorted.bed $in\.up.targets.RNAfold.fa.all $in\.up.fasta
perl 2.2.get_priRNA.pl $in\.up.sorted.bed.RNAfold $in\.up.RNAfold.pri 2>log.pri

cd predict_$in\.down_out/predict/static/
gunzip targets.*.RNAfold.fa.gz
cat targets.*.RNAfold.fa >$in\.down.targets.RNAfold.fa.all
cd ../../..
ln -s predict_$in\.down_out/predict/static/$in\.down.targets.RNAfold.fa.all ./
bedtools getfasta -name -s -fi hg19.fa -bed $in\.down.sorted.bed -fo $in\.down.fasta
perl 2.1.extract_structure.pl $in\.down.sorted.bed $in\.down.targets.RNAfold.fa.all $in\.down.fasta
perl 2.2.get_priRNA.pl $in\.down.sorted.bed.RNAfold $in\.down.RNAfold.pri 2>log.pri


