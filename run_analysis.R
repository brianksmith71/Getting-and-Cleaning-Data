################################################################################
## Download, unzip and clean up data files                                    ##
################################################################################

working.dir = getwd()
file.url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zip.file = "./getdata-projectfiles-UCI HAR Dataset.zip"
unzip.dir = "./UCI HAR Dataset"
unzip.dir.path = "/UCI HAR Dataset/"

if (file.exists(zip.file) == FALSE) {
    download.file(file.url, destfile = zip.file)    
}

if (file.exists(unzip.dir) == FALSE) {
    unzip(zip.file)
}
    
suppressWarnings(file.remove("./getdata-projectfiles-UCI HAR Dataset.zip")) ##  delete original zip

################################################################################
## Load train, test, subject, features and activities files                   ##
################################################################################

if (file.exists(paste0(working.dir, unzip.dir.path, "train/X_train.txt")) == TRUE) {
    x.train <- read.table(paste0(working.dir, unzip.dir.path, "train/X_train.txt"))
}

if (file.exists(paste0(working.dir, unzip.dir.path, "train/y_train.txt")) == TRUE) {
    y.train <- read.table(paste0(working.dir, unzip.dir.path, "train/y_train.txt"))    
}

if (file.exists(paste0(working.dir, unzip.dir.path, "train/subject_train.txt")) == TRUE) {
    subject.train <- read.table(paste0(working.dir, unzip.dir.path, "train/subject_train.txt"))    
}

if (file.exists(paste0(working.dir, unzip.dir.path, "test/X_test.txt")) == TRUE) {
    x.test <- read.table(paste0(working.dir, unzip.dir.path, "test/X_test.txt"))    
}

if (file.exists(paste0(working.dir, unzip.dir.path, "test/y_test.txt"))) {
    y.test <- read.table(paste0(working.dir, unzip.dir.path, "test/y_test.txt"))    
}

if (file.exists(paste0(working.dir, unzip.dir.path, "test/subject_test.txt")) == TRUE) {
    subject.test <- read.table(paste0(working.dir, unzip.dir.path, "test/subject_test.txt")) 
}

if (file.exists(paste0(working.dir, unzip.dir.path, "features.txt")) == TRUE) {
    features <- read.table(paste0(working.dir, unzip.dir.path, "features.txt"))
}

if (file.exists(paste0(working.dir, unzip.dir.path, "activity_labels.txt")) == TRUE) {
    activities <- read.table(paste0(working.dir, unzip.dir.path, "activity_labels.txt"))
}

################################################################################
## 1.  Merge the data files                                                   ##
################################################################################

x.merged <- rbind(x.train, x.test)
y.merged <- rbind(y.train, y.test)
subject.merged <- rbind(subject.train, subject.test)

################################################################################
## 2.  Extract only measurements on mean and std dev for each measurement     ##
################################################################################

features.indices <- (grep("-mean\\(\\)|-std\\(\\)", features[, 2]))
x.merged.abridged <- x.merged[, features.indices]

################################################################################
## 3.  Use descriptive activity names to name the activities in the data set  ##
################################################################################

colnames(activities) <- c("activity.id", "activity.name")
activities[, 2] <- gsub("_", ".", tolower(as.character(activities[, 2])))
names(subject.merged) <- "subject.id"
names(y.merged) <- "activity.name"
y.merged[, 1] = activities[y.merged[, 1], 2]

################################################################################
## 4.  Appropriately label the data set with descriptive variable names       ##
################################################################################

names(x.merged.abridged) <- features[features.indices, 2]
tidydata <- cbind(subject.merged, y.merged, x.merged.abridged)
write.table(tidydata, file = "tidydata_all.txt", sep = "|", row.name = FALSE)

################################################################################
##  5.  From the data set in step 4, create a second, independent tidy data   ##
##  set with the average of each variable for each activity and each subject. ##
################################################################################

tidydata.averaged <- aggregate(. ~subject.id + activity.name, tidydata, mean)
write.table(tidydata.averaged, file = "tidydata.txt", sep = ",", row.name = FALSE)
