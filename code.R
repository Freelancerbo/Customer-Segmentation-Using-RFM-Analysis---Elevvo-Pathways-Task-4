# app.R
library(shiny)
library(plotly)
library(dplyr)

# ---------------------------
# Fake Dataset Generation
# ---------------------------
set.seed(42)
dates <- seq(as.Date("2023-01-01"), as.Date("2023-12-31"), by = "month")
stores <- c("Store A", "Store B", "Store C")
products <- c("Electronics", "Clothing", "Groceries")

data <- expand.grid(Date = dates, Store = stores, Product = products)
data$Sales <- sample(1000:5000, nrow(data), replace = TRUE)

# ---------------------------
# UI Layout
# ---------------------------
ui <- fluidPage(
  titlePanel("📊 Interactive Sales Dashboard (R Shiny)"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("store_filter", "Select Store(s):", choices = stores, selected = stores),
      checkboxGroupInput("product_filter", "Select Product(s):", choices = products, selected = products)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("📈 Sales Trend", plotlyOutput("line_plot")),
        tabPanel("🏬 Sales by Product", plotlyOutput("bar_plot")),
        tabPanel("🍩 Store Contribution", plotlyOutput("pie_plot")),
        tabPanel("📋 Data Table", tableOutput("data_table"))
      )
    )
  )
)

# ---------------------------
# Server Logic
# ---------------------------
server <- function(input, output) {
  
  filtered_data <- reactive({
    data %>%
      filter(Store %in% input$store_filter, Product %in% input$product_filter)
  })
  
  # Line Chart
  output$line_plot <- renderPlotly({
    plot_ly(filtered_data(), x = ~Date, y = ~Sales, color = ~Store, type = "scatter", mode = "lines+markers") %>%
      layout(title = "Monthly Sales Trend")
  })
  
  # Bar Chart
  output$bar_plot <- renderPlotly({
    plot_ly(filtered_data(), x = ~Product, y = ~Sales, color = ~Product, type = "bar") %>%
      layout(title = "Product-wise Sales")
  })
  
  # Pie Chart
  output$pie_plot <- renderPlotly({
    plot_ly(filtered_data(), labels = ~Store, values = ~Sales, type = "pie", hole = 0.4) %>%
      layout(title = "Store Contribution to Sales")
  })
  
  # Data Table
  output$data_table <- renderTable({
    filtered_data()
  })
}

# ---------------------------
# Run the Application
# ---------------------------
shinyApp(ui = ui, server = server)
