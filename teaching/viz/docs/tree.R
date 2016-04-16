# -------------------------------------------------------------------
# Example 2: tree map using googleVis


## ---- googleVis_example

## load googleVis library
library(googleVis)

## inspect help
?gvisTreeMap

## define the plot parameters
Tree <- gvisTreeMap(data=Regions,  
                    idvar = "Region", parentvar = "Parent", 
                    sizevar = "Val", colorvar = "Val", 
                    options=list(fontSize=16))

## See the result
Tree        ## Ajax code
plot(Tree)  ## dispay as HTML in browser



## ---- myTree ---

## change working directory
# getwd()
# setwd("D:/project/") ## replace with your own project folder.

## read data in csv format
# hies <- read.csv("hies.csv", stringsAsFactors=FALSE) ## to use your own data
hies <- read.csv("http://klein.uk/R/Viz/hies.csv", stringsAsFactors=FALSE)
# str(hies)
# View(hies)

## work with subset of categories where Total not missing and >10
hies <- hies[!is.na(hies$Total),] 
hies <- hies[hies$Total>10,]

## add total amounts to categories
hies$Subcategory <- paste(hies$Subcategory, hies$Total, sep=" $")
hies$Category <- paste(hies$Category, hies$Total.cat, sep=" $")

## set value of global category as Not Applicable (!) 
hies$Category[1] <- NA

## load googleVis library
library(googleVis)

## set plot parameters
tree <- gvisTreeMap(
          data=hies,  
          idvar = "Subcategory", parentvar = "Category", 
          sizevar = "Total", colorvar = "Total",
          options=list(
            width=600, height=500,
            fontSize=16, 
            minColor='lightblue',
            midColor='blue',
            maxColor='darkblue',
            headerHeight=20,
            fontColor='white',
            showScale=TRUE
          )
        )

## results
# tree                                   ## Ajax code
# plot(tree)                             ## dispay as HTML in browser
# cat(tree$html$chart, file="Tree.html") ## save as HTML

print(tree, tag='chart')


