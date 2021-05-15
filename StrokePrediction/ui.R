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
    titlePanel("Stroke Prediction Dataset Analysis"),

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
            selectInput("scatterplot_predictor_x","Choose a variable for Scatter Plot (X)",num.vars,selected="age"),
            selectInput("scatterplot_predictor_y","Choose a variable for Scatter Plot (Y)",num.vars,selected="bmi"),
            selectInput("scatterplot_predictor_color","Choose a Color variable for Scatter Plot",c(cat.vars,"stroke"),selected="stroke"),
            selectInput("boxplot_predictor","Choose a variable for Box Plot",cat.vars),
            selectInput("colorbox_predictor","Choose a variable for Fill Color in Box Plot",cat.vars)
            #,submitButton()
        ),

        # Show a plot of the generated distribution
        mainPanel(
            titlePanel("Logit Model Summary"),
            tableOutput("modelSummary"),
            titlePanel("Scatter Plot for Numeric Variables"),
            plotlyOutput("xyScatter")
        )
    )
))
