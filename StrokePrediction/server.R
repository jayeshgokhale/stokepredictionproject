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
    
    lm.df <- NULL
    output$modelSummary <- renderTable({
     all.vars <- c(input$cat_predictors,input$num_predictors)
     if (length(all.vars) == 0) stop("Cannot build model")
     mytext <- paste0("lm.df <- glm(predict_stroke~",paste(all.vars,collapse="+"),",data=df.train,family='binomial')")
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
     output$validationMetrics <- renderText(
         {
             print(summary(lm.df))
             print(input$prediction_threshold)
             test.logit <- predict(lm.df,df.test)
             print("test.logit")
             print(head(test.logit,20))
             test.probs <- exp(test.logit)/(1 + exp(test.logit))
             print("test.probs")
             print(head(test.probs,20))
             print("actual values")
             print(head(df.test$predict_stroke,20))
             test.predictions <- ifelse(test.probs >= input$prediction_threshold,1,0)
             test.accuracy <- round(sum(test.predictions == df.test$predict_stroke)/nrow(df.test),10)
             tp <- sum((df.test$predict_stroke == 1) & (test.predictions == 1))
             tn <- sum((df.test$predict_stroke == 0) & (test.predictions == 0))
             fp <- sum((df.test$predict_stroke == 0) & (test.predictions == 1))
             fn <- sum((df.test$predict_stroke == 1) & (test.predictions == 0))
             precision <- tp / (tp+fp)
             recall <- tp / (tp+fn) 
             #print(test.predictions)
             #print(df.test$predict_stroke)
             #print(head(test.predictions==df.test$predict_stroke))
             #print(sum(test.predictions == df.test$predict_stroke))
             
             retString <- paste0("Accuracy: ",test.accuracy,"; Precision: ",precision,"; Recall: ", recall)
             retString
         }
         
     )
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
