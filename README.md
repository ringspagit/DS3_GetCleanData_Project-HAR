# Human Activity Recognition (HAR) Analysis
## Course 3 - Getting and Cleaning Data - Week 4 Project
## Paul Ringsted, 7th October 2018
---
### Overview
Loads raw data from the messy UCI HAR dataset, merges into tidy dataset and summarizes

The data used in this project represents data collected from the accelerometers from the Samsung Galaxy S smartphone.

A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Data set used for this project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

---
### Execution Description
|Item|Notes|
|:---|:---|
|Usage|**run_analysis()**|
|Inputs|HAR dataset in current working directory (test and train are immediate subdirectories)|
|Outputs|Mean of mean() and std() observations by subject ID and activity to file *harmean.txt*|
---
### Data Process Steps:
1. Load reference file *activity_labels.txt* from working directory (enumerates activity names)
2. Load reference file *features.txt* from working directory (enumerates observation column names)
3. Identify the mean() and std() cols only for final dataset (66 observations; Freq cols excluded)
4. Clean up the observation column names - strips punctuation and converts to lowercase
5. Process each TYPE = {test|train} dataset from TYPE subdirectory, using subfunction **harload(...)**:
	1. Load *subject_TYPE.txt*  -  Subject ID for the observation set (1-30)
	2. Load *y_TYPE.txt*  -  Activity labels for the observation set (1-6)
	3. Load *X_TYPE.txt*  -  Observation set (561 variables per obs)
	4. Convert activity ID in activity labels (y) data to activity name
	5. Selects only the mean() and std() observations from the observation (X) data
	6. Returns data frame with: subject id, activity name, selected observations
6. Merge the two datasets
7. Summarize data using aggregate() - calc mean() of each col, by subject id and activity name
8. Output summary resultset to file *harmean.txt* in working directory
---
### Codebook
|Column|Name|Min|Max|Description|
|:---|:---|:---|:---|:---|
1|subjectid
2|actname
3-5|tbodyaccmean{x|y|z}
6-8|tbodyaccstd{x|y|z}
9-11|tgravityaccmean{x|y|x}
12-14|tgravityaccstd{x|y|z}
15-17|tbodyaccjerkmean{x|y|z}
18-20|tbodyaccjerkstd{x|y|z}
21-23|tbodygyromean{z|y|z}
24-26|tbodygyrostd{x|y|z}
27-29|tbodygyrojerkmean{x|y|z}
30-32|tbodygyrojerkstd{x|y|z}
33|tbodyaccmagmean
34|tbodyaccmagstd
35|tgravityaccmagmean
36|tgravityaccmagstd
37|tbodyaccjerkmagmean
38|tbodyaccjerkmagstd
39|tbodygyromagmean
40|tbodygyromagstd
41|tbodygyrojerkmagmean
42|tbodygyrojerkmagstd
43-45|fbodyaccmean{x|y|z}
46-48|fbodyaccstd{x|y|z}
49-51|fbodyaccjerkmean{x|y|z}
52-54|fbodyaccjerkstd{x|y|z}
55-57|fbodygyromean{x|y|z}
58-60|fbodygyrostd{x|y|z}
61|fbodyaccmagmean
62|fbodyaccmagstd
63|fbodybodyaccjerkmagmean
64|fbodybodyaccjerkmagstd
65|fbodybodygyromagmean
66|fbodybodygyromagstd
67|fbodybodygyrojerkmagmean
68|fbodybodygyrojerkmagstd
