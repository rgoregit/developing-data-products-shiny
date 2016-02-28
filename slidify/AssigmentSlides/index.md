---
title       : Developing Data Products Course Assignment
subtitle    : Feb 28th 2016
author      : Rajesh Gore
job         : Student
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
ext_widgets: {rCharts: [libraries/nvd3]}

---
## Overview

1. Intoduction to World Hunger statistics
2. Assignment details
3. Summary

--- .class #id 

## World Hunger statistics

The data used for this assignment is "hunger.csv"  data file from one of the Coursera course.
This data is used for assignment to Number of hungry children per year and per country.


<div id = 'chart1' class = 'rChart nvd3'></div>
<script type='text/javascript'>
 $(document).ready(function(){
      drawchart1()
    });
    function drawchart1(){  
      var opts = {
 "dom": "chart1",
"width":    650,
"height":    400,
"x": "YEAR",
"y": "TCOUNT",
"type": "multiBarChart",
"id": "chart1" 
},
        data = [
 {
 "YEAR": 1999,
"TCOUNT":         1217.3 
},
{
 "YEAR": 2000,
"TCOUNT":         3036.6 
},
{
 "YEAR": 2001,
"TCOUNT":         1162.7 
},
{
 "YEAR": 2002,
"TCOUNT":          896.1 
},
{
 "YEAR": 2003,
"TCOUNT":         1022.7 
},
{
 "YEAR": 2004,
"TCOUNT":          952.7 
},
{
 "YEAR": 2005,
"TCOUNT":         1165.1 
},
{
 "YEAR": 2006,
"TCOUNT":           2197 
},
{
 "YEAR": 2007,
"TCOUNT":         1052.2 
},
{
 "YEAR": 2008,
"TCOUNT":            993 
},
{
 "YEAR": 2009,
"TCOUNT":            560 
},
{
 "YEAR": 2010,
"TCOUNT":          408.6 
},
{
 "YEAR": 2011,
"TCOUNT":          486.6 
} 
]
  
      if(!(opts.type==="pieChart" || opts.type==="sparklinePlus" || opts.type==="bulletChart")) {
        var data = d3.nest()
          .key(function(d){
            //return opts.group === undefined ? 'main' : d[opts.group]
            //instead of main would think a better default is opts.x
            return opts.group === undefined ? opts.y : d[opts.group];
          })
          .entries(data);
      }
      
      if (opts.disabled != undefined){
        data.map(function(d, i){
          d.disabled = opts.disabled[i]
        })
      }
      
      nv.addGraph(function() {
        var chart = nv.models[opts.type]()
          .width(opts.width)
          .height(opts.height)
          
        if (opts.type != "bulletChart"){
          chart
            .x(function(d) { return d[opts.x] })
            .y(function(d) { return d[opts.y] })
        }
          
         
        chart
  .margin({
 "left":    100 
})
          
        chart.xAxis
  .axisLabel("Year")
  .width(    70)

        
        
        chart.yAxis
  .axisLabel("Count")
  .width(    80)
      
       d3.select("#" + opts.id)
        .append('svg')
        .datum(data)
        .transition().duration(500)
        .call(chart);

       nv.utils.windowResize(chart.update);
       return chart;
      });
    };
</script>

--- .class #id 

## Assignment details

Assignment is for developing as a shiny application for learning shiny package.
The application includes the following:

1. Input Year range in form of slider, Gender in form of checkbox and others widgets 
2. server.R contains the code for data processing and rendering data and plots for ui.R
3. This application has three tabs which show hunger count details by country, by year and also provides ability to view and download data.
4. All source code and related document are available on git hub server.


--- .class #id 

## Summary

Data show hungry children statistic for all countries from year 1990 to 2015.
Most countries very few hungry children compare to countries like Bangladesh.


