library(shiny)
library(DT)

### Data
md <- read.csv("/srv/shiny-server/survey/id_output.csv")
md <-  md[order(md$row_id),]
bkupmd <- md
md$id <- as.character(md$id)
md$notes <- as.character(md$notes)

### Module
modFunction <- function(input, output, session, data,reset) {
    
    v <- reactiveValues(data = data)
    data
    proxy = dataTableProxy("mod_table")
    print(str(data))
    observeEvent(input$mod_table_cell_edit, {
        
        info = input$mod_table_cell_edit
        str(info)
        i = info$row
        j = info$col
        k = info$value
        str(info)
        
        isolate(
            if (j %in% match(c("id","notes"), names(v$data))) {
                print(match(c("id","notes"), names(v$data)))
                print("Index")
                print(paste0("Row_Index: ",k))
                print(paste0("Column_Index: ",i))
                v$data[i, j] <<- k
                print(v$data)
                
            } else {
                stop("You are not supposed to change this column.") # check to stop the user from editing only few columns
            }
        )
        replaceData(proxy, v$data, resetPaging = FALSE)  # replaces data displayed by the updated table
    })
    
    ### Reset Table
    observeEvent(reset(), {
        v$data <- data # your default data
    })
    
    print(isolate(colnames(v$data)))
    output$mod_table <- DT::renderDataTable({
        DT::datatable(v$data, editable = TRUE)
        
    })
}

modFunctionUI <- function(id) {
    ns <- NS(id)
    DT::dataTableOutput(ns("mod_table"))
    
}

    server = function(input, output, session) {
        
        callModule(modFunction,"editable", md,
                   reset = reactive(input$reset))
        
        observeEvent(input$run, {
            print("Saving live data")
            write.csv(md, "/srv/shiny-server/survey/id_output.csv", row.names = F)
            print("Saving backup data")
            write.csv(bkupmd, paste0("/srv/shiny-server/survey/",Sys.Date(),"id_output.csv"), row.names = F)
        })
        
    }
    

