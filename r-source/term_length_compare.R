library(ggplot2)
library(scales)
library(grid)
library(RColorBrewer)
library(scales)
library(reshape2)

source("fte_theme.R")

results_location <- "results/packets/amazonaws.com/"

num_rounds <- 20
data_raw <- list()
algorithms <- c("Bitap", "Bloom", "BoyerMoore", "Horspool", "KnuthMorrisPratt", "Naive", "RabinKarp")
number_of_rows <- 10

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

combined_data <- Reduce(function(...) merge(..., by="id", all=T), combined_data_algorithms)


for (i in 1:length(algorithms)) {
    colnames(combined_data)[i+1] <- algorithms[i]
    combined_data[paste(algorithms[i], ".cum_sum", sep="")] <- cumsum(combined_data[algorithms[i]])
}

ggplot(combined_data, aes(x=id)) +
    geom_line(aes(y = Bitap.cum_sum, color = "Bitap")) +
    labs(title = "Cumulative total of each algorithm", y = "Cumulative total (μs)", x = "Packet number") +
    fte_theme() +
    theme(axis.text.x = element_text(hjust=1, angle=90))

ggsave("term_length_compare.png", dpi=1200, width=5, height=3)
