in=$1

cat -n $in\.bed |awk '{print $2, $3, $4, "K562_uniq_", $1, $5, $7}' OFS="\t" |sort -k1,1 -k2,2n >$in\.sorted.bed 
./mustard-master/MuStARD.pl predict --modelDirName predict_results --model Drosha_dependent.CNNonRaw.hdf5 --modelType CNN --inputMode sequence,RNAfold --chromList all --targetIntervals $in\.sorted.bed --genome hg19.fa --classNum 2 --consDir NaN --staticPredFlag 1 --dir predict_$in\_out 2>log.$in

gzip -d predict_$in\_out/predict/static/predict_results/bed_tracks/all.*.gz

ln -s predict_$in\_out/predict/static/predict_results/bed_tracks/all.predictions.class_1.bed ./$in\.class_1.bed
ln -s predict_$in\_out/predict/static/predict_results/bed_tracks/all.predictions.class_0.bed ./$in\.class_0.bed
awk 'NR==FNR{a[$4]=$5;next}{print $0"\t"a[$4]}' $in\.class_1.bed $in\.sorted.bed >$in\.sorted.bed.merge.class_1
awk 'NR==FNR{a[$4]=$5;next}{print $0"\t"a[$4]}' $in\.class_0.bed $in\.sorted.bed.merge.class_1 >$in\.sorted.bed.merge.class_1_0
awk 'BEGIN{print "Chr\tStart\tEnd\tType\tStrand\tScore_class_1\tScore_class_0";}{$5=null;print $0}' $in\.sorted.bed.merge.class_1_0 >$in\.sorted.bed.mustard.predicted
rm $in\.sorted.bed.merge.class_1 $in\.sorted.bed.merge.class_1_0
rm $in\.class_1.bed $in\.class_0.bed



