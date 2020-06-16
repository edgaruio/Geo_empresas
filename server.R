library(plotly)

shinyServer(function(input, output){
  
  ### ========= PUNTO --------------

  bd_mapa_punto<-eventReactive(input$go,{
    aux1 <- data.frame(CX = as.numeric(input$CX), CY = as.numeric(input$CY))
    return(aux1)
  })

  bd_empresa <- eventReactive(input$go,{
    aux1 <- empresa %>% 
      filter(!is.na(cx_empresa))
    aux1$Dist_E <- round(distHaversine(aux1[,c("cx_empresa","cy_empresa")], bd_mapa_punto()[,c("CX","CY")])/1000,1)
    aux1 <- aux1 %>% filter(Dist_E<input$Distancia)
  })
  
  paleta <- eventReactive(input$go,{
    pal <- colorFactor(palette = 'Dark2',domain = bd_empresa()$Piramide1)
  })

  output$Mapapunto <- renderLeaflet({
    
    aux_punto <- bd_mapa_punto()

    map <- leaflet(options = leafletOptions(zoomControl = FALSE, attributionControl=FALSE, minZoom = 8, maxZoom = 16))
    map %>%
      addProviderTiles(provider = "CartoDB.Positron",
                       options = providerTileOptions(opacity = 1)) %>%
      addMarkers(data = aux_punto,lng =~ CX, lat =~ CY) %>%
      addCircles(data = aux_punto, lng = ~CX, lat = ~CY, color = "steelblue", radius = input$Distancia*1000) %>%
      addCircleMarkers(data = bd_empresa(), lng = ~cx_empresa, lat = ~cy_empresa, fillOpacity = 0.6, color = ~paleta()(bd_empresa()$Piramide1), stroke = FALSE, 
                       radius = ~ifelse(bd_empresa()$Piramide1 == "1 Emp Grandes", 15,
                                        ifelse(bd_empresa()$Piramide1 == "2 Emp Medio", 10,
                                               ifelse(bd_empresa()$Piramide1 == "3 Empresas Pymes", 6, 
                                                      ifelse(bd_empresa()$Piramide1 == "4 Micro", 2 , 10))))) %>%
      addLegend(pal=paleta(), values= bd_empresa()$Piramide1, opacity=0.7, title = "Piramide 1", position = "bottomright") %>%
      addPolygons(data=localidad, fill = F, stroke = T, color = "navy", weight = 1) %>%
      addPolygons(data=cundi, fill = F, stroke = T, color = "red", weight = 1) %>%
      addLayersControl(
        # baseGroups  = c("1 Emp Grandes","2 Emp Medio","3 Empresas Pymes","4 Micro"),
        overlayGroups =  c("Agencia de Empleo","Centros de Servicio","Educación","Supermercados","Medicamentos","Recreación y Turismo","Salud","Vivienda"),
        options = layersControlOptions(collapsed = FALSE), position = "bottomleft") %>%
      addMarkers(data=AGENCIA, lng =~CX, lat =~CY, popup = ~as.character(NOMBRE),label = ~as.character(paste(NOMBRE)),
                 icon = leafIconsAG, group = "Agencia de Empleo") %>%
      addMarkers(data=CSERVICIOS, lng =~CX, lat =~CY, popup = ~as.character(NOMBRE),label = ~as.character(paste(NOMBRE)),
                 icon = leafIconsCS, group = "Centros de Servicio") %>%
      addMarkers(data=EDUCACION, lng =~CX, lat =~CY, popup = ~as.character(NOMBRE),label = ~as.character(paste(NOMBRE)),
                 icon = leafIconsED, group = "Educación") %>%
      addMarkers(data=SUPERMERCADOS, lng =~CX, lat =~CY, popup = ~as.character(NOMBRE),label = ~as.character(paste(NOMBRE)),
                 icon = leafIconsSP, group = "Supermercados") %>%
      addMarkers(data=MEDICAMENTOS, lng =~CX, lat =~CY, popup = ~as.character(NOMBRE),label = ~as.character(paste(NOMBRE)),
                 icon = leafIconsDR, group = "Medicamentos") %>%
      addMarkers(data=RYT, lng =~CX, lat =~CY, popup = ~as.character(NOMBRE),label = ~as.character(paste(NOMBRE)),
                 icon = leafIconsRYT, group = "Recreación y Turismo") %>%
      addMarkers(data=SALUD, lng =~CX, lat =~CY, popup = ~as.character(NOMBRE),label = ~as.character(paste(NOMBRE)),
                 icon = leafIconsSL, group = "Salud") %>%
      addMarkers(data=VIVIENDA, lng =~CX, lat =~CY, popup = ~as.character(NOMBRE),label = ~as.character(paste(NOMBRE)),
                 icon = leafIconsVV, group = "Vivienda") %>%
      hideGroup(c("Centros de Servicio","Educación","Supermercados","Medicamentos","Recreación y Turismo","Salud","Vivienda")) %>%
      # addLegend(pal=mypalette, values=~aportes_pro, opacity=0.9, title = "Aportes Promedio", position = "bottomright") %>%
      setView(input$CX, input$CY, zoom = 15) %>% 
      addMiniMap(tiles = providers$CartoDB.Positron,toggleDisplay = TRUE) 
  })

  output$downloadData <- downloadHandler(
    filename = function(){
      paste("Empresas", Sys.time(), ".csv", sep = "_")
    },
    content = function(file){
      write.csv2(bd_empresa() %>% select(id_empresa,RazonSocial,Piramide1,Piramide2) %>% distinct(), file, row.names = F)
    }
  )
  
  output$info_emp1 <- renderValueBox({
    data_f1<-bd_empresa()
    valueBox(
      value = formatC(length(unique(data_f1$id_empresa)),digits = 0, format = "d", big.mark=","),
      subtitle = "Total Empresas",
      icon = icon("home"),
      color = "blue"
    )
  })

  output$info_emp2 <- renderValueBox({
    data_f1<-bd_empresa()
    valueBox(
      value = formatC(sum(data_f1$NumEmpleados, na.rm = T),digits = 0, format = "d", big.mark=","),
      subtitle = "Total Empleados Empresas",
      icon = icon("user"),
      color = "blue"
    )
  })

  output$info_emp3 <- renderValueBox({
    data_f1<-bd_empresa()
    valueBox(
      value = formatC(sum(data_f1$promedio_aportes, na.rm = T)/1000000,digits = 0, format = "d", big.mark=","),
      subtitle = "Total Aporte Promedio (M)",
      icon = icon("dollar"),
      color = "blue"
    )
  })
  
  output$info_emp4 <- renderValueBox({
    data_f1<-bd_empresa()
    valueBox(
      value = formatC(sum(data_f1$promedio_remaneto, na.rm = T)/1000000,digits = 0, format = "d", big.mark=","),
      subtitle = "Total Remanente Promedio (M)",
      icon = icon("dollar"),
      color = "blue"
    )
  })
  
  output$plot1 <- renderPlotly({
    data_plot <- bd_empresa() %>%
      dplyr::select(id_empresa,Piramide1) %>%
      group_by(Piramide1) %>%
      summarise(Conteo = n_distinct(id_empresa)) %>% 
      arrange(desc(Conteo))
    
    m <- list(l = 100,r = 0,b = 50,t = 100, pad = 0)
    colors <- c('rgb(333,133,133)', 'rgb(111,103,167)', 'rgb(222,104,87)')
    f1 <- list(family = "Arial, sans-serif",size = 18,color = "lightgrey")
    f2 <- list(family = "Old Standard TT, serif",size = 14,color = "lightgrey")
    
    data_plot %>% 
      plot_ly(x = ~Conteo, y = ~reorder(Piramide1,Conteo), type = 'bar', orientation = 'h') %>%
      layout(margin = m,
             title = 'Piramide 1',
             xaxis = list(title = ""),
             yaxis = list(title = "")) %>%
      config(displayModeBar = F)
  })
  
  output$plot2 <- renderPlotly({
    data_plot <- bd_empresa() %>%
      dplyr::select(id_empresa,Piramide2) %>%
      group_by(Piramide2) %>%
      summarise(Conteo = n_distinct(id_empresa)) %>% 
      arrange(desc(Conteo))
    
    m <- list(l = 100,r = 0,b = 50,t = 100, pad = 0)
    colors <- c('rgb(333,133,133)', 'rgb(111,103,167)', 'rgb(222,104,87)')
    f1 <- list(family = "Arial, sans-serif",size = 18,color = "lightgrey")
    f2 <- list(family = "Old Standard TT, serif",size = 14,color = "lightgrey")
    
    data_plot %>% 
      plot_ly(x = ~Conteo, y = ~reorder(Piramide2,Conteo), type = 'bar', orientation = 'h') %>%
      layout(margin = m,
             title = 'Piramide 2',
             xaxis = list(title = ""),
             yaxis = list(title = "")) %>%
      config(displayModeBar = F)
  })
  
  
  
  
  
  
})
