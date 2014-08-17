library(data.table)
run_analysis <- function(directory=".",summaryFilename="summary.txt") {
  cNames<-read.table(paste0(directory,"\\","featuresDescriptive.txt"),header=FALSE)
  aLabels<-as.data.table(read.table(paste0(directory,"\\","activity_labels.txt"),header=FALSE))
  setnames(aLabels,c("activity","activity.name"))
  setkey(aLabels,activity)
  
  trainingFeatures<-read.table(paste0(directory,"\\train\\X_train.txt"),header=FALSE,col.names=cNames[,2])
  trainingSubjects<-read.table(paste0(directory,"\\train\\subject_train.txt"),header=FALSE,col.names="subject")
  trainingActivity<-read.table(paste0(directory,"\\train\\y_train.txt"),header=FALSE,col.names="activity")
  trainingSAF<-data.frame(trainingSubjects,data.frame(trainingActivity,trainingFeatures))
  
  testFeatures<-read.table(paste0(directory,"\\test\\X_test.txt"),header=FALSE,col.names=cNames[,2])
  testSubjects<-read.table(paste0(directory,"\\test\\subject_test.txt"),header=FALSE,col.names="subject")
  testActivity<-read.table(paste0(directory,"\\test\\y_test.txt"),header=FALSE,col.names="activity")
  testSAF<-data.frame(testSubjects,data.frame(testActivity,testFeatures))
  
  
  meanAndSdColNames<-cNames[,2][cNames[,3]]
  meanAndSdColNamesPlusKeys<-c("subject","activity.name",levels(meanAndSdColNames)[meanAndSdColNames])
  mergedSAF<-as.data.table(merge(trainingSAF,testSAF,all=TRUE))
  setkey(mergedSAF,activity)
  mergedSAF<-mergedSAF[aLabels]
  mergedSAFMeanAndSd<-mergedSAF[,meanAndSdColNamesPlusKeys,with=FALSE]
  setkey(mergedSAFMeanAndSd,subject,activity.name)
  mergedSAFMeanAndSdAvg<-mergedSAFMeanAndSd[,lapply(.SD,mean),by=list(subject,activity.name)]
  avgMeanAndSdColNames<-as.character(lapply(meanAndSdColNames,function(x) paste0("average.",x)))
  avgMeanAndSdColNamesPlusKeys<-c(c("subject","activity.name"),avgMeanAndSdColNames)
  setnames(mergedSAFMeanAndSdAvg,avgMeanAndSdColNamesPlusKeys)
  write.table(mergedSAFMeanAndSdAvg,paste0(directory,"\\",summaryFilename),row.names=FALSE)
}