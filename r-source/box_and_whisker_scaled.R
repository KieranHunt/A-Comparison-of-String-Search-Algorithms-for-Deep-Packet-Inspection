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

combined_data <- scale(combined_data)
# combined_melted_data <- melt(combined_data[,-1])
# colnames(combined_melted_data) <- c("id", "algorithm", "time_scaled")
# combined_melted_data <- combined_melted_data[c("algorithm", "time_scaled")]

plot_data <- data.frame()

biggest <- 0
smallest <- 0

for (i in 1:length(algorithms)) {
    algorithm <- algorithms[[i]]
    column <- combined_data[,algorithm]

    quartiles <- quantile(column)
    zero_quart <- quartiles[[1]]
    twentyfive_quart <- quartiles[[2]]
    fifty_quart <- quartiles[[3]]
    seventyfive_quart <- quartiles[[4]]
    hundered_quart <- quartiles[[5]]

    mean_value <- mean(column)
    standard_deviation <- sd(column)
    max_value <- max(column)
    min_value <- min(column)
    new_row <- data.frame(algorithm, mean_value, standard_deviation, max_value, min_value, zero_quart, twentyfive_quart, fifty_quart, seventyfive_quart, hundered_quart)
    plot_data <- rbind(plot_data, new_row)

    if (max_value > biggest) {
        biggest <- max_value
    }
    if (min_value < smallest) {
        smallest <- min_value
    }
}

ggplot(plot_data) +
    geom_boxplot(aes(x = as.factor(algorithm), ymin = zero_quart, lower = twentyfive_quart, middle = fifty_quart, upper = seventyfive_quart, ymax = hundered_quart), stat="identity") +
    scale_y_continuous(limits = c(smallest, biggest)) +
    labs(title = "Algorithm time as Box and Whisker Plot", y = "Time (microseconds)", x = "Algorithm") +
    fte_theme()

# ggplot(combined_melted_data) +
#     geom_boxplot(aes(x = algorithm, y = time_scaled), outlier.size = NA, range = 1) +
#     labs(title = "Algorithm time as Box and Whisker Plot", y = "Time (microseconds)", x = "Algorithm") +
#     scale_y_continuous(limits = c(-1, 1)) +
#     fte_theme()

ggsave("box_and_whisker_scaled.png", dpi=300, width=4, height=3)
