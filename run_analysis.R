#############################################################################################
## File         : run_analysis.R
## Project      : Human Activity Recoginition - Data Tidyup
## Coursera     : Course 3 Getting and Cleaning Data / Week 4 Project
## Author       : Paul Ringsted
## Date         : 2018-10-07
## Description  : Loads raw data from HAR dataset, merges into tidy dataset and summarizes
#############################################################################################

#############################################################################################
## Function     : har_load(type)
## Description  : Takes a dataset type of 'test' or 'train', mapping of activities,
##		    observation variable names, and logical list of observations to return
##		  Loads data files associated with this test type from subdirectory
##		    subject_<type>.txt		Subject ID for the observation set (1-30)
##		    y_<type>.txt		Activity labels for the observation set (1-6)
##		    X_<type>.txt		Observation set (561 variables per obs)
##		  Returns dataframe with subject ID, activity ID and requested columns
##		  Assumes working directory is the parent level for the zip
#############################################################################################

har_load <- function(type,act_labels,obs_labels,obs_cols) {

	print(paste("Processing type ",type))

	## Load the subjects, set column names

	filename<-file.path(".",type,paste0("subject_",type,".txt"))
	print(paste("Loading: ",filename))
	subjects <- read.table(filename)
	colnames(subjects)<-c("subjectid")
	print(paste("Records: ",nrow(subjects)," x ",ncol(subjects)))

	## Load the activities and convert to names based on input mapping 'acts_labels'
	## The activity IDs happen to be in order in the file but use match to do the lookup

	filename<-file.path(".",type,paste0("y_",type,".txt"))
	print(paste("Loading: ",filename))
	act <- read.table(filename)
	colnames(act)<-c("actid")
	actname <- act_labels$actname[match(act$actid,act_labels$actid)]
	print(paste("Records: ",length(actname)))

	## Load the observations, set column names based on input mapping 'obs_labels'

	filename<-file.path(".",type,paste0("X_",type,".txt"))
	print(paste("Loading: ",filename))
	obs <- read.table(filename)
	colnames(obs)<-obs_labels$obsname
	print(paste("Records: ",nrow(obs)," x ",ncol(obs)))

	## Build the output dataframe - subject ID, activity name, observations
	## Only use the observation columns specified in input logical 'obs_cols'

	print("Building data frame")
	hardata <- data.frame(subjects,actname,obs[obs_cols])

	print(paste("Records: ",nrow(hardata)," x ",ncol(hardata)))

	## Return the results

	hardata
}


#############################################################################################
## Function     : run_analysis()
## Description  : Process the HAR data into tidy, summarized form
##		  1. Loads the reference files for the HAR dataset from working directory
##		  2. Cleans up the observation variable names and selects mean and std cols
##		  3. Processes the test & train data for these cols
##		  4. Merges the datasets
##		  5. Resulting dataframe contains subject ID, activity name, mean/std cols
##		  6. Summarizes data - mean of each col, by subject and activity
##		  7. Outputs summary resultset to file harmean.txt
#############################################################################################

run_analysis <- function() {

	## Load the reference files for activities and variables, set column names
	
	filename<-file.path(".","activity_labels.txt")
	print(paste("Loading: ",filename))
	act_labels <- read.table(filename)
	colnames(act_labels)<-c("actid","actname")
	print(paste("Records: ",nrow(act_labels)))

	filename<-file.path(".","features.txt")
	print(paste("Loading: ",filename))
	obs_labels <- read.table(filename)
	colnames(obs_labels)<-c("obsid","obsname")
	print(paste("Records: ",nrow(obs_labels)))

	## Build a logical vector to select only mean and std columns
	obs_cols<-(grepl("mean|std",obs_labels$obsname) & !grepl("Freq",obs_labels$obsname))
	print(paste("# Cols : ",sum(obs_cols)))

	## Strip punctuation from the names and convert to lowercase
	obs_labels$obsname<-tolower(gsub("[[:punct:]]","",obs_labels$obsname))

	print("Loading test data.....")
	test_data <- har_load("test",act_labels,obs_labels,obs_cols)
	print(paste("Records: ",nrow(test_data)," x ",ncol(test_data)))

	print("Loading training data.....")
	train_data <- har_load("train",act_labels,obs_labels,obs_cols)
	print(paste("Records: ",nrow(train_data)," x ",ncol(train_data)))

	print("Merging data sets.....")
	full_data <- rbind(test_data,train_data)
	print(paste("Records: ",nrow(full_data)," x ",ncol(full_data)))
	
	## Calculate means for all observations by subject ID and activity
	print("Summarizing data.....")
	mean_data <- aggregate(
			full_data[-(1:2)],
			list(subjectid=full_data$subjectid,
				actname=full_data$actname),
			mean)
				
	print(paste("Records: ",nrow(mean_data)," x ",ncol(mean_data)))

	## Output summary data to file
	filename<-file.path(".","harmean.txt")
	print(paste("Writing: ",filename))
	write.table(mean_data,filename,row.names=FALSE)

	print("Finished")
}

