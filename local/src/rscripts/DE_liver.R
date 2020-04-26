# LIBRARIES
# BiocManager::install("pkag")
library("readr")
library("DESeq2")

#########
# INTRO
#########
# Working directory
data <- "../../../data/liver/"

# select the EXPERIMENT:
count_file <- file.path(data, "count_matrix/count_matrix_liver.txt")
countdata <- read.table(file = count_file, sep = ' ', header = TRUE)

# Read input data
colData_file <- file.path(data, "liver.csv")
coldata <- read.table(file = colData_file, sep = ',', header = TRUE)

dds <- DESeqDataSetFromMatrix(countData = countdata, colData = coldata, design = ~ Fat.Category)
dds$Fat.Category <- relevel(dds$Fat.Category, "thin")
# Other possible initial exploratory design includes: Sex, Age.Bracket, Hardy.Scale, Pathology.Categories_liver


########################################
# EXPLORATORY ANALYSIS AND VISUALIZATION
########################################

# PREFILTERING THE DATASET
# Removing rows of the DESeqDataSet that have no counts, or only a few count across all samples
nrow(dds)
keep <- rowSums(counts(dds) >= 10) >= 3
dds <- dds[keep,]
nrow(dds)


# SOLUTION : stabilize the variance across mean
# VST: Variiance Stabilizing Transformation
# They correct the variance of genes with lower counts by shrunken the towards a middle value.
# VST and rlog return a DESeqTransform object which is based on the SummarizedExperiment class
vsd <- vst(dds, blind = FALSE)
head(assay(vsd), 3)
colData(vsd)


# PLOT
library("dplyr") 
library("ggplot2")
pdf(file = "Exploratory_Analysis_liver.pdf")

# COMPUTE DISTANCES
# We use the R function dist to calculate the Euclidean distance between samples. 
# To ensure we have a roughly equal contribution from all genes, we use it on the VST data.
sampleDists <- dist(t(assay(vsd))) 

# HEATMAP
library("pheatmap") 
library("RColorBrewer")
sampleDistMatrix <- as.matrix( sampleDists )
rownames(sampleDistMatrix) <- paste(vsd$SAMPID_liver) 
colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255) 
pheatmap(sampleDistMatrix, clustering_distance_rows = sampleDists, clustering_distance_cols = sampleDists, col = colors)


# PCA PLOT
# plotPCA that comes with DESeq2.
# Built the PCA plot from scratch using the ggplot2 package. 
pdf(file = "PCA_liver_Countstringent.pdf")
pcaData <- plotPCA(vsd, intgroup = c( "Sex", "Fat.Category"), returnData = TRUE)
pcaData

# We can then use these data to build up a second plot in a figure below, specifying that the color of the points should reflect the treatment and the shape should reflect the cell line
percentVar <- round(100 * attr(pcaData, "percentVar"))
ggplot(pcaData, aes(x = PC1, y = PC2, color = Sex, shape = Fat.Category)) + 
geom_point(size =3) +
xlab(paste0("PC1: ", percentVar[1], "% variance")) + 
ylab(paste0("PC2: ", percentVar[2], "% variance")) + 
coord_fixed() +
ggtitle("PCA with VST data")
dev.off()


# GENERALIZED-PCA (GLM-PCA)
# GLM-PCA operates on raw counts, avoiding the pitfalls of normalization
library("glmpca")
gpca <- glmpca(counts(dds), L=2) 
gpca.dat <- gpca$factors 
gpca.dat$Pathology.Categories_liver <- dds$Pathology.Categories_liver
ggplot(gpca.dat, aes(x = dim1, y = dim2, color = Pathology.Categories_liver)) + 
    geom_point(size =3) + coord_fixed() + ggtitle("glmpca - Generalized PCA")


# MDS
# Multidimensional scaling: useful when we don’t have a matrix of data, but only a matrix of distances
mds <- as.data.frame(colData(vsd)) %>% cbind(cmdscale(sampleDistMatrix))
ggplot(mds, aes(x = `1`, y = `2`, color = Pathology.Categories_liver)) + 
    geom_point(size = 3) + coord_fixed() + ggtitle("MDS with VST data")

# PoissonDistance
mdsPois <- as.data.frame(colData(dds)) %>% cbind(cmdscale(samplePoisDistMatrix))
ggplot(mdsPois, aes(x = `1`, y = `2`, color = Pathology.Categories_liver)) + 
geom_point(size = 3) + coord_fixed() + ggtitle("MDS with PoissonDistances")

dev.off()


# =========================================================================================================

####################################
# DIFFERENTIAL EXPRESSION ANALYSIS #
####################################

# =========================================================================================================


# DE analysis on the raw counts
dds <- DESeq(dds)
resultsNames(dds)

# RESULTS
# The user should specify three values as contrast arguments: the name of the variable, 
# the name of the level for the numerator, and the name of the level for the denominator.
# NB. "results": automatically performs independent filtering based on the mean of normalized counts for 
# each gene, optimizing the number of genes which will have an adjusted p-value below a given FDR cutoff, alpha.

# zhang2018
res_1 <- results(dds, contrast=c("Fat.Category","thin","fat"))

# DataFrame object, it carries metadata with information on the meaning of the columns:
# p value indicates the probability that a fold change as strong as the observed one, or even stronger, 
# would be seen under the situation described by the null hypothesis.
mcols(res_1, use.names = TRUE)
summary(res_1)
table(res_1$padj < 0.05)

# =========================================================================================================

####################
# PLOTTING RESULTS #
####################

pdf(file = "DEresults_liver.pdf")

# MA PLOT 
library("apeglm") 
# There are 3 types of shrinkage estimators in DESeq2 (apeglm):
# The DESeq2 package uses a Bayesian procedure to moderate (or “shrink”) log2 fold changes (LFC) from genes
# with very low counts and highly variable counts 
res_1 <- lfcShrink(dds, coef="Fat.Category_thin_vs_fat", type="apeglm") 
plotMA(res_1, ylim = c(-5, 5), main = "MA plot with lfcShrink")

# HISTOGRAM OF P-VALUES 
# This plot is best formed by excluding genes with very small counts, which otherwise generate spikes
hist(res_1$pvalue[res_1$baseMean > 1], breaks = 0:20/20, col = "grey50", border = "white", main ="Histogram of p-values",  xlab = "p-value")

dev.off()



# INDEPENDENT FILTERING
# The term independent highlights an important caveat. Such filtering is permissible only if the statistic 
# that we filter on (here the "mean of normalized counts" across all samples) is independent of the actual 
# test statistic (the p value) under the null hypothesis

# =========================================================================================================
# SAVE THE RESULTS
resOrderedDF <- as.data.frame(res_1[order(res_1$pvalue), ])
write.csv(resOrderedDF, file = "results_fat_thin.csv")