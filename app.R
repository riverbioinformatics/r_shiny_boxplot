# Load required libraries
library(shiny)
library(ggplot2)
library(readr)


user_base <- tibble::tibble(
  user = c("user1"),
  password = c("pass1"),
  permissions = c("admin"),
  name = c("River Computing")
)

# Define UI
ui <- fluidPage(
  div(class = "pull-right", shinyauthr::logoutUI(id = "logout")),
  shinyauthr::loginUI(id = "login"),
  titlePanel("Interactive ggplot2 Visualization"),

  sidebarLayout(
    sidebarPanel(
      fileInput("file1", "Choose CSV File",
                accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")
      ),
      selectInput("x_var", "X-axis variable:", choices = names(iris)),
      selectInput("y_var", "Y-axis variable:", choices = names(iris)[-1], selected = "Sepal.Length"),
      actionButton("plotButton", "Plot")
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  credentials <- shinyauthr::loginServer(
    id = "login",
    data = user_base,
    user_col = user,
    pwd_col = password,
    log_out = reactive(logout_init())
  )

  # call the logout module with reactive trigger to hide/show
  logout_init <- shinyauthr::logoutServer(
    id = "logout",
    active = reactive(credentials()$user_auth)
  )

  # Reactive expression to read the uploaded file
  datasetInput <- reactive({
    req(credentials()$user_auth)
    req(input$file1)
    inFile <- input$file1
    
    # Read the data from the uploaded file
    read_csv(inFile$datapath)
  })
  
  # Reactive expression to return the dataset
  data <- reactive({
    req(credentials()$user_auth)
    if (is.null(input$file1)) {
      iris
    } else {
      datasetInput()
    }
  })
  
  # Update selectInput choices based on uploaded dataset
  observe({
    if (!is.null(input$file1)) {
      updateSelectInput(session, "x_var", choices = names(data()))
      updateSelectInput(session, "y_var", choices = names(data()))
    }
  })
  
  # Render plot based on user inputs
  output$plot <- renderPlot({
    req(credentials()$user_auth)
    req(input$x_var, input$y_var)
    req(credentials()$user_auth)
    ggplot(data(), aes_string(x = input$x_var, y = input$y_var)) +
      geom_boxplot() +
      theme_minimal() +
      labs(title = "Boxplot", x = input$x_var, y = input$y_var)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
