##carregar bibliotecas
library(renv) ##utilizado para criar pasta que irá armazenar info das bibliotecas usadas
library(tidyverse)
library(knitr) ##RMarkdown -> integrar código e exposição gerada por RMarkdown e YAML
library(summarytools)
library(ggplot2)
library(stringr) ##manipulação de strings
##library(stringi) ##converter char pra utf8 para manipulação
library(stats)

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
base_select <- base_inic %>% select(mes,ano,munic,Regiao,total_furtos,total_roubos,tentat_hom,hom_doloso,latrocinio) %>% mutate(DataCompleta=formData(base_inic$ano,base_inic$mes))
View(base_select)
base_select

##removendo espaços em branco das colunas de Municipio e Regiao

base_select$Regiao <- stringr::str_trim(base_select$Regiao)
##base_select$munic <- stringi::stri_enc_toutf8(base_select$munic)%>%stringr::str_trim(side="both")
view(base_select)

##Escolha uma variável de seu banco de dados e calcule:
##Media de roubos e furtos por ano para cada região
media_roubosefurtos<-base_select%>%dplyr::group_by(ano)%>%summarize(media_furto=mean(total_furtos),media_roubo=mean(total_roubos),na.rm=TRUE)
media_roubosefurtos

##o desvio padrão
desvpad_roubosefurtos <- base_select%>% dplyr::group_by(ano)%>%summarize(desv_furto=sd(total_furtos),desv_roubo=sd(total_roubos),na.rm=TRUE)
desvpad_roubosefurtos

##os quantis: 25% e 75%
quant25_furtos <- quantile(base_select$total_furtos,probs = (0.25),na.rm = TRUE)
quant25_furtos
quant75_furtos <- quantile(base_select$total_furtos,probs = (0.75),na.rm = TRUE)
quant75_furtos

##Utilizando o pacote summarytools (função descr), descreva estatisticamente a sua base de dados.

summarytools::descr(base_select%>%select(tentat_hom,total_furtos,total_roubos,latrocinio,hom_doloso),na.rm=TRUE)


## Escolha uma variável e crie um histograma. Justifique o número de bins usados.
##a distribuição dessa variável se aproxima de uma "normal"? Justifique.
##his<-hist(base_select$tentat_hom)
ggplot(base_select,aes(x=tentat_hom))+geom_histogram(color="purple",fill="blue",bins=50)+
  labs(x="Tentativa de Homicidio",y="Frequencia")+ggtitle("Histograma de Tentativas de Homicidio entre 20xx e 2022")+
  geom_vline(aes(xintercept=mean(tentat_hom,na.rm=TRUE)),color="red",size=1)
##Não se aproxima de uma normal, visto que a curva não se distribui em torno do ponto médio

##Calcule a correlação entre todas as variáveis dessa base. Quais são as 3 pares de variáveis mais correlacionadas?

correlacao <- cor(base_select%>%select(total_furtos,total_roubos,tentat_hom,hom_doloso,latrocinio))
correlacao

##Crie um scatterplot entre duas variáveis das resposta anterior. 
##Qual a relação da imagem com a correlação entre as variáveis.
ggplot(base_select,aes(x=tentat_hom,y=total_roubos))+geom_point()+geom_smooth()


##crie um gráfico linha de duas das variáveis. Acrescente uma legenda e rótulos nos eixos.
s <-base_select%>%dplyr::group_by(ano)%>%dplyr::filter(munic=="Rio de Janeiro")%>%summarize(sumtr=sum(hom_doloso,na.rm = TRUE))
s
ggplot(s,aes(x=ano,y=sumtr))+geom_line()+labs(x="Ano",y="Homicidio Doloso",title="Homicidios por ano")


tinytex::install_tinytex()