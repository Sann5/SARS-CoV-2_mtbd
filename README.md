# SARS-CoV-2 Herd Immunity Accounting for Population Structure
Final project for the 2021 Bayesian Phylodynamics course at ETH Zürich on estimating age specific effective reproductive numbers for Switzerland.

## Workflow
* **Ordered** list of the scripts used in this project to obtain the data, preprocess it and run the analysis. 
* **Warning**: the dress referencing the data (`./data/`) on the scripts (`./code/`) might have to be changed to match the location of the files locally. 
* **Data**: All the necessary data is available in the `data` directory. 

### 1. Acquiring the data
All the sequences available from the the 6th of november 2020 to the 17th of november were downloaded in batches from the GSAID web interface. The metadata of the sequences was used as inputs for the `code/get_GSAID_ids.R` script to get the ids of all the sequences that were annotated and were dated after the 14th of november 2020. This generated a text file which was used to do an additional download with all the age annotated sequences into the same fasta file. 

### 2. Preprocessing
Sequences were annotated and aligned using `code\fasta_preprocessing.R` script. 

### 3. Running BEAST
* The details of the model selections are described in `code/report.pdf`. 
* The script to calculate the number of new cases in this period is `code/number_of_cases_OWOD.R`. 
* For all the information regarding the model used see `code/SARSCoV2_mtbd.xml`. 
* You can find the bash script used to run this analysis on the cluster in `submit_basic.sh`.

### 4. Analysis
The report was made using R Markdown (`code/report.Rmd`). 




