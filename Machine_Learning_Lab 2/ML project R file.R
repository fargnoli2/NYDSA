library(dplyr)
library(ggplot2)
library(ggthemes)
library(scales)
library(viridis)
library(RColorBrewer)
library(lubridate)

Orders=read.csv("/Users/fargnoli/Desktop/Machine_Learning_Lab 2/data/Orders.csv")
Returns=read.csv("/Users/fargnoli/Desktop/Machine_Learning_Lab 2/data/Returns.csv")

## 1.  Change data types to numeric


Orders$Sales = as.numeric(gsub("\\$", "", Orders$Sales))
Orders$Profit = as.numeric(gsub("\\$", "", Orders$Profit))
plot(Orders$Sales,Orders$Profit)


## 2 Inventory management - is there any seasonal trend?  Does the trend change per product category?

season<-Orders %>% select(.,Ship.Date,Segment,Country,Category,Sub.Category,Quantity) %>% filter(.,Quantity>7) %>% arrange(.,Ship.Date)
OcttoDec_orders=(3225-198)/3225
OcttoDec_orders

##93% of orders of stock 7 or more occur between October and December 
regular<-Orders %>% select(.,Ship.Date,Segment,Country,Category,Sub.Category,Quantity) %>% filter(.,Quantity>3) %>% arrange(.,Ship.Date)
holiday<-season[199:3225,]

holiday %>%   ggplot(aes(x="Prop",y=Quantity,fill=Category)) +
  geom_bar(width = 1,stat = "identity")+
  theme(plot.title = element_text(size=22)
  ) +
  ggtitle("SALES TREND PER CATEGORY: HOLIDAY SEASON") +theme(axis.text = element_text(size = 18))

regular %>%   ggplot(aes(x="Prop",y=Quantity,fill=Category)) +
  geom_bar(width = 1,stat = "identity")+
  theme(plot.title = element_text(size=22)
  ) +
  ggtitle("SALES TREND PER CATEGORY: WINTER/SPRING/SUMMER SEASON") +theme(axis.text = element_text(size = 18))

## There was no difference in distribution of % of sales roughly in each category.  

#### How much profit wsas lost due to returns

sum(Loss$Profit,na.rm = TRUE)
#$58,453.80

## Plots for returns
tworeturns<-Loss %>% select(.,Customer.Name) %>% count(Customer.Name) %>% filter(.,n>1)

## 2 Returns - 2075

sum(tworeturns$n) 

## 5 Returns - 1050 

fivereturns<-Loss %>% select(.,Customer.Name) %>% count(Customer.Name) %>% filter(.,n>5)

## Regions more likely to return orders

Loss %>%   ggplot(aes(x="Prop",y=Quantity,fill=Region.x)) +
  geom_bar(width = 1,stat = "identity")+
  theme(plot.title = element_text(size=22)
  ) +
  ggtitle("RETURNS BY REGIONS") +theme(axis.text = element_text(size = 18))

## The west coast of USA and wetern Europe as well as Canada return the most
Loss=inner_join(Returns,Orders,by="Order.ID")
prop.table(table(Loss$Category))

## Office supplies are more likely to be returned..
Loss %>%   ggplot(aes(x="Prop",y=Quantity,fill=Category)) +
  geom_bar(width = 1,stat = "identity")+
  theme(plot.title = element_text(size=22)
  ) +
  ggtitle("RETURNS BY REGIONS") +theme(axis.text = element_text(size = 18))


## MACHINE LEARNING EXERCISES

Main<-Orders %>% mutate(.,Return=ifelse(Order.ID %in% Loss$Order.ID,1,0))

abis<-strptime(Main$Ship.Date,format="%m/%d/%y") #defining what is the original format of your date
Main$Ship.Date<-as.Date(abis,format="%m-%d-%y")
abis2<-strptime(Main$Order.Date,format="%m/%d/%y")
Main$Order.Date<-as.Date(abis2,format="%m-%d-%y")


Main<-Main %>% mutate(.,Process.Time=difftime(Ship.Date,Order.Date,units = 'days'))


Main2<-Main %>% group_by(Product.ID) %>% mutate("Count"=ave(Product.ID=Product.ID,Return,FUN=cumsum))

## MACHINE LEARNING CLASSIFICATION MODELS

input<-Main2 %>% select(.,Process.Time,Region,Customer.Name,Segment,Product.ID,Category,Sub.Category,Sales,Quantity,Discount,Profit,Order.Priority,Return,Count)
as.data.frame(input)
write.csv(input,"/Users/fargnoli/Desktop/Machine_Learning_Lab 2/MachineCL.csv", row.names = FALSE)
