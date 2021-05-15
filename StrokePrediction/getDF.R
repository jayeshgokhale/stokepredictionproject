#Get Data Ready
rm(list=ls())
df <- read.csv("healthcare-dataset-stroke-data.csv")
suppressWarnings(df$bmi <- as.numeric(levels(df$bmi)[df$bmi]))
df$stroke <- as.factor(df$stroke)
df$hypertension <- as.factor(df$hypertension)
df$smoking_status <- as.factor(df$smoking_status)
df$heart_disease <- as.factor(df$heart_disease)
df <- df[-1]
df.cols <- colnames(df)
factor.tf <- sapply(df,function(x) is.factor(x))
num.vars <- names(factor.tf[factor.tf==FALSE])
cat.vars <- names(factor.tf[factor.tf==TRUE])
cat.vars <- cat.vars[!(cat.vars %in% "stroke")]
