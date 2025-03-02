#!/bin/bash
#SBATCH --nodes=1 # Number of nodes needed
#SBATCH --qos=normal # Meaning walltime of up to 24 hours on a CPU or a gpu partition (NOT on a high mem node)
#SBATCH --partition=amilan # Name of the AMC CPU partition
#SBATCH --time=00:30:00 # Max walltime with --qos=normal
#SBATCH --ntasks=4 # Number of cores on the CPU side -> Total memory= 3.8G * 10
#SBATCH --account=amc-general # Coming from CU Anschutz
#SBATCH --job-name=step2_consensus
#SBATCH --output=./log/step2_consensus_%j.log # Output log file from my Job
#SBATCH --error=./err/step2_consensus_%j.err # Output error file from my Job
#SBATCH --mail-user=megan.stumpf@cuanschutz.edu # Email the user
#SBATCH --mail-type=ALL  # Meaning I get emailed once the job begins, abort and ends. Other identifiers can be (BEGIN, END, ABORT)

module load perl
module load bwa

# Setting up variables
export R_LIBS_USER=/projects/mstumpf@xsede.org/software/VirVarSeq/R/lib
export PERL5LIB=$PERL5LIB:/projects/mstumpf@xsede.org/software/VirVarSeq/lib

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
sample_number=$SLURM_ARRAY_TASK_ID
sample_name=`sed -n "$sample_number p" $samples`

#
./consensus.pl --samplelist $sample_name --ref $ref --indir $indir --outdir $outdir --start $startpos --end $endpos >> VirVarSeq.log 2>&1

