library(shiny)
library(dplyr)
library(ggplot2)
library(googleVis)
library(leaflet)


function(input, output) { 
  
  df3<-reactive({
  df2 %>% filter(Year==input$YEAR)
  })
  df4<-reactive({
    df2 %>% filter(Drug==input$DRUG)
  })  
  
  df5<-reactive({
    OP2 %>% filter(State==input$STATE)
  })
 
  output$main <- renderPlot(
    ggplot(data=Deaths, aes(x=State, y=Death_Total)) +
      geom_bar(stat="identity")+theme(axis.text.x = element_text(angle=90))+ggtitle("Opioid Crisis In USA: 2011-2014 Deaths")
  )
  
  output$test <- renderPlot(
    ggplot(data=df3(), aes(x=Drug, y=Filled, fill=Drug)) +
      geom_bar(stat="identity", position = "dodge")+theme_economist()+ggtitle("Opioid Prescription Distrubtion: Drug Type"))

  output$test1 <- renderPlot(
    ggplot(data=df4(), aes(x=Year, y=Filled, fill=Year)) +
      geom_bar(stat="identity", position = "dodge")+theme_economist()+ggtitle("Opioid Type:Prescription Trend")
  )
  output$test2 <- renderPlot(
    ggplot(data=df5(), aes(x=Year, y=Deaths,fill=Year)) +
      geom_bar(stat="identity", position = "dodge")+theme_economist()+ggtitle("Deaths Per Year By State")
  )
  output$test3 <- renderPlot(
    ggplot(data=df5(), aes(x=Year, y=PPP, fill=Year)) +
      geom_bar(stat="identity", position = "dodge")+theme_economist()+ggtitle("Scripts Filled Per Person By State")
  )
  
}

