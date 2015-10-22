library(ggplot2)
library(scales)
library(grid)
library(RColorBrewer)
library(scales)
library(reshape2)

source("fte_theme.R")

num_rounds <- 20
data_raw <- list()
algorithms <- c("Bitap", "BoyerMoore", "Horspool", "KnuthMorrisPratt", "Naive", "RabinKarp")
number_of_rows <- 1000000

for (i in 1:length(algorithms)) {
    data_raw[[i]] = list()
    for (j in 1:num_rounds) {
        file <- paste("results/", algorithms[[i]], "-", j, "-datasetA.cap", sep="")
        data_raw[[i]][[j]] <- read.csv(file, sep=",", header=FALSE, nrows=number_of_rows)
        names(data_raw[[i]][[j]]) <- c("id", "time")
    }
}

combined_data_algorithms <- list()

for (i in 1:length(algorithms)) {
    combined_data_algorithms[[i]] <- Reduce(function(...) merge(..., by="id", all=T), data_raw[[i]])
    combined_data_algorithms[[i]] <- data.frame(id=combined_data_algorithms[[i]][,1], mean=rowMeans(combined_data_algorithms[[i]][,-1]))
}

combined_data <- Reduce(function(...) merge(..., by="id", all=T), combined_data_algorithms)

for (i in 1:length(algorithms)) {
    colnames(combined_data)[i+1] <- algorithms[i]
}

combined_melted_data <- melt(combined_data[,-1])

ggplot(combined_melted_data) +
    geom_boxplot(aes(x = variable, y = value), outlier.size = NA) +
    scale_y_continuous(trans=log2_trans()) +
    labs(title = "Algorithm time as Box and Whisker Plot", y = "Time (microseconds)", x = "Algorithm") +
    fte_theme()

ggsave("box_and_whisker.png", dpi=300, width=4, height=3)
