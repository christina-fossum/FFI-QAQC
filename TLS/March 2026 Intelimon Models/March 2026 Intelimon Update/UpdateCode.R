
# 3/18/2026


# Look at pre/post/ yr-01 burn
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# west side fuels
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(tidyverse)
library(leaps)
library(performance)
library(ggplot2)

pred <- read.csv("RMNP Intelimon Update/4. ROMO_West_Fuels/a. ROMO_West_Fuels_TotalAll/ROMO_West_Fuels_TotalAll_pred.csv")
vars <- read.csv("RMNP Intelimon Update/4. ROMO_West_Fuels/a. ROMO_West_Fuels_TotalAll/ROMO_West_Fuels_TotalAll_vars.csv")
vars <- vars %>% mutate(across(where(is.character), as.factor)) %>% select(where(~!is.factor(.) || nlevels(.) > 1)) %>% select(where(~sum(is.na(.)) == 0))



# Create training/test data
set.seed(123)
sample_size <- floor(0.2* nrow(vars))
test_indices <- sample(seq_len(nrow(vars)), size = sample_size)
train_vars <- vars[-test_indices, ]
test_vars <- vars[test_indices, ]
train_pred <- pred[-test_indices, ]
test_pred <- pred[test_indices, ]

regfit = regsubsets(train_pred$TotalAll~., train_vars,  nvmax = 5 , method = "seqrep", really.big = T) 

# Visual checks to see how many variables you should use
regsum<- summary(regfit)
plot(regsum$rsq, type = "l") 
plot(regsum$rss, type = "l") 
plot(regsum$bic, type = "l") 
which.min(regsum$bic) 
plot(regfit, scale = "r2") 

# Change # to best model
vcov(regfit,5) 
coef(regfit,5)

# 0.1 for test data
# 2: SDSHT      LF_CBD 
# 3:   h_MS_tgi  +  h_OS_per +   LF_FDist 
# 4:  X      +        OLAI +hr100_1000_l1_cnt     +     LF_FDist
# 5:  h_l1_cnt   +   h_MS_tgi   +   h_OS_per   +      GCvol   +   LF_FDist

# 0.2 for test data
# 2: h_l5_median  +    LF_CBD
# 3:  h_l5_median +s_l2_na_per    +  LF_CBD 
# 4: h_OS_per +s_l1_zero_per  + s_l2_na_per      +  LF_CBD 
# 5: h_OS_per +s_l1_zero_per   +s_l2_na_per +        MaxSH      +  LF_CBD


attach(train_vars)

lm1 <- lm(formula = train_pred$TotalAll ~   h_l5_median +s_l2_na_per    +  LF_CBD )


summary(lm1)
r2(lm1) 
rmse(lm1) 


check_model(lm1) 

lm_out <- predict.lm(lm1, vars)

data<-data.frame(x=lm_out, y=pred$MeanScHt)

ggplot(data,aes(x,y)) +
  geom_point() +
  geom_smooth(method='lm', se=FALSE,) +
  theme_light() +
  labs(x='Predicted Values', y='Observed Values', title='?') +
  theme(plot.title = element_text(hjust=0.5, size=20, face='bold') 
  ) 

test_out<- predict.lm(lm1,test_vars)

  errors<- test_out - test_pred$TotalAll
mae <- mean(abs(errors))
mse <- mean(errors^2)
rmse <- sqrt(mse)
rmse 

data2<- data.frame(x=test_out, y=test_pred$MeanScHt)

ggplot(data2,aes(x,y)) +
  geom_point() +
  geom_smooth(method='lm', se=FALSE,) +
  theme_light() +
  labs(x='Predicted Values', y='Observed Values', title='test') +
  theme(plot.title = element_text(hjust=0.5, size=20, face='bold') 
  ) 

saveRDS(lm1, "RMNP Intelimon Update/3. ROMO_East_RX/b. ROMO_East_RX_MeanScPct/ROMO_East_RX_MeanScPct.rda")

###############################################################################
# Plots
library(tidyverse)
library(leaps)
library(performance)
library(ggplot2)

# Load pred / vars data
pred <- read.csv("RMNP Intelimon Update/1. ROMO_East_Fuels/a. ROMO_East_Fuels_PRE_TotalAll/ROMO_East_Fuels_PRE_TotalAll_pred.csv")
vars <- read.csv("RMNP Intelimon Update/1. ROMO_East_Fuels/a. ROMO_East_Fuels_PRE_TotalAll/ROMO_East_Fuels_PRE_TotalAll_vars.csv")
lm1<- readRDS("RMNP Intelimon Update/1. ROMO_East_Fuels/a. ROMO_East_Fuels_PRE_TotalAll/ROMO_East_Fuels_PRE_TotalAll.rda")
lm_out <- predict.lm(lm1, vars)
data_preburn_fuels<-data.frame(x=lm_out, y=pred$TotalAll)
data_preburn_fuels <- data_preburn_fuels %>% rename(Observed = y, Predicted = x)
data_preburn_fuels <- cbind(data_preburn_fuels, pred) %>% select(c(1:7))

pred <- read.csv("RMNP Intelimon Update/1. ROMO_East_Fuels/b. ROMO_East_Fuels_POST_TotalAll/ROMO_East_Fuels_POST_TotalAll_pred.csv")
vars <- read.csv("RMNP Intelimon Update/1. ROMO_East_Fuels/b. ROMO_East_Fuels_POST_TotalAll/ROMO_East_Fuels_POST_TotalAll_vars.csv")
lm1<- readRDS("RMNP Intelimon Update/1. ROMO_East_Fuels/b. ROMO_East_Fuels_POST_TotalAll/ROMO_East_Fuels_POST_TotalAll.rda")
lm_out <- predict.lm(lm1, vars)
data_postburn_fuels<-data.frame(x=lm_out, y=pred$TotalAll)
data_postburn_fuels <- data_postburn_fuels %>% rename(Observed = y, Predicted = x)
data_postburn_fuels <- cbind(data_postburn_fuels, pred) %>% select(c(1:7))

pred <- read.csv("RMNP Intelimon Update/1. ROMO_East_Fuels/c. ROMO_East_Fuels_YR01_TotalAll/ROMO_East_Fuels_YR01_TotalAll_pred.csv")
vars <- read.csv("RMNP Intelimon Update/1. ROMO_East_Fuels/c. ROMO_East_Fuels_YR01_TotalAll/ROMO_East_Fuels_YR01_TotalAll_vars.csv")
lm1<- readRDS("RMNP Intelimon Update/1. ROMO_East_Fuels/c. ROMO_East_Fuels_YR01_TotalAll/ROMO_East_Fuels_YR01_TotalAll.rda")
lm_out <- predict.lm(lm1, vars)
data_yr01_fuels<-data.frame(x=lm_out, y=pred$TotalAll)
data_yr01_fuels <- data_yr01_fuels %>% rename(Observed = y, Predicted = x)
data_yr01_fuels <- cbind(data_yr01_fuels, pred) %>% select(c(1:7))

fuels <- bind_rows(data_preburn_fuels, data_postburn_fuels,data_yr01_fuels)
fuels <- fuels %>% pivot_longer(cols = c("Predicted", "Observed"), names_to = "Data", values_to = "value")

Fall24 <- fuels %>% filter(Macroplot %in% c("BME_RAP001", "BME_RAP002", "BME_RAP003", "BME_RAP004", "BME_RAP006", "BME_RAP009", "BME_RAP010"))
Fall24$MonStatus <- factor(Fall24$MonStatus, levels = c("PRE", "POST", "YR01"))
ggplot(Fall24, aes(x = MonStatus, y = value, fill = Data)) + geom_boxplot() + labs(title = "Total Fuel Load (tons/acre) - Fall24 RX")

pred <- read.csv("RMNP Intelimon Update/3. ROMO_East_RX/a. ROMO_East_RX_SubSev/ROMO_East_RX_SubSev_pred.csv")
vars <- read.csv("RMNP Intelimon Update/3. ROMO_East_RX/a. ROMO_East_RX_SubSev/ROMO_East_RX_SubSev_vars.csv")
lm1<- readRDS("RMNP Intelimon Update/3. ROMO_East_RX/a. ROMO_East_RX_SubSev/ROMO_East_RX_SubSev.rda")
lm_out <- predict.lm(lm1, vars)
data_subsev<-data.frame(x=lm_out, y=pred$SubSev)
data_subsev <- data_subsev %>% rename(Observed = y, Predicted = x)
data_subsev <- cbind(data_subsev, pred) %>% select(c(1:6, 18))

data_subsev <- data_subsev %>% pivot_longer(cols = c("Predicted", "Observed"), names_to = "Data", values_to = "value")

ggplot(data_subsev, aes(x = Sample.Event.Date, y = value, fill = Data))+ geom_boxplot()

