#gitignore -> ignora os arquivos/pastas mencionadas
library(renv)
library(tidyverse)
library(knitr)
library(data.table)
library(rvest)
renv::init() ##cria uma pasta para armazenar os pacotes que forem inicializados
renv::status() ##verifica o versionamento daquilo que está guardado e se há algo diferente não armazenado/registrado
renv::snapshot() ##registrar os pacotes novos instalados no ambiente

