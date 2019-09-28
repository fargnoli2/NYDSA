library(shiny)
library(dplyr)
library(ggthemes)
library(ggplot2)

df2 <- data.frame(Year=rep(c("2011", "2012","2013","2014"), each=6),
                  Drug=rep(c("Hydrocodone", "Oxycodone", "Tramadol","Morphine","Fentanyl","Other"),4),
                  Filled=c(130931704 , 55814709, 33017002,  7782180,  5151194, 25255123,130755781,  55000827, 37768970,  8061525,  5068183, 23878175,123656888,  53101127, 39826732,  8173534 , 5023666, 22052478,113432547  ,54043581 ,41713372  ,8284442  ,4983214 ,22086043 ))

Deaths<-OP2 %>% group_by(State) %>% 
  summarise(.,Death_Total=sum(Deaths))

fluidPage(
  titlePanel(""),
  sidebarLayout(
  sidebarPanel(
    selectizeInput(inputId = "YEAR",
                   label = "Single Year",
                   choices = unique(df2$Year)),
    selectizeInput(inputId = "DRUG",
                   label = "Opioid Class",
                   choices = unique(df2$Drug)),
    selectizeInput(inputId = "STATE",
                   label = "State Analysis",
                   choices = unique(OP2$State))
    ),
  mainPanel(
    fluidRow(
      column(8, plotOutput("main"))
    ),
    fluidRow(
      column(4, plotOutput("test")),
      column(4, plotOutput("test1"))
          ),
    fluidRow(
      column(4, plotOutput("test2")),
      column(4, plotOutput("test3"))
    )
    
    
      )
)
    )
    
    
      

## Width of app only 12 units.  Divide graphs between space.