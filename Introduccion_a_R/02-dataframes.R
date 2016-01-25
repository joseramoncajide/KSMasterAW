#############################################################################
# KS Master AW - R
# jose.ramon.cajide@gmail.com, 2015-01-09
#
# Dataframes
#
#############################################################################


# creación ----------------------------------------------------------------

date <- as.Date(rep("2015-12-12",3))
medium <- c("(none)", "organic", "cpc")
sessions <- c(1250,1640,250)
traffic <- data.frame(date, medium, sessions)
traffic


#si queremos editar o crear un df
traffic <- edit(traffic)

attributes(traffic)
attributes(traffic)$names
attributes(traffic)$class
class(traffic)
dim(traffic)
str(traffic)

traffic[,2]
traffic[1,3]
traffic[c(2,3),]
traffic[1:3,2:3]
traffic[-1]
traffic[c(2,3),]

traffic[,c("sessions")]
traffic$sessions

traffic$medium
str(traffic)
levels(traffic$medium)

require(MASS)
data("Cars93")
Cars93
summary(Cars93$Cylinders)


# importación -------------------------------------------------------------

datos <- read.table("data/Weights.txt") #importando datos
datos <- read.table("data/Weights.txt", header = TRUE, sep = ".")
datos


# missing data ------------------------------------------------------------

is.na(datos)
is.na(datos[1,1])
mean(datos$Weight)
mean(na.omit(datos$Weight))
mean(datos$Weight, na.rm = T)

complete.cases(datos)
datos_completos <- datos[complete.cases(datos),]
datos_completos

#Ausencia de datos en series temporales

sesiones <- data.frame(mobile = abs(cumsum(rnorm(100))), desktop = abs(cumsum(rnorm(100))))
sesiones
par(mfrow = c(2,1))
plot(sesiones$mobile, type = 'l')
plot(sesiones$desktop, type = 'l')
sesiones[40:50,1] <- NA
sesiones[50:60,2] <- NA

plot(sesiones$mobile, type = 'l')
plot(sesiones$desktop, type = 'l')
par(mfrow = c(1,1))

#Rellenando datos
install.packages('xts')
require(xts)
#Método 1
?na.locf
sesiones <- na.locf(sesiones)
plot(sesiones$mobile, type = 'l')
plot(sesiones$desktop, type = 'l')

#Método 2
sesiones[40:50,1] <- NA
sesiones[50:60,2] <- NA
?na.fill
sesiones <- na.fill(sesiones, fill = 'extend')
#ojo: convierte el dataframe a matrix
class(sesiones)
plot(sesiones[,1], type = 'l')
plot(sesiones[,2], type = 'l')



# outliers ----------------------------------------------------------------

sessions.df <- read.table('data/outliers.csv', sep = ',', header = T)
plot(sessions.df, type = 'l') #vemos que hay valores extremos
boxplot(sessions.df$sessions) #vemos que hay valores extremos

#localizamos los valores extremos. Si sólo es uno:
max(sessions.df$sessions)
#si son varios
outliers <- boxplot(sessions.df$sessions, plot=FALSE)$out
outliers
#método base
sessions.df[sessions.df$sessions %in% outliers,]

#con dplyr
#library(dplyr)
#sessions.df %>% filter(sessions.df$sessions %in% outliers)

plot(sessions.df, type = 'l') #vemos que hay valores extremos
abline(v= 36, , col= 'red',lty=3) #dotted

#Eliminamos los valores extremos

#podemos borrarlos de la serie: No sería lo correcto ya que estamos dando por echo que no hay datos de dos días
incorrecto <- sessions.df[!sessions.df$sessions %in% outliers,]
plot(incorrecto, type = 'l') 

#o dejarlos en blanco
sessions.df[sessions.df$sessions %in% outliers,]$sessions <- NA
is.na(sessions.df) # ver fila 36
plot(sessions.df, type = 'l')  

# y rellenarlos
require(xts)
sessions.df$sessions <- na.fill(sessions.df$sessions, fill = 'extend')
plot(sessions.df, type = 'l') 
abline(v= 36, , col= 'green',lty=3) #dotted


# scrapping ---------------------------------------------------------------


install.packages('rvest')
library(rvest)
url <- "https://es.wikipedia.org/wiki/Provincia_de_Espa%C3%B1a"
tmp <- html(url)
tmp <- html_nodes(tmp, "table")
length(tmp)
provincias <- html_table(tmp[2])
provincias <- as.data.frame(provincias)

?write.csv()
