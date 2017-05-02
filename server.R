#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

shinyServer(function(input, output) {
    
    library(stats)
    ##setwd("D:/OneDrive/DataScience/Training/Data Science Specialization/Course9-DataProducts/wk4")
    hd <- read.fwf(file="housing.data", widths=c(8,7,8,3,8,8,7,8,4,7,7,7,7,7))
    names(hd) <- c("CRIM", "ZN", "INDUS", "CHAS", "NOX", "RM", "AGE", "DIS", "RAD", "TAX", "PTRATIO", "B", "LSTAT", "MEDV")
    
    values <- reactiveValues(df_data = NULL)
    
    observeEvent(input$sliderRM, {
        values$df_data <- subset(hd, as.integer(hd$RM) == input$sliderRM)
    })
    
    model1 <- reactive({
        lm(MEDV ~ AGE, data = values$df_data)
    })
    
    model1pred <- reactive({
        predict(model1(), newdata = data.frame(AGE = input$sliderAGE))
    })
    
    dimHd <- reactive({
        dim(values$df_data)[1]
    })
    
    pv <- reactive({
        summary(model1())$coefficients[2,4]
    })
    
    output$plot1 <- 
        renderPlot({
            if (dimHd() > 0)
            {
            plot(values$df_data$AGE, values$df_data$MEDV, xlab = "Age of the house", ylab = "Value in thousands dollars", bty = "n", pch = 19, xlim = c(0,100), ylim = c(0, 50))
            abline(model1(), col = "red", lwd = 2)
            legend(2, 7, c("Prediction"), pch = 16, col = c("red"), bty = "n", cex = 2)
            points(input$sliderAGE, model1pred(), col = "red", pch = 16, cex = 3)
            }
    })
    
    output$plotDes <- renderText({
        if(dimHd() > 0)
        {
            if(input$showNr)
                paste("The prediction is based on ", dimHd(), "observations")
        }
        else
        {
            "Sorry, there are no observations for the selected number of rooms! Select a different value."
        }
    })
    
    output$pval <- renderText({
        if(dimHd() > 0 & input$showP)
        {
            if(!is.nan(pv()))
            {
                if(pv() < 0.05)
                {
                    sprintf("P-value: %e. The prediction is highly significant.", pv())
                }
                else
                {
                    sprintf("P-value: %e. There are not enough observations for a highly significant prediction.", pv())
                }
            }
            else
            {
                "The P-value is not available. There are not enough observations for a highly significant prediction."
            }
            
        }
    })

    
    output$pred1 <- renderText({
        if(dimHd() > 0)
        {
            sprintf("The predicted price of a %i rooms, %i years old house is %.2f$", input$sliderRM, input$sliderAGE, model1pred() * 1000)
        }
        else
        {
            ""
        }
        
    })
})



