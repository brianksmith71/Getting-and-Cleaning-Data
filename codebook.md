---
title: "Code Book for Coursera Getting and Cleaning Data Course Project"
output: html_document
---


### References:

Jorge L. Reyes-Ortiz(1,2), Davide Anguita(1), Alessandro Ghio(1), Luca Oneto(1) and Xavier Parra(2)
1 - Smartlab - Non-Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova, Genoa (I-16145), Italy. 
2 - CETpD - Technical Research Centre for Dependency Care and Autonomous Living
Universitat Politècnica de Catalunya (BarcelonaTech). Vilanova i la Geltrú (08800), Spain
activityrecognition '@' smartlab.ws


### Data Set Information:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.


### Source Data:

A full description is available at the site where the data was obtained:  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.

Here are the data for the project:  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.


### Variables and Transformations:
**NOTE:  I have surrounded variable names with curly braces "{}" for ease of reading and following along**

* Download and unzip the raw data
    + Set variables
        + {working.dir} = getwd()
        + {file.url} = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        + {zip.file} = "./getdata-projectfiles-UCI HAR Dataset.zip"
        + {unzip.dir} = "./UCI HAR Dataset"
        + {unzip.dir.path} = "/UCI HAR Dataset/"
    + Download and unzip {file.url} which creates the {unzip.dir.path}.
    + From the downloaded data, populate your initial data frames
        + {x.train} from "X_train.txt", 7352 obs. of 561 variables
        + {y.train} from "y_train.txt", 7352 obs. of 1 variables
        + {subject.train} from "subject_train.txt", 7352 obs. of 1 variables
        + {x.test} from "X_test.txt", 2947 obs. of 561 variables
        + {y.test} from "y_test.txt", 2947 obs. of 1 variables
        + {subject.test} from "subject_test.txt", 2947 obs. of 1 variables
        + {features} from "features.txt", 561 obs. of 2 variables
        + {activities} from "activity_labels.txt", 6 obs. of 2 variables
    + Merge your initial data frames
        + {x.merged}, 10299 obs. of 561 variables
        + {y.merged}, 10299 obs. of 1 variables
        + {subject.merged}, 10299 obs. of 1 variables
    + Extract only mean and standard deviation measurements
        + {features.indices}, numeric vector with 66 indices representing captured measurements
            ```{r}
            features.indices <- (grep("-mean\\(\\)|-std\\(\\)", features[, 2]))
            ```
        + {x.merged.abridged}, 10299 obs. of 66 variables filtered by {features.indices}
    + Use descriptive names for activities
        + ```{r}colnames(activities) <- c("activity.id", "activity.name")```
        + ```{r}activities[, 2] <- gsub("_", ".", tolower(as.character(activities[, 2])))```
        + ```{r}names(subject.merged) <- "subject.id"```
        + ```{r}names(y.merged) <- "activity.name"```
        + ```{r}y.merged[, 1] = activities[y.merged[, 1], 2]```
    + Appropriately label the data with descriptive names
        + {names(x.merged.abridged)} based upon values from {features[features.indices, 2]}
    + Column bind {subject.merged}, {y.merged}, {x.merged.abridged} into {tidydata}
    + Average measurements by subject.id and activity.name
        + ```{r}tidydata.averaged <- aggregate(. ~subject.id + activity.name, tidydata, mean)```
        
        
    
    
    
    
    
    