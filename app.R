source("global.R")
source("module/shinySQL.R")

## Basic App ##
ui <- fluidPage(sqlUI("aws_ns"))
server <- function(input,output,session){
  rv <- reactiveValues()
  awsServer("aws_ns",rv)
}
app <- shinyApp(ui,server)
app %>% runApp() #%>% secure_app()
