# install.packages("readxl")

rm(list=ls())
setwd('/home/mary/hackathon/data/')
library("readxl")

# load all-inclusive and sequence-only 
gtex_noseq <- read_excel('GTEx_pancreas_liver_images_liverfat_pancreasfat.xlsx')
gtex_noseq$Sex <- as.factor(gtex_noseq$Sex)
gtex_seq <- read_excel('GTEx_pancreas_liver_images_liverfat_pancreasfat_seq.xlsx')
gtex_seq$Sex <- as.factor(gtex_seq$Sex)


# samples with rna-seq data
rna_ids <- read.table('liver.subjID.RNA.txt')
gtex_seq <- gtex_noseq[gtex_noseq$Subject.ID %in% rna_ids$V1,]

# low fat samples (in both pancreas AND liver) + high fat samples (in pancreas OR liver)
# final thresholds used for low fat: 12 and 30 % for pancreas and liver respectively
# final thresholds used for high fat: 25 and 45 % for pancreas and liver respectively

gtex_low_fat_all <- gtex_noseq[gtex_noseq$Fat.Percentage_pancreas < 12 & gtex_noseq$Fat.Percentage_liver < 30,]
gtex_seq_low_fat <- gtex_seq[gtex_seq$Subject.ID %in% gtex_low_fat_all$Subject.ID,]
write.csv(gtex_seq_low_fat, 'low_fat.csv')
gtex_seq_low_fat_ids <- as.factor(gtex_seq_low_fat$Subject.ID)
write(gtex_seq_low_fat_ids, 'low_fat_ids.txt')

gtex_high_pancreas_fat <- gtex_noseq[gtex_noseq$Fat.Percentage_pancreas > 25,]
gtex_high_liver_fat <- gtex_noseq[gtex_noseq$Fat.Percentage_liver > 45,]

gtex_seq_high_liver_fat <- gtex_seq[gtex_seq$Subject.ID %in% gtex_high_liver_fat$Subject.ID,]
write.csv(gtex_seq_high_liver_fat, 'high_fat_liver.csv')

gtex_seq_high_pancreas_fat <- gtex_seq[gtex_seq$Subject.ID %in% gtex_high_pancreas_fat$Subject.ID,]
write.csv(gtex_seq_high_pancreas_fat, 'high_fat_pancreas.csv')

gtex_seq_high_liver_fat_id <- as.factor(gtex_seq_high_liver_fat$Subject.ID)
gtex_seq_high_pancreas_fat_id <- as.factor(gtex_seq_high_pancreas_fat$Subject.ID)
write(gtex_seq_high_liver_fat$Subject.ID, 'high_liver_fat_ids.txt')
write(gtex_seq_high_pancreas_fat$Subject.ID, 'high_pancreas_fat_ids.txt')


# subsetting for sex
gtex_noseq_male <- gtex_noseq[gtex_noseq$Sex=='male',]
gtex_noseq_male <- droplevels(gtex_noseq_male)

gtex_noseq_female <- gtex_noseq[gtex_noseq$Sex=='female',]
gtex_noseq_female <- droplevels(gtex_noseq_female)


# subsetting by age bracket
gtex_noseq$Age.Bracket <- as.factor(gtex_noseq$Age.Bracket)
bins <- split(gtex_noseq, gtex_noseq$Age.Bracket)
df20_29 <- data.frame(bins[1])
df30_39 <- data.frame(bins[2])
df40_49 <- data.frame(bins[3])
df50_59 <- data.frame(bins[4])
df60_69 <- data.frame(bins[5])
df70_79 <- data.frame(bins[6])
