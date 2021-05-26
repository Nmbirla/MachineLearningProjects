######################################
#####                            #####
#####       IMSE514 Project      #####
#####                            #####
######################################

library("readxl")

#Necessary for the Scree Plot
if(!require(devtools)) install.packages("devtools")
devtools::install_github("kassambara/factoextra")
library("factoextra")

# Read the file
setwd('C:\\Users\\gabri\\Desktop\\IMSE514_Project\\')
Data<- read_excel("MedicalData.xlsx", sheet=6)

#Let's convert the discrete data in factor
ICD1<-as.numeric(factor(Data$ICD1))
ICD2<-as.numeric(factor(Data$ICD2))
surgeon1<-as.numeric(factor(Data$SURGEON1))
surgeon2<-as.numeric(factor(Data$SURGEON2))
anestethist<-as.numeric(factor(Data$ANESTETHIST))
scrubNurse<-as.numeric(factor(Data$SCRUBNURSE))

#Let's run PCA just on the continuous variables
dataPCA <-prcomp(Data[,c(1,8:12)], center = TRUE,scale. = TRUE)
summary(dataPCA)

#Scree Plot
fviz_eig(dataPCA)

#let's save the PCA values
PCAValue <- dataPCA$x

FinalData <-data.frame(PCAValue, ICD1, ICD2, surgeon1, surgeon2, anestethist, scrubNurse)


write.csv(FinalData, file = "PreProcessedData.csv")

