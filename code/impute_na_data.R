source("code/1_source_env_data.R")

#Dealing with missing data - imputations ----
summary(df)
sum(is.na(df))#counts the number of missing values NAs, a total of 404

#randomForest approach (supervised learning) ----
library(randomForest) #should have the randomForest package installed
#New data set with imputed values instead of NA's
set.seed(1113) #for replicability
df_imp_rf <- rfImpute(marriage_tr ~ .,
                      data =df,
                      iter=4, #how many random forests to build to estimate missing values (4 to 6 are sufficient)
                      ntree=500) #the OOB error stabilizes about 35% #The estimates are as good as they're going to get with this method
summary(df_imp_rf)
sum(is.na(df_imp_rf))#counts the number of missing values NAs, now ZERO NAs

#knn approach (unsupervised learning) ----
#set.seed(1113) #for replicability
#library(VIM) #should have the VIM package installed
#df_imp_knn <- kNN(df, variable = c("industry", "hh_members", "hh_u18",
#                                   "income"), k=39)
#rule of thumb to select a number for k is square root of the number of obs
#sqrt(length(df$marriage_tr)) #38-39 is recommended value for k
#summary(df_imp_knn)  

#df_imp_knn <- df_imp_knn %>% select(marriage_tr:age_groups)  #remove auxiliary vars
#in order to keep the code below universal irregardless of what data imputation method is used
df_imp <- df_imp_rf

# Recode and filter the response var ----
#proceed from here with the kNN imputed data - Eurostat impute income data using kNN; income var - most NAs
summary(df_imp$marriage_tr)
class(df_imp$marriage_tr)
#we're looking for the determinants of those who reject mixed marriages b/n BGs and TRs
df_imp <- df_imp %>% mutate(marriage_tr = recode(marriage_tr,
                                                         "Не" = "disagree",
                                                         "Да" = "agree_dk",
                                                         "НП" = "agree_dk"))
class(df_imp$marriage_tr)
levels(df_imp$marriage_tr)
#we are interested in disagree (negative), so this auto factor levels are fine

#as the attitude of ethnic Bulgarians are studied, all non-bulgarians should be filtered out
df_imp <- df_imp %>% filter(ethnicity == "Българска") %>% 
  mutate(ethnicity=NULL) %>%  
  mutate(income=NULL) #Remove the already unnecessary ethnicity var + the rather imputed income
summary(df_imp)
levels(df_imp$marriage_tr)
df_imp <- df_imp %>% mutate(marriage_tr = if_else(marriage_tr == "agree_dk", 1, 0))
table(df_imp$marriage_tr)
df_imp$marriage_tr <- as.factor(df_imp$marriage_tr)
summary(df_imp$marriage_tr)
775/(775+512) #BASELINE RATE, i.e. the model shoud perform better than 60.2%
#alternative options is to only turks to be filtered out  - more obs, option for ethnicity as a factor
#df_imp <- df_imp %>% filter(ethnicity != "Турска")

#Data partition, i.e. split the data into train and test datasets ----
set.seed(1113)
ind <- sample(2, nrow(df_imp), replace = T, prob = c(0.7, 0.3))
#table(ind) #expected structure of the data after partition
train <- df_imp[ind==1,]
test <- df_imp[ind==2,]

