#Productivity calculation of DRE users

library(data.table)
library(magrittr)
library(dplyr)

options(width=150)

sample1 = fread("DREUser.csv",sep=",",header=T, strip.white=F)
s = sample1 %>% group_by(dre_id,woc_id) %>% count()
s1 <- s %>% group_by(dre_id) %>% count() %>% as.data.frame()

sample2 <- sample1 %>% group_by(dre_id) %>% mutate(minTime = min(time))
sample2 <- sample2 %>% group_by(dre_id) %>% mutate(maxTime = max(time))
sample2$timeDiff <- sample2$maxTime - sample2$minTime

s3 <- sample2 %>% group_by(dre_id,timeDiff) %>% count() %>% as.data.frame()
s3 <- s3[s3$n>=20,]
s3$Prod <- s3$n/s3$timeDiff * (3600 * 24 * 365.25)

s4 <- sample2 %>% group_by(dre_id,timeDiff,woc_id) %>% count() %>% as.data.frame()
s4$Prod <- (s4$n/s4$timeDiff) * (3600 * 24 * 365.25)
Minprod = tapply(s4$Prod,as.character(s4$dre_id),min)
Maxprod = tapply(s4$Prod,as.character(s4$dre_id),max)
s3$mprod = Minprod[match(s3$dre_id,names(Minprod),nomatch=0)]
s3$maxprod = Maxprod[match(s3$dre_id,names(Maxprod),nomatch=0)]

x <- inner_join(s3, s1, by=c("dre_id"="dre_id"))
x$pctChngMax = ((x$Prod / x$maxprod)-1) * 100
x$pctChngMin = ((x$Prod / x$mprod)-1) * 100

print(x)
