# Read the file
setwd('C:\\Users\\gabri\\Desktop\\IMSE514_Project\\')
givenData <- read.csv('X_train.csv', header=T)

#Let's run PCA just on the continuous variables
dataPCA <-prcomp(givenData[,c(7:11)], center = TRUE,scale. = TRUE)
summary(dataPCA)

#let's save the PCA values
PCAValue <- dataPCA$x

write.csv(FinalData, file = "PreProcessedData.csv")

# Run the model
lm_1 <- lm(data=givenData, Response~ICD1+ICD2+surgeon1+surgeon2+anestethist+scrubNurse+AGE+T0+DELTAT01+DELTAT12+DELTAT23)

summary(lm_1)

#Mean Absolute Error
MAE <-sum(abs(resid(lm_1)))/length(givenData$Response)
MAE
#Root Mean Square Error
RMSE <- sqrt(sum(resid(lm_1)^2)/length(givenData$Response))
RMSE

#stepwise elimination

library(leaps)
start<-lm(Response~1, data=givenData)
step(start, scope=list(lower=start, upper=lm_1), direction="both")

#output
output<-lm(formula = Response ~ DELTAT12 + DELTAT01 + DELTAT23 + ICD2 + 
             surgeon2 + surgeon1 + T0 + scrubNurse + anestethist + AGE, 
           data = givenData)

summary(output)

#Mean Absolute Error
MAE <-sum(abs(resid(output)))/length(givenData$Response)
MAE
#Root Mean Square Error
RMSE <- sqrt(sum(resid(output)^2)/length(givenData$Response))
RMSE


## QQ plot to check for the normality assumption
# Plot the normal scores (assumed quantiles) vs Residuals and they should follow the first bisector
qqnorm(lm_1$residuals, ylab="Standardized residuals", xlab="Standardized Normal Scores (Z-scores)")
qqline(lm_1$residuals)

plot(fitted.values(output),resid(output), ylab="Residuals", xlab="Fitted Y")
abline(0,0) # line with slop 0 and intercept 0

plot(givenData$AGE,resid(output), ylab="Residuals", xlab="ICD1")
abline(0,0) # line with slop 0 and intercept 0


#WLS
#Define a vector of weights
wgt<-1/fitted(lm(abs(residuals(output))~givenDataBoxCox$ICD1+givenData$ICD2+givenData$surgeon1+givenData$surgeon2+givenData$anestethist+givenData$scrubNurse+givenData$AGE+givenData$T0
                 +givenData$DELTAT01+givenData$DELTAT12+givenData$DELTAT23))^2
WLS<-lm(formula = Response ~ DELTAT12 + DELTAT01 + DELTAT23 + ICD2 + 
          surgeon2 + surgeon1 + T0 + scrubNurse + anestethist, 
        data = givenData, weights=wgt)
summary(WLS)

#Mean Absolute Error
MAE <-sum(abs(resid(WLS)))/length(givenDataBoxCox$BoxCoxResponse)
MAE
#Root Mean Square Error
RMSE <- sqrt(sum(resid(WLS)^2)/length(givenDataBoxCox$BoxCoxResponse))
RMSE

plot(fitted.values(WLS),resid(WLS), ylab="Residuals", xlab="Fitted Y")
abline(0,0) # line with slop 0 and intercept 0


#BoxCox
library(MASS)

Bx1<-lm(formula = Response ~ DELTAT12 + DELTAT01 + DELTAT23 + ICD2 + 
          surgeon2 + surgeon1 + T0 + scrubNurse + anestethist + AGE, 
        data = givenData)
boxcox(output,plotit=T)
BX_1=boxcox(Bx1,plotit=T,lambda = seq(0.3,0.5,by=0.01))

givenDataBoxCox <- read.csv('X_trainBoxCox.csv', header=T)

lmBoxCox<-lm(formula = BoxCoxResponse ~ DELTAT12 + DELTAT01 + DELTAT23 + ICD2 + 
             surgeon2 + surgeon1 + T0 + scrubNurse + anestethist + AGE, 
           data = givenDataBoxCox)

summary(lmBoxCox)

#WLS for BoxCox
#Define a vector of weights
wgt<-1/fitted(lm(abs(residuals(output))~givenDataBoxCox$ICD1+givenData$ICD2+givenData$surgeon1+givenData$surgeon2+givenData$anestethist+givenData$scrubNurse+givenData$AGE+givenData$T0
                 +givenData$DELTAT01+givenData$DELTAT12+givenData$DELTAT23))^2
WLSBoxCox<-lm(formula = BoxCoxResponse ~ DELTAT12 + DELTAT01 + DELTAT23 + ICD2 + 
          surgeon2 + surgeon1 + T0 + scrubNurse + anestethist, 
        data = givenDataBoxCox, weights=wgt)
summary(WLSBoxCox)
#Mean Absolute Error
MAE <-sum(abs(resid(WLSBoxCox)))/length(givenDataBoxCox$BoxCoxResponse)
MAE
#Root Mean Square Error
RMSE <- sqrt(sum(resid(WLSBoxCox)^2)/length(givenDataBoxCox$BoxCoxResponse))
RMSE

# Plot the normal scores (assumed quantiles) vs Residuals and they should follow the first bisector
qqnorm(WLSBoxCox$residuals, ylab="Standardized residuals", xlab="Standardized Normal Scores (Z-scores)")
qqline(WLSBoxCox$residuals)

plot(fitted.values(WLSBoxCox),resid(WLSBoxCox), ylab="Residuals", xlab="Fitted Y")
abline(0,0) # line with slop 0 and intercept 0


#Let's try this model on the testset
givenTest <- read.csv('X_testBoxCox.csv', header=T)

prediction <-predict(WLSBoxCox, givenTest)
#Mean Absolute Error
MAE <-sum(abs(resid(prediction)))/length(givenTest$BoxCoxResponse)
MAE
#Root Mean Square Error
RMSE <- sqrt(sum(resid(prediction)^2)/length(givenTest$BoxCoxResponse))
RMSE

df <-data.frame(prediction)

R2 <- rsq(df)