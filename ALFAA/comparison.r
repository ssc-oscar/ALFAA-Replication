library(data.table)
library(dplyr)
library(magrittr)

#Matches Produced by Alfaa
alfaa = fread("/home/audris/alfaa.txt",sep=";",quote="",colClasses="character",header=F, strip.white=F)

#Matches produced by Bogdan Vasilescu's algorithm
tweaked1 = fread("/home/audris/tweaked1.txt",sep=";",quote="",colClasses="character",header=F, strip.white=F)

colnames(alfaa) = c("id","match")
colnames(tweaked1) = c("id","match")

#Identify self-matched IDs
alfaa <- alfaa %>% mutate(is_same = (id==match))
tweaked1 <- tweaked1 %>% mutate(is_same = (id==match))

#Find the unique IDs in ALFAA and Tweaked1
unique_id_alfaa <- union(alfaa$id,alfaa$match)
unique_id_tweaked <- union(tweaked1$id,tweaked1$match)

#Subset the matches in from ALFAA in Tweaked1
common <- tweaked1 %>% filter(id %in% unique_id_alfaa)
common <- common  %>% filter(match %in% unique_id_alfaa)

unique_id_common <- union(common$id,common$match)

alfaa <- alfaa %>% mutate(pairs = paste0(id,';',match))
tweaked1<- tweaked1 %>% mutate(pairs = paste0(id,';',match))

#Find pairs matched by BV's algorithm that were not matched by ALFAA
#common_pair_tweaked <- tweaked1 %>% filter(pairs %in% alfaa$pairs)
not_common_tweaked <- tweaked1 %>% filter(!(pairs %in% alfaa$pairs))
not_common_not_same_tweaked <- not_common_tweaked %>% filter(is_same==FALSE)
print(paste("Number of observations matched by BV and not ALFAA:",nrow(not_common_not_same_tweaked)))

#Sample 500 observations from the above set
sample_500_tweaked <- sample_n(not_common_not_same_tweaked,500,replace=FALSE)
print ("Extracted 500 Samples from matches produced BV's algorithm but not ALFAA")
fwrite(sample_500_tweaked, file="sample_tweaked1_not_alfaa_500.csv")

#Find out how many of the samples have a differnt email address
sample_500_tweaked$e=sub(".*<","",sample_500_tweaked$id)
sample_500_tweaked$e=sub(">.*","",sample_500_tweaked$e)
sample_500_tweaked$e_match=sub(".*<","",sample_500_tweaked$match)
sample_500_tweaked$e_match=sub(">.*","",sample_500_tweaked$e_match)
sample_500_tweaked$email_match = (sample_500_tweaked$e == sample_500_tweaked$e_match)
eNotSame <- nrow(sample_500_tweaked %>% filter(email_match == FALSE))
print (paste("Number of email not matched in TWEAKED sample:",eNotSame))

#Find pairs matched by ALFAA that are not in tweaked
not_common_alfaa <- alfaa %>% filter(!(pairs %in% tweaked1$pairs))
not_common_not_same_alfaa <- not_common_alfaa %>% filter(is_same==FALSE)
print (paste("Number of observations matched by ALFAA and not BV:", nrow(not_common_not_same_alfaa)))

#Sample 500 observations from the above set
sample_500_alfaa <- sample_n(not_common_not_same_alfaa, 500, replace = FALSE)       
print ("Extracted 500 Samples from matches produced by ALFAA but not in BV's algorithm")
fwrite(sample_500_alfaa, file="sample_alfaa_not_tweaked1_500.csv")

#Find out how many of the samples have a differnt email address
sample_500_alfaa$e=sub(".*<","",sample_500_alfaa$id)
sample_500_alfaa$e=sub(">.*","",sample_500_alfaa$e)
sample_500_alfaa$e_match=sub(".*<","",sample_500_alfaa$match)
sample_500_alfaa$e_match=sub(">.*","",sample_500_alfaa$e_match)
sample_500_alfaa$email_match = (sample_500_alfaa$e == sample_500_alfaa$e_match)
eNotSame <- nrow(sample_500_alfaa %>% filter(email_match == FALSE))
print (paste("Number of email not matched in ALFAA sample:",eNotSame))

#create unbiased sample
full_sample <- rbind(sample_500_tweaked,sample_500_alfaa)
sample1 <- sample_n(full_sample, 500, replace = FALSE)
sample1 <- sample1 %>% select(-pairs, -e,-e_match,-is_same)
fwrite(sample1, file="sample1.csv")
sample2 <- anti_join(full_sample,sample1)
sample2 <- sample2 %>% select(-pairs, -e,-e_match,-is_same)
fwrite(sample2, file="sample2.csv")
