library(dplyr)

OP<-read.csv(file="OpDeaths.csv")

OP %>% filter(.,Year>2010,Year<2015)

OP2<-OP %>% mutate(.,Pharmacy_Fills=`Prescriptions Filled (Mil)`*1000000) %>% 
  select(.,State, Year, Deaths,Population,Pharmacy_Fills) %>% 
  mutate(.,PPP=Pharmacy_Fills/Population) 

PF<-read.csv(file="Prescriptions.csv")
PF<-select(PF,1:7)

PF<-PF %>% slice(2:5)
PF

PF<-filter(PF,Year>2019)

df2 <- data.frame(Year=rep(c("2011", "2012","2013","2014"), each=6),
                  Drug=rep(c("Hydrocodone", "Oxycodone", "Tramadol","Morphine","Fentanyl","Other"),4),
                  Filled=c(130931704 , 55814709, 33017002,  7782180,  5151194, 25255123,130755781,  55000827, 37768970,  8061525,  5068183, 23878175,123656888,  53101127, 39826732,  8173534 , 5023666, 22052478,113432547  ,54043581 ,41713372  ,8284442  ,4983214 ,22086043 ))



ggplot(data=df2, aes(x=Year, y=Filled, fill=Drug)) +
  geom_bar(stat="identity")

#Static chart showing drug distriburtion per year, visualize % change
ggplot(data=df2, aes(x=Drug, y=Filled, fill=Year)) +
  geom_bar(stat="identity", position = "dodge")


#Select by year the PPP statistic and its change per state via drop down
ggplot(data=OP2, aes(x=State, y=PPP, fill=Year)) +
  geom_bar(stat="identity")+theme(axis.text.x = element_text(angle = 90, hjust = 1))

#USA map overlay of average death between 2010-2014

MAP<-Dead %>% group_by(.,State) %>% 
summarise(.,Death_Total=sum(Deaths),Period_Avg=sum(Deaths)/54238*100)

ggplot(data=MAP, aes(x=State, y=Death_Total)) +
  geom_bar(stat="identity", position = "dodge")+theme(axis.text.x = element_text(angle = 90, hjust = 1))
            
ggplot(data=MAP, aes(x=State, y=Perc_Total_USA)) +
  geom_bar(stat="identity", position = "dodge")+theme(axis.text.x = element_text(angle = 90, hjust = 1))


        


