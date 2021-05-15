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
source("getDF.R")
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    

    output$modelSummary <- renderTable({
     all.vars <- c(input$cat_predictors,input$num_predictors)
     if (length(all.vars) == 0) stop("Cannot build model")
     mytext <- paste0("lm.df <- glm(stroke~",paste(all.vars,collapse="+"),",data=df,family='binomial')")
     eval(parse(text=mytext))
     coefs <- as.data.frame(summary(lm.df)$coef)
     coefs <- coefs[order(coefs$'Pr(>|z|)'),]
     coefs$is_significant <- ifelse(coefs$'Pr(>|z|)' < 0.001,"***"
                                    ,ifelse(coefs$'Pr(>|z|)' < 0.01,"**"
                                            ,ifelse(coefs$'Pr(>|z|)' < 0.05,"*","")))
     coefs$predictor <- rownames(coefs)
     coefs
    }
    )
    
    output$xyScatter <- renderPlotly(
        {
            mytext <- paste0("myplot <- plot_ly(data=df,x=~",input$scatterplot_predictor_x,
                             ",y=~",input$scatterplot_predictor_y,",color=~",input$scatterplot_predictor_color,",colors='Dark2')")
            eval(parse(text=mytext))
            myplot
        }
    )
    
})
