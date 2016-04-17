# -------------------------------------------------------------------
# Example 1: pie chart using googleVis


## read data
pizza = read.csv("http://klein.uk/R/Viz/pizza.csv")

## install and load package googleVis
# install.packages("googleVis")
library(googleVis)

## create pie chart
pizza = gvisPieChart(pizza)
plot(pizza)

## find help
?gvisPieChart

