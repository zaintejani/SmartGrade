## Server.R File aka HelluvanEngine.R

library(shiny);library(ggplot2)

## Source data, relevant functions
load("./Grade_data/final.RData")

## Correct classes for columns
all[,2]<-as.numeric(all[,2])
all[,3:4]<-apply(all[,3:4],2,function(x) as.character(x))

f1<-as.data.frame(table(all$Field));f1<-f1[order(f1$Freq, decreasing=TRUE),]f1$Var1<-as.character(f1$Var1)

shinyServer(
  function(input, output){
    
  }
)