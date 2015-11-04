library(ggplot2)
library(scales)
library(grid)
library(RColorBrewer)
library(scales)
library(reshape2)

source("fte_theme.R")

index <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13)
amazon_prefix <- c(2783497, 101726, 55808, 9111, 9094, 9094, 7285, 7285, 7285, 6389, 6389, 6389, 6389)
amazon_suffix <- c(812339, 290968, 266672, 266645, 25810, 6980, 6389, 6389, 6389, 6389, 6389, 6389, 6389)
google_prefix <- c(465303, 19007, 15456, 15231, 15223, 15223)
google_suffix <- c(1061226, 92113, 15432, 15223, 15223, 15223)

amazon <- data.frame(index, amazon_prefix, amazon_suffix)
google <- data.frame(index[1:6], google_prefix, google_suffix)

colnames(amazon)[1] <- "index"
colnames(google)[1] <- "index"

ggplot(NULL) +
    geom_line(data = amazon, aes(x=index, y = amazon_prefix, colour = "amazonaws.com - prefix")) +
    geom_line(data = amazon, aes(x=index, y = amazon_suffix, colour = "amazonaws.com - suffix")) +
    geom_line(data = google, aes(x=index, y = google_prefix, colour = "google - suffix")) +
    geom_line(data = google, aes(x=index, y = google_suffix, colour = "google - prefix")) +
    labs(title = "", y = "Total count", x = "Index") +
    scale_y_continuous(labels = comma, trans=log2_trans()) +
    fte_theme()
ggsave("frequency-graph.png", dpi=300, width=4, height=3)
