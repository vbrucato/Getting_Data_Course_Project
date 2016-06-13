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

datatrain1 <- cbind(cbind(datatrain, subjecttrain), labeltrain)
datatest1 <- cbind(cbind(datatest, subjecttest), labeltest)
names(datatest1)<-names(datatrain1)
identical(names(datatrain1),names(datatest1))
datajoined <- rbind(datatrain1, datatest1)

colname <- rbind(rbind(features, c(562, "subject")), c(563, "actid"))[,2]
names(datajoined) <- colname

stdmeandatajoined <- datajoined[,grepl("mean|std|subject|actid", names(datajoined))]

stdmeandatajoined <- join(stdmeandatajoined, activitylabels, by = "actid", match = "first")
stdmeandatajoined <- stdmeandatajoined[,-1]

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

tidydata = ddply(stdmeandatajoined, c("subject","activity"), numcolwise(mean))
write.table(tidydata, file = "tidydata.txt")