setwd("~/Desktop/Math/Programming Methods/chicago")

#libraries
library(data.table) #fread
library(dplyr) #ranking frequency
## 
## Attaching package: 'dplyr'
## The following objects are masked from 'package:data.table':
## 
##     between, first, last
## The following objects are masked from 'package:stats':
## 
##     filter, lag
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
library(grDevices) #png function
library(wordcloud) #wordcloud
## Loading required package: RColorBrewer
library(RColorBrewer) #brewer colors

#read in data table
chi_dat = fread("chicago_6mos_google_communities.csv")

#convert to data table
chi_dat = as.data.table(chi_dat)

#table of total incidents by community
#filter places outside of chicago communities
chi_tab = chi_dat[community!=""]
chi_tab2 = chi_tab[,.N, by=community]

#70 communities with gun violence incidents, ranked
chi_table1 = chi_tab2[order(-N)] %>% head(70) %>% rename("Incidents" = N, "Community" = "community")

#wordcloud
png("wordcloud.png", width=12,height=8, units='in', res=300)
par(mar = rep(0, 4))
set.seed(1337)
wordcloud(words = chi_table1$Community, freq = chi_table1$Incidents,scale=c(3.5,0.25),
          max.words=70, colors=brewer.pal(8, "Dark2"))