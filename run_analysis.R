
library(plyr)
# read files
dfFeatures <- read.csv("./UCI HAR Dataset/features.txt",col.names = c("Num","Name"),sep = " ",header = FALSE,stringsAsFactors = FALSE)
colsOutput <- union(c("subject","activity"),dfFeatures[,"Name"])

#read X files into dfX data frame
dfX_test <- read.csv("./UCI HAR Dataset/test/X_test.txt",sep = "",header = FALSE,colClasses="numeric")
dfX_train<- read.csv("./UCI HAR Dataset/train/X_train.txt",sep="",header = FALSE,colClasses="numeric")
dfX <- rbind(dfX_test,dfX_train)
colnames(dfX) <- dfFeatures[,"Name"]

#read Subject files into dfSubject data frame
dfSubject_test<- read.csv("./UCI HAR Dataset/test/subject_test.txt",sep = "",header = FALSE,colClasses="numeric")
dfSubject_train <- read.csv("./UCI HAR Dataset/train/subject_train.txt",sep="",header = FALSE,colClasses="numeric")
dfSubject <- rbind(dfSubject_test,dfSubject_train)
colnames(dfSubject) <- "subject"

#read activity into dfActivity data frame
dfActivity_test<- read.csv("./UCI HAR Dataset/test/y_test.txt",sep = "",header = FALSE,colClasses="numeric")
dfActivity_train <- read.csv("./UCI HAR Dataset/train/y_train.txt",sep="",header = FALSE,colClasses="numeric")
dfActivity <- rbind(dfActivity_test,dfActivity_train)
colnames(dfActivity) <- "Label"

#read activity labels and add the activity names to dfActivity 
dfActivityLabel <- read.csv("./UCI HAR Dataset/activity_labels.txt",sep = "",header = FALSE,
                            colClasses=c("numeric","character"),col.names= c("Label","activity"))
#replace in dfActivity names by label
dfActivity  <- join(dfActivity, dfActivityLabel, by = "Label") 

# combine the 3 tables, and remove the unecessary columns
df <- cbind(dfSubject,dfActivity,dfX)
dfDataSet1 <- df[,colsOutput[grep("((std|mean)[^A-Za-z0-9_])|(subject)|(activity)",colsOutput)]]

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject
dfDataSet2 <- ddply(dfDataSet1,c("subject","activity"),numcolwise(mean))
write.table(dfDataSet2,"Proj2Result.csv",row.names=FALSE, sep = ",")
write.table(dfDataSet1,"Proj2BeforeMeans.csv",row.names=FALSE, sep = ",")

