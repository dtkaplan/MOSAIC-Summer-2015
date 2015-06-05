library("shiny")
source("layer_tab.R")
library(mosaicData)


output_panel_data <- tabsetPanel(
  "data_output",
  tabPanel("Table", plotOutput("my_plot")),
  tabPanel("Plot", textOutput("plot_data")),
  tabPanel("Code", textOutput("code_data"))
)


output_panel_frame <- tabsetPanel(
  "frame_output",
  tabPanel("Table", plotOutput("simple_plot")),
  tabPanel("Plot", textOutput("plot_frame")),
  tabPanel("Code", textOutput("code_frame"))
)


