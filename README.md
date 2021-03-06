
# ALFAA replication package

This repository contains data and codes for the prototype based on the framework ALFAA (Active Learning Fingerprint-based Anti Aliasing) to correct developer identity errors in version control data. The details of this framework can be found at https://arxiv.org/abs/1901.03363

### Key Pieces of Data

* clean version of best data (golden dataset) used for training

* full data on OS developers
  - d2v data
  - tz data
  - file similarity

* full data on developers in nine OSS ecosystems (Chris) 
  - files similarity
  - tz ?
  - d2v ?

### Code  

The code to produce the models on golden dataset

* skinny model (no fps)
* full model  (three fps)

The utility codes

* code for transitive closure

* code to match developers that someone provides an input (skinny model)

### Models

* skinny

* full (three fps)

 
###Training the model
  Currently, the model being used compares 2345 authors against each other to generate a table of 5,499,025 rows that holds comparison data ranging between 0-1 for the following attributes: name, email, first name, last name, username, and “is match”. The “is match” attribute is used to label a comparison between two authors as being the same author or not (1 if they are the same, 0 otherwise). The data imported to the model currently has various other attributes but have not been enabled to be used yet.
	To generate this comparison data for new authors to be added into the training / validation data, the compare.linkage function in R is used. This function builds comparison patterns of record pairs for deduplication or linkage. If an author has author names it selected as being theirs, and others they selected as not being theirs, this data needs to be recorded and will be used after the compare.linkage function is run (will be used for the “is_match” attribute). For this model, the input data follows the format: cluster number; name; email; is_match for the current cluster (current individual).
	Once the author data has been loaded into a table in R, the compare.linkage function can be run by passing the table into the function as the first two parameter, making the authors be compared against each other, and setting the string comparison function to be jarowinkler. Make sure the comparison function ignores the author id number, only string attributes should be considered in this comparison. See the model reference at the bottom, lines 106-108 as an example.
	Once the comparison function is finished, the last attribute needed is the “is_match” attribute to mark the comparisons between authors that were the same person. The data that was imported in that had the cluster number and a column for saying whether the current row is selected as being the author of the cluster will be used to generate the is_match column. To do this, you can loop through each row in the comparison data and look at the two authors being compared. Between the two authors, if their cluster id’s do not match, then the “is_match” value for that row will be 0. If they do match, then if the author of the cluster selected both the authors being used in the current comparison as being them, then the “is_match” is set to 1, otherwise if one of the authors in the comparison is not selected as being the author of the cluster, the “is_match” is 0.
	Once the “is_match” column has been filled, the model can be trained and validated. The program first separates the comparison data into two sets: a set that holds matched authors, and a set that holds un-matched authors. To do this, all rows in the comparison data where the “is_mach” value is a 1 are used for the most likely matched set, and for the most likely unmatched set, it looks across other attributes in the rows that do not have an “is_match” of 1, and if any of the attributes checked contain a value greater than 0.8, it is excluded. Once these two sets have been created, random samples are taken from both that contain the row index values of the selected entries. Then the training and validation sets are generated by using the selected index values and indexing into the comparison data to get the attributes of each row. Then the random forest model is trained and validated for performance. 

model reference: https://github.com/ssc-oscar/fingerprinting/blob/master/basicModel.r


###Running the model
	For running the model, the following libraries will be needed: randomForest, and RecordLinkage. Once these libraries have been installed, the program will be able to run.
	The R program first opens the RData file containing the data of the random forest model, then proceeds to open the testing data. The testing data follows the following format per line: cluster number; name; email; author. Once the data has been parsed into a table, additional columns are created that append into that same table that will be used by the model, see lines 89-99 for the additional attributes that are computed. Then the program will use compare.linkage with the testing data compared against itself, to generate the comparison pairs values using the jarowwinkler string comparison, see line 106 for an example. Once the pairs data has been calculated, the model will cluster authors based on its predictions. All authors outside of the clusters are separated into connected subsets, see lines 124-142. The subset connections comes from the creation of a graph for each cluster and the mapping is used to find authors who are potentially linked together by association with another author, basically it finds authors who aren’t directly linked as being the same person, but they could both be linked to a separate individual. Ex: if a-> c and b->c, then a->b.

model reference: https://github.com/ssc-oscar/fingerprinting/blob/master/basicModel.r


