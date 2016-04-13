library(shiny)
shinyUI(pageWithSidebar(
        headerPanel("Natural Language Predictor"),
        sidebarPanel(
                h4('Choose the number of words you want to enter for prediction - the more, the better'),
                uiOutput('ngramOptions')    
        ),
        mainPanel(
                tabsetPanel(
                        tabPanel("Prediction", verticalLayout(
                                h4('Start typing your phrase and see what the next predicted word is below'),
                                textInput('textInput', "Text Input"),
                                textOutput("textOutput"))
                        ),
                        tabPanel("Instructions", HTML('
                                                      <p>Type any text into the input box on the "Prediction" tab.
                                                      Try selecting a different length of entry to vary your answers.</p>
                                                      <h3>n-Gram</h3>
                                                      <p>This app uses a collection of text gathered from data available on the internet from Twitter, blogs, and news, and creates data sets of <a href="https://en.wikipedia.org/wiki/N-gram">n-Grams</a> (bi, tri, quad) in order to predict the next word.</p>
                                                      <ul>
                                                      <li>Last two words - Applies the most common bigram that starts with the last two words of your entered text.</li>
                                                      <li>Last three words - Applies the most common trigram that starts with the last three words of your entered text.</li>
                                                      <li>Last four words - Applies the most common <quadgram that starts with the last four words of your entered text.</li>
                                                      <li>combo - Here we use the <a href="https://en.wikipedia.org/wiki/Katz%27s_back-off_model">Katz backoff algorithm</a> and all of the n-grams combined.</li>
                                                      </ul>
                                                     </p>
                                                      ')),
      tabPanel("Bibliography", HTML('
                                    <ol>
                                    <li>Book: <a href="http://www.amazon.com/Statistical-Machine-Translation-Philipp-Koehn/dp/0521874157">Statistical Machine Translation</a> by Phillipp Keohn</li>
                                    <li><a href="https://en.wikipedia.org/wiki/Natural_language_processing">Wikipedia Natural language processing</a></li>
                                    <li><a href="https://www.kaggle.com/c/word2vec-nlp-tutorial/details/part-1-for-beginners-bag-of-words">https://www.kaggle.com/c/word2vec-nlp-tutorial/details/part-1-for-beginners-bag-of-words</a></li>
                                    <li><a href="https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-ngram-tokenizer.html">N-gram tokenizer</a></li>
                                    <li><a href="http://davies-linguistics.byu.edu/ling485/for_class/hispling_final.htm">Linguistics study</a> by Mark Davies of Brigham Young University</li>
                                    <li><a href="https://www.coursera.org/specializations/jhu-data-science">Coursera John Hopkins Data Science Certification Course</a></li>  
                                    <li>Info for using removeWords: <a href="http://www.inside-r.org/packages/cran/tm/docs/removeWords">http://www.inside-r.org/packages/cran/tm/docs/removeWords</a></li>
                                    <li>Text Mining: <a href="http://www.rdatamining.com/examples/text-mining">http://www.rdatamining.com/examples/text-mining</a></li>
                                    <li><a href="http://cran.r-project.org">CRAN project for R info</a></li>
                                    <li>sentDetect in R: <a href="http://www.inside-r.org/packages/cran/openNLP/docs/sentDetect">http://www.inside-r.org/packages/cran/openNLP/docs/sentDetect</a></li>
                                    </ol>
                                    ')),
      tabPanel("About", p(HTML('This is a project for the Coursera Data Science Capstone. My code repository is located on <a href="https://github.com/kellisphere/capstone">GitHub</a>.')))
    )
  )
))