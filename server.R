library(shiny)
library(DT)

### Data
md <- read.csv("/srv/shiny-server/survey/id_output.csv")
md <-  md[order(md$row_id), ]
bkupmd <- md
md$id <- as.character(md$id)
md$notes <- as.character(md$notes)

### Module

source("/srv/shiny-server/survey-view-edit/modFunction.R")
source("/srv/shiny-server/survey-view-edit/modFunctionUI.R")


server = function(input, output, session) {
    callModule(modFunction, "editable", md,
               reset = reactive(input$reset))
    
    observeEvent(input$run, {
        print("Saving live data")
        write.csv(md,
                  "/srv/shiny-server/survey/id_output.csv",
                  row.names = F)
        print("Saving backup data")
        write.csv(
            bkupmd,
            paste0(
                "/srv/shiny-server/survey/",
                Sys.Date(),
                "id_output.csv"
            ),
            row.names = F
        )
    })
    
}
