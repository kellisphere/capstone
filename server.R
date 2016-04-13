library(shiny)
library(tm)
library(RWeka)
library(stringr)

source("LoadModel.R")

algorithm <- c('ngram')
predict <- function(algo, inputText, input) {
        cat('Predicting for', algo, inputText, "\n")
        if ((length(algo) == 0) || (algo == 'ngram')) {
                ngc <- input$ngramComplexity
                if (is.null(inputText) || (str_length(inputText) == 0)) {
                        'the'
                } else if ((length(ngc) == 0) || (ngc == 'combo')) {
                        predictAll(inputText)
                } else if (ngc == 'last two words') {
                        bigramPrediction(inputText)
                } else if (ngc == 'last three words') {
                        trigramPrediction(inputText)
                } else if (ngc == 'last four words') {
                        quadgramPrediction(inputText)
                } else {
                        'the'
                }
        } else {
                'ERROR'
        }
}

shinyServer(
        function(input, output) {
                inputText <- reactive({input$textInput})
               ngramChoice <- reactive({as.character(input$ngramChoice)})
               output$ngramChoice <- renderUI({
                        selectInput('ngramChoice', "Prediction Algorithm", algorithm)
                })
                ngramOptions <- reactive({
                        cat('Choice:', ngramChoice(), "\n")
                        if ((length(ngramChoice()) == 0) || (as.character(ngramChoice()) == 'ngram')) {
                                cat("Rendering ngram\n")
                                selectInput('ngramComplexity', "Complexity of n-gram", c('last two words', 'last three words', 'last four words', 'combo'))
                        } else {
                                renderText(paste("Unrecognized algorithm", ngramChoice()))
                        }
                })
                output$ngramOptions <- renderUI({ngramOptions()})
                output$textOutput <- renderText({
                        prediction = predict(ngramChoice(), inputText(), input)
                        paste0(ngramChoice(), " prediction: ", prediction, sep="", collapse="")
                })
        }
)