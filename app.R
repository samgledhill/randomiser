#
# This is a Shiny web application built to do the following:
#    1. Allow a user ti upload an Excel sheet
#    2. Specify the number of rows to ignore
#    3. Specify the number of samples to pull
#    4. Return a random sample of n rows of the total file
#


library(shiny)
library(readxl)

# Define UI for application
ui <- fluidPage(

    # Application title
    titlePanel("Movember Randomisator Machine"),

    # Sidebar with file upload, ignore_rows and n_samples inputs 
    sidebarLayout(
        sidebarPanel(
            fileInput("file1", "Choose XLSX File",
                      multiple = FALSE,
                      accept = c("application/excel",
                                 ".xlsx")),
            
            numericInput(inputId = "sheet_number",
                      label = "Choose sheet to import",
                      value = 1),
            
            numericInput(inputId = "num_samples",
                         label = "Choose number of samples",
                         value = 5)
        ),

        # Show a plot of the generated distribution
        mainPanel(
 ##           DT::dataTableOutput('contents'),
            
            tableOutput('sample_list'),
            
            textOutput("num_rows")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    myData <<- reactive({
        inFile <- input$file1
        if (is.null(inFile)) return(NULL)
        data <- read_excel(inFile$datapath, 
                           sheet = as.numeric(input$sheet_number),
                           col_names = "Applicant")
        data
    })
    
    output$contents <- DT::renderDataTable({
        DT::datatable(myData())       
    })
    
    output$sample_list <- renderTable(
        
        myData()[sample(1:nrow(myData()), input$num_samples),]
        
    )
    


}

# Run the application 
shinyApp(ui = ui, server = server)
