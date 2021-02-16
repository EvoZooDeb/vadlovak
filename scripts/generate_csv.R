#How to RUN:
#Rscript generate_csv.R <coordinates> <frames_folder> <scale_size>

# Read from argument
args = commandArgs(trailingOnly = TRUE)
coord1 <- read.table(args[1],sep = ',')

# Calculate exact position
cx <- as.integer((coord1$V2))
cy <- as.integer((coord1$V3))

# Box size
v <- 35

# Square left top corner
coord1$V2 <- cx-v
coord1$V3 <- cy-v

# Square right bottom corner
coord1$V4 <- cx+v
coord1$V5 <- cy+v

coord1$V6 <- 'horse'

factor <- as.factor(coord1$V1)
#File list

coord1$V7 <- paste(args[2],list.files(args[2])[factor], sep="")

#Write file
write.table(coord1[,c(7,2:6)], file = 'original_frames_map.csv', dec=".", sep="," , col.names = FALSE, row.names = FALSE)

write.table(t(c('horse',0)),file = 'retinanet_class.csv', sep="," , col.names = FALSE, row.names = FALSE)