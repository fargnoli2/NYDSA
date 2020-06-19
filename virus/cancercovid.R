library(dplyr)
library(ggplot2)
library(ggthemes)
library(scales)
library(RColorBrewer)

setwd("/Users/fargnoli/Desktop/virus")
df=read.csv(file = 'coronovirus_stats.csv')
df<-df[!(is.na(df$country) | df$country=="" |df$population==""|df$deaths==""), ]
cols<-c(1,3,4,5,6,7,8)
df[cols]<-lapply(df[cols],as.character)
df$deaths=(gsub(",","",df$deaths))
df$deaths_per_mil=(gsub(",","",df$deaths_per_mil))
df$population=(gsub(",","",df$population))
df$serious=(gsub(",","",df$serious))
df$test_per_mil=(gsub(",","",df$test_per_mil))
df$tests=(gsub(",","",df$tests))
df$total=(gsub(",","",df$total))
df[cols]<-lapply(df[cols],as.numeric)

## Compute death rate per population incluidng only countries with testing and >5000 deaths including Sweden
r<-runif(16, min=0.28, max=0.42)
rate<-df %>% select(.,country,deaths,total,population) %>% filter(.,deaths>5000) %>% mutate(.,Perc_death_pop=deaths/population*100,Perc_death_case=deaths/total*100,True_denominator=population*0.8*r,True_death_rate=deaths/True_denominator*100,Perc_Risk_Healthy=(deaths*0.55)/True_denominator*100)

## Breast, Cervical, and Colon Cancer risk

breast_t=276000 ##Source Susan Komen Foundation for Breast Cancer
breast_deaths=42710
diag_rate=276000/89000000*100

cerv_t=13800 ## Sourve from cancer.org and Pubmed, 65% of female population eligible for exams is 89,000,000 women
cerv_deaths=4290
diag_rate_cerv=13800/89000000*100

colon_t=52270+17380 # Cancer.net Colorectal cancer rates in women
colo_deaths=24570
diag_rate_colorectal=69650/89000000*100

cancer_diag=breast_t+cerv_t+colon_t
cancer_rate=cancer_diag/89000000*100

## Pie chart of women death

## From screenings.org, papers show lives saved from mammogram 18,864, Colon: 16,000 ; cervical 5,520

lives_saved=sum(18864,16000,5520)

color_count=length(unique(rate$country))
getpalette= colorRampPalette(brewer.pal(9,"Set1"))

p<-rate %>% ggplot(aes(x=country, y=Perc_death_case, fill=getpalette(color_count))) +
  geom_bar(stat = "identity")+
  theme(
    legend.position="upperleft",
    plot.title = element_text(size=22)
  ) +
  ggtitle("% COVID19 Deaths Per Confirmed Case") +theme(axis.text = element_text(size = 12))

p+theme(axis.text.x=element_text(angle = 90,vjust=0.5,hjust=1))


q<-rate %>% ggplot(aes(x=country, y=True_death_rate, fill=getpalette(color_count))) +
  geom_bar(stat = "identity")+
  theme(
    legend.position="upperleft",
    plot.title = element_text(size=22)
  ) +
  ggtitle("% COVID19 Deaths Adjusted for Asymptomatics Real Denominator") +theme(axis.text = element_text(size = 12))

q+theme(axis.text.x=element_text(angle = 90,vjust=0.5,hjust=1))

h<-rate %>% ggplot(aes(x=country, y=Perc_Risk_Healthy, fill=getpalette(color_count))) +
  geom_bar(stat = "identity")+
  theme(
    legend.position="upperleft",
    plot.title = element_text(size=16)
  ) +
  ggtitle("% Death Risk Adjusted for: Female & <65 yrs/Non Nursing Home/LTC Facility") +theme(axis.text = element_text(size = 12))

h+theme(axis.text.x=element_text(angle = 90,vjust=0.5,hjust=1))

## Preventable Cancer deaths
library(treemap)

# Create data
group <- c("COVID19","Breast","Colon","Cervical")
value <- c(21234,breast_deaths,colo_deaths,cerv_deaths)
data <- data.frame(group,value)

# treemap
treemap(data,
        index="group",
        vSize="value",
        type="index"
)

library(tidyverse)

# Create data
data <- data.frame(
  x=group,
  y=c(17000,breast_t,colon_t,cerv_t)
)

# plot
ggplot(data, aes(x=x, y=y)) +
  geom_segment( aes(x=x, xend=x, y=0, yend=y)) +
  geom_point( size=5, color="red", fill=alpha("orange", 0.3), alpha=0.7, shape=21, stroke=2)+ggtitle("Diagnosis Rates for 2020")

#2nd treemap with no screening, best available models predict COVID19 death rate of women without co morbidity to be <25,000
# Non compliance with routine early detection increases breast cancer deaths approx 2.5 fold, colorectial 3.5 fold, cervical 2 fold
                                                                                                                                                                                                                                                                           
group <- c("COVID19","Breast","Colon","Cervical")
value <- c(21234,breast_deaths*2.48,colo_deaths*3.58,cerv_deaths*2)
data <- data.frame(group,value)
                                                                                                                                       
                                                                                                                    
treemap(data,index="group",
        vSize="value",
        type="index"
)


#Final statistic for death rate risks

perc_risk=c(cancer_rate,0.057914)
group2<-c("Cancer (Diag)","COVID19")
data2 <- data.frame(group2,perc_risk)

ggplot(data2,aes(x=group2, y=perc_risk, fill=group2)) +
  geom_bar(stat = "identity")+ggtitle("Cancer vs. COVID19 Risk")

## Without screening risk of cancer deaths increase 


