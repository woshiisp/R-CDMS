source('global.R')

myheader <- dashboardHeader(
  titleWidth = "300",title = "GuLou HFC MDS",
  tags$li(class = "dropdown", style = "padding: 8px;",shinyauthr::logoutUI("Logout")),
  #tags$li(class = "dropdown",tags$a(img(src = 'JSCN.jpg',height = '45'))),
  tags$li(class = "dropdown",tags$a(icon("github"), 
                                    href = "https://github.com/paulc91/shinyauthr",
                                    title = "See the code on github"))
  
)

myheader$children[[2]]$children[[2]] <- myheader$children[[2]]$children[[1]]
myheader$children[[2]]$children[[1]] <- tags$img(src = 'JSCN.jpg',height='45',width='100',align = 'left')



mysidebar <- dashboardSidebar(
  collapsed = TRUE,
  width = '300',
  sidebarMenu(id = "mytabs",
    menuItem("HFC网络概览",tabName = "globalview",icon = icon("th"),selected = TRUE),
    menuItem("HFC设备分布图",tabName = "opticalnodes",icon = icon("images")),
    menuItem("光机查询/录入",tabName = "opticalnodes_data",icon = icon("th")),
    menuItem("楼放查询/录入",tabName = "amplifiers_data",icon = icon("th"))
    )
  )

mybody <- dashboardBody(
  #shinyDashboardThemes(theme = "flat_red"),
  shinyjs::useShinyjs(),
  #tags$body(tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")),
  #includeScript("www/returnClick.js"),
  shinyauthr::loginUI("login",title = "用户登录"),
  uiOutput("testUI"),
  
  
  
  
)
  


ui <- dashboardPage(skin = "blue",title = "My Demo App",
                    header = myheader,
                    sidebar = mysidebar,
                    body = mybody
)