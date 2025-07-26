# In this file, write the R-code necessary to load your original data file
# (e.g., an SPSS, Excel, or SAS-file), and convert it to a data.frame. Then,
# use the function open_data(your_data_frame) or closed_data(your_data_frame)
# to store the data.

library(worcs)

friend <- read.table("~/Documents/LazegaLawyers/ELfriend.dat")
advise <- read.table("~/Documents/LazegaLawyers/ELadv.dat")
work <- read.table("~/Documents/LazegaLawyers/ELwork.dat")
attr <- read.table("~/Documents/LazegaLawyers/ELattr.dat")


open_data(friend)
open_data(advise)
open_data(work)
open_data(attr)