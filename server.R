library(shiny)
library(DT)

pw <- read.csv("/srv/shiny-server/survey/cde.txt")

### Data
md <- read.csv("/srv/shiny-server/survey/id_output.csv")
md <-  md[order(- md$row_id), ]
md$id <- as.character(md$id)
md$notes <- as.character(md$notes)

### Module

source("modFunction.R")
source("modFunctionUI.R")


server = function(input, output, session) {
    callModule(modFunction, "editable", md,
               reset = reactive(input$reset),
               save = reactive(input$save))

}
