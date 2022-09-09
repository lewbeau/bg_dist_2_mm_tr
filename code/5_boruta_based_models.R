#Boruta model ----

m_boruta_vars <- glm(marriage_tr ~ province+age+family_status+edu+hh_members+place_type+gen+age_groups, 
                     data = train, 
                     family = "binomial") 
summary(m_boruta_vars) 
#Hosmer-Lemeshow goodness of fit test in R (https://www.youtube.com/watch?v=MYW8gA1EQCQ)
hlbor <- hoslem.test(m_boruta_vars$y, fitted(m_boruta_vars), g=10)
hlbor

#AIC:  1190.1; significant vars (0.5) - education, family_status, province.
#Goodness-of-fit test
with(m_boruta_vars, pchisq(null.deviance - deviance, df.null-df.residual,lower.tail = F))
#to calculate McFadens Pseudo R2: 1) pull out the log-likelihood of the null model out of the model and divide by -2
ll.nullbor <- m_boruta_vars$null.deviance
#2) pull the log-likelihood for the model out by getting the value for the residual deviance and dividing by -2
ll.proposedbor <- m_boruta_vars$deviance
#do the math for the Pseudo R2 coefficient; This can be interpreted as the overall effect size
(ll.nullbor-ll.proposedbor)/ll.nullbor # Pseudo R2 = 0.08472523
#p-value for the Pseudo R2
1-pchisq(2*(ll.proposedbor-ll.nullbor), df=(length(m_boruta_vars$coefficients)-1)) #p-value = 1 ergo Pseudo R2 not significant


#rFerns model ----
m_rFerns_vars <- glm(marriage_tr ~ province+family_status+education+hh_members+hh_u18+age_groups*children, 
                     data = train, 
                     family = "binomial") 
summary(m_rFerns_vars) 
#Hosmer-Lemeshow goodness of fit test in R (https://www.youtube.com/watch?v=MYW8gA1EQCQ)
hlrFerns <- hoslem.test(m_rFerns_vars$y, fitted(m_rFerns_vars), g=10)
hlrFerns

#AIC:  1190.1; significant vars (0.5) - education, family_status, province.
#Goodness-of-fit test
with(m_rFerns_vars, pchisq(null.deviance - deviance, df.null-df.residual,lower.tail = F))
#to calculate McFadens Pseudo R2: 1) pull out the log-likelihood of the null model out of the model and divide by -2
ll.nullrFerns <- m_rFerns_vars$null.deviance
#2) pull the log-likelihood for the model out by getting the value for the residual deviance and dividing by -2
ll.proposedrFerns <- m_rFerns_vars$deviance
#do the math for the Pseudo R2 coefficient; This can be interpreted as the overall effect size
(ll.nullrFerns-ll.proposedrFerns)/ll.nullrFerns # Pseudo R2 = 0.08472523
#p-value for the Pseudo R2
1-pchisq(2*(ll.proposedrFerns-ll.nullrFerns), df=(length(m_rFerns_vars$coefficients)-1)) #p-value = 1 ergo Pseudo R2 not significant
