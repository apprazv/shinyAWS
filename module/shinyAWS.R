awsUI <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(actionBttn("upload_aws" %>% ns,"Upload Button",icon = icon("aws")))
    )
}

awsServer <- function(id,rv) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- NS(id)
      observeEvent(input$upload_aws,{
        
        showModal(modalDialog(size = "l",
                              title = "Upload a CSV file to put into an S3 Bucket",
                              textInput(ns("csv_name"),"Name the CSV you want in the AWS S3 Bucket"),
                              fileInput("file1", "Choose CSV File",
                                        multiple = TRUE,
                                        accept = c("text/csv",
                                                   "text/comma-separated-values,text/plain",
                                                   ".csv")),
                              
                              output$upload_csv <- renderDT({
                                req(input$file1)
                                rv$upload <- read.csv(input$file1$datapath)
                                DT::datatable(rv$upload,options = list(scrollX = TRUE),rownames = FALSE)}),
                              actionButton(ns("upload_csv"),"Upload CSV to S3 Bucket")
        ))
      })
      observeEvent(input$upload_csv,{
        temp_def <- rv$upload
        s3save(temp_def, bucket = psu_bucket, object = paste0(rv$uid,"*UploadCourse*",input$csv_name,".csv"))
        shinyalert("Success","We have uploaded your course",timer = 4000)
        removeModal()
      })
    })
}