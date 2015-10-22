library(ggplot2)
library(scales)
library(grid)
library(RColorBrewer)
library(scales)

source("fte_theme.R")

rows <- 100

bitap_data <- read.csv("results/Bitap-1-datasetA.cap", sep=",", header=FALSE, nrows=rows)
boyermoore_data <- read.csv("results/BoyerMoore-1-datasetA.cap", sep=",", header=FALSE, nrows=rows)
horspool_data <- read.csv("results/Horspool-1-datasetA.cap", sep=",", header=FALSE, nrows=rows)
knuthmorrispratt_data <- read.csv("results/KnuthMorrisPratt-1-datasetA.cap", sep=",", header=FALSE, nrows=rows)
naive_data <- read.csv("results/Naive-1-datasetA.cap", sep=",", header=FALSE, nrows=rows)
rabinkarp_data <- read.csv("results/RabinKarp-1-datasetA.cap", sep=",", header=FALSE, nrows=rows)

names(bitap_data) <- c("id", "time")
names(boyermoore_data) <- c("id", "time")
names(horspool_data) <- c("id", "time")
names(knuthmorrispratt_data) <- c("id", "time")
names(naive_data) <- c("id", "time")
names(rabinkarp_data) <- c("id", "time")

bitap_data["cum_sum"] <- cumsum(bitap_data$time)
boyermoore_data["cum_sum"] <- cumsum(boyermoore_data$time)
horspool_data["cum_sum"] <- cumsum(horspool_data$time)
knuthmorrispratt_data["cum_sum"] <- cumsum(knuthmorrispratt_data$time)
naive_data["cum_sum"] <- cumsum(naive_data$time)
rabinkarp_data["cum_sum"] <- cumsum(rabinkarp_data$time)

combined_data <- merge(bitap_data, boyermoore_data, by="id")
combined_data <- merge(combined_data, horspool_data, by="id")
combined_data <- merge(combined_data, knuthmorrispratt_data, by="id")
combined_data <- merge(combined_data, naive_data, by="id")
combined_data <- merge(combined_data, rabinkarp_data, by="id")
names(combined_data) <- c("id", "bitap_data.time", "bitap_data.cum_sum", "boyermoore_data.time", "boyermoore_data.cum_sum", "boyermoore_data.time", "horspool_data.cum_sum", "horspool_data.time", "knuthmorrispratt_data.cum_sum", "naive_data.time", "naive_data.cum_sum", "rabinkarp_data.time", "rabinkarp_data.cum_sum")

ggplot(combined_data, aes(x=id)) +
    geom_line(aes(y = bitap_data.cum_sum, colour = "bitap")) +
    geom_line(aes(y = boyermoore_data.cum_sum, colour = "boyermoore")) +
    geom_line(aes(y = horspool_data.cum_sum, colour = "horspool")) +
    geom_line(aes(y = knuthmorrispratt_data.cum_sum, colour = "knuthmorrispratt")) +
    geom_line(aes(y = naive_data.cum_sum, colour = "naive")) +
    geom_line(aes(y = rabinkarp_data.cum_sum, colour = "rabinkarp")) +
    scale_y_continuous(trans=log2_trans()) +
    labs(title = "Cumulative total of each algorithm", y = "Total in micro seconds", x = "") +
    fte_theme()
ggsave("cum_sum.png", dpi=300, width=4, height=3)
