library(shiny)
library(shinyapps)

data(mtcars)

set.seed(123)

n <- nrow(mtcars)
nTrain <- floor(n*0.7)
inTrain <- sample(1:n,nTrain)

#inTrain <- createDataPartition(y=mtcars$mpg,p=0.7,list=FALSE)
training <- mtcars[inTrain,]
testing <- mtcars[-inTrain,]

v <- training$hp
w <- testing$hp
xTrain <- data.frame(x1=v,x2=v^2,x3=v^3,x4=v^4,x5=v^5)
xTest <- data.frame(x1=w,x2=w^2,x3=w^3,x4=w^4,x5=w^5)

lm.fit1 <- lm(training$mpg ~ x1, data=xTrain)
lm.fit2 <- lm(training$mpg ~ x1 + x2, data=xTrain)
lm.fit3 <- lm(training$mpg ~ x1 + x2 + x3, data=xTrain)
lm.fit4 <- lm(training$mpg ~ x1 + x2 + x3 + x4, data=xTrain)
lm.fit5 <- lm(training$mpg ~ x1 + x2 + x3 + x4 + x5, data=xTrain)

mseTrain <- 1:5
mseTest <- 1:5

mseTrain[1] <- mean((predict(lm.fit1,xTrain) - training$mpg)^2)
mseTrain[2] <- mean((predict(lm.fit2,xTrain) - training$mpg)^2)
mseTrain[3] <- mean((predict(lm.fit3,xTrain) - training$mpg)^2)
mseTrain[4] <- mean((predict(lm.fit4,xTrain) - training$mpg)^2)
mseTrain[5] <- mean((predict(lm.fit5,xTrain) - training$mpg)^2)

mseTest[1] <- mean((predict(lm.fit1,xTest) - testing$mpg)^2)
mseTest[2] <- mean((predict(lm.fit2,xTest) - testing$mpg)^2)
mseTest[3] <- mean((predict(lm.fit3,xTest) - testing$mpg)^2)
mseTest[4] <- mean((predict(lm.fit4,xTest) - testing$mpg)^2)
mseTest[5] <- mean((predict(lm.fit5,xTest) - testing$mpg)^2)

shinyServer (
    function(input,output) {
        n <- reactive({as.numeric(input$degree)})
        val <- reactive({as.double(input$hpvalue)})
        
        output$odegree <- renderPrint({n()})
        output$hpvalue <- renderPrint({val()})
        output$mseTrain <- renderPrint({mseTrain[n()]})
        output$mseTest <- renderPrint({mseTest[n()]})
        output$lmPlot <- renderPlot({
            
            if(n() == 1)
                lm.fit <- lm.fit1
            else if(n() == 2)
                lm.fit <- lm.fit2
            else if(n() == 3)
                lm.fit <- lm.fit3
            else if(n() == 4)
                lm.fit <- lm.fit4
            else 
                lm.fit <- lm.fit5
            
            idx <- order(xTrain$x1)
            orderData <- xTrain[idx,]

            plot(training$hp,training$mpg,pch=4,main="Moto Trend US (mpg vs hp) - Training Set",ylab="mpg (miles per gallon)",xlab="hp (horsepower)")
            lines(orderData$x1,predict(lm.fit,orderData),col="red",lwd=2)
        })
        output$msePlot <- renderPlot({
            plot(1:5,mseTrain,type='l',col="blue",ylim=c(0,25), ylab="Mean Squared Error (MST)", xlab="n (Degree of Polynomial)", main="Training Error and Test Error")
            lines(1:5,mseTest,col="red")
            lines(c(n(),n()),c(0,200),col="green",lwd=3)
            legend('topright',c("MSE Training Set","MSE Test Set"),col=c("blue","red"),lty=1)
        })
        output$mpgvalue <- renderPrint(

            if(n() == 1)
                predict(lm.fit1,data.frame(x1=val()))
            else if(n() == 2)
                predict(lm.fit2,data.frame(x1=val(),x2=val()^2))
            else if(n() == 3)
                predict(lm.fit3,data.frame(x1=val(),x2=val()^2,x3=val()^3))
            else if(n() == 4)
                predict(lm.fit4,data.frame(x1=val(),x2=val()^2,x3=val()^3,x4=val()^4))
            else
                predict(lm.fit5,data.frame(x1=val(),x2=val()^2,x3=val()^3,x4=val()^4,x5=val()^5))
           )
    }
)