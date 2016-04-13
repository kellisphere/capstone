# source("BuildModel.R")
load('data/predict2.RData')
load('data/predict3.RData')
load('data/predict4.RData')

bigramPrediction <- function(x) {
        xclean <- removeNumbers(removePunctuation(tolower(x)))
        xs <- tail(strsplit(xclean, " ")[[1]], 1)
        predict2hash[[xs]]
}

trigramPrediction <- function(x) {
        xclean <- removeNumbers(removePunctuation(tolower(x)))
        xs <- tail(strsplit(xclean, " ")[[1]], 2)
        predict3hash[[paste(xs, sep="_", collapse='_')]]
}

quadgramPrediction <- function(x) {
        xclean <- removeNumbers(removePunctuation(tolower(x)))
        xs <- tail(strsplit(xclean, " ")[[1]], 3)
        predict4hash[[paste(xs, sep="_", collapse='_')]]
}

predictAll <- function(x) {
        p4 <- quadgramPrediction(x)
        if (!is.null(p4)) {
                p4
        } else {
                p3 <- trigramPrediction(x)
                if (!is.null(p3)) {
                        p3
                } else {
                        p2 <- bigramPrediction(x)
                        if (!is.null(p2)) {
                                p2
                        } else {
                                'the'
                        }
                }
        }
}