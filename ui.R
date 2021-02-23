#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(tidyverse)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Sample Size Calculator"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput(inputId = "me",
                        label = "Margin of error (%):",
                        min = 1,
                        max = 100,
                        value = 5),
            sliderInput(inputId = "conf",
                        label = "Confidence level (%):",
                        min = 1,
                        max = 100,
                        value = 95),
            sliderInput(inputId = "dist",
                        label = "Response distribution (%):",
                        min = 1,
                        max = 100,
                        value = 50),
            numericInput(inputId = "population", 
                         label = "Population size:", 
                         value = 20000,
                         min = 1, 
                         max = 10000000, 
                         step = 1),
            sliderInput(inputId = "nr",
                        label = "Non response rate (%):",
                        min = 0,
                        max = 99,
                        value = 20)
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            h3('Recommended sample size'),
            h4('Without non response rate:'),
            textOutput("ss_sin_nr"),
            h4('With non response rate:'),
            textOutput("ss_con_nr"),
            br(),
            h3('Relationship Between Sample Size and Margin of Error:'),
            plotlyOutput("ss_plot"),
            br(),
            br(),
            div(strong("How to use"), style="color:blue"),
            div("If 50% of all the people in a population of 20000 people drink coffee in the morning, 
                and if you were repeat the survey of 381 people (Did you drink coffee this morning?) 
                many times, then 95% of the time, your survey would find that between 45% and 55% of 
                the people in your sample answered Yes.", style="color:blue"),
            div("The remaining 5% of the time, or for 1 in 20 survey questions, you would expect the 
                survey response to more than the margin of error away from the true 
                answer.", style="color:blue"),
            div("When you survey a sample of the population, you don't know that you've found the 
                correct answer, but you do know that there's a 95% chance that you're within the 
                margin of error of the correct answer.", style="color:blue"),
            div("Source for more information: http://www.raosoft.com/samplesize.html", style="color:blue")
        )
    )
))
