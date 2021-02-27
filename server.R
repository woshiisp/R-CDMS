
server <- function(input,output,session){
#credent user name and passwords=============================================
  credentials <- callModule(shinyauthr::login, "login",
                            data = user_base,
                            user_col = user,
                            pwd_col = password,
                            sodium_hashed = TRUE,
                            log_out = reactive(logout_init()))
  
  logout_init <- callModule(shinyauthr::logout, "Logout", reactive(credentials()$user_auth))
  
  observe({
    if(credentials()$user_auth) {
      shinyjs::removeClass(selector = "body", class = "sidebar-collapse")
      
    } else {
      shinyjs::addClass(selector = "body", class = "sidebar-collapse")
   
    }
  })
  
  user_info <- reactive({credentials()$info})
  
  user_data <- reactive({
    req(credentials()$user_auth)
    if (user_info()$permissions == "admin") {
      dplyr::starwars[,1:10]
    } else if (user_info()$permissions == "standard") {
      dplyr::storms[,1:11]
    }
  })

#MySQL select infomation==========================
  loaduserdata <- function(){
          conn <- dbConnect(MariaDB(),user = 'root',password = 'yh010101',
                    host = '127.0.0.1',port = '3306',dbname = 'yanhan')
          opticals <- dbGetQuery(conn = conn,'select * from user')
          dbDisconnect(conn)
          return(opticals)
  
  }
  
  
  loadteamdata <- function(){
    conn <- dbConnect(MariaDB(),user = 'root',password = 'yh010101',
                      host = '127.0.0.1',port = '3306',dbname = 'yanhan')
    teamdata <- dbGetQuery(conn = conn,'select * from teamdata')
    dbDisconnect(conn)
    return(teamdata)
    
  }
  
#render opticals table============================  
  output$mytable <- renderDataTable({
    cb <- htmlwidgets::JS('function(){debugger;HTMLWidgets.staticRender();}')
    opticals <- loaduserdata()
    dt <- datatable(data = opticals,
                    rownames = FALSE,
                    escape = FALSE,
                    options = list(drawCallback =  cb))
    #datatable(data = opticals)
    })
  
  
#测试光机调试数据表格输出formattable=====================
  teamdataframe <- loadteamdata()
  #print(teamdataframe)
  
  output$testtable <- renderFormattable({
    formattable(teamdataframe,
                list(teamid = color_text('black','red'),
                     teammanager = color_text("black","red"),
                     pointlocation = color_tile("transparent","black"),
                     area(col = c(lat)) ~ color_tile("transparent", "pink"),
                     area(col = c(usernum)) ~ normalize_bar("pink",0.2)))
    
  })
 
  
#login success and renderUI==========================
output$testUI <- renderUI({
  req(credentials()$user_auth)
  print(credentials()$user_auth)
  htmlwidgets::getDependency("sparkline", "sparkline")
  #fluidPage(
    #fluidRow(
      #box("xxxxxxxxxxx",width = 6)
    #),
    #fluidRow(
      #ui03
    #)
  #)
  tabItems(
    tabItem(tabName = "globalview",
            h1('JSCN鼓楼广电中心HFC网络状况一览表'),
    ),
    tabItem(tabName = "opticalnodes",
            fluidRow(
                box(title = "boxone",width = 8,leafletOutput("mymap",height = 400)),
                box(title = "boxtwo",width = 4,"My box two")
    )),
    tabItem(tabName = "opticalnodes_data",
            fluidRow(
              column(width = 4,
                box(title = "box1",width = NULL,
                    textInput("opticalnode number input1","请输入1："),
                    textInput("opticalnode number input2","请输入2："))),
              column(width = 8,
                box(width = NULL,dataTableOutput('mytable')))
            )),
    tabItem(tabName = "amplifiers_data",
            box('这个是amplifiers_data页面',width = 4),
            box(formattableOutput('testtable'),width = 8)
    )
  )
  
  

})  
  
#render leaflet of opticalnodes============================  
output$mymap <- renderLeaflet({
  a <- fread("opticalnodes.csv")
  df <- data.frame(a)
  df <- data.frame(Lat = a$log,Lon = a$lat)
  size <- runif(7, 5, 10)
  co <- substr(rainbow(7),1,7)
  df %>% leaflet() %>% addTiles() %>% addCircleMarkers(lng = ~Lat,lat = ~Lon,radius = ~size,color = 'blue',fill = TRUE) %>% setView(lng=118.767767,lat=32.09149,zoom=12.2)
})
  


 


}


