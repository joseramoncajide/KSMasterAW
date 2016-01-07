#############################################################################
# KS Master AW - R
# jose.ramon.cajide@gmail.com, 2015-01-09
#
# Introducción a R
# 
#############################################################################

# Asignación de variables

1
2  
1 + 2

x <- 1
y <- 2
z <- 3

x + y
x + y - z

## Números, cadenas y lógicos
num <- 10
string <- "Hola, Mundo"
boolean <- TRUE

class(num)
class(string)
class(boolean)

is.numeric(num)
is.numeric(string)
is.character(string)
is.character(boolean)

#Cambiar el tipo de datos
as.character(num)
as.character(boolean)
as.numeric(string)
as.numeric(boolean)

#Ojo. El valor no se ha asigando
class(num)
num
num <- as.character(num)
class(num)
num
num + 2
num <- as.numeric(num)
num + 2

num < 10
num != 10
num == 10 # OJO: No usar = ya que es símbolo de asignación
string == "Hola, Mundo"


## Workspace 

### Directorio de trabajo
getwd()
dir <- "/" #usar la tecla tabulador tab para completar
dir <- "~/Documents/GitHub/KSMasterAW-R/"
dir
setwd(dir)
getwd()

### Entorno
x <- 10
y <- 20
x + y
ls()  
rm(y)
y
ls()
rm(list = ls())

### Funciones

sqrt()
?sqrt
help(sqrt)
??sqrt
example(sqrt)
sqrt(12)

#install.packages("datasets")
data()
data(cars)
?cars
summary(cars)
plot(cars)

## Operaciones básicas

x <- 10
y <- 8
z <- -3


x + y + z
x - y
x*y
x^3

pi
round(pi, 0)
round(pi, 4)
floor(pi)
cos(pi) #sin #tan
abs(cos(pi))
log(x)
log10(x)

exp(1)
factorial(4)
1*2*3*4


#### EJERCICIO
#### Calcular la longitud de una moneda de 1€ sabiendo que su diametro es 23.25 mm
#### Fórmula: longitud = pi * radio2 

radio <- ...
longitud <- ...
longitud

# sol ---------------------------------------------------------------------
radio <- 23.25 / 2
longitud <- pi * radio^2
longitud


## FUNCIONES PERSONALIZADAS

suma <- function() {
  return(2+2)
}

suma()

suma <- function(a,b) {
  return(a+b)
}

suma(2,6)

#### EJERCICIO
# Crea una función "longitud.moneda" a la que facilitándole un diámentro 
# calcule la longitud de la circunferencia de cualquier moneda 

longitud.moneda <- function () {
  #calcula el radio:
  radio <- 
  #calcula la longitud:
  longitud <- 
  return(longitud) 
}

#Comprueba que la función devuelve correctamente el resultado ejecutado
longitud.moneda(23.25)


# sol ---------------------------------------------------------------------

longitud.moneda <- function (diametro) {
     radio <- diametro / 2;
     longitud <- pi * radio^2;
     return(longitud) 
     #print(paste('La longitud es de:',round(longitud,2), 'mm.'))
}

longitud.moneda(23.25)


## VECTORES

x <- 15
vec <- c(1,2,3,4,5)
class(vec)
str(vec)
1:5
vec2 <- 10:14
vec2
vec2[1]
vec2[1:3]
length(vec2)

vec2 + vec
vec2 - vec
3*vec2
sqrt(vec2)

char_vec <- c("Hola", "Mundo")

hummm <- c("Hola", 10) #coerce
hummm

## Sequencias
seq(1:10)
seq(1,10)
seq(from=1, to=10, by=.5)
rep(1:5, 2)

## Funciones estadísticas básicas
x_vec <- c(1,2,4,5,6,3,9,5)

sum(x_vec)
min(x_vec)
max(x_vec)
range(x_vec)

mean(x_vec)
median(x_vec)

#Medidas de disperión

#Varianza: esperanza del cuadrado de la desviación de dicha variable respecto a su media
var(x_vec)

#Desviación estándar: Se define como la raíz cuadrada de la varianza de la variable
sqrt(var(x_vec))
sd(x_vec)

#Correlación: indica la fuerza y la dirección de una relación lineal y proporcionalidad entre dos variables estadísticas. 
cor(x_vec, x_vec)

y_vec <- c(2,4,6,5,5,4,5,8)

cor(x_vec, y_vec)

## MATRICES

a.mat <- matrix(c(30,32,31,27,36,72,60,78,67,71,55,57,56,55,49),ncol = 3)
colnames(a.mat) <- c("Fairbanks","San Francisco","Chicago")
rownames(a.mat) <- paste("3/",12:16,sep = '')

b.mat <- matrix(c(88,85,83,81,78,62,61,54,60,65,90,92,91,89,90),ncol=3)
colnames(b.mat) <- c("Los Angeles","Seattle","Honolulu")
rownames(b.mat) <- paste("3/",12:16,sep='')

ciudades.mat <- cbind(a.mat, b.mat)

ncol(ciudades.mat)
nrow(ciudades.mat)
dim(ciudades.mat)

#Acceder a una fila
ciudades.mat[1,]

#Acceder a una columna: Los Ángeles
ciudades.mat[,4]

#Acceder a la penúltima  columna
ciudades.mat[,5]
ciudades.mat[,ncol(ciudades.mat)-1]

#Un subconjuto
ciudades.mat[1:2,1:2]

#Agregar una nueva fila 
#nueva_fila <- matrix(c(36, 71, 49 ,78, 65 ,90), ncol = 6)
#tmp_data <- rbind(tmp_data, nueva_fila)
#rownames(tmp_data[6,])<-"3/17"
#t(tmp_data)

#Un adelanto: ¿cuáles son las temperaturas que se repiten con más frequencia?
hist(ciudades.mat)

rowMeans(ciudades.mat)
colMeans(ciudades.mat)
#Un adelanto
boxplot(ciudades.mat)

#Cuál es la ciudad con mayores diferencias de temperatura
?apply
apply(ciudades.mat, 2, FUN=sd)

#Un adelanto
barplot(apply(ciudades.mat, 2, FUN=sd))

#Existe correlación entre algunos países
cor(ciudades.mat)

heatmap(cor(ciudades.mat))

library(corrgram)
corrgram(ciudades.mat)
corrgram(ciudades.mat, upper.panel=NULL)

summary(ciudades.mat)

summary(t(ciudades.mat))



#### EJERCICIO
# Crea una matriz 'monedas.mat' con los diámetros de varias monedas y calcula para todas ellas su longitud aplicando la función 'longitud.moneda' creada anteriormente a toda la matriz

monedas.mat <- matrix(...)

#Dale un nombre a cada columna
colnames(monedas.mat) <- ...

longitudes <- apply(...)

# Dibuja un digrama de barras con las longitudes obtenedidas

...

# sol ---------------------------------------------------------------------

monedas.mat <- matrix(c(16.25, 19.75, 22.25, 24.25, 23.25, 25.75),ncol = 6)

colnames(monedas.mat)<-c("1 cent.","10 cent.","20 cent.", "50 cent." , "1 euro", "2 euros")

longitudes <- apply(monedas.mat, 2, FUN=longitud.moneda)

# Dibuja un digrama de barras con las longitudes de cada moneda

barplot(longitudes)



## STRINGS

saludo<-"Hola"
saludos<-c("Hola","Hello","Hey")
nombre<-"Mundo"

paste(saludo, nombre)
paste0(saludo, nombre)
paste(saludo, nombre, sep = ', ')
paste(saludo,', ', nombre, '!', sep="")

url <- '/es-es/miamix-c512835000'
idioma <- substr(url, 2,6)
idioma
nchar(url)

#### Aplicación: Obtener el id de producto de la anterior url
id_producto <- substr(url, nchar(url)-9, nchar(url))

urls <- c('/es-es/miamix-c512835000','/es-es/beach-c342891010')

ids_producto <- substr(urls, nchar(urls)-9, nchar(urls))
ids_producto[1]
ids_producto[2]


## BASIC PLOTING

x <- rnorm(500)
xu <- runif(500)
cumsum_x <- cumsum(x)
plot(x)
plot(xu)
plot(cumsum_x)
plot(x, type = 'l')
plot(x, type = 'p')
plot(x, type = 'h')
plot(x, type = 'o')
plot(x, type = 's')
plot(x, type = 'l', col = 'blue') # red, green
title(main = "Mi título", col.main = 'blue', font.main = 3)

# Barcharts & histogram

install.packages('MASS')
require(MASS)
data()
data("caith")
caith

eye_color <- rowSums(caith)
hair_color <- colSums(caith)
barplot(eye_color)
barplot(hair_color)
barplot(eye_color, main = 'Color de ojos', xlab = 'Color' , ylab = 'Nº de personas', density = 20)

barplot(caith)
barplot(as.matrix(caith))
barplot(as.matrix(caith), col = c("blue", "orange", "yellow", "green"))
barplot(t(as.matrix(caith)), col = c("blue", "orange", "yellow", "green"))
barplot(t(as.matrix(caith)), col = c("blue", "orange", "yellow", "green"), beside = TRUE)

## SCATTERPLOTS
data("Cars93")
Cars93
head(Cars93)
ncol(Cars93)
attach(Cars93)
plot(x=Price, y=Weight)
plot(x=Weight, y=MPG.city)
abline(lm(MPG.city~Weight), col = "red")
abline(h = max(MPG.city), col = "red")
abline(v = max(Weight), col = "red")

dotchart(MPG.city)
dotchart(MPG.city, labels=paste(Manufacturer,Model))
dotchart(MPG.city, labels=paste(Manufacturer,Model), cex=.5)

orderedCars <- Cars93[order(MPG.city),]
attach(orderedCars)
dotchart(MPG.city, labels=paste(Manufacturer,Model), cex=.5)

#Más de un gráfico
par(mfrow=c(2,1))
plot(x=Weight, y=MPG.city)
plot(x=Weight, y=Price)

#Ejecutar para dejar la configuración inicial:
par(mfrow=c(1,1))


