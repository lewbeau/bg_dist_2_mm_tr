
#Environment ----
#set working directory and paste the data files in it
rm(list=ls()) #cleaning up the environment
Sys.setlocale("LC_CTYPE", "bulgarian")
options(locale = locale(encoding = "windows-1251"))


#Data ----
library(tidyverse, warn.conflicts = F) # You should have the package installed.
df <- read.csv("data/data.csv") #Reading the data in R; 82 vars, too many
str(df) #get to know the data
paste(colnames(df), collapse = ", ") #list of the variables

df <- df %>% select(marryTR, Oblast, age, kidsYoN, gender, 
                    familyStatus, education, edu, edu2, ethnicity, emplStatus, 
                    industry, jobClass, hshldMembers, hshldU18, 
                    netHshldIncome, placeType, yearBirth) #overwrite the df object filtering out non-determinants 

#This leads to 18 var dataset

#option1 - demographic generations - x, y, z...
df <- df %>% mutate(gen = if_else(yearBirth>1996, "gen_z",
                                  if_else(yearBirth<1981, "gen_x", "gen_y")))
table(df$gen) #everything seems recoded correctly
#option2 - generations born and raised in communism and post-communism - x, y, z...
df <- df %>% mutate(generation = if_else(yearBirth>1988, "com_born", "transition_born")) 
table(df$generation) #everything seems recoded correctly

df <- df %>% mutate(yearBirth = NULL) #remove the yearBirth var as its function was completed

#Make an age band variable 
df$age_groups <- cut(df$age, breaks = c(18, 22, 28, 34, 40, 46, 52, 55), include.lowest = TRUE,
                     labels = c("18-22", "23-28", "29-34", "35-40", "41-46", "47-52", "52+"))
df$age_groups
str(df)
df <- df %>% mutate_if(is.character, factor) #convert all strings/character vectors to factors
df %>% summary()


#need to rename *emplStatus* var, first is Cyrillic + other changes of var names for convenience
df <- df %>% 
  rename(empl_status = emplStatus) %>% 
  rename(province = Oblast) %>% 
  rename(educ = edu2) %>% 
  rename(place_type = placeType) %>% 
  rename(family_status = familyStatus) %>% 
  rename(income = netHshldIncome) %>% 
  rename(hh_members = hshldMembers) %>% 
  rename(hh_u18= hshldU18) %>% 
  rename(occup_soc_stratification = jobClass) %>% 
  rename(children = kidsYoN) %>% 
  rename(marriage_tr = marryTR)

str(df) #so far, there are 20 vars for the analysis

# hh_members and hh_u18 vars need rfImpute because they have 6 missing data points
# income var needs recoding - has "#N/A" and "Без отговор"
levels(df$income) 
class(df$income) 

df <- df %>%
  mutate(income = na_if(income, " Без отговор")) %>% 
  mutate(income = na_if(income, "#N/A")) %>% droplevels() #unused levels are removed
levels(df$income) #see the new reduced levels


df$income <- factor (df$income,
                     levels = c(" До 499 лв", " От 500 до 999 лв", " От 1000 до 1499 лв",
                                " От 1500 до 1999 лв", " От 2000 до 2499 лв"," От  2500 до 2999 лв",
                                " 3000+ лв"))
sum(is.na(df$income))/length(df$income) #25.5 % of the sampled refused to declare their net income
#that's too large a percentage for imputation; see how to deal with


# industry var needs recoding
levels(df$industry)
df <- df %>% 
  mutate(industry = recode(industry,
                           " Администрация                                               " = "governtment_institutions",
                           " Временна заетост " = "unknown",
                           " Добивна промишленост" = "mining_energy",
                           " Домакински дейности (гледане на възрастни, болни хора, деца, домашен помощник)" = "social_services",
                           " Здравеопазване" = "healthcare",
                           " Лека промишленост (текстилната, шивашката, кожарската и обувната промишленост, хранително-вкусова и др.)" = "textiles_shoes_foods",
                           " Научноизследователска и педагогическа дейност" = "education_science",
                           " Не работя" = "unemployed",
                           " Образование                                                 " = "education_science",
                           " Охрана, полиция, военно дело, пожарникари" = "security",
                           " По програма                                                 " ="unknown",
                           " Селскостопанска дейност" = "agriculture_forestry",
                           " Спорт, изкуство" = "leisure_arts_sports",
                           " Строителство" = "construction_real_estate",
                           " Тежка промишленост (металургия, химическа, машиностроене и др.)" = "mechanical_engg_industrial_goods",
                           " Телекомукации, ИТ специалисти                               " = "it_telecoms",
                           " Транспорт" = "transpotation_shipping",
                           " Туристическа дейност (хотели, ресторанти и други)" = "hotels_restaurants_casinos",
                           " Търговия" = "retail",
                           " Търговия и ремонт на техника" = "retail",
                           " Услуги                                                      " = "business_fin_consumer_services",
                           " Финансова дейност и бизнес услуги" = "business_fin_consumer_services",
                           " Учащ                                                        " = "student")) %>% 
  mutate(industry = na_if(industry, "unknown")) #prepare for imputation
df$industry <- droplevels(df$industry) #remove the "unknown" level which has become NA
levels(df$industry)

# keep province var for now as will help rfImpute
# non-bulgarians should be filtered out after the imputation; the determinants towards Turks are studied
print(df %>% filter(ethnicity == "Българска") %>% count()) # the sample before split will be 1287


