library(ggplot2)
library(scales)
library(grid)
library(RColorBrewer)

source("fte_theme.R")

rows <- 100

cuckoo_data <- read.csv("Cuckoo_Apr14_1.cap.txt.shrunk.txt", sep=";", header=FALSE, nrows=rows)
bitap_data <- read.csv("Bitap_Apr14_1.cap.txt.shrunk.txt", sep=";", header=FALSE, nrows=rows)
ahocorasick_data <- read.csv("AhoCorasick_Apr14_1.cap.txt.shrunk.txt", sep=";", header=FALSE, nrows=rows)
bloom_data <- read.csv("Bloom_Apr14_1.cap.txt.shrunk.txt", sep=";", header=FALSE, nrows=rows)

names(cuckoo_data) <- c("id", "time")
names(bitap_data) <- c("id", "time")
names(ahocorasick_data) <- c("id", "time")
names(bloom_data) <- c("id", "time")

cuckoo_data["cum_sum"] <- cumsum(cuckoo_data$time)
bitap_data["cum_sum"] <- cumsum(bitap_data$time)
ahocorasick_data["cum_sum"] <- cumsum(ahocorasick_data$time)
bloom_data["cum_sum"] <- cumsum(bloom_data$time)

combined_data <- merge(cuckoo_data, bitap_data, by="id")
combined_data <- merge(combined_data, ahocorasick_data, by="id")
combined_data <- merge(combined_data, bloom_data, by="id")
names(combined_data) <- c("id", "cuckoo.time", "cuckoo.cum_sum", "bitap.time", "bitap.cum_sum", "ahocorasick.time", "ahocorasick.cum_sum", "bloom.time", "bloom.cum_sum")

ggplot(combined_data) +
    geom_histogram(aes(x=cuckoo.time), binwidth=1, fill="#c0392b", alpha=0.75) +
    geom_histogram(aes(x=bitap.time), binwidth=1, fill="#cfffB0", alpha=0.75) +
    geom_histogram(aes(x=ahocorasick.time), binwidth=1, fill="#5998c5", alpha=0.75) +
    geom_histogram(aes(x=bloom.time), binwidth=1, fill="#58355E", alpha=0.75) +
    fte_theme()
ggsave("histogram.png", dpi=300, width=4, height=3)
