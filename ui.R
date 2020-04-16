#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

source("/srv/shiny-server/survey-view-edit/modFunctionUI.R")

# Define UI
ui = basicPage(
    mainPanel(
        
        actionButton("reset", "Reset"),
        tags$hr(),
        modFunctionUI("editable"),
        actionButton("run", "Save", color = "teal")
        )
)