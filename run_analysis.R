#Load the datasets
features<-read.table("features.txt",col.names = c("n","functions"))
activities<-read.table("activity_labels.txt",col.names = c("code","activity"))
SubjectTest<-read.table("subject_test.txt",col.names = "subject")                       
Xtest<-read.table("X_test.txt",col.names = features$functions)
Ytest<-read.table("y_test.txt",col.names = "code")
SubjectTrain<-read.table("subject_train.txt",col.names = "subject")
Xtrain<-read.table("X_train.txt",col.names = features$functions)
Ytrain<-read.table("y_train.txt",col.names = "code")

#Merge files related to x
Xfiles<-rbind(Xtest,Xtrain)
#Merge Files related to Y
Yfiles<-rbind(Ytest,Ytrain)
#Merge subject files
subjects<-rbind(SubjectTest,SubjectTrain)
#Merge all previous data sets
data<-cbind(subjects,Xfiles,Yfiles)

#Delete data sets you dont need any more.
rm(features,subjects,SubjectTest,SubjectTrain,Xfiles,Xtest,Xtrain,Yfiles,Ytest,Ytrain)

#Drop variables you wont need
data<-data%>%
  select(subject,code, contains("mean"),contains("std"))

#Change Numbers by name of activities
data$code<-activities[data$code,2]

#remove data sets you dont need any more
rm(activities)

#Adjust Names
data<-rename(data,activity=code)
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("^t", "Time", names(data))
names(data)<-gsub("^f", "Frequency", names(data))
names(data)<-gsub("tBody", "TimeBody", names(data))
names(data)<-gsub("-mean()", "Mean", names(data), ignore.case = TRUE)
names(data)<-gsub("-std()", "STD", names(data), ignore.case = TRUE)
names(data)<-gsub("-freq()", "Frequency", names(data), ignore.case = TRUE)
names(data)<-gsub("angle", "Angle", names(data))
names(data)<-gsub("gravity", "Gravity", names(data))

#Independent data set

SecondData <- data %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(SecondData, "SecondData.txt", row.name=FALSE)

#Check Names
names(SecondData)

#View dataset
View(SecondData)
