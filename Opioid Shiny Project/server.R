library(shiny)
library(dplyr)
library(ggplot2)

function(input, output) { 
  output$test <- renderPlot(
    ggplot(data=df2, aes(x=Drug, y=Filled, fill=Year)) +
      geom_bar(stat="identity", position = "dodge")+theme_fivethirtyeight()
  
) 
}

