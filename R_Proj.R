##carregar bibliotecas
library(renv) ##utilizado para criar pasta que irá armazenar info das bibliotecas usadas
library(tidyverse)
library(knitr) ##RMarkdown -> integrar código e exposição gerada por RMarkdown e YAML
library(summarytools)
library(ggplot2)
library(stringr) ##manipulação de strings

renv::init() ##cria uma pasta para armazenar os pacotes que forem inicializados
renv::status() ##verifica o versionamento daquilo que está guardado e se há algo diferente não armazenado/registrado
renv::snapshot() ##registrar os pacotes novos instalados no ambiente

##abrir o arquivo com os dados
base_inic <- read.csv2("~/ProjetoEst/R/aux/BaseDPEvolucaoMensalCisp.csv")
##Visualizar Base
View(base_inic)

##Criar coluna no formato YYYY-MM-DD
formData <- function(YY,MM)
  {
   formated<-stringr::str_c(YY,MM,"01",sep="-")
    date_t<-as.Date(formated,format="%Y-%m-%d")
    return(date_t)
  }
##selecionando variaveis de interesse
base_select <- base_inic %>% select(mes,ano,munic,Regiao,total_furtos,total_roubos,tentat_hom) %>% mutate(DataCompleta=formData(base_inic$ano,base_inic$mes))
View(base_select)
base_select

##Escolha uma variável de seu banco de dados e calcule:
##a média para todos os eventos
base_select%>%dplyr::group_by(DataCompleta)%>%summarize(media_furto=mean(total_furtos),media_roubo=mean(total_roubos),na.rm=TRUE)%>%dplyr::arrange(desc(DataCompleta))

##o desvio padrão
##os quantis: 25% e 75%

