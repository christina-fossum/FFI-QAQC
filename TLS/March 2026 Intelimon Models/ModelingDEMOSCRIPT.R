
# Edited by: Christina Fossum 2/09/2026
# Title: Intelimon Modeling - DEMO

# The purpose of this script is to walk you through the steps of modeling 'pred' metrics (traditional field-collected data) using 'vars' intelimon data metrics
# Ultimately, the goal is to produce good predictive models that we can send into intelimon so that they can provide us with more useful outputs from our TLS scans
# Basic workflow: 
    # (1) we create reasonable models (i.e. minimal variables (2-3), good enough r^2, good enough rmse, and that these both translate from training data to test data)
    # (2) Save models, send to intelimon staff
    # (3) Whenever they do their updates, they will review these models and if they pass review process, they will integrate into our available intelimon TLS metrics


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Step 1
# Load required r packages

library(tidyverse)
library(leaps)
library(performance)
library(ggplot2)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Step 2
# Load data (using burn severity data for this demo)

pred <- read.csv("intelimon models/RX Burn Severity//pred_burnseverity.csv") %>% select(-1)
vars <- read.csv("intelimon models/RX Burn Severity//vars_burnseverity.csv") %>% select(-1)

# Filter out reads/scans that you don't want to use in models as well as 'pred' variables you aren't interested in
# (might not be necessary, but for burn severity data, we want to filter out all of the year-1 data and most of the pre-burn data so that those don't overpower post-burn)

# Combine pred + vars so that when we filter, data stays aligned
temp_data <- cbind(pred, vars)

# Filter out scorch/char data & Yr01 data 
temp_data <- temp_data %>% select(-c(4:12)) %>% filter(MonStatus != "YR01") 

# Check and see how many post-burn plots we have vs. pre-burn
sum <- temp_data %>% group_by(MonStatus) %>% summarise(count = n(), .groups = "drop")
sum # 17 post, 5 PR01, 25 PRE. Lets cut down the pre so that we have 7 pre and 17 post

# To do this, I am going to start with cutting all Eagle Cliff & PR01
temp_data <- temp_data %>% slice(-c(19:24)) %>% filter(MonStatus != "PR01") 
# Keep cutting down PRE data (might come back to this later on to fine tune model outputs)
temp_data <- temp_data %>% slice(-c(1, 5, 7, 11, 17, 19:21, 25, 34:36))

# Check and see how many post-burn plots we have vs. pre-burn
sum <- temp_data %>% group_by(MonStatus) %>% summarise(count = n(), .groups = "drop")
sum # 7 pre and 17 post

# Now I have my data filtered the way I want it, separate pred and vars back out
pred <- temp_data %>% select(1:15)
vars <- temp_data %>% select(16:268)

# Run the following chunk so that the vars data is formatted correctly for modeling
vars <- vars %>% mutate(across(where(is.character), as.factor)) %>% select(where(~!is.factor(.) || nlevels(.) > 1)) %>% select(where(~sum(is.na(.)) == 0))

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Step 3
## Split data into training and test datasets (change sample_size if needed so that 'test_vars' and 'test_pred' contain atleast 3-4 datapoints)

set.seed(123)
sample_size <- floor(0.2 * nrow(vars))
test_indices <- sample(seq_len(nrow(vars)), size = sample_size)
train_vars <- vars[-test_indices, ]
test_vars <- vars[test_indices, ]
train_pred <- pred[-test_indices, ]
test_pred <- pred[test_indices, ]

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Step 4
## Model Selection

# I want to try to model substrate burn severity, so I will set variable to 'SubSev'. nvmax is max number of variables (set to 2 or 3)
# method should be kept as 'seqrep' and really.big as 'T' although these can both be changed 
regfit = regsubsets(train_pred$SubSev~., train_vars,  nvmax = 3 , method = "seqrep", really.big = T) 

# Visual checks to see how many variables you should use
regsum<- summary(regfit)
plot(regsum$rsq, type = "l") 
plot(regsum$rss, type = "l") 
plot(regsum$bic, type = "l") 
which.min(regsum$bic) 
plot(regfit, scale = "r2") 

# Change # to best model
vcov(regfit,3) 
coef(regfit,3)

# Whichever variables are listed for vcov and coef, these are your variables selected for models 
# Here I got: h_l2_std, s_l4_na_per, and s_l4_prop_ku

attach(train_vars)
# put the selected predictor variables in the model after the "~" seperated by "+" and run the model
lm1 <- lm(formula = train_pred$SubSev ~ h_l2_std + s_l4_na_per + s_l4_prop_ku)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Step 5
# Check model 


#look at the summary r2 values and RMSE
summary(lm1)
r2(lm1) #adj r^2 is 0.851 is pretty good (anything 0.5-0.8 is good for ecological data)
rmse(lm1) #rmse is 0.28, meaning model predicts 'SubSev' +/- 0.28 of actual data. this seems pretty good to me

# Visual check of model assumptions. Make sure Linearity, homogeneity of variance, influential observations, colinearity, normality of risiduals all check out
check_model(lm1) #if you have colinearity, consider using model with fewer variables

#use the model to predict out new values from variables alone
lm_out <- predict.lm(lm1, vars)

#format the predictions and observations for plotting
data<-data.frame(x=lm_out, y=pred$SubSev)

# Plot observed values vs. predicted
ggplot(data,aes(x,y)) +
  geom_point() +
  geom_smooth(method='lm', se=FALSE,) +
  theme_light() +
  labs(x='Predicted Values', y='Observed Values', title='TotalFuel Load') +
  theme(plot.title = element_text(hjust=0.5, size=20, face='bold') 
  ) 
# data points should be distributed fairly evenly along lm line

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Step 6
# Check model's ability to predict test data

# use the model to predict test data
test_out<- predict.lm(lm1,test_vars)

# Calculate RMSE of test data
errors<- test_out - test_pred$SubSev
mae <- mean(abs(errors))
mse <- mean(errors^2)
rmse <- sqrt(mse)
rmse #rmse = 0.62. You can expect rmse for test data to not be as good as that for training data, but should still be good enough to predict. 0.62 is not great 

# format test predicted and observed
data2<- data.frame(x=test_out, y=test_pred$SubSev)

# Plot test observed values vs. test predicted
ggplot(data2,aes(x,y)) +
  geom_point() +
  geom_smooth(method='lm', se=FALSE,) +
  theme_light() +
  labs(x='Predicted Values', y='Observed Values', title='test') +
  theme(plot.title = element_text(hjust=0.5, size=20, face='bold') 
  ) 

# this plot really is not great: points are not distributed evenly along lm

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# If the model looks good, save to disk using naming convention you will remember meaning of
saveRDS(lm1,  "intelimon models/DEMO_ROMO_SubSev.rda")


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Plot your model to see where you went wrong/show efficacy. y = actual data, x = predicted data 


BS <- cbind(pred, data)
BS <- BS %>% select(c(x, y, MacroPlot.Name, MonStatus)) %>% 
  mutate(burn = case_when(MacroPlot.Name %in% c("BME_RAP001", "BME_RAP003", "BME_RAP004", "BME_RAP006", "BME_RAP009", "BME_RAP010", "BME_RAP002") ~ "Fall2024",
                          MacroPlot.Name %in% c("BME_RAP013", "BME_RAP015", "BME_RAP016", "BME_RAP014", "FPIPS1T02:08", "FPIPS1T02:16") ~ "Spring2025",
                          MacroPlot.Name %in% c("FPIPS1T02:14", "FPIPS1T02:01", "FPIPS1T02:05", "FPIPS1T02:02") ~ "Fall2025"))

BS <- BS %>% pivot_longer(cols = c(x,y), names_to = "type", values_to = "value")


ggplot(BS) + geom_boxplot(aes(x = burn, y = value, fill = type)) 


sum <- BS %>% group_by( burn, type ) %>% summarise(max = max(value), min = min(value), median = median(value), mean = mean(value), sd = sd(value)) %>% ungroup()

ggplot(sum) + geom_col(aes(x = burn, y = mean, fill = type), position = position_dodge())+ geom_errorbar(aes(x = burn, ymin = mean - sd, ymax = mean+ sd, fill = type), 
                                                                                                         position = position_dodge())




























