#How to RUN:
#Rscript generate_David_edit.R /home/wildhorse_project/resized/180824_coordinates.txt /home/wildhorse_project/resized/resized_180824/

#Read from argument
args = commandArgs(trailingOnly = TRUE)
coord1 <- read.table(args[1],sep = ',')

#Calculate exact position
cx <- as.integer((coord1$V2)*1.5625)
cy <- as.integer((2160-coord1$V3)*1.5625)
v <- 70
coord1$V2 <- cx-v
coord1$V3 <- cy-v
coord1$V4 <- cx+v
coord1$V5 <- cy+v
coord1$V6 <- 'horse'

factor <- as.factor(coord1$V1)
#File list
coord1$V7 <- paste(args[2],list.files(args[2])[factor], sep="")

#Write file
write.table(coord1[,c(7,2:6)],
           file = paste(basename(args[2]),"_orig_prep.csv", sep=""),
          ,dec=".", sep="," , col.names = FALSE, row.names = FALSE)
