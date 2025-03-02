#!/bin/bash

#Setting up variables:
indir=./testdata/fastq
outdir=./testdata/results
samples=./testdata/samples.txt
ref=./testdata/ref/1b_con1_AJ238799.NCBI.fa
startpos=3112
endpos=5531
region_start=3420
region_len=181
qv=0
#
#sample_number=$SLURM_ARRAY_TASK_ID
#sample_name=`sed -n "$sample_number p" $samples`
total_samples=`grep -c  . testdata/samples.txt`
# Setting up sbatch to avoid dependency error
#alias sbatch='sbatch --export=NONE'

# Reference for job arrays and job in chain: https://mesocentre.pages.centralesupelec.fr/user_doc/ruche/06_slurm_jobs_management/
# Step 1 map_vs_ref
tmp1=$(sbatch --export=NONE --array=1-$total_samples step1_map_vs_ref.sh)
jid1=`echo ${tmp1##* }`

# Step 2 consensus
tmp2=$(sbatch --export=NONE --array=1-$total_samples --dependency=afterok:$jid1 step2_consensus.sh)
jid2=`echo ${tmp2##* }`

# Step 3 map_vs_consensus
tmp3=$(sbatch --export=NONE --array=1-$total_samples --dependency=afterok:$jid2 step3_map_vs_consensus.sh)
jid3=`echo ${tmp3##* }`

# Step 4 codon_table
tmp4=$(sbatch --export=NONE --array=1-$total_samples --dependency=afterok:$jid3 step4_codon_table.sh)
jid4=`echo ${tmp4##* }`

# Step 5 mixture_model
tmp5=$(sbatch --export=NONE --array=1-$total_samples --dependency=afterok:$jid4 step5_mixture_model.sh )
jid5=`echo ${tmp5##* }`