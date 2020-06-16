# Dashboard
library(plotly)

dashboardPage(skin = "blue",
              dashboardHeader(title = "Geo_empresas"),
              dashboardSidebar(
                sidebarMenu(disable = TRUE, br(),
                            tags$img(src = "Logo.png", height=40, width=200, align="center"),
                            tags$hr(),
                            shinyjs::hidden(menuItem("INSTRUCCIONES", tabName = "dummy")),
                            tags$hr(),
                            menuItem("PUNTO", tabName = "punto", icon = icon("dashboard"),
                                     menuSubItem("Check", tabName = "punto", icon = icon("check-circle")),
                                     sliderInput("Distancia", label = h3("Distancia (km)"), min = 0.1,max = 5, step = 0.1, value=1),
                                     h5("Escriba coordenadas"),
                                     textInput("CX",label = "Longitud", value = "-74.10858316"),
                                     textInput("CY", label = "Latitud", value = "4.62808999"),
                                     br(),
                                     actionButton("go", label = "Go"),
                                     br(),
                                     tags$a("Consulta Coordenadas", 
                                            href = "https://geoportal.dane.gov.co/v3/en/catastro.html")
                                     ),
                            tags$hr()
                            )),
              dashboardBody(
                tags$style(type="text/css",
                           ".shiny-output-error { visibility: hidden; }",
                           ".shiny-output-error:before { visibility: hidden; }"),
                tabItems(
                  tabItem("dummy",
                          fluidRow(
                            column(1),
                            column(10,
                                   h1("Aplicacion Georreferenciación Empresas"),
                                   br(),br(),
                                   h3("La presente aplicacion tiene por objetivo ser una herramienta de consulta de información de empresas por punto de interes"),
                                   br(),
                                   h3("En la siguiente pestaña muestra informacion global de Empresas por Piramide 1 y Piramide 2"),
                                   br(),
                                   h3("Nota: Debe dar click en el boton 'Check' para cambiar el panel principal. 
                                      Al cambiar los filtros debe dar click en 'Go' para visualizar la información"),
                                   br(),
                                   h4("Fecha actualizacion: 16/06/2020 (Corte Mayo)")
                            ),
                            column(1)
                          )
                  ),
                  tabItem(tabName = "punto",
                          h3("Ubicacion punto"),
                          p(class = "text_small", "En esta seccion puede encontrar la geolocalizacion del punto y resumen descriptivo"),
                          fluidRow(
                            column(width = 6,
                                 fluidRow(
                                   box(title = "Ubicacion Punto (Corte Mayo)",status = "primary", solidHeader = TRUE,collapsible = TRUE,
                                       leafletOutput("Mapapunto", height = 750), width=12),
                                   downloadButton("downloadData", "Descargar Base Empresas")
                                   )
                                 ),
                            column(width = 6,
                                 fluidRow(
                                   box(title = "Resumen Empresas",status = "primary", solidHeader = TRUE,collapsible = TRUE, width = 12,
                                       valueBoxOutput("info_emp1",width = 3),
                                       valueBoxOutput("info_emp2",width = 3),
                                       valueBoxOutput("info_emp3",width = 3),
                                       valueBoxOutput("info_emp4",width = 3))
                                   ),
                                 fluidRow(
                                   box(title = "Resumen Empresas por Piramide 1",status = "primary", solidHeader = TRUE,collapsible = TRUE,
                                       plotlyOutput("plot1"), width = 12)
                                 ),
                                 fluidRow(
                                   box(title = "Resumen Empresas por Piramide 2",status = "primary", solidHeader = TRUE,collapsible = TRUE,
                                       plotlyOutput("plot2"), width = 12)
                                 ))
                            )
                  )
                )
              )
)

