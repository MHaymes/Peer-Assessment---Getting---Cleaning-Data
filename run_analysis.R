

# Source Data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# This program assumes that the main zipped data folder has been extracted into the local working directory. 



# This function calls a series of functions that create and write two tidy data sets.  The first data set contains extracted mean and standard deviation
# observations extracted from the HAR machine learning datasets.  The second contains the mean value for each variable of interest 
# for each unique subject/activity identifier.  These datasets are outputted as text files. 

run_analysis<-function(){
        require(stringi)
        require(reshape2)
        
        mainDF<-mergeDataSets()                     #Completes assignment Parts 1 and 4
        mainDF<-extractMeanAndStd(mainDF)           #Completes Assignment Part 2
        mainDF<-assignActivityNames(mainDF)         #Completes Assignment Part 3
        getAverages(mainDF)                         #Completes Assignment Part 5
}








# This function merges the training and the test sets to create one data set. (ASSIGNMENT PART 1)
# The function also extracts and assigns column names to the variables from the features.txt file. (ASSIGNMENT PART 4)

mergeDataSets<-function(){
        
        # Read in the training data files
        trainDF <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE)
        trainDF_Y<-read.table("./UCI HAR Dataset/train/Y_train.txt", header=FALSE)
        trainDF_sub<-read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)
        
        #append the Activity and Subject vectors to the main training dataframe.
        trainDF$activity<-trainDF_Y$V1
        trainDF$subject<-trainDF_sub$V1
        
        # Read in the test data files
        testDF <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE)
        testDF_Y<-read.table("./UCI HAR Dataset/test/Y_test.txt", header=FALSE)
        testDF_sub<-read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)
        
        #append the Activity and Subject vectors to the main testing dataframe.
        testDF$activity<-testDF_Y$V1
        testDF$subject<-testDF_sub$V1
        
        #append the entire test dataframe to the end of the train dataframe (ASSIGNMENT PART 1)
        DF<-rbind(trainDF,testDF)
        
        #Read in the Variable Names and assign to the main dataframe (ASSIGNMENT PART 4)
        VariableLabels <- read.table("./UCI HAR Dataset/features.txt", header=FALSE)
        colnames(DF)<-c(as.character(variableLabels$V2),"activity","subject")
        return(DF)
}







# This function extracts only the measurements on the mean and standard deviation for each measurement. 
extractMeanAndStd<-function(DF = NULL){

        # stringi package for use in identifying strings within another string.        
        

        #Create a vector label composed of the variable names.  
        Labels<-colnames(DF)
        
        class(Labels)
        
        #Create a logical vector that searches for the partial string "mean()" or "std()" within the variable names.
        #It also retains the subject and activity vectors.
        meanYes<-stri_detect_fixed(Labels,"mean()")
        stdYes<-stri_detect_fixed(Labels,"std()")
        subOrAct<-(colnames(DF)=="activity") | (colnames(DF)=="subject")
        keep<-meanYes|stdYes|subOrAct
        
        #return a new DataFrame of variables containing mean() or std() in the column name.
        DF[,keep]
}





# Assignment Part 3: Uses descriptive activity names to name the activities in the data set
assignActivityNames<-function(DF=NULL){
        
        #reads in the activity lables from the activity_labels.txt file        
        actLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE)
        
        #assigns the labels to the dataframe
        DF$activity <- factor(DF$activity,levels = actLabels$V1,labels = actLabels$V2)

        #Outputs the tidy data set to a txt format.  
        write.table(DF,"HAR tidy (Assignment Part 1-4).txt", sep=",")
        return(DF)
}





# Assignment Part 5 - Creates a second, independent tidy data set with the average of each variable 
# for each activity and each subject
getAverages<-function(DF=NULL){
        

        #melt the dataframe into long form. 
        meltDF = melt(DF, id = c("activity", "subject"), na.rm=TRUE)
        
        #Use dcast to calculate the averages for each unique subject+activity ID. 
        aveDF<-dcast(meltDF, formula = subject + activity ~ variable, mean)
        
        #Outputs the tidy data set to a txt format.  
        write.table(aveDF,"HAR-Averages (Assignment Part 5).txt", sep=",")
}