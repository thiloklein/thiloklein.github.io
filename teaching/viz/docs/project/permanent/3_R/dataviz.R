

###########################
## -- rCharts library -- ##
###########################

## ---- A.1. Population pyramid

## Load the devtools, rCharts and other libraries
## install.packages("devtools")
## devtools::install_github('ramnathv/rCharts')
library(rCharts)
library(XML)
library(reshape2)
library(plyr)
source('http://klein.uk/R/Viz/pyramids.R')

## Select population counts for Qatar in 2014
dat <- getAgeTable2(country = 'QA', year = 2014)
head(dat)
View(dat)

n1 <- nPyramid(dat = dat, colors = c('darkred', 'silver'))
n1



## ---- A.2. Data table

## Load data
SchoolsGroup <- read.csv("https://raw.github.com/patilv/rChartsTutorials/master/SchoolsGroup.csv")
head(SchoolsGroup)

## Load styles
tab2 <- dTable(SchoolsGroup[,-1], sPaginationType = "full_numbers")
tab2$templates$script <- "http://timelyportfolio.github.io/rCharts_dataTable/chart_customsort.html" 

## Set column names
tab2$params$table$aoColumns =
  list(
    list(sType = "string_ignore_null", sTitle = "Group 1"),
    list(sType = "string_ignore_null", sTitle = "Group 2"),
    list(sType = "string_ignore_null", sTitle = "Group 3"),
    list(sType = "string_ignore_null", sTitle = "Group 4")
  )

## Produce data table
n1 <- tab2
n1



#############################
## -- googleVis library -- ##
#############################

## Load the googleVis library
library(googleVis)

## ---- B.1. Tree map

## Inspect data
library(googleVis)
head(Regions)

## Plot
Tree <- gvisTreeMap(data = Regions,  
                    idvar = "Region", parentvar = "Parent", 
                    sizevar = "Val", colorvar = "Fac", 
                    options=list(fontSize=16))
plot(Tree)



## ---- B.2. Sankey chart

datSK <- data.frame(From=c(rep("A",3), rep("B", 3)),
                    To=c(rep(c("X", "Y", "Z"),2)),
                    Weight=c(5,7,6,2,9,4))
head(datSK)

Sankey <- gvisSankey(data = datSK, from="From", to="To", weight="Weight",
                     options=list(
                       sankey="{link: {color: { fill: '#d799ae' } },
                            node: { color: { fill: '#a61d4c' },
                            label: { color: '#871b47' } }}"))
plot(Sankey)



## ---- B.3. Calendar chart

head(Cairo)

Cal <- gvisCalendar(Cairo, 
                    datevar="Date", 
                    numvar="Temp",
                    options=list(
                      title="Daily temperature in Cairo",
                      height=320,
                      calendar="{yearLabel: { fontName: 'Times-Roman',
                               fontSize: 32, color: '#1A8763', bold: true},
                               cellSize: 10,
                               cellColor: { stroke: 'red', strokeOpacity: 0.2 },
                               focusedCellColor: {stroke:'red'}}")
)
plot(Cal)



## ---- B.4. Pie chart

head(CityPopularity)
Pie <- gvisPieChart(CityPopularity)
plot(Pie)



## ---- B.5. Geo chart

head(Exports)

Geo=gvisGeoChart(Exports, locationvar="Country", 
                 colorvar="Profit",
                 options=list(projection="kavrayskiy-vii"))
plot(Geo)



## ---- B.6. Motion chart

head(Fruits)

M <- gvisMotionChart(Fruits, 'Fruit', 'Year',
                     options=list(width=400, height=350))
plot(M)



#########################
## -- rMaps library -- ##
#########################

## devtools::install_github('ramnathv/rMaps')

## ---- A.1. Population pyramid

## 1. Create map
library(rMaps)
L2 <- Leaflet$new()
L2$setView(c(29.7632836,  -95.3632715), 15)
L2$tileLayer(provider = "MapQuestOpen.OSM")
L2

## 2. Get data
## install.packages("ggmap")
data(crime, package="ggmap")
## install.packages("ggmap")
library(plyr)
crime_dat <- ddply(crime, .(lat, lon), summarise, count = length(address))
head(crime_dat)

## 3. Transform to json format
crime_dat <- rCharts::toJSONArray2(na.omit(crime_dat), json = F, names = F)

## 4. Add leaflet-heat plugin. 
L2$addAssets(jshead = c(
  "http://leaflet.github.io/Leaflet.heat/dist/leaflet-heat.js"
))

## 5. Add javascript to modify underlying chart
L2$setTemplate(afterScript = sprintf("<script> var addressPoints = %s
  var heat = L.heatLayer(addressPoints).addTo(map) </script>", 
                                     rjson::toJSON(crime_dat)
))
L2



## ---- C.2. Simple choropleths

## Get data
## install.packages("Quandl")
library(Quandl)
vcData <- Quandl("FBI_UCR/USCRIME_TYPE_VIOLENTCRIMERATE")
head(vcData[,1:6])

## Reshape data
library(reshape2)
datm <- melt(vcData, 'Year', 
             variable.name = 'State',
             value.name = 'Crime'
)
datm <- subset(na.omit(datm), 
               !(State %in% c("United States", "District of Columbia"))
)

## Discretize crime rates
datm2 <- transform(datm,
                   State = state.abb[match(as.character(State), state.name)],
                   fillKey = cut(Crime, quantile(Crime, seq(0, 1, 1/5)), labels = LETTERS[1:5]),
                   Year = as.numeric(substr(Year, 1, 4))
)

## Associate fill colors
fills = setNames(
  c(RColorBrewer::brewer.pal(5, 'YlOrRd'), 'white'),
  c(LETTERS[1:5], 'defaultFill')
)

## Create payload for data maps
library(plyr); library(rMaps)
dat2 <- dlply(na.omit(datm2), "Year", function(x){
  y = rCharts::toJSONArray2(x, json = F)
  names(y) = lapply(y, '[[', 'State')
  return(y)
})

## Create simple choropleth
options(rcharts.cdn = TRUE)
map <- Datamaps$new()
map$set(
  dom = 'chart_1',
  scope = 'usa',
  fills = fills,
  data = dat2[[46]],
  legend = TRUE,
  labels = TRUE
)
map



## ---- C.3. Animated choropleth
map2 = map$copy()
map2$set(
  bodyattrs = "ng-app ng-controller='rChartsCtrl'"
)
map2$addAssets(
  jshead = "http://cdnjs.cloudflare.com/ajax/libs/angular.js/1.2.1/angular.min.js"
)

map2$setTemplate(chartDiv = "
  <div class='container'>
    <input id='slider' type='range' min=2005 max=2010 ng-model='year' width=200>
    <span ng-bind='year'></span>
    <div id='' class='rChart datamaps'></div>  
  </div>
  <script>
    function rChartsCtrl($scope){
      $scope.year = 2005;
      $scope.$watch('year', function(newYear){
        map.updateChoropleth(chartParams.newData[newYear]);
      })
    }
  </script>"
)
map2$set(newData = dat2)
map2




