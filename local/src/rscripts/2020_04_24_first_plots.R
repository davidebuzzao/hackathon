# install.packages("readxl")

rm(list=ls())
setwd('/home/mary/hackathon/data/')
library("readxl")

gtex_noseq <- read_excel('GTEx_pancreas_liver_images_liverfat_pancreasfat.xlsx')
gtex_noseq$Sex <- as.factor(gtex_noseq$Sex)

# things we can try to correlate first:
# fat in liver and fat in pancreas
# fat in male and in female
# fat by age
# fat in presence/absence of some disease
# we should also see how data are distributed!


# boxplots of fat % by underlying health conditions in liver
is.na(gtex_noseq$Pathology.Categories_liver)
gtex_noseq_steatosis <- gtex_noseq[gtex_noseq$Pathology.Categories_liver == 'steatosis',]
gtex_noseq_healthy <- gtex_noseq[is.na(gtex_noseq$Pathology.Categories_liver),]
gtex_noseq_nosteatosis <- gtex_noseq[!gtex_noseq$Pathology.Categories_liver == 'steatosis',]

boxplot(gtex_noseq_steatosis$Fat.Percentage_liver, gtex_noseq_steatosis$Fat.Percentage_pancreas, gtex_noseq_healthy$Fat.Percentage_liver, gtex_noseq_healthy$Fat.Percentage_pancreas)



# boxplot of fat % in all healthy vs steatosis

boxplot(gtex_noseq_allhealthy$Fat.Percentage_liver, gtex_noseq_steatosis$Fat.Percentage_liver)
plot(gtex_noseq_steatosis$Fat.Percentage_liver)
plot(gtex_noseq_allhealthy$Fat.Percentage_liver)

# useful note: you can use grepl to check if a field contains a substring
# usage: grepl(needle, haystack, fixed=TRUE)
# individuals with steatosis (and not only)
gtex_noseq_allsteatosis <- gtex_noseq[grepl('steatosis', gtex_noseq$Pathology.Categories_liver, fixed=T),]
boxplot(gtex_noseq_allhealthy$Fat.Percentage_liver, gtex_noseq_allsteatosis$Fat.Percentage_liver)

# saponification in pancreas
gtex_noseq_saponification <- gtex_noseq[gtex_noseq$Pathology.Categories_pancreas == 'saponification',]
boxplot(gtex_noseq_allhealthy$Fat.Percentage_liver, gtex_noseq_saponification$Fat.Percentage_liver)rm(list=ls())


# congestion in liver
gtex_noseq_congestion <- gtex_noseq[gtex_noseq$Pathology.Categories_liver == 'congestion',]
boxplot(gtex_noseq_allhealthy$Fat.Percentage_liver, gtex_noseq_congestion$Fat.Percentage_liver)


# reverse approach: what are common characteristics in samples with high fat and low fat?
gtex_noseq_lowfat_all <- gtex_noseq[gtex_noseq$Fat.Percentage_liver < 30 & gtex_noseq$Fat.Percentage_pancreas < 30,]
# the proportions in age seem pretty much the same
table(gtex_noseq_lowfat_all$Age.Bracket)/250
table(gtex_noseq$Age.Bracket)/577
table(gtex_noseq_lowfat_all$Hardy.Scale)
# high fat in both
gtex_noseq_highfat_all <- gtex_noseq[gtex_noseq$Fat.Percentage_liver > 45 & gtex_noseq$Fat.Percentage_pancreas > 45,]


# subsetting for % fat in liver and pancreas with the following thresholds:
# liver < 33%, liver > 66%
# pancreas < 15%, pancreas > 40%
gtex_high_pancreas_fat = gtex_noseq[gtex_noseq$Fat.Percentage_pancreas > 40,]
gtex_low_pancreas_fat = gtex_noseq[gtex_noseq$Fat.Percentage_pancreas < 10,]

gtex_high_liver_fat = gtex_noseq[gtex_noseq$Fat.Percentage_liver > 50,]
gtex_high_liver_fat_m = gtex_high_liver_fat[gtex_high_liver_fat$Sex=='male',]
gtex_high_liver_fat_f = gtex_high_liver_fat[gtex_high_liver_fat$Sex=='female',]

gtex_low_liver_fat = gtex_noseq[gtex_noseq$Fat.Percentage_liver < 25,]
gtex_low_liver_fat_m = gtex_low_liver_fat[gtex_low_liver_fat$Sex=='male',]
gtex_low_liver_fat_f = gtex_low_liver_fat[gtex_low_liver_fat$Sex=='female',]
