library(ggplot2)
library(scales)
library(grid)
library(RColorBrewer)
library(scales)
library(reshape2)

source("fte_theme.R")

num_rounds <- 20
data_raw <- list()
algorithms <- c("Bitap", "Bloom", "BoyerMoore", "Horspool", "KnuthMorrisPratt", "Naive", "RabinKarp")
number_of_rows <- 1000000

# ------------------------------------------------------------------------------

results_location <- "results/packets/amazonaws.com/"

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

combined_data_amazon <- Reduce(function(...) merge(..., by="id", all=T), combined_data_algorithms)

for (i in 1:length(algorithms)) {
    colnames(combined_data_amazon)[i+1] <- algorithms[i]
    combined_data_amazon[paste(algorithms[i], ".cum_sum", sep="")] <- cumsum(combined_data_amazon[algorithms[i]])
}

# ------------------------------------------------------------------------------

results_location <- "results/packets/google/"

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

combined_data_google <- Reduce(function(...) merge(..., by="id", all=T), combined_data_algorithms)

for (i in 1:length(algorithms)) {
    colnames(combined_data_google)[i+1] <- algorithms[i]
    combined_data_google[paste(algorithms[i], ".cum_sum", sep="")] <- cumsum(combined_data_google[algorithms[i]])
}

# ------------------------------------------------------------------------------

combined_data <- merge(combined_data_amazon, combined_data_google, by="id")


ggplot(combined_data, aes(x=id)) +
    geom_line(aes(y = RabinKarp.cum_sum.x, color = "Rabin-Karp - google")) +
    geom_line(aes(y = RabinKarp.cum_sum.y, color = "Rabin-Karp - amazonaws.com")) +
    labs(title = "Cumulative total for different strings with Rabin-Karp", y = "Cumulative total (μs)", x = "Packet number") +
    fte_theme() +
    theme(axis.text.x = element_text(hjust=1, angle=90))

ggsave("term_length_compare.png", dpi=1200, width=5, height=3)
