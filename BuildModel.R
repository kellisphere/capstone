# Load libraries
suppressMessages(library(caTools))
suppressMessages(library(RWeka))
suppressMessages(library(hash))
suppressMessages(library(reshape))
suppressWarnings(library(stringi))
suppressWarnings(library(stringr))
suppressMessages(library(tm))
suppressMessages(library(knitr))
suppressMessages(library(ggplot2))
suppressMessages(library(R.utils))
suppressMessages(library(googleVis))
suppressMessages(library(qdap))
suppressMessages(library(NLP))
suppressMessages(library(openNLP))

## load data
data_zip_uri="https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
data_zip_filename <- "Coursera-SwiftKey.zip"
if (!file.exists(data_zip_filename)) {
        download.file(data_zip_uri, destfile=data_zip_filename, method="curl")
        unzip(data_zip_filename)
}

blogs_filename = "final/en_US/en_US.blogs.txt.0.01"
news_filename = "final/en_US/en_US.news.txt.0.01"
twitter_filename = "final/en_US/en_US.twitter.txt.0.01"

## build n-grams
UnigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
TrigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
QuadgramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))

dirSource <- DirSource(directory='final/en_us',
                       encoding='utf-8',
                       pattern='en_US.twitter.split.aa')
corpus <- Corpus(dirSource)
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, content_transformer(removePunctuation))
corpus <- tm_map(corpus, content_transformer(removeNumbers))

# Sets the default number of threads to use; see http://stackoverflow.com/questions/17703553/bigrams-instead-of-single-words-in-termdocument-matrix-using-r-and-rweka
options(mc.cores=1)

tdm1gram <- TermDocumentMatrix(corpus, control = list(tokenize = UnigramTokenizer))
tdm2gram <- TermDocumentMatrix(corpus, control = list(tokenize = BigramTokenizer))
tdm3gram <- TermDocumentMatrix(corpus, control = list(tokenize = TrigramTokenizer))
tdm4gram <- TermDocumentMatrix(corpus, control = list(tokenize = QuadgramTokenizer))

dfToHash <- function(df) {
        hash <- new.env(hash=TRUE, parent=emptyenv())
        for (ii in rev(seq(nrow(df)))) {
                key <- gsub(" ", "_", df[ii, 'predictor'])
                value <- df[ii, 'prediction']
                #cat (key, "<-", value, "\n")
                hash[[key]] <- value
        }
        hash
}

df1ngram <- as.data.frame(inspect(tdm1gram))
df1ngram$num <- rowSums(df1ngram)
df1ngram <- subset(df1ngram, num > 1)
df1ngram$prediction <- row.names(df1ngram)
df1ngram$predictor <- ""
df1ngram <- subset(df1ngram, select=c('predictor', 'prediction', 'num'))
df1ngram <- df1ngram[order(df1ngram$predictor,-df1ngram$num),]
row.names(df1ngram) <- NULL

df2ngram <- as.data.frame(inspect(tdm2gram))
df2ngram$num <- rowSums(df2ngram)
df2ngram <- subset(df2ngram, num > 1)
df2ngram[c('predictor', 'prediction')] <- subset(str_match(row.names(df2ngram), "(.*) ([^ ]*)"), select=c(2,3))
df2ngram <- subset(df2ngram, select=c('predictor', 'prediction', 'num'))
df2ngram <- df2ngram[order(df2ngram$predictor,-df2ngram$num),]
row.names(df2ngram) <- NULL

predict2hash <- dfToHash(df2ngram)

df3ngram <- as.data.frame(inspect(tdm3gram))
df3ngram$num <- rowSums(df3ngram)
df3ngram <- subset(df3ngram, num > 1)
df3ngram[c('predictor', 'prediction')] <- subset(str_match(row.names(df3ngram), "(.*) ([^ ]*)"), select=c(2,3))
df3ngram <- subset(df3ngram, select=c('predictor', 'prediction', 'num'))
df3ngram <- df3ngram[order(df3ngram$predictor,-df3ngram$num),]
row.names(df3ngram) <- NULL

predict3hash <- dfToHash(df3ngram)

df4ngram <- as.data.frame(inspect(tdm4gram))
df4ngram$num <- rowSums(df4ngram)
df4ngram <- subset(df4ngram, num > 1)
df4ngram[c('predictor', 'prediction')] <- subset(str_match(row.names(df4ngram), "(.*) ([^ ]*)"), select=c(2,3))
df4ngram <- subset(df4ngram, select=c('predictor', 'prediction', 'num'))
df4ngram <- df4ngram[order(df4ngram$predictor,-df4ngram$num),]
row.names(df4ngram) <- NULL

predict4hash <- dfToHash(df4ngram)
## save for use
#save(predict2hash, file='predict2.RData')
#save(predict3hash, file='predict3.RData')
#save(predict4hash, file='predict4.RData')