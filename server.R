  library("ggplot2")
  library("plotly")
  library("plyr")
  library("gdata")
  

server=function(input, output) {
  
  #service for dataset navigation tab  
  output$contents = renderDataTable({
    dataset
  })
  
  #service for feature dataset
  output$features = renderDataTable({
    featext
  })
  
  #service for press & sd
  output$pressure_sd <- renderPlot({
    press_sd
    })
  
  #Service for correlation matrix
  output$corelationMx <- renderPlot({
    corrplot(d2,order="hclust", addrect=2, col=col4(10))
  })
  
  #service for Landscape Orientation
  output$orLandscape <- renderPlot({
    orientation(1,1)
  })
  
  #Service for Potrait Orientation
  output$orPotrait <- renderPlot({
    orientation(1,2)
  })
  
  #Service for Pressure of users for a random of 100 training sets
  output$pPoints <- renderPlotly({
    press_points
  })
  
  
  #service for user 36 traces in smaptphone
  output$touch1 <- renderPlotly({
    user_finger_trace(36)
  })
  
  #service for user trace in smartphone
  output$touch2 <- renderPlotly({
    user_finger_trace(5)
  })
  
  #Service for user 18 traces is apps
  output$traces1 <- renderPlotly({
    user_doc_traces(18)
  })
  
  #service for user 5 traces in app
  output$traces2 <- renderPlotly({
    user_doc_traces(12)
  })
  
}