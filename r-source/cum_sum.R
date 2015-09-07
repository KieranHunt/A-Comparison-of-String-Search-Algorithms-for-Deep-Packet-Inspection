library(ggplot2)
library(scales)
library(grid)
library(RColorBrewer)

source("fte_theme.R")

rows <- 10000

cuckoo_data <- read.csv("Cuckoo_Apr14_1.cap.txt.shrunk.txt", sep=";", header=FALSE, nrows=rows)
bitap_data <- read.csv("Bitap_Apr14_1.cap.txt.shrunk.txt", sep=";", header=FALSE, nrows=rows)
ahocorasick_data <- read.csv("AhoCorasick_Apr14_1.cap.txt.shrunk.txt", sep=";", header=FALSE, nrows=rows)
bloom_data <- read.csv("Bloom_Apr14_1.cap.txt.shrunk.txt", sep=";", header=FALSE, nrows=rows)
boyermoore_data <- read.csv("BoyerMoore_Apr14_1.cap.txt.shrunk.txt", sep=";", header=FALSE, nrows=rows)

names(cuckoo_data) <- c("id", "time")
names(bitap_data) <- c("id", "time")
names(ahocorasick_data) <- c("id", "time")
names(bloom_data) <- c("id", "time")
names(boyermoore_data) <- c("id", "time")

cuckoo_data["cum_sum"] <- cumsum(cuckoo_data$time)
bitap_data["cum_sum"] <- cumsum(bitap_data$time)
ahocorasick_data["cum_sum"] <- cumsum(ahocorasick_data$time)
bloom_data["cum_sum"] <- cumsum(bloom_data$time)
boyermoore_data["cum_sum"] <- cumsum(boyermoore_data$time)

combined_data <- merge(cuckoo_data, bitap_data, by="id")
combined_data <- merge(combined_data, ahocorasick_data, by="id")
combined_data <- merge(combined_data, bloom_data, by="id")
combined_data <- merge(combined_data, boyermoore_data, by="id")
names(combined_data) <- c("id", "cuckoo.time", "cuckoo.cum_sum", "bitap.time", "bitap.cum_sum", "ahocorasick.time", "ahocorasick.cum_sum", "bloom.time", "bloom.cum_sum", "boyermoore.time", "boyermoore.cum_sum")

ggplot(combined_data, aes(x=id)) +
    geom_line(aes(y = cuckoo.cum_sum, colour = "cuckoo: cum_sum")) +
    geom_line(aes(y = bitap.cum_sum, colour = "bitap: cum_sum")) +
    geom_line(aes(y = ahocorasick.cum_sum, colour = "ahocorasick: cum_sum")) +
    geom_line(aes(y = bloom.cum_sum, colour = "bloom: cum_sum")) +
    geom_line(aes(y = boyermoore.cum_sum, colour = "boyermoore: cum_sum")) +
    labs(title = "Cumulative total packet processing time", y = "Cumulative pack processing time (μs)", x = "Packet ID") +
    fte_theme()
ggsave("cum_sum.png", dpi=300, width=4, height=3)
