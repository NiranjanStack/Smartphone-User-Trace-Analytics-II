library(shiny)
library(Cairo)

#load the data in this file to access the name of various columns
dataset <- read.csv(file = "data.csv", header=T, sep=",")

shinyUI=navbarPage("Smartphone Analytics",
                   
                   #UI for Dataset Section                   
                   tabPanel("Dataset",
                            dataTableOutput('contents'),
                            hr(),
                            
                            list(basicPage(
                              renderDataTable('contents')
                            ))),
                   
                   #UI for feature dataset
                   tabPanel("Features",
                            dataTableOutput('features'),
                            hr(),
                            
                            list(basicPage(
                              renderDataTable('features')
                            ))),
                   
                   #UI for press & sd
                   tabPanel("Pressure-StDev",
                            h3("Pressure & Standard Deviation of User w.r.t Phone Orientation"),
                            style="text-align: center;",
                            basicPage(plotOutput("pressure_sd"))),
                   
                   #UI for correlation matrix plot
                   
                   
                   tabPanel("Correlation Matrix",
                            fluidRow(
                              column(6,h3("Correlation Matrix Plot"),style="text-align: center;",
                                     basicPage(plotOutput("corelationMx"))),  
                              column(6,h3("Strategy Analysis based on feature extraction"),style="text-align: center;",
                                     div(img(src = "diagram.jpg", height = 300, width = 600), style="text-align: center;",
                                     width="300px",height="300px"))
                            )),
                            
                          
                   
                   #UI for pressure points
                   
                   tabPanel("Pressure Points",
                            h2("Scatter Plot of Pressure & Area for various users"),
                            style="text-align: center;",
                            basicPage(plotlyOutput("pPoints"))),
                            
                   #UI for Orientation - Landscape & Potrait
                   tabPanel("Orientation",
                            fluidRow(
                              column(12, plotOutput("orPotrait")),
                              column(12, plotOutput("orLandscape"))
                            )),
                   
                   #UI for user traces in smartphone
                   tabPanel("Traces in Phone",
                            fluidRow(
                              column(12, plotlyOutput("touch1")),
                              column(12, plotlyOutput("touch2"))
                            )),
                   
                   #UI for user traces in apps
                   tabPanel("Traces in Apps",
                            fluidRow(
                              column(12, plotlyOutput("traces1")),
                              column(12, plotlyOutput("traces2"))
                            ))
                   

                            )