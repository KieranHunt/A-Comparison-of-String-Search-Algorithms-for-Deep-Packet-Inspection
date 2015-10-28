library(ggplot2)
library(scales)
library(grid)
library(RColorBrewer)
library(scales)
library(reshape2)

source("fte_theme.R")

results_location <- "results/packets/google/"

num_rounds <- 20
data_raw <- list()
algorithms <- c("Bitap", "Bloom", "BoyerMoore", "Horspool", "KnuthMorrisPratt", "Naive", "RabinKarp")
number_of_rows <- 1000000

for (i in 1:length(algorithms)) {
    data_raw[[i]] = list()
    for (j in 1:num_rounds) {
        file <- paste(results_location, algorithms[[i]], "-", j, "-datasetA.cap", sep="")
        data_raw[[i]][[j]] <- read.csv(file, sep=",", header=FALSE, nrows=number_of_rows)
        names(data_raw[[i]][[j]]) <- c("id", "time")
    }
}

combined_data_algorithms <- list()

for (i in 1:length(algorithms)) {
    combined_data_algorithms[[i]] <- Reduce(function(...) merge(..., by="id", all=T), data_raw[[i]])
    combined_data_algorithms[[i]] <- data.frame(id=combined_data_algorithms[[i]][,1], mean=rowMeans(combined_data_algorithms[[i]][,-1]))
}

for (i in 1:length(algorithms)) {
    print(algorithms[[i]])
    print(summary(combined_data_algorithms[[i]]$mean))
}
