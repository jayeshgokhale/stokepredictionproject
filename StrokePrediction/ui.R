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
source("getDF.R")


# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel( "Stroke Prediction Dataset Analysis",windowTitle = "Stroke Prediction"),
    tags$a(href='https://jayeshgokhale.shinyapps.io/strokePredictionAnalysis/', target='blank'
           , 'User Documentation'),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            checkboxGroupInput("cat_predictors", "Choose Categorical Predictors:",
                               choiceNames = cat.vars
                                   ,
                               choiceValues = cat.vars
                               ,selected = "heart_disease"
                                   ),
            checkboxGroupInput("num_predictors", "Choose Numeric Predictors:",
                               choiceNames = num.vars
                               ,
                               choiceValues = num.vars
                               ,selected = "age"
            ),
            #sliderInput("prediction_threshold","Enter a value for threshold",0,1,0.25),
            selectInput("scatterplot_predictor_x","Choose a variable for Scatter Plot (X)",num.vars,selected="age"),
            selectInput("scatterplot_predictor_y","Choose a variable for Scatter Plot (Y)",num.vars,selected="bmi"),
            selectInput("scatterplot_predictor_color","Choose a Color variable for Scatter Plot",c(cat.vars,"stroke"),selected="stroke"),
            selectInput("color_palette","Choose a Color Palette",palette.names,selected="Accent"),
        ),

        # Show a plot of the generated distribution
        mainPanel(
            h3("Logit Model Summary (Ascending Order of P Value)"),
            tableOutput("modelSummary"),
            #h3("Validation Metrics"),
            #textOutput("validationMetrics"),
            h3("Scatter Plot (Size of Bubble indicates Risk of Stroke)"),
            plotlyOutput("xyScatter")        
            )
    )
))
