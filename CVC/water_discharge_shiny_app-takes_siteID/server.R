library(shiny)
library(dplyr)
library(dygraphs)
library(xts)

shinyServer(function(input, output) {
  
  getColumn <- function(url,n) {
    #Read the data from the web
    txt <- readLines(url)
    cond <- grepl("^#",txt)
    txt <- txt[cond==FALSE]
    txt <- txt[-c(1:2)]
    split <- strsplit(txt, "\t")
    newlist <- do.call("rbind", lapply(split, "[[", n))
  }
  
  makeDf <- function(url){
    df <- data.frame(Date=getColumn(url,3),Volume=getColumn(url,4))
    df <- df %>% mutate(newDate = ymd(Date)) %>% mutate(newVolume = extract_numeric(Volume)) %>%
      select(newDate, newVolume)
  }
  
  
  plot <- eventReactive(input$button, {
    url <- paste0("http://waterdata.usgs.gov/nwis/dv?cb_00060=on&format=rdb&site_no=",input$site,"&referred_module=sw&period=&begin_date=", input$dates[1],"&end_date=",input$dates[2])
    df <- makeDf(url)
    df_ts <- xts(df$newVolume, df$newDate)
    colnames(df_ts) <- "Water Discharge"
    dygraph(df_ts, main = "Water Discharge Over Time") %>%
      dyRangeSelector()
  })
  
  output$graph <- renderDygraph({
    plot()
  })
})
