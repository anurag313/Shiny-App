library(shiny)
library(shinyapps)

shinyUI(pageWithSidebar(
    headerPanel("Overfitting in Regression"),
    sidebarPanel(
        p("This application illustrates the important concept of overfitting using the mtcars
        data set. We fit a polynomial regression model to estimate the mpg using the horsepower
        as a predictor."),
        p("In the sidebar panel, User can select the degree of the polyomial model and see the
        results in the main panel. Scatterplot and the regression line are plotted and MSE of the
        training and test set displayed. Also, for a given number of horsepower the prediction of 
        mpg will be shown."),
        p("The purpose of this application is to show how using a more fitting model(for training
        data), the error goes down, but the error increases for test data because when we tried
        to made our model for training data to be more accurate, we also fitted the model for the
        noise present in training data which make the model less accurate for test data."),
        
        h4("Input"),
        sliderInput('degree','Select Polynomial Degree [1,10]:',value=1,min=1,max=5,step=1),
        sliderInput('hpvalue','Select Horsepower Value [50,250]:',value=100,min=50,max=250,step=1)
    ),
    mainPanel(
        h4('Degree of the Polynomial'),
        verbatimTextOutput("odegree"),
        h4('Horsepower Value'),
        verbatimTextOutput("hpvalue"),
        h4('Estimated MPG Value'),
        verbatimTextOutput("mpgvalue"),
        plotOutput("lmPlot"),
        plotOutput("msePlot"),
        h4("MSE Training Set"), 
        textOutput("mseTrain"),
        h4("MSE Test Set"),
        textOutput("mseTest")
    )
))
