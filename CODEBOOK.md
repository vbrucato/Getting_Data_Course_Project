---
title: "CODEBOOK"
output: html_document
---


The script follows the different steps described in the analysis course project :

Here's how to load our data and initialize our packages:

```{r}
library(plyr)
library(data.table)

datatrain <- read.table("./gettingdataassign/train/X_train.txt")
labeltrain <- read.table("./gettingdataassign/train/y_train.txt")
subjecttrain <- read.table("./gettingdataassign/train/subject_train.txt")

datatest <- read.table("./gettingdataassign/test/X_test.txt")
labeltest <- read.table("./gettingdataassign/test/y_test.txt")
subjecttest <- read.table("./gettingdataassign/test/subject_test.txt")

activitylabels <- read.table("./gettingdataassign/activity_labels.txt", col.names=c("actid","activity"))
features <- read.table("./gettingdataassign/features.txt", colClasses=c("character"))

```
Here the merging of the data to obtain one dataset :

```{r}
datatrain1 <- cbind(cbind(datatrain, subjecttrain), labeltrain)
datatest1 <- cbind(cbind(datatest, subjecttest), labeltest)
names(datatest1)<-names(datatrain1)
identical(names(datatrain1),names(datatest1))
datajoined <- rbind(datatrain1, datatest1)

colname <- rbind(rbind(features, c(562, "subject")), c(563, "actid"))[,2]
names(datajoined) <- colname
```
Here's the extraction of the measurements on the mean and standard deviation for each measurement:

```{r}
stdmeandatajoined <- datajoined[,grepl("mean|std|subject|actid", names(datajoined))]
```
Here are the descriptive activity names of the activities in the data set:

```{r}
stdmeandatajoined <- join(stdmeandatajoined, activitylabels, by = "actid", match = "first")
stdmeandatajoined <- stdmeandatajoined[,-1]
```
Here are the appropriately labels the data set with descriptive variable names:

```{r}
names(stdmeandatajoined) <- gsub('\\(|\\)',"",names(stdmeandatajoined), perl = TRUE)
names(stdmeandatajoined) <- make.names(names(stdmeandatajoined))
names(stdmeandatajoined) <- gsub('Acc',"Acceleration",names(stdmeandatajoined))
names(stdmeandatajoined) <- gsub('GyroJerk',"GyroscopicAcceleration",names(stdmeandatajoined))
names(stdmeandatajoined) <- gsub('Gyro',"Gyroscopic",names(stdmeandatajoined))
names(stdmeandatajoined) <- gsub('Mag',"Magnitude",names(stdmeandatajoined))
names(stdmeandatajoined) <- gsub('^t',"Time",names(stdmeandatajoined))
names(stdmeandatajoined) <- gsub('^f',"Frequency",names(stdmeandatajoined))
names(stdmeandatajoined) <- gsub('\\.mean',"Mean",names(stdmeandatajoined))
names(stdmeandatajoined) <- gsub('\\.std',"StandardDeviation",names(stdmeandatajoined))
names(stdmeandatajoined) <- gsub('Freq\\.',"Frequency",names(stdmeandatajoined))
names(stdmeandatajoined) <- gsub('Freq$',"Frequency",names(stdmeandatajoined))
names(stdmeandatajoined) <- gsub('BodyBody',"Body",names(stdmeandatajoined))
```
Finally, here's our independent tidy data set with the average of each variable for each activity and each subject:

```{r}
tidydata = ddply(stdmeandatajoined, c("subject","activity"), numcolwise(mean))
write.table(tidydata, file = "tidydata.txt")
```
