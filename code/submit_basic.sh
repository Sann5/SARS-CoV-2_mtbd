#!/bin/sh
#BSUB -W 120:00
#BSUB -n 1
#BSUB -R "rusage[mem=4096]"
#BSUB -J "myAnalysis[1-20]"
module load java

SEED=$LSB_JOBINDEX

../beast/bin/beast -resume -seed $SEED -statefile SARSCoV2_mtbd.$SEED.state SARSCoV2_mtbd.xml
