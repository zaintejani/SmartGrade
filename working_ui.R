## SmartGrade: UI.R

library(shiny)


shinyUI(fluidPage(
  titlePanel("Professor Comparator 9001"),
  
  sidebarLayout(
    sidebarPanel(
      h3("Select Field and Professors"),
      
      p("Use the tools below to compare professors teaching the same course"),
      
      selectInput(inputId="level", label="Level of Study", choices=c("Undergraduate","Graduate"), selected="Undergraduate"),
      
      selectInput(inputId="field", label="Field of Study", choices=f1$Var1),
      
      uiOutput("course1"),
      
      uiOutput("p1"),
      
      uiOutput("p2"),
      
      checkboxGroupInput(inputId="semChoice", label="Semesters Selected",
                         choices=c("Fall","Spring","Summer"), selected=c("Fall","Spring","Summer")),
      
      sliderInput(inputId="yearChoice", label="Years Selected", min=min(all$Term.Yr),
                  max=max(all$Term.Yr), value=c(min(all$Term.Yr), max(all$Term.Yr)), rounding=TRUE),
      
      checkboxGroupInput(inputId="sizeFilter", label="Class Size",
                         choices=levels(as.factor(all$Class.Size)), selected=levels(as.factor(all$Class.Size))),
      
      radioButtons(inputId="plotType", label="Plot Type",
                   choices=list("Prof 1 aggregate weighted grades"=1,"Prof 2 aggregate weighted grades"=2,
                             "Prof 1 average GPA over time"=3,"Prof 2 average GPA over time"=4,
                             "Head-to-head aggregate weighted grades"=5,"Head-to-head average GPA over time"=6))
      
    )
    
  )
  
))