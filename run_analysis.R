### Data Cleaning on  UCI HAR DATASET to create a tidy data set 
library(check)
library(plyr)
# Downloading  the dataset
if(!file.exists("./cleandata")){dir.create("./cleandata")}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./cleandata/projectdataset.zip",method="curl")

# Unzip the dataset
unzip(zipfile = "./cleandata/projectdataset.zip", exdir = "./cleandata")

# 1. Merge the training and test datasets
## unzipped files are in folder UCI HAR DATASET and list the data .
path_rf<-file.path("./cleandata","UCI HAR Dataset")
files<-list.files(path_rf,recursive=TRUE)
files

# 1.1 Reading files

##Read the Activity files
dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
## Read the Subject files
dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
##Read Fearures files
dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

str(dataActivityTest)

str(dataSubjectTrain)

str(dataFeaturesTest)

str(dataFeaturesTrain)

#Concatenate the data tables by rows  
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

#set names to variables
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

#3.Merge columns to get the data frame Data for all data
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

#1.	Subset Name of Features by measurements on the mean and standard deviation
#i.e taken Names of Features with “mean()” or “std()”
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

#2.	Subset the data frame Data by seleted names of Features
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

#3.	Check the structures of the data frame Data
str(Data)

activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
#2.	facorize Variable activity in the data frame Data using descriptive activity names
#3.	check
head(Data$activity,30)


names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
check 
names(Data)


library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidy_data.txt",row.name=FALSE)

