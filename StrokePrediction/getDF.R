#Get Data Ready
rm(list=ls())
df <- read.csv("healthcare-dataset-stroke-data.csv")
suppressWarnings(df$bmi <- as.numeric(levels(df$bmi)[df$bmi]))
df$stroke <- as.factor(df$stroke)
levels(df$stroke) <- c("no_risk","risk")
df$hypertension <- as.factor(df$hypertension)
levels(df$hypertension) <- c("non_hypertensive","hypertensive")
df$smoking_status <- as.factor(df$smoking_status)
df$heart_disease <- as.factor(df$heart_disease)
levels(df$heart_disease) <- c("no_heart_disease","heart_disease_history")
df <- df[-1]
df.cols <- colnames(df)
factor.tf <- sapply(df,function(x) is.factor(x))
num.vars <- names(factor.tf[factor.tf==FALSE])
cat.vars <- names(factor.tf[factor.tf==TRUE])
cat.vars <- cat.vars[!(cat.vars %in% "stroke")]
