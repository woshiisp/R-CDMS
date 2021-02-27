
ui03 <-  fluidPage(
  tabItems(
    #selected = 1,
    tabItem(tabName = "globalview",
            h1('JSCN鼓楼广电中心HFC网络状况一览表'),
            )
            ),
    tabItem(tabName = "opticalnodes",
            box(leafletOutput("mymap",height = 450),width = 8)
            ),
    tabItem(tabName = "opticalnodes_data",
            tableOutput(table))),
  
    print(opticals)
    )
    
