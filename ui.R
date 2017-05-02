#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Predict house values in suburbs of Boston"),
    
    sidebarLayout(
        sidebarPanel(
            sliderInput("sliderRM", "Filter the data by number of rooms", min = 2, max = 10, value = 6),
            
            sliderInput("sliderAGE", "Select the age of the house", min = 1, max = 100, value = 20),
            
            checkboxInput("showNr", "Show the number of observations", value = T),
            
            checkboxInput("showP", "Show the P-value", value = T)
            
            ),
        
        # Show a plot of the generated distribution
        mainPanel(
            h2("How to use the app"),
            h5("1. Select the number of rooms to filter the data accordingly. The points you see in the plot are only relative to the number of rooms you have chosen. Some number of rooms values don't have any entry in the data. In that case the application tells you that there are no observations. In the plot, the red line corresponds to a linear model where the house price is the target and the age of the house is the predictor."),
            h5("2. You can select the age of the house and notice that the big red point indicates the prediction. The text of the prediction is also displayed below the plot."),
            h5("3. It's possible to select if you want to see a text with the number of observations for the selected number of rooms of the house and if you want to see what is the p-value of the prediction. Some combinations of data allow a very low p-value, while others don't contain enough observations to achieve a highly significant prediction."),   
               
               
            plotOutput("plot1"),
            h3(textOutput("pred1")),
            h3(textOutput("plotDes")),
            h3(textOutput("pval"))
            
        )
    )
))
