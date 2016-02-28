## SmartGrade: UI.R

library(shiny)


shinyUI(fluidPage(
  titlePanel("Professor Comparator 9001"),
  
  sidebarLayout(
    sidebarPanel(
      h3("Select Field and Professors"),
      
      p("Use the tools below to compare porfessors teaching the same course"),
      
      selectInput(inputId="level", label="Level of Study", choices=c("Undergraduate","Graduate"), selected="Undergraduate"),
      
      selectInput(inputId="field", label="Field of Study", choices=f1$Var1),
      
      selectInput(inputId="course", label="Course", choices=),
      
      selectInput(inputId="prof1", label="Professor 1", choices=),
      
      selectInput(inputId="prof2", label="Professor 2", choices=),
      
      checkboxGroupInput(inputId="semChoice", label="Semesters Selected",
                         choices=c("Fall","Spring","Summer"), selected=c("Fall","Spring","Summer")),
      
      sliderInput(inputId="yearChoice", label="Years Selected", min=min(all$Term.Yr),
                  max=max(all$Term.Yr), value=c(min(all$Term.Yr), max(all$Term.Yr)), rounding=TRUE),
      
      checkboxGroupInput(inputId="sizeFilter", label="Class Size",
                         choices=levels(as.factor(all$Class.Size)), selected=levels(as.factor(all$Class.Size)))
      
      radioButtons(inputId="plotType", label="Plot Type",
                   choices=c("Head-to-head aggregate weighted grades","Head-to-head average GPA over time"))
      
    )
    
  )
  
))