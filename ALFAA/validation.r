#Validation of ALFAA vs Recent

library(data.table)
library(magrittr)
library(dplyr)

#Rater Info
#sample1 :
#sample2 : 
#rater1   : 

sample1 = fread("sample1.csv",sep=",",header=T, strip.white=F)
sample2 = fread("sample2.csv",sep=",",header=T, strip.white=F)
sample_alfaa = fread("sample_alfaa_not_tweaked1_500.csv",sep=",",header=T, strip.white=F)
sample_tweaked = fread("sample_tweaked1_not_alfaa_500.csv",sep=",",header=T, strip.white=F)
rater1 = fread("full_sample_rarer1.csv",sep=",",header=T, strip.white=F)

full = rbind(sample1,sample2)

table(sample1$score)
table(sample2$score)

table(rater1$score)
#  0 0.5   1 
#109 106 784 

table(full$score)
# 0 0.5   1 
#162 388 450 

full$pair = paste(full$id,':',full$match)
rater1$pair = paste(rater1$id,':',rater1$match)
sample_alfaa$pair = paste(sample_alfaa$id,':',sample_alfaa$match)
sample_tweaked$pair = paste(sample_tweaked$id,':',sample_tweaked$match)


#Validation from UTK
#-------------------

a <- inner_join(sample_alfaa,full,by=c("pair" = "pair"))
sample_alfaa[match(sample_alfaa$pair, full$pair, nomatch=0)==0,]
#4 not found (1,0.5,0.5,1)
table(a$score) 
#adjusted
# 0 0.5   1 
#43 295 162
# 8.6% were False Positives - wrongly matched by ALFAA
# 32.4% was True Positives - correctly matched by ALFAA

t <- inner_join(sample_tweaked,full,by=c("pair" = "pair"))
sample_tweaked[match(sample_tweaked$pair, full$pair, nomatch=0)==0,]
#21 not found(1,1,1,1,1,1,1,1,0,1,1,0,0.5,1,1,1,0,0.5,1,1,1)
table(t$score)
#adjusted
#  0 0.5   1 
#119  93 288 
# 23.8% was False Positive - wrongly matched by Recent
# 57.6% was True Positive - correctly matched by Recent


#Validation from rater1
#---------------------

a_rater1 <- inner_join(sample_alfaa,rater1,by=c("pair" = "pair"))
sample_alfaa[match(sample_alfaa$pair, rater1$pair, nomatch=0)==0,]
#5 not found(1,1,1,1,1)
table(a_rater1$score)
#adjusted
# 0 0.5   1 
#13  42 444 
# 2.6% was False Positive - wrongly matched by ALFAA
# 88.8% was True Positive - correctly matched by ALFAA
#include bounds here

t_rater1 <- inner_join(sample_tweaked,rater1,by=c("pair" = "pair"))
sample_tweaked[match(sample_tweaked$pair, rater1$pair, nomatch=0)==0,]
#14 not found (1,1,1,0.5,1,0,1,1,1,1,0,1,1,1)
table(t_rater1$score)
#adjusted
# 0 0.5   1 
#96  63 341 
# 19.6% was False Positive - wrongly matched by Recent
# 68.2% was True Positive - correctly matched by Recent

#========================================================================
#Deduction: 
#UTK : Recent has 2.76 (23.8/8.6) times greater lumping error than ALFAA
#rater1: Recent has 7.53 (19.6/2.6) time greater lumping error than ALFAA
#========================================================================
#

#Comparison between Rater Groups

table(rater1$score_rater1,full$score)

#      0 0.5   1
#0    15  39  55
#0.5  15  43  48
#1   132 306 346
