library(data.table)
run_analysis <- function(directory=".",summaryFilename="summary.txt") {
  #Read in the column names mapping
  cNames<-read.table(paste0(directory,"\\","featuresDescriptive.txt"),header=FALSE)
  
  #Construct the column names subset
  meanAndSdColNames<-cNames[,3][cNames[,4]]
  meanAndSdColNamesPlusKeys<-c("subject","activity.name",levels(meanAndSdColNames)[meanAndSdColNames])
  
  #Read in the activity labels, assign column names and set a key
  aLabels<-as.data.table(read.table(paste0(directory,"\\","activity_labels.txt"),header=FALSE))
  setnames(aLabels,c("activity","activity.name"))
  setkey(aLabels,activity)
  
  #Read in the training Features, Subjects, and Activity Data and unify
  trainingFeatures<-read.table(paste0(directory,"\\train\\X_train.txt"),header=FALSE,col.names=cNames[,3])
  trainingSubjects<-read.table(paste0(directory,"\\train\\subject_train.txt"),header=FALSE,col.names="subject")
  trainingActivity<-read.table(paste0(directory,"\\train\\y_train.txt"),header=FALSE,col.names="activity")
  trainingSAF<-data.frame(trainingSubjects,data.frame(trainingActivity,trainingFeatures))
  
  #Read in the test Features, Subjects, and Activity Data and unify
  testFeatures<-read.table(paste0(directory,"\\test\\X_test.txt"),header=FALSE,col.names=cNames[,3])
  testSubjects<-read.table(paste0(directory,"\\test\\subject_test.txt"),header=FALSE,col.names="subject")
  testActivity<-read.table(paste0(directory,"\\test\\y_test.txt"),header=FALSE,col.names="activity")
  testSAF<-data.frame(testSubjects,data.frame(testActivity,testFeatures))

  #Merge the test and training datasets
  mergedSAF<-as.data.table(merge(trainingSAF,testSAF,all=TRUE))
  
  #Set a key and join in the activity names
  setkey(mergedSAF,activity)
  mergedSAF<-mergedSAF[aLabels]
  
  #Subset the merged datasets
  mergedSAFMeanAndSd<-mergedSAF[,meanAndSdColNamesPlusKeys,with=FALSE]
  
  #Set keys and compute the average by the keys
  setkey(mergedSAFMeanAndSd,subject,activity.name)
  mergedSAFMeanAndSdAvg<-mergedSAFMeanAndSd[,lapply(.SD,mean),by=list(subject,activity.name)]
  
  #Produce new column names for the subsetted/averaged (summary) dataset
  avgMeanAndSdColNames<-as.character(lapply(meanAndSdColNames,function(x) paste0("average.",x)))
  avgMeanAndSdColNamesPlusKeys<-c(c("subject","activity.name"),avgMeanAndSdColNames)
  setnames(mergedSAFMeanAndSdAvg,avgMeanAndSdColNamesPlusKeys)
  
  #Output the summary dataset
  write.table(mergedSAFMeanAndSdAvg,paste0(directory,"\\",summaryFilename),row.names=FALSE)
}