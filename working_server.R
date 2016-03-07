## Server.R File aka HelluvanEngine.R

library(shiny);library(ggplot2)

## Source data, relevant functions
load("./Grade_data/final.RData")

## Correct classes for columns
all[,2]<-as.numeric(all[,2])
all[,3:4]<-apply(all[,3:4],2,function(x) as.character(x))

f1<-as.data.frame(table(all$Field));f1$Var1<-as.character(f1$Var1)
## f1<-f1[order(f1$Freq, decreasing=TRUE),]

shinyServer(
  function(input, output){
    
    c1<-reactive(levels(as.factor(all[all$Field==input$field,6])))
    
    output$course1 <- renderUI({
      selectInput(inputId="course", label="Course", choices=c1())
    })
    
    pr1<-reactive({
      levels(as.factor(all[all$Field==input$field && all$Course==input$course,all$Name]))
    })
    
    output$p1<-renderUI({
      selectInput(inputId="prof1", label="Professor 1", choices=pr1())
    })
    
    pr2<-reactive(pr1()[pr1()!=input$prof1])
    
    output$p2<-renderUI({
      selectInput(inputId="prof2", label="Professor 2", choices=pr2())
    })
    
    plotDF<-reactive({
      all[all$Level==input$level & all$Field==input$field & all$Course==input$course & all$Name %in% c(input$prof1,input$prof2) & all$Semester %in% input$semChoice & all$Term.Yr %in% input$yearChoice & all$Class.Size %in% input$sizeFilter,]
    })
    
    ## insert if statement for plot type here
    
  }
)