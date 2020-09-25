library(dplyr)
if(!file.exists("./downloaddata.zip")){
        url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(url, destfile = "./downloaddata.zip")
        zipF<- "./downloaddata.zip"
        outDir<-"./"
        unzip(zipF,exdir=outDir)
}

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activitys <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code","activity"))
subjecttest <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "code")
subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "code")

#STEP 1

xdf <- rbind(xtrain,xtest)
ydf <- rbind(ytrain,ytest)
subjects <- rbind(subjecttrain,subjecttest)
completedf <- cbind(subjects,xdf,ydf)

# STEP 2

tidydata <- select(completedf,subject, code, contains("mean"), contains("std"))
 
# STEP 3

tidydata$code <- activitys[tidydata$code,2]


# STEP 4


names(tidydata)[2] = "activity"
names(tidydata)<-gsub("Acc", "accelerometer ", names(tidydata))
names(tidydata)<-gsub("Gyro", "gyroscope ", names(tidydata))
names(tidydata)<-gsub("BodyBody", "body ", names(tidydata))
names(tidydata)<-gsub("Body", "body ", names(tidydata))
names(tidydata)<-gsub("Mag", "magnitude ", names(tidydata))
names(tidydata)<-gsub("^t", "time ", names(tidydata))
names(tidydata)<-gsub("^f", "frequency ", names(tidydata))
names(tidydata)<-gsub("tBody", "time body ", names(tidydata))
names(tidydata)<-gsub("\\.mean", " mean ", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("\\.std", " std ", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("Freq", "frequency ", names(tidydata))
names(tidydata)<-gsub("angle", "angle ", names(tidydata))
names(tidydata)<-gsub("Gravity", "gravity ", names(tidydata))
names(tidydata)<-gsub("\\.tbody", "time body ", names(tidydata))

# STEP 5

finaldata <- group_by(tidydata, subject, activity) %>%
        summarise_all(funs(mean))
write.table(finaldata, "FinalData.txt", row.name=FALSE)
finaldata
