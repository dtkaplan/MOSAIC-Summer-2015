library(shiny)
source("helper.R",local=TRUE)

dataset <- BabyNames

frame_tab <- tabPanel(
  "Frame",
  column(4,
         selectInput("x", "X variable:",
                     c(unique(as.character(names(dataset))))),
         
         selectInput("y", "Y variable:",
                     c(unique(as.character(names(dataset))))) 
  ),
  column(8,
         output_panel_frame
  ))

