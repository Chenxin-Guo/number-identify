#delete useless columns
google <- google[, !colnames(google) %in% c('index','date','fullVisitorId', 'sessionId', 
                                            'visitId', 'adwordsClickInfo', 'adContent', 
                                            'visitStartTime', 'region', 'metro', 
                                            'city', 'networkDomain', 'referralPath', 'keyword', 
                                            'visitStartTime', 'Time', 'NewDate','visits','X', 'country')]

#devide newtime into 'night', 'morning', 'afternoon', 'evening' 4 equal levels
google$NewTime <- as.numeric(lapply(strsplit(as.character(google$NewTime),":"),  function(x) x[1]))
google$NewTime <-cut(google$NewTime, breaks = 6*(0:4), labels=c('night', 'morning', 'afternoon', 'evening'), 
                     include.lowest=TRUE, ordered=TRUE)

#transfer Revenue into classification and regresson that new feature-transactionRevenue
Revenue=ifelse(google$transactionRevenue<=0,"False","True")
google=data.frame(google,Revenue)
#countryNumber=c(summary(google$country))

#convert NA into 0 and morning
#c=is.na(google$bounces)
#which(is.na(google$bounces))
google$bounces[which(is.na(google$bounces))]=0
google$pageviews[which(is.na(google$pageviews))]=0
google$NewTime[which(is.na(google$NewTime))]='morning'

#make logic into factor
google$isMobile=as.factor(google$isMobile)
google$isTrueDirect=as.factor(google$isTrueDirect)

#browse have 54levels which is more than the mac level of random forest level so i merge the names whose total sum is 1 , and call them Other
levels(google$browser)[levels(google$browser) %in% c("User Agent",'TCL P500M', "Reddit",'Konqueror', '[Use default User-agent string] LIVRENPOCHE',
                                                     'subjectAgent: NoticiasBoom', 'M5', 'first', 'Hisense M20-M_LTE', 'IE with Chrome Frame', 'HTC802t_TD','DoCoMo', 
                                                     'Changa 99695759','CSM Click','ADM','subjectAgent: NoticiasBoom')] <- "Other"

#source has 180levels, so i merge them into 7 levels
#levels(google$source)[levels(google$source) %in% c('google')] <- "google"
#levels(google$source)[levels(google$source) %in% c('youtube.com')] <- "youtube"
#levels(google$source)[levels(google$source) %in% c('(direct)')] <- "(direct)"
#levels(google$source)[levels(google$source) %in% c('mall.googleplex.com')] <- "mall"
#levels(google$source)[levels(google$source) %in% c('Partners')] <- "Partners"
#levels(google$source)[levels(google$source) %in% c('analytics.google.com')] <- "analytics"
levels(google$source)[levels(google$source) %in% c('dfa','google.com','baidu','m.facebook.com','sites.google.com','facebook.com','siliconvalley.about.com',
                                                   'reddit.com')] <- "big_k"
levels(google$source)[!levels(google$source) %in% c('google', 'youtube.com','(direct)','mall.googleplex.com','Partners',
                                                    'analytics.google.com','dfa','google.com','baidu','m.facebook.com','sites.google.com','facebook.com','siliconvalley.about.com',
                                                    'reddit.com','(Other)')] <- "Other"


#the follow is using the true revenue to regression
google_new<-google[google$Revenue=='True', ]
#transfer revenue into log(revenue)
google_new$transactionRevenue=log(google_new$transactionRevenue)
#regression: random forest
google_new=google_new[, !colnames(google_new) %in% c('Revenue')]
train_ind_new <- sample(1:nrow(google_new), 2/3*nrow(google_new))
google_train_new <- google_new[train_ind_new, ]
google_test_new <- google_new[-train_ind_new, ]

#duplicate the min side
google_dup=google[google$Revenue=="True", ]
ind=rep(1:length(google_dup[,1]), 60)
google=rbind(google, google_dup[ind, ])
'''
for (i in 1:60){
  google<-rbind(google, google_dup)
}'''

#devide the training and testing data
set.seed(5)
train_ind <- sample(1:nrow(google), 2/3*nrow(google))
google_train <- google[train_ind, ]
google_test <- google[-train_ind, ]


#https://medium.com/@aravanshad/gradient-boosting-versus-random-forest-cfa3fa8f0d80
'''
#logistic regression
google_logit <- glm(Revenue~.-transactionRevenue, data = google_train, family = binomial,control=list(maxit=1000))
summary(google_logit)
pre=predict(google_logit, newdata=google_test, type='response')
library(ROCR)
library(gplot)
perf=performance(pre, google$Revenue[-train_ind]) #木有做出来
'''


#svm
library(e1071)
svm.fit=svm(Revenue~. -transactionRevenue, data=google_train,kernel='linear', cost=0.1, scale=FALSE)
svm.fit
#cross validation:
tuned=tune(svm, Revenue~. -transactionRevenue, data=google_train, kernel='linear', ranges = list(cost=c(0.001, 0.01, 0.1, 1,10,100)))
tuned # and find the best cost is 0.01
svm.fit=svm(Revenue~. -transactionRevenue, data=google_train,kernel='linear', cost=0.01, scale=FALSE)
pre=predict(svm.fit, newdata=google_test, type='class')
error=mean(pre-google$Revenue[-train_ind])

#naive bayes:
bayes.fit=naiveBayes(Revenue~. -transactionRevenue, data=google_train, laplace = TRUE)
summary(bayes.fit)
pre=predict(bayes.fit, newdata=google_test)
error=mean(pre-google$Revenue[-train_ind])



#XGB
library(Matrix)
library(xgboost)
google$Revenue=as.numeric(google$Revenue)-1
google1=google[, !colnames(google) %in% c('transactionRevenue')]
sparse_matrix <- sparse.model.matrix(Revenue ~ ., data = google1)[,-1]
xgb.fit <- xgboost(data = sparse_matrix, label = google1$Revenue, max_depth = 4,
               eta = 1, nthread = 2, nrounds = 10,objective = "binary:logistic")
#You can see some train-error: 0.XXXXX lines followed by a number. It decreases. 
#Each line shows how well the model explains your data. Lower is better.
#Build the feature importance data.table
#Gain is the improvement in accuracy brought by a feature to the branches it is on.
importance <- xgb.importance(feature_names = colnames(sparse_matrix), model = xgb.fit)
head(importance)
importance
# from the frequency and importance output, we know that the pageviews, hits and visitnumber in the most imp 3 features
# the following is the importance plot
xgb.plot.importance(importance_matrix = importance)

importanceRaw <- xgb.importance(feature_names = colnames(sparse_matrix), model = xgb.fit, 
                                data = sparse_matrix, label = output_vector)
importanceRaw





'''
#lightGBM

library(lightgbm)
data(agaricus.train, package='lightgbm')
train <- agaricus.train
dtrain <- lgb.Dataset(train$data, label=train$label)
params <- list(objective="regression", metric="l2")
model <- lgb.cv(params, dtrain, 10, nfold=5, min_data=1, learning_rate=1, early_stopping_rounds=10)
'''





#after the classification, we need to use regression to regress the true revenue
#the follow is using the true revenue to regression
#linear regression
linear.fit=lm(transactionRevenue~. , data=google_train_new)
summary(linear.fit)
pre=predict(linear.fit, data=google_test_new)
mse=mean((pre - google_new$transactionRevenue[-train_ind_new])^2)
mse
#[1] 1.660467
#from the report of linear regression, i know that hit, pageview newvisits, visitNumber and (newtime) are very important
library(boot)
cv.error=c(1,2,3)
for (i in 1:3){
  glm.fit=glm(google_new$transactionRevenue~poly(google_new$hits, i)+poly(google_new$pageviews, i)+
                poly(google_new$NewTime, i)+poly(google_new$visitNumber, i))
  cv.error[i]=cv.glm(glm.fit,google_train_new, k=10)$delta[1]
}


library(ISLR)
library(leaps)
regfit <- regsubsets(transactionRevenue~.,data=google_train_new,nvmax=10)
summary(regfit)




#random forest regression forecast:
library(randomForest)
RF.google_new=randomForest(transactionRevenue~. , data=google_train_new, mtry=10, ntree=100, importance=TRUE)
importance(RF.google_new)
# from the importance, the most important facors are visitNumber, channelGrouping , operatingSystem, NewTime
pre = predict(RF.google_new,newdata=google_test_new)
error=mean((pre-google_new$transactionRevenue[-train_ind])^2)
error

#para Cross validation,total 23 parameters
test.MSE <- rep(0,23)
train.MSE=rep(0,23)
for (i in 1:23){
  set.seed(2)
  RF.google_new=randomForest(transactionRevenue~. , data=google_train_new, mtry=i, ntree=1000, importance=TRUE)
  set.seed(2)
  pre = predict(RF.google_new,newdata=google_test_new)
  test.MSE[i]=mean((pre-google_new$transactionRevenue[-train_ind])^2)
  
  train.result=predict(RF.google_new,newdata=google_train_new)
  train.MSE[i]=mean((pre-google_new$transactionRevenue[train_ind])^2)
}

plot(Sh.val, test.MSE)
plot(Sh.val, train.MSE )


#boosting regression forecate
library(gbm)
boost.google = gbm(transactionRevenue~., data=google_train_new, distribution = "gaussian", 
                   n.trees = 1000, interaction.depth = 4) 
#default shrinkage = 0.001
summary(boost.google)

yhat.boost = predict(boost.google, newdata=google_test_new, n.trees=100)
mean((yhat.boost - google_new$transactionRevenue[-train_ind_new])^2)

#if the shrinkage=0.2, error 会变大
boost.google = gbm(transactionRevenue~., data=google_train_new, distribution = "gaussian", 
                   n.trees = 1000, interaction.depth = 4, shrinkage = 0.2) 
#default shrinkage = 0.001
summary(boost.google)
yhat.boost = predict(boost.google, newdata=google_test_new, n.trees=100)
mean((yhat.boost - google_new$transactionRevenue[-train_ind_new])^2)
'''
Sh.val <- 10^(seq(-3,-0.1, by = 0.1))
test.MSE <- rep(0,length(Sh.val))
train.MSE=rep(0,length(Sh.val))
for (i in 1:length(Sh.val)){
  set.seed(2)
  boost.google=gbm(transactionRevenue~., data = google_train_new, distribution = "gaussian", 
                    n.trees = 1000, interaction.depth = 4, shrinkage = Sh.val[i])
  set.seed(2)
  pre=predict(boost.google, newdata=google_test_new,n.tree=1000)
  test.MSE[i]=mean((pre- google_new$transactionRevenue[-train_ind_new])^2)
  
  train.result=predict(boost.google, newdata=google_train_new,n.tree=1000)
  train.MSE[i]=mean((train.result-oogle_new$transactionRevenue[train_ind_new])^2)
}

plot(Sh.val, test.MSE)
plot(Sh.val, train.MSE )
'''


#https://cran.r-project.org/web/packages/xgboost/vignettes/discoverYourData.html#numeric-v.s.-categorical-variables
library(Matrix)
library(xgboost)
revenue=google_new$transactionRevenue
google_new1=data.frame(google_new, revenue)
google_new2= google_new1[, !colnames(google_new1) %in% c('transactionRevenue')]
sparse_matrix <- sparse.model.matrix(revenue ~ ., data = google_new2)[,-1]
xgb.fit <- xgboost(data = sparse_matrix[train_ind_new,], label = google_new2$revenue[train_ind_new], max_depth = 4,
                   eta = 1, nthread = 2, nrounds = 10,objective = "reg:linear")
#You can see some train-error: 0.XXXXX lines followed by a number. It decreases. 
#Each line shows how well the model explains your data. Lower is better.
#Build the feature importance data.table
#Gain is the improvement in accuracy brought by a feature to the branches it is on.
importance <- xgb.importance(feature_names = colnames(sparse_matrix), model = xgb.fit)
#head(importance)
importance
# from the frequency and importance output, we know that the pageviews, hits and visitnumber in the most imp 3 features
# the following is the importance plot
xgb.plot.importance(importance_matrix = importance)

importanceRaw <- xgb.importance(feature_names = colnames(sparse_matrix), model = xgb.fit, 
                                data = sparse_matrix, label = output_vector)
importanceRaw

#[10]	train-rmse:1.025379 (training error)

#then make prediction:
pred_xgb <- predict(xgb.fit, sparse_matrix[-train_ind_new, ])
error=mean((pred_xgb-google_new2$revenue[-train_ind_new])^2)
error
#therefor the xgboost testing error=[1] 1.196031
#the MSE is the lowest among the random forest, boosting. (random forest>boosting>xgboost)


#lasso and ridge regression:
library(ISLR)
library(leaps)
regfit <- regsubsets(transactionRevenue~.,data=google_train_new,nvmax=10,really.big = TRUE)
summary(regfit)

regfit.fwd <- regsubsets(transactionRevenue~.,data=google_train_new,nvmax=10, method="forward")
summary(regfit.fwd)


x=model.matrix(revenue~.,google_new2[train_ind_new, ])[,-1]
y=google_new2$revenue[train_ind_new]
library(glmnet)
ridge.mod1 <- glmnet(x, y, alpha=0, lambda=0.1)
MSE1 <- sum((y[-train_ind_new] - predict(ridge.mod1, s = 0.1, newx = x[-train_ind_new,]))^2) / length(y[-train_ind_new])
#MSE1=[1] 1.162273
ridge.mod2 <- glmnet(x, y, alpha=0, lambda=0.5)
MSE2 <- sum((y[-train_ind_new] - predict(ridge.mod, s = 0.5, newx = x[-train_ind_new,]))^2) / length(y[-train_ind_new])
#MSE1=[1] 1.162273

#Model fit on the training set
ridge.mod <- glmnet(x, y, alpha=0, thresh=1e-12)
# Use 10-fold cross-validation to choose lambda
set.seed(1)
cv.out=cv.glmnet(x, y, nfolds = 10, lambda = ridge.mod$lambda, alpha=0)
cv.out
#$lambda.min [1] 0.03308305
ridge.mod2 <- glmnet(x, y, alpha=0, lambda=0.03308)
MSE2 <- sum((y[-train_ind_new] - predict(ridge.mod, s = 0.5, newx = x[-train_ind_new,]))^2) / length(y[-train_ind_new])
#MSE1=[1] 1.162273

regfit.fwd <- regsubsets(Salary~.,data=Hitters,nvmax=19,method="forward")
summary(regfit.fwd)

