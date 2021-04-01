## Fake News

## Bernoulli response
## NLP

## where do you get the features for text analytics?

## feature engineering

## language variable 
## what language is this written in? 

## tfidf(d, t) = tf * 1/df
## relates whether a word comes up a lot in an article and whether it is unique to that article

## term frequency * inverse document frequency (which is a function of document and term)


## take all the unique words that come from all the documents in your corpus
## calculate a tfidf score for each of those words

## find the words which are most commonly used in each of the 
## documents, select the top commonly used words which are 
## described by tfidf score ... hmmm idk about this step

## now you have a row of words and for each document that document
## has a tfifd score for each word in that row
## the tfidf score represents how important that word is for the 
## given document


## convert the document into a tidy text format


## feature engineer word count?

library(caret)
library(tidyverse)
library(rpart)
library(adabag)

df <- vroom::vroom("~/Desktop/Kaggle/FakeNews/Data/CleanFakeNews.csv")
df$isFake <- as.factor(df$isFake)

data <- df %>% filter(Set=="train")
data <- subset(data, select = -c(Set, Id, language.x)) 

### XGB Tree Model
tr = trainControl(method="repeatedcv", number=3, repeats=3, search="grid", verboseIter=TRUE)
xgbTreeGrid <- expand.grid(nrounds = 20,
                       max_depth = 20,
                       eta = 0.5,
                       gamma = 1,
                       colsample_bytree = .7,
                       min_child_weight = 1,
                       subsample = 1) 
## Parallelization
cl <- parallel::makeCluster(4, setup_strategy = "sequential")
news.model <- train(form=isFake~.,
                             data = data,
                             method = "xgbTree",
                             metric = "Accuracy",
                             tuneGrid = xgbTreeGrid,
                             trControl=tr)
parallel::stopCluster(cl)

preds <- predict(news.model, newdata=df %>% filter(Set=="test"))
submission <- data.frame(id=df %>% filter(Set=="test") %>% pull(Id),
                         label=preds)
write.csv(x=submission, row.names=FALSE, file="~/Kaggle/FakeNews/submissions.csv")


#fake.adaboost <- boosting(isFake~., data = data, boos=TRUE, mfinal=3)
#importanceplot(fake.adaboost)



## Use stemmed and lemmatized data set 
X <- vroom::vroom("~/Desktop/Kaggle/FakeNews/Data/embedded.csv")
y <- data.frame(df %>% filter(Set=="train") %>% pull(isFake))
names(y)[1] <- "isFake"
X$isFake <- y
X$isFake <- as.factor(y$isFake)

news.model <- train(form=isFake~.,
                             data = X,
                             method = "xgbTree",
                             metric = "Accuracy",
                             tuneGrid = xgbTreeGrid,
                             trControl=tr)

test_data <- vroom::vroom("~/Desktop/Kaggle/FakeNews/Data/embedded_test.csv")
preds <- predict(news.model, newdata=test_data)
submission <- data.frame(id=df %>% filter(Set=="test") %>% pull(Id),
                         label=preds)
write.csv(x=submission, row.names=FALSE, file="~/Desktop/Kaggle/FakeNews/submissions.csv")

