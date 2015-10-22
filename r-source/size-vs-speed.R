library(ggplot2)
library(scales)
library(grid)
library(RColorBrewer)
library(scales)

source("fte_theme.R")

rows <- 1000

boyermoore_apr14_data <- read.csv("KnuthMorrisPratt-Apr14_1.cap-first-10000.csv", sep=",", header=FALSE, nrows=rows)
apr14_metadata <- read.csv("Apr14_1.cap-meta-first-10000.csv", sep=",", header=FALSE, nrows=rows)

names(boyermoore_apr14_data) <- c("id", "time")
names(apr14_metadata) <- c("id", "size")

combined_data <- merge(boyermoore_apr14_data, apr14_metadata["size"])

ggplot(combined_data) +
      geom_point(aes(x=size, y=time), alpha=0.05) +
      labs(x="Size of packet (bytes)", y="Processing time per packet (microseconds)", title="Packet Processing Time vs Packet Size (Boyer-Moore)") +
      fte_theme()
ggsave("processing_time_vs_packet_size.png", dpi=300, width=4, height=3)
