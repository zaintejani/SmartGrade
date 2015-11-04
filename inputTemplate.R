## LETS BULID IT, BABY!

## Assume data structures present: UG. Add column: Field (ME, CS, AE, etc.)

w<-UG[UG$Field==input$Field,]
w<-w[w$Course==input$Course,]
w<-w[w$Name==input$Name,]
w<-w[w$Year==input$Year,]
w<-w[w$Term==input$Term,]

## insert plots with w as the main df from which to pull data.

## investigate "in" instead of "==" for multi-select variables.