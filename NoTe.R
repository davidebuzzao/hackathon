#  Maria docet: 
#  for (i in listID_f)
#  {
#  subst <- gsub('-', '.', i)
#  a <- c(a, subst)
#  }
#  a <- as.factor(a)
#  countdata_f <- subset(countdata, select = a)

nrow(coldata[coldata$Sex=='female',])
nrow(coldata[coldata$Sex=='male',])
coldata_f <- coldata[coldata$Sex=='female',]
coldata_m <- coldata[coldata$Sex=='male',]
m_id <- coldata_m$SAMPID_pancreas
f_id <- coldata_f$SAMPID_pancreas
m_id <- as.factor(m_id)
f_id <- as.factor(f_id)
f_id <- droplevels(f_id)
m_id <- droplevels(m_id)
countdata_m <- subset(countdata, select = m_id)
countdata_f <- subset(countdata, select = f_id)

count_file <- file.path(data,"GTEx_pancreas_liver_images_liverfat_pancreasfat_seq.csv")
countdata <- read.table(file = count_file, sep = ',', header = TRUE)

# hign_fat_countdata <- countdata[countdata$Fat.Percentage_liver >40 & countdata$Fat.Percentage_pancreas >20,]
low_fat_countdata <- countdata[countdata$Fat.Percentage_liver <33 & countdata$Fat.Percentage_pancreas <12,]
nrow(low_fat_countdata)
# nrow(hign_fat_countdata)
low_fat_liver_countdata <- subset(low_fat_countdata, select = c("Subject.ID", "Sex", "Hardy.Scale", "Pathology.Categories_liver","SAMPID_liver", "Fat.Percentage_liver"))
low_fat_pancreas_countdata <- subset(low_fat_countdata, select = c("Subject.ID", "Sex", "Hardy.Scale", "Pathology.Categories_pancreas","SAMPID_ncreas","Fat.Percentage_pancreas"))
summary(low_fat_liver_countdata)
summary(low_fat_pancreas_countdata)

low_fat_liver_ID <- low_fat_liver_countdata$SAMPID_liver
low_fat_liver_ID <- as.factor(low_fat_liver_ID)
subset(countdata, select = low_fat_liver_ID)

low_fat_pancreas_ID <- low_fat_pancreas_countdata$SAMPID_pancreas
low_fat_pancreas_ID <- as.factor(low_fat_pancreas_ID)


hign_fat_pancreas_countdata <- countdata[countdata$Fat.Percentage_pancreas >30,]
nrow(hign_fat_pancreas_countdata)
hign_fat_pancreas_countdata <-  subset(hign_fat_pancreas_countdata, select = c("Subject.ID", "Sex", "Hardy.Scale", "Pathology.Categories_pancreas","SAMPID_pancreas","Fat.Percentage_pancreas"))
summary(hign_fat_pancreas_countdata)

hign_fat_liver_countdata <- countdata[countdata$Fat.Percentage_liver >50,]
nrow(hign_fat_liver_countdata)
hign_fat_liver_countdata <- subset(hign_fat_liver_countdata, select = c("Subject.ID", "Sex", "Hardy.Scale", "Pathology.Categories_liver","SAMPID_liver","Fat.Percentage_liver"))
summary(hign_fat_liver_countdata)
