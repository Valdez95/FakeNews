# FakeNews
https://www.kaggle.com/c/fake-news/overview

## Purpose
The purpose of this project is to build a system to identify unreliable news articles. This is based off of the Kaggle Fake News Competition.

## Files
The submissions directory contains files for each individual submission.
FakeNews.R contains my code for building and training the models.
FakeNews.ipynb and FakeNewsCleaning.R both contain code for data preprocessing.

## Preprocessing
Created a language variable which identifies which language the article is in. 
Removed stop words from the articles. 
Calculated TF-IDF.

## Predictions
The model I used for predictions was a Boosted Tree using the caret package in R.
