#Source manually the r-scripts that process the data, impute the missing values and split them into train and test data sets

#Logistic regression modeling ----
m_all_vars <- glm(marriage_tr ~ ., data = train, family = "binomial")
summary(m_all_vars) 
#AIC: 1227.8; significant vars (0.5) - province, family_status, education, empl_status, industry, occup_soc_stratification. 
options(scipen=999) 
#Hosmer-Lemeshow goodness of fit test in R (https://www.youtube.com/watch?v=MYW8gA1EQCQ)
library(ResourceSelection) #you should have it installed
hl <- hoslem.test(m_all_vars$y, fitted(m_all_vars), g=10)
hl

#Goodness-of-fit test
#with(m_all_vars, pchisq(null.deviance - deviance, df.null-df.residual,lower.tail = F))

#to calculate McFadens Pseudo R2: 1) pull out the log-likelihood of the null model out of the model and divide by -2
#ll.null <- m_all_vars$null.deviance
#2) pull the log-likelihood for the model out by getting the value for the residual deviance and dividing by -2
#ll.proposed <- m_all_vars$deviance
#do the math for the Pseudo R2 coefficient; This can be interpreted as the overall effect size
#(ll.null-ll.proposed)/ll.null # Pseudo R2 = 0.14
#p-value for the Pseudo R2
#1-pchisq(2*(ll.proposed-ll.null), df=(length(m_all_vars$coefficients)-1)) #p-value = 1 ergo Pseudo R2 not significant

#significant vars model 
m_sign_vars <- glm(marriage_tr ~ family_status + province + education + empl_status  + industry + occup_soc_stratification, data = train, family = "binomial")
summary(m_sign_vars) 

#Hosmer-Lemeshow goodness of fit test in R (https://www.youtube.com/watch?v=MYW8gA1EQCQ)
hl2 <- hoslem.test(m_sign_vars$y, fitted(m_sign_vars), g=10)
hl2
#AIC: 1219.3; significant vars (0.5) - all in the model.
#Goodness-of-fit test
#with(m_sign_vars, pchisq(null.deviance - deviance, df.null-df.residual,lower.tail = F))
#to calculate McFadens Pseudo R2: 1) pull out the log-likelihood of the null model out of the model and divide by -2
#ll.null2 <- m_sign_vars$null.deviance
#2) pull the log-likelihood for the model out by getting the value for the residual deviance and dividing by -2
#ll.proposed2 <- m_sign_vars$deviance
#do the math for the Pseudo R2 coefficient; This can be interpreted as the overall effect size
#(ll.null2-ll.proposed2)/ll.null2 # Pseudo R2 = 0.09722553
#p-value for the Pseudo R2
#1-pchisq(2*(ll.proposed2-ll.null2), df=(length(m_sign_vars$coefficients)-1)) #p-value = 1 ergo Pseudo R2 not significant

m_sign_vars2 <- glm(marriage_tr ~ family_status + province + education, data = train, family = "binomial") 
summary(m_sign_vars2) 
#Hosmer-Lemeshow goodness of fit test in R (https://www.youtube.com/watch?v=MYW8gA1EQCQ)
hl3 <- hoslem.test(m_sign_vars2$y, fitted(m_sign_vars2), g=10)
hl3

#AIC:  1190.1; significant vars (0.5) - education, family_status, province.
#Goodness-of-fit test
with(m_sign_vars2, pchisq(null.deviance - deviance, df.null-df.residual,lower.tail = F))
#to calculate McFadens Pseudo R2: 1) pull out the log-likelihood of the null model out of the model and divide by -2
ll.null3 <- m_sign_vars2$null.deviance
#2) pull the log-likelihood for the model out by getting the value for the residual deviance and dividing by -2
ll.proposed3 <- m_sign_vars2$deviance
#do the math for the Pseudo R2 coefficient; This can be interpreted as the overall effect size
(ll.null3-ll.proposed3)/ll.null3 # Pseudo R2 = 0.08472523
#p-value for the Pseudo R2
1-pchisq(2*(ll.proposed3-ll.null3), df=(length(m_sign_vars2$coefficients)-1)) #p-value = 1 ergo Pseudo R2 not significant

#Model selection - model  "family_status + province + education + empl_status" ----
m <- m_sign_vars
#termplot(m) #need to see interpretation for details

#Predictions (train data)
p1 <- predict(m, train, type = "response")
head(p1)

#Classifications error (train data)
pred1 <- ifelse(p1>0.5, 1, 0)
table(Predicted = pred1, Actual = train$marriage_tr)

#Accuracy (train data) - 67.6% beats the 60.22% baseline
(453+157)/(903)

#Predictions (test data)
p2 <- predict(m, test, type = "response")
head(p2)

#Classifications error (test data)
pred2 <- ifelse(p2>0.5, 1, 0)
table(Predicted = pred2, Actual = test$marriage_tr)

#Accuracy (test data) - 60.42% beats the 60.2% baseline
(172+60)/(384) #with regard to overfitting the model is OK; better predicting those who disagree

#Model selection - model "family_status + education + province" ----
#for simplicity let's choose model m_sign_vars
m2 <- m_sign_vars2
#termplot(m) #need to see interpretation for details

#Predictions (train data)
p_1 <- predict(m2, train, type = "response")
head(p_1)

#Classifications error (train data)
pred_1 <- ifelse(p_1>0.5, 1, 0)
table(Predicted = pred_1, Actual = train$marriage_tr)

#Accuracy (train data) - 65.7% beats the 60.2% baseline
(452+141)/(903)

#Predictions (test data)
p_2 <- predict(m2, test, type = "response")
head(p_2)

#Classifications error (test data)
pred_2 <- ifelse(p_2>0.5, 1, 0)
table(Predicted = pred_2, Actual = test$marriage_tr)

#Accuracy (test data) - 62.5% beats the 60.22% baseline
(191+49)/384
