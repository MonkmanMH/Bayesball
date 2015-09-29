# ######################
#
# Blog with output and discussion:
# "Fair weather fans? (An R scatter plot matrix)" 2013-07-18
# http://bayesball.blogspot.ca/2013/07/fair-weather-fans-r-scatter-plot-matrix.html
#
########################
# data: 
# version 1 # saved on Google Drive:
# https://docs.google.com/spreadsheet/ccc?key=0Art4wpcrwqkBdHZvTUFzOUo5U3BzMHFveXdYOTdTWUE&usp=sharing
# File / Download as > Comma Separated Values (CSV)
#
# version 2 saved at GitHub
# read the csv file
# http://christophergandrud.blogspot.kr/2013/01/sourcegithubdata-simple-function-for.html
#
# Load source_GitHubData
if (!require(devtools)) install.packages("devtools")
library(devtools)
# The function's gist ID is 4466237
source_gist("4466237")
#
HarbourCat.attend <- source_GitHubData("https://raw.github.com/MonkmanMH/HarbourCats/master/HC_attendance_2013.csv")
# print data
print(HarbourCat.attend)
#
#
# load ggplot2
if (!require(ggplot2)) install.packages("ggplot2")
library(ggplot2)
#
# #####
#
# simple line plot of data series
#
ggplot(HarbourCat.attend, aes(x=num, y=attend)) + 
    geom_point() + 
    geom_line()+
    ggtitle("HarbourCats attendance \n2013 season") +
    annotate("text", label="Opening Night", x=3, y=3050, size=3,    
      fontface="bold.italic")
#
# #####
#
# BOX PLOT
#
boxplot(HarbourCat.attend$attend, ylab="attendance", main="Box plot of HarbourCat attendance")
#
#
# prune the extreme outliers 
# and structure the data so that attendance is last and will appear as the Y axis on plots
HarbourCat.attend.data <- (subset(HarbourCat.attend, num > 1 & num < 26, select = c(num, day2, sun, temp.f, attend)))
# print the data table to screen
HarbourCat.attend.data
#
#
# ###################
# scatter plot matrix
# ###################
#
# scatter plot matrix - simple
# (see Winston Chang, "R Graphics Cookbook", recipe 5.13)
pairs(HarbourCat.attend.data[,1:5])
#
# #####
#
# scatter plot matrix - with correlation coefficients
# define panels (copy-paste from the "pairs" help page)
panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor, ...)
{
    usr <- par("usr"); on.exit(par(usr))
    par(usr = c(0, 1, 0, 1))
    r <- abs(cor(x, y))
    txt <- format(c(r, 0.123456789), digits = digits)[1]
    txt <- paste0(prefix, txt)
    if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
    text(0.5, 0.5, txt, cex = cex.cor * r)
}
#
panel.hist <- function(x, ...)
{
    usr <- par("usr"); on.exit(par(usr))
    par(usr = c(usr[1:2], 0, 1.5) )
    h <- hist(x, plot = FALSE)
    breaks <- h$breaks; nB <- length(breaks)
    y <- h$counts; y <- y/max(y)
    rect(breaks[-nB], 0, breaks[-1], y, col = "cyan", ...)
}
#
# run pairs plot
#
pairs(HarbourCat.attend.data[,1:5], upper.panel = panel.cor,
                                    diag.panel = panel.hist,
                                    lower.panel = panel.smooth)
#
#
# ######################
# Spearman's correlation
# ######################
#
# big thanks to r2evans who supplied the code below in the comments to the blog post
# 
panel.cor <- function(x, y, digits=3, ..., text.cex, text.col='black') {
par(usr = c(0, 1, 0, 1))
numsamples <- sum(! is.na(x) & ! is.na(y))
r <- cor(x, y, use='complete.obs')
spearman <- cor.test(x, y, method='spearman', continuity=TRUE, exact=FALSE)
#
if (require(RColorBrewer, quietly=TRUE)) {
colbrew <- 'YlOrRd' ## 9 available colors
ndiv <- 5 ## can be up to 9+1=10 since first cut has no color
colors <- c(NA, brewer.pal(ndiv-1, 'YlOrRd'))
} else {
## if RColorBrewer is not available, need to define 'colors' manually
ndiv <- 4
colors <- c(NA, 'yellow', 'orange', 'red') ## for ndiv=4
}
## Could use c(0:ndiv/ndiv), but cut() looks at (0,0.2] so a
## p-value of 0, though highly unlikely, would break things.
## Using anything less than 0 side-steps this problem.
cuts <- c(-1, 1:ndiv/ndiv)
if (spearman$p.value <= 0.05)
polygon( c(-2,2,2,-2,-2), c(-2,-2,2,2,-2),
col=colors[ cut(abs(r), breaks=cuts, labels=FALSE) ])
mindig <- max(0.001, 1/10^digits)
if (spearman$p.value < mindig) {
spearman$p.value <- mindig
leq <- '<'
} else leq <- '='
## Can "arbitrarily" add other info to this list for stacked display.
labels <- list(sprintf('n = %d', numsamples),
sprintf(paste0('%0.', digits, 'f'), r),
sprintf(paste0('p %s %0.', digits, 'f'), leq, spearman$p.value))
nn <- length(labels)
## Ensure the text isn't too big for the square in height or width.
## 0.9 is just a factor to give a little bit of buffer.
if (missing(text.cex)) 
text.cex <- min(0.9/((nn+1) * strheight(labels[[1]]) * 1.3),
0.9/max(strwidth(labels)))
text(0.5, (nn:1)/(nn+1), labels, cex=text.cex, col=text.col, adj=0.5)
}
#
#
