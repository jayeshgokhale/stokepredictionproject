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
     for (my.cat.var in input$cat_predictors)
     {
         my.replacement <- paste0(my.cat.var,":")
         coefs$predictor <- gsub(my.cat.var,my.replacement,coefs$predictor)
     }
     coefs
    }
    )
    
    output$xyScatter <- renderPlotly(
        {
            mytext <- paste0("myplot <- plot_ly(data=df,type='scatter', mode = 'markers',x=~",input$scatterplot_predictor_x,
                             ",y=~",input$scatterplot_predictor_y,",size = ~size_stroke,
                             opacity = 1,marker = list(line = list(
        color = 'rgb(0, 0, 0)',
        width = 1
      )),
                             color=~",input$scatterplot_predictor_color,",colors='",input$color_palette,"')")
            mytext <- paste0(mytext, " %>% layout(legend=list(title=list(text='<b> ",input$scatterplot_predictor_color," </b>')))")
            eval(parse(text=mytext))
            myplot 
        }
    )
    
})
