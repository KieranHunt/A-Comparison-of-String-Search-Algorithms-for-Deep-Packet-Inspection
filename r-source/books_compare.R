library(ggplot2)
library(scales)
library(grid)
library(RColorBrewer)
library(scales)
library(reshape2)

source("fte_theme.R")

results_location_amazon <- "results/books/amazonaws.com/"
results_location_google <- "results/books/google/"

num_rounds <- 1000
books <- c("Alices-Adventures-in-Wonderland.txt", "Bird-Watching.txt", "Frankenstein-or-the-Modern-Prometheus.txt", "Pride-and-Prejudice.txt", "The-Adventures-of-Sherlock-Holmes.txt", "The-Adventures-of-Tom-Sawyer-Complete.txt", "The-Yellow-Wallpaper.txt")
algorithms <- c("Bitap", "BoyerMoore", "Horspool", "KnuthMorrisPratt", "Naive", "RabinKarp")

data_raw_amazon <- array(1, dim=c(length(algorithms), length(books), num_rounds))
data_raw_google <- array(1, dim=c(length(algorithms), length(books), num_rounds))

for (i in 1:length(algorithms)) {
    for (j in 1:length(books)) {
        for (k in 1:num_rounds){
            file <- paste(results_location_amazon, algorithms[[i]], "-", k, "-", books[[j]], sep="")
            if (file.exists(file)) {
                data_raw_amazon[i,j,k] <- as.numeric(readLines(file))
            }
        }
    }
}

for (i in 1:length(algorithms)) {
    for (j in 1:length(books)) {
        for (k in 1:num_rounds){
            file <- paste(results_location_google, algorithms[[i]], "-", k, "-", books[[j]], sep="")
            if (file.exists(file)) {
                data_raw_google[i,j,k] <- as.numeric(readLines(file))
            }
        }
    }
}

for (i in 1:length(algorithms)) {
    for (j in 1:length(books)) {
        print(mean(data_raw_amazon[i,j,]) - mean(data_raw_google[i,j,]))
    }
}
