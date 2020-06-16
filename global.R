## ================== 0. Paquetes ------------------------------------------------
# options(scipen = 999) 1018426823

library(shiny);library(dplyr)
library(shinydashboard);library(shinythemes)
library(DT);library(leaflet);library(shinyjs)
library(data.table); library(readxl); 
library(leaflet.extras); library(geosphere); library(rgdal)
library(Hmisc); library(tidyr); library(plotly)

# # ================== 1. Datos ------------------------------------------------
# consolidada <- readRDS("//Bogak08beimrodc/bi/Base_Mes/ConsolidadosMensuales/ConsolidacionMAY2020.rds")
# names(consolidada)
# empresa <- consolidada %>%
#   select(id_empresa:Num_cesantias) %>%
#   distinct() %>% 
#   mutate(cx_empresa = ifelse(cx_empresa == 0, NA, cx_empresa),
#          cy_empresa = ifelse(cy_empresa == 0, NA, cy_empresa)) %>% 
#   filter(!is.na(cx_empresa))
# table(duplicated(empresa$id_empresa))
# names(empresa)
# saveRDS(empresa,"Data/Empresa.rds")

empresa <- readRDS("Data/Empresa.rds") %>%
  data.frame() 
str(empresa)
names(empresa)

## Capas
cundi <- readRDS("Data/poligonos-localidades/Cundinamarca.rds")
localidad <- readOGR("Data/poligonos-localidades/poligonos-localidades.shp")

# Infraestructura Colsubsidio
infra <- read_excel("Data/INFRAESTRUCTURA_PROPIA_COLSUBSIDIO.xlsx")
AGENCIA  <- infra %>% filter(UES == "AGENCIA DE EMPLEO")
CSERVICIOS <- infra %>% filter(UES=="CENTROS DE SERVICIO")
EDUCACION <- infra %>% filter(UES=="EDUCACION")
MERCADEO_SOCIAL <- infra %>% filter(UES=="MERCADEO SOCIAL")
SUPERMERCADOS <- infra %>% filter(TIPO=="SUPERMERCADO")
MEDICAMENTOS <- infra %>% filter(TIPO=="DROGUERIA")
RYT <- infra %>% filter(UES=="RECREACION Y TURISMO")
SALUD <- infra %>% filter(UES=="SALUD")
VIVIENDA <- infra %>% filter(UES=="VIVIENDA")


# Infraestrutura LogColsubsidio
leafIconsAG <- icons(
  iconUrl = ifelse(AGENCIA$UES == "AGENCIA DE EMPLEO",
                   "Data/icons/ICONOS_ACT/LogColsubsidio.png","Data/icons/ICONOS_COLSUBSIDIO/LogColsubsidio.png"),
  iconWidth = 28, iconHeight = 45,
  iconAnchorX = 16, iconAnchorY = 40)

leafIconsCS <- icons(
  iconUrl = ifelse(CSERVICIOS$UES == "CENTROS DE SERVICIO",
                   "Data/icons/ICONOS_ACT/Colsubsidio.png","Data/icons/ICONOS_COLSUBSIDIO/Colsubsidio2.png"),
  iconWidth = 28, iconHeight = 45,
  iconAnchorX = 16, iconAnchorY = 40)

leafIconsED <- icons(
  iconUrl = ifelse(MERCADEO_SOCIAL$UES == "EDUCACION",
                   "Data/icons/ICONOS_ACT/Educacion.png","Data/icons/ICONOS_ACT/Educacion.png"),
  iconWidth = 28, iconHeight = 45,
  iconAnchorX = 16, iconAnchorY = 40)

leafIconsSP <- icons(
  iconUrl = ifelse(MERCADEO_SOCIAL$UES == "EDUCACION",
                   "Data/icons/ICONOS_ACT/Supermercados.png","Data/icons/ICONOS_ACT/Supermercados.png"),
  iconWidth = 28, iconHeight = 45,
  iconAnchorX = 16, iconAnchorY = 40)

leafIconsDR <- icons(
  iconUrl = ifelse(MERCADEO_SOCIAL$UES == "EDUCACION",
                   "Data/icons/ICONOS_ACT/Farmacias.png","Data/icons/ICONOS_ACT/Farmacias.png"),
  iconWidth = 28, iconHeight = 45,
  iconAnchorX = 16, iconAnchorY = 40)

leafIconsRYT <- icons(
  iconUrl = ifelse(MERCADEO_SOCIAL$UES == "EDUCACION",
                   "Data/icons/ICONOS_ACT/Recreacion.png","Data/icons/ICONOS_ACT/Recreacion.png"),
  iconWidth = 28, iconHeight = 45,
  iconAnchorX = 16, iconAnchorY = 40)

leafIconsSL <- icons(
  iconUrl = ifelse(MERCADEO_SOCIAL$UES == "EDUCACION",
                   "Data/icons/ICONOS_ACT/Salud.png","Data/icons/ICONOS_ACT/Salud.png"),
  iconWidth = 28, iconHeight = 45,
  iconAnchorX = 16, iconAnchorY = 40)

leafIconsVV <- icons(
  iconUrl = ifelse(MERCADEO_SOCIAL$UES == "EDUCACION",
                   "Data/icons/ICONOS_ACT/Vivienda.png","Data/icons/ICONOS_ACT/Vivienda.png"),
  iconWidth = 28, iconHeight = 45,
  iconAnchorX = 16, iconAnchorY = 40)


