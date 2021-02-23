#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(tidyverse)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    #RANDOM SIMPLE
    ssize.as <- function(n=c(),p=c(0.5),z=c(0.95),e=c(0.05),nr=c(0)) {
        a=qnorm(1-(1-z)/2)
        numerador = ((a^2)*(p*(1-p)+e^2)*n)
        denominador = ((a^2)*(p*(1-p))+(e^2)*n)
        muestra = ceiling(numerador/denominador*(1/(1-nr)))
        muestra
    }
    
    #MARGIN OF ERROR FOR A GIVEN SAMPLE SIZE
    error_m <- function(N=c(),n=c(),p=c(0.5), z=c(0.95),nr=c(0)) {
        a=qnorm(1-(1-z)/2)
        n.1<-n*(1-nr)
        e.1<-round(a*sqrt(p*(1-p)/n.1)*sqrt(1-n.1/N),5)
        e.1
    }
    
    output$ss_sin_nr <- renderText({
        ssize.as(n = input$population,
                 p = input$dist/100,
                 z = input$conf/100,
                 e = input$me/100,
                 nr = c(0))
    })
    
    output$ss_con_nr <- renderText({
        ssize.as(n = input$population,
                 p = input$dist/100,
                 z = input$conf/100,
                 e = input$me/100,
                 nr = input$nr/100)
    })
    
    

    output$ss_plot <- renderPlotly({
        
        #Estimating margin of error
        samplesizes <- seq(from=1, min(2000, input$population),1)
        
        me_vec <- sapply(samplesizes, error_m, N=input$population, p = input$dist/100, z = input$conf/100)
        
        fig <- plot_ly(x = samplesizes,
                y = me_vec,
                type = 'scatter', mode = 'lines') 
        fig <- fig %>% 
            layout(xaxis = list(range = c(0, min(2000, input$population)), title = "Sample size"),
                   yaxis = list (title = "Margin of error (%)"))
        fig
    })

})
