# devtools::install_github("lchiffon/wordcloud2")

# install.packages("wordcloud2")
# install.packages("tm")
# install.packages("readr")
# install.packages("dplyr")

library(wordcloud2)
library(tm)
library(readr)
library(dplyr)

# https://www.kaggle.com/dorianlazar/medium-articles-dataset?select=medium_data.csv
# Read CSV and filter data with UX Collective Column
medium_csv = read_csv("/Users/paige/Desktop/WordCloud/data/medium_data.csv") %>%
  filter(publication == 'UX Collective')

# Create Corpus
medium.corpus = Corpus(VectorSource(medium_csv$title))

removeHTML = function(text){
  text = gsub(pattern = '<.+\\">', '', text)
  text = gsub(pattern = '</.+>', '', text)
  return(text)
}

medium.corpus = medium.corpus %>%
  tm_map(content_transformer(removeHTML)) %>%
  tm_map(removeNumbers) %>%
  tm_map(removePunctuation) %>%
  tm_map(stripWhitespace) %>%
  tm_map(content_transformer(tolower))  %>%
  tm_map(removeWords, stopwords("english")) # %>%
#  tm_map(removeWords, stopwords("SMART"))
# Remove Some words
# corpus <- tm_map(corpus, removeWords, c('get', 'told', 'gave'))

tdm = TermDocumentMatrix(medium.corpus) %>%
  as.matrix()
words = sort(rowSums(tdm), decreasing = TRUE)
df = data.frame(word = names(words), freq = words)

df = df %>%
  filter(nchar(as.character(word)) > 2,
         word != "don’")

uxc.colors = c("#fefefe", "#f4f2a8", "#030303")
uxc.background = "#00ccff"

library(extrafont)
# font_import()
fonts()

wordcloud2(df,
           color = rep_len(uxc.colors, nrow(df)),
           backgroundColor = uxc.background,
           fontFamily = "DM Sans",
           size = 2.5,
           minSize = 5,
           rotateRatio = 0)