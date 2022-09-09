#Potential variables ---- 
#new var using provice showing the type of province based on the share ot Turkish population
# df <- df %>% 
#   mutate(province_tr_ethnicity_type = recode(province,
#                                              "Благоевград"= "equal_more_than_1%_AND_less_than_11%",
#                                              "Бургас" = "equal_more_than_11%_AND_less_than_33%",
#                                              "Варна" = "equal_more_than_1%_AND_less_than_11%",
#                                              "Велико Търново" = "equal_more_than_1%_AND_less_than_11%",
#                                              "Видин" = "less_than_1%",
#                                              "Враца" = "less_than_1%",
#                                              "Габрово" = "equal_more_than_1%_AND_less_than_11%",
#                                              "Добрич" = "equal_more_than_11%_AND_less_than_33%",
#                                              "Кърджали" = "50%_or_more",
#                                              "Кюстендил" = "less_than_1%",
#                                              "Ловеч" ="equal_more_than_1%_AND_less_than_11%",
#                                              "Монтана" = "less_than_1%",
#                                              "Пазарджик" = "equal_more_than_1%_AND_less_than_11%",
#                                              "Перник" = "less_than_1%",
#                                              "Плевен" = "equal_more_than_1%_AND_less_than_11%",
#                                              "Пловдив" = "equal_more_than_1%_AND_less_than_11%",
#                                              "Разград" = "50%_or_more",
#                                              "Русе" = "equal_more_than_11%_AND_less_than_33%",
#                                              "Силистра" = "equal_more_than_33%_AND_less_than_50%",
#                                              "Сливен" = "equal_more_than_1%_AND_less_than_11%",
#                                              "Смолян" = "equal_more_than_1%_AND_less_than_11%",
#                                              "София град" = "less_than_1%",
#                                              "София област" = "less_than_1%",
#                                              "Стара Загора" = "equal_more_than_1%_AND_less_than_11%",
#                                              "Търговище" = "equal_more_than_33%_AND_less_than_50%",
#                                              "Хасково" = "equal_more_than_11%_AND_less_than_33%",
#                                              "Шумен" = "equal_more_than_11%_AND_less_than_33%",
#                                              "Ямбол" = "equal_more_than_1%_AND_less_than_11%")) 
# 
# df <- df %>% 
#   mutate(tr_pop_pct = recode(province,
#                              "Благоевград"= "0.060048103",
#                              "Бургас" = "0.133193359",
#                              "Варна" = "0.071709819",
#                              "Велико Търново" = "0.067134774",
#                              "Видин" = "0.000893552",
#                              "Враца" = "0.003465514",
#                              "Габрово" = "0.056034259",
#                              "Добрич" = "0.135043905",
#                              "Кърджали" = "0.661617513",
#                              "Кюстендил" = "0.000803889",
#                              "Ловеч" = "0.033315409",
#                              "Монтана" = "0.001191912",
#                              "Пазарджик" = "0.057162137",
#                              "Перник" = "0.001841782",
#                              "Плевен" = "0.036068508",
#                              "Пловдив" = "0.064888382",
#                              "Разград" = "0.500205285",
#                              "Русе" = "0.132301073",
#                              "Силистра" = "0.360892553",
#                              "Сливен" = "0.096901955",
#                              "Смолян" = "0.049340688",
#                              "София град" = "0.001828573",
#                              "София област" = "0.005538342",
#                              "Стара Загора" = "0.048798141",
#                              "Търговище" = "0.357968165",
#                              "Хасково" = "0.125093455",
#                              "Шумен" = "0.30293179",
#                              "Ямбол" = "0.029253547")) %>% 
#   mutate(tr_pop_pct = as.character(tr_pop_pct)) %>% 
#   mutate(tr_pop_pct = as.numeric(tr_pop_pct)) %>% 
#   mutate(tr_pop_pct = tr_pop_pct*100)
# summary(df$tr_pop_pct)
# 
# df <- df %>% 
#   mutate(bg_pop_pct = recode(province,
#                              'Благоевград' = '0.885528784437642',
#                              'Бургас' = '0.804568418325489',
#                              'Варна' = '0.873273977213087',
#                              'Велико Търново' = '0.903248829019796',
#                              'Видин' = '0.912495006622795',
#                              'Враца' = '0.927303953138897',
#                              'Габрово' = '0.92239809982836',
#                              'Добрич' = '0.75396638278541',
#                              'Кърджали' = '0.302176921724104',
#                              'Кюстендил' = '0.929073996095395',
#                              'Ловеч' = '0.909095099093563',
#                              'Монтана' = '0.863055615577101',
#                              'Пазарджик' = '0.8378387167584',
#                              'Перник' = '0.9641769386551',
#                              'Плевен' = '0.914040746675546',
#                              'Пловдив' = '0.87093248739065',
#                              'Разград' = '0.430041493775934',
#                              'Русе' = '0.814419330415674',
#                              'Силистра' = '0.573976162738597',
#                              'Сливен' = '0.766122420701361',
#                              'Смолян' = '0.912498029944838',
#                              'София град' = '0.914174043790433',
#                              'София област' = '0.96444292817553',
#                              'Стара Загора' = '0.862099407346822',
#                              'Търговище' = '0.546544943820225',
#                              'Хасково' = '0.793998645451267',
#                              'Шумен' = '0.592109650376298',
#                              'Ямбол' = '0.868537810209488')) %>% 
#   mutate(bg_pop_pct = as.character(bg_pop_pct)) %>% 
#   mutate(bg_pop_pct = as.numeric(bg_pop_pct)) %>% 
#   mutate(bg_pop_pct = bg_pop_pct*100)
# summary(df$bg_pop_pct)

#Variable/feature selection ----
library(Boruta) #you should have the package installed
library(mlbench) #you should have the package installed
library(caret) #you should have the package installed
library(randomForest) #you should have the package installed

set.seed(1113)
boruta <- Boruta(marriage_tr ~ ., 
                 data =df_imp, 
                 doTrace=2,
                 maxRuns=500)
print(boruta)
attStats(boruta) #
plot(boruta, las=2, cex.axis=0.7)
plotImpHistory(boruta)

#Tentative Fix
bor <- TentativeRoughFix(boruta)
print(bor)
attStats(bor)
plot(bor, las=2, cex.axis=0.7)

#Alternate approach
library(rFerns) #you should have the package installed
Boruta(marriage_tr ~ ., 
       data=df_imp,
       getImp=getImpFerns,
       maxRuns=500) -> Boruta.srx.ferns
print(Boruta.srx.ferns)
plot(Boruta.srx.ferns, las=2, cex.axis=0.7)
attStats(Boruta.srx.ferns)

#Tentative Fix
bor.srx.ferns <- TentativeRoughFix(Boruta.srx.ferns)
attStats(bor.srx.ferns)
plot(bor.srx.ferns, las=2, cex.axis=0.7)

