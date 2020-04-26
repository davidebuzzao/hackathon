# install.packages("readxl")

rm(list=ls())
setwd('/home/mary/hackathon/data/')
library("readxl")

gtex_noseq <- read_excel('GTEx_pancreas_liver_images_liverfat_pancreasfat.xlsx')
gtex_noseq$Sex <- as.factor(gtex_noseq$Sex)

# distribution of fat values
par(mfrow=c(1,2))
plot(density(gtex_noseq$Fat.Percentage_liver), main='fat % in liver')
abline(v=mean(gtex_noseq$Fat.Percentage_liver), col='red')
abline(v=median(gtex_noseq$Fat.Percentage_liver), col='blue')
plot(density(gtex_noseq$Fat.Percentage_pancreas), main='fat % in pancreas')
abline(v=mean(gtex_noseq$Fat.Percentage_pancreas), col='red')
abline(v=median(gtex_noseq$Fat.Percentage_pancreas), col='blue')

# scatter b/w fat in liver and fat in pancreas (all samples, colored by sex)
plot(gtex_noseq$Fat.Percentage_liver, gtex_noseq$Fat.Percentage_pancreas, col=gtex_noseq$Sex)


# subsetting for sex
gtex_noseq_male <- gtex_noseq[gtex_noseq$Sex=='male',]
gtex_noseq_male <- droplevels(gtex_noseq_male)

gtex_noseq_female <- gtex_noseq[gtex_noseq$Sex=='female',]
gtex_noseq_female <- droplevels(gtex_noseq_female)

# boxplots of fat in liver and pancreas, m and f
par(mfrow=c(1,2))
boxplot(gtex_noseq_male$Fat.Percentage_liver, gtex_noseq_female$Fat.Percentage_liver, main="fat in liver M/F")
boxplot(gtex_noseq_male$Fat.Percentage_pancreas, gtex_noseq_female$Fat.Percentage_pancreas, main="fat in pancreas M/F")

gtex_noseq$Age.Bracket <- as.factor(gtex_noseq$Age.Bracket)
# boxplots of fat % by age bins
bins <- split(gtex_noseq, gtex_noseq$Age.Bracket)
df20_29 <- data.frame(bins[1])
df30_39 <- data.frame(bins[2])
df40_49 <- data.frame(bins[3])
df50_59 <- data.frame(bins[4])
df60_69 <- data.frame(bins[5])
df70_79 <- data.frame(bins[6])
boxplot(df20_29$X20.29.Fat.Percentage_liver, df30_39$X30.39.Fat.Percentage_liver, df40_49$X40.49.Fat.Percentage_liver, df50_59$X50.59.Fat.Percentage_liver, df60_69$X60.69.Fat.Percentage_liver, df70_79$X70.79.Fat.Percentage_liver, main='% fat in liver by age bracket')
boxplot(df20_29$X20.29.Fat.Percentage_pancreas, df30_39$X30.39.Fat.Percentage_pancreas, df40_49$X40.49.Fat.Percentage_pancreas, df50_59$X50.59.Fat.Percentage_pancreas, df60_69$X60.69.Fat.Percentage_pancreas, df70_79$X70.79.Fat.Percentage_pancreas, main='% fat in pancreas by age bracket')


