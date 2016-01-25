#############################################################################
# KS Master AW - R
# jose.ramon.cajide@gmail.com, 2015-01-09
#
# Caso práctico de modelado con R y Google Analytics 
#############################################################################

#dev.off()

#install.packages("RGA")
library("RGA")
library("dplyr")
library("ggplot2")

dir <- "~/Documents/GitHub/KSMasterAW-R/"
setwd(dir)

#Conectamos a la api de Google Analytics
authorize()
authorize(username = "kschool.alumnos@gmail.com")

ga_profiles.df <- list_profiles()
ga_profiles.df <- tbl_df(ga_profiles.df)
class(ga_profiles.df)
id <- ga_profiles.df[grep("http://www.kschool.com", ga_profiles.df$website.url), "id"]
first.date <- firstdate('46728973')
goals.df <- list_goals() 
goals.df <- tbl_df(goals.df)
names <- as.vector(t(goals.df[grep("46728973", goals.df$profile.id), "name"]))
class(names)
names(ga.df) <- c('fecha', 'sesiones', names)

#Extraemos de Google Analytics los siguientes datos desde 2012-01-01 hasta 2015-12-31: sesiones, cumplimientos de todos los objetivos (# descargas de programas, # formularios de contacto enviados y # de reservas de plaza realizadas), dimensionadas por fecha y segmentadas para sesiones sin rebote.

ga.df <- get_ga(
  profile.id = '46728973',
  start.date = '...',
  end.date = '...',
  metrics = "...
  ",
  dimensions = "...",
  sort = "...",
  segment = '...',
  filters = "",
  max.results = '',
  sampling.level = "HIGHER_PRECISION"
)


# sol ---------------------------------------------------------------------

ga.df <- get_ga(
  profile.id = '46728973',
  start.date = '2012-01-01',
  end.date = '2015-12-31',
  metrics = "
  ga:sessions,
  ga:goal1Completions,
  ga:goal2Completions,
  ga:goal3Completions
  ",
  dimensions = "
  ga:date
  ",
  sort = "ga:date",
  segment = 'gaid::-12',
  filters = "",
  max.results = '',
  sampling.level = "HIGHER_PRECISION"
)

#comprobamos el resultado devuelto
dim(ga.df)
head(ga.df)

#exportamos el resultado
write.csv(ga.df, file = 'data/kschool_goals.csv', row.names = F)

#cargamos los datos desde el CSV
goals.df <- read.csv('data/kschool_goals.csv', sep = ',', stringsAsFactors = F)
goals.df <- tbl_df(goals.df) 

#comprobamos que se ha identificado correctamente cada tipo de dato
glimpse(goals.df)

#vemos que las fechas se han importado como carácter. Lo corregimos.
goals.df$date <- as.Date(goals.df$date)

#vamos a darle un nombre más descriptivo a nuestras variables
names(goals.df) <- c('fecha', 'sesiones', 'descargas', 'reservas', 'contactos')

#primer examen visual de los datos
pairs(goals.df[,2:5])

#comprobamos las correlación entre variables
correlation_matrix<-cor(goals.df[,2:5])
round(correlation_matrix,2)

#visualizamos la correlación
#install.packages('corrplot')
library(corrplot)
corrplot(correlation_matrix, method="color")
corrplot(correlation_matrix, method="number", type="lower", order="hclust")
corrplot(correlation_matrix, method="circle")
corrplot(correlation_matrix, method="pie")

mean(goals.df$descargas)

#visualizamos los datos de sesiones y descargas
#dev.off() #FIX
plot(goals.df$sesiones, goals.df$descargas)
abline(h=mean(goals.df$descargas), col='green')
qplot(goals.df$sesiones, goals.df$descargas) 

#vamos a modelar los datos
#outcome ~ predictor
#dependent ~ independent
#response ~ explanatory
modelo <- lm(descargas ~ sesiones, data=goals.df)
#fit <- step(lm(Descargas ~ Sesiones, data=goals.df))

#evaluamos el modelo
summary(modelo)

#vemos los coeficientes de la recta de regresión
coefficients(modelo)

#podemos ver los valores (descargas) estimados por nuestro modelo para las sesiones facilitadas
predict(modelo)

#así como ver las diferencias (errores) entre los valores estimados por el modelo y los reales
resid(modelo)

#podemos visualizar los errores del modelo y ver si siguen algún comportamiento no aleatorio
plot(resid(modelo))

####NUEVO
fitted(modelo)
modelo$fitted.values
plot(goals.df$descargas, modelo$fitted, type = 'p', col='blue')


training_index <- 

#visualizamos el modelo

plot(goals.df$sesiones, goals.df$descargas)
abline(modelo, col='red')

#con ggplot
qplot(goals.df$sesiones, goals.df$descargas) + geom_smooth(lwd = 1, se = T, method = "lm")

#hacemos una  sobre la línea de regresión
install.packages('forecast')
library(forecast)
prediccion <- forecast(modelo, newdata=data.frame(sesiones=c(12,311)))
prediccion
plot(prediccion, xlab="Sesiones", ylab="Descargas")

fitted(modelo)


# time series -------------------------------------------------------------

#Creamos una serie temporal mensual
install.packages('lubridate')
library(lubridate)
goals_por_mes.df <- goals.df %>% 
  mutate(mes = month(fecha), year = year(fecha)) %>% 
  group_by(year, mes) %>% 
  summarise(descargas = sum(descargas), sesiones = sum(sesiones), reservas = sum(reservas))


s.date <- c(2012,1)    #start date - factual
e.date <- c(2015,12)   #end date - factual

#Tranformamos los datos a una serie temporal
#goals_por_mes.ts <- ts(goals_por_mes.df[,3:5], start=s.date, end=e.date, frequency=12)
goals_por_mes.ts <- ts(goals_por_mes.df[,c(4,3,5)], start=s.date, end=e.date, frequency=12)
goals_por_mes.ts
class(goals_por_mes.ts)
plot(goals_por_mes.ts, xlab = "Años",
     main = "Evolución Mensual de Sesiones, Descargas de programas y Reservas")

#Análisis de las descargas
descargas.ts <- ts(goals_por_mes.df$descargas, start=s.date, end=e.date, frequency=12)
plot.ts(descargas.ts)
plot(descargas.ts,col="red",main="Descargas de programas",xlab="Tiempo",ylab="Descargas",type="b")



# Filtrado de medias móviles ----------------------------------------------

library(forecast)
mva3.ts <- ma(descargas.ts, order=3) #cuatrimestre
mva4.ts <- ma(descargas.ts, order=4) #trimestral
mva6.ts <- ma(descargas.ts, order=6) #semestral
mva.ts <- cbind(descargas.ts,mva3.ts,mva4.ts, mva6.ts)
plot(mva.ts)
plot(mva.ts,plot.type="single",col=4:1)



# Descomposición de las series --------------------------------------------


#Descomposición de la serie
componentes <- decompose(descargas.ts)
plot(componentes)

#Método avanzado
# componentes <- stl(descargas.ts, 'per')
# plot(componentes)

#Explicar: random

#Ejercicio. Realiza lo mismo para la sesiones. ¿Hay estacionalidad en la serie?

#opcional
library(ggfortify)
autoplot(stl(descargas.ts, s.window = 'periodic'), ts.colour = 'blue')

#Comprobamos si el modelo se ajusta a la realidad
modelo_predictivo <- HoltWinters(descargas.ts)
plot(modelo_predictivo)

# modelo_predictivo$alpha
# modelo_predictivo$beta
# modelo_predictivo$gamma
# modelo_predictivo$coefficients
# sqrt(modelo_predictivo$SSE/length(modelo_predictivo))
# sd(modelo_predictivo$coefficients)
# plot(modelo_predictivo$fitted)

#Como sí se ajusta procedemos a realizar una predicción
forecast2 <- forecast.HoltWinters(modelo_predictivo, h=6)
plot(forecast2)
#lines(fitted(forecast2), col='red', lty= 'longdash')


#opcional
#Para ver si el modelo es mejorable analizamos los errores de la predicción
plot.ts(forecast2$residuals) #Errores de predicción
abline(h=0, col="blue")
#Analizamos si existe autocorrelación entre distintos periodos de tiempo: Autocrrelación
acf(forecast2$residuals, lag.max=20)
#Podemos comprobarlo con un Ljung-Box test
Box.test(forecast2$residuals, lag=20, type="Ljung-Box") 

#Mejorando la visualización
forecast.df <- as.data.frame(forecast2)
totalrows <- nrow(goals_por_mes.df) + nrow(forecast.df)
descargas_ultimo_periodo <- tail(goals_por_mes.df$descargas,1)

forecastdata <- data.frame(mes=c(1:totalrows),
                           actual=c(goals_por_mes.df$descargas,rep(NA,nrow(forecast.df))),
                           forecast=c(rep(NA,nrow(goals_por_mes.df)-1),
                                      descargas_ultimo_periodo,
                                      forecast.df$"Point Forecast"),
                           forecastupper=c(rep(NA,nrow(goals_por_mes.df)-1),
                                           descargas_ultimo_periodo,
                                           forecast.df$"Hi 80"),
                           forecastlower=c(rep(NA,nrow(goals_por_mes.df)-1),
                                           descargas_ultimo_periodo,
                                           forecast.df$"Lo 80")
)

library("ggthemes")

ggplot(forecastdata, aes(x=mes)) +
  geom_line(aes(y=actual),color="grey") +
  geom_point(aes(y=actual), size = 2, pch=21, fill = "white") +
  geom_line(aes(y=forecast),color="#006666",linetype="dotdash", size = 1.0) +
  geom_point(aes(y=forecast), size = 2, colour="#006666") +
  geom_text(aes(y=forecast), label=round(forecastdata$forecast, 0), vjust=-1, size=3.5) +
  geom_ribbon(aes(ymin=forecastlower,ymax=forecastupper),
              alpha=0.4, fill="#00CCCCCC") +
  ggtitle("Descargas de Programas: Evolución y Predicción (6 Meses)") +
  #xlab("Meses (Desde ene/2012") +
  #ylab("Descargas") +
  scale_color_fivethirtyeight("cyl") +
  theme_fivethirtyeight()



# Ejercicio ---------------------------------------------------------------

# Aplicar lo mismo para la tasa de conversión de descargas

goals_por_mes.df <- ...

# sol ---------------------------------------------------------------------


goals_por_mes.df <- goals.df %>% 
  mutate(mes = month(fecha), year = year(fecha)) %>% 
  group_by(year, mes) %>% 
  summarise(descargas = sum(descargas), sesiones = sum(sesiones), descargas = (descargas /sesiones) *100 )



# avanzado ----------------------------------------------------------------



# Regresores sobre la serie -----------------------------------------------

#Vamos a utilizar las sesiones como una variable que influye en el comportamiento de la serie

f.s.date <- c(2016,1)  #start date - prediction
f.e.date <- c(2016,6) #end date - prediction

#Teníamos que:
#descargas.ts <- ts(goals_por_mes.df$descargas, start=s.date, end=e.date, frequency=12)

sesiones.ts <- ts(goals_por_mes.df$sesiones, start=s.date, end=f.e.date, frequency=12)
plot.ts(sesiones.ts)
sesiones_pasadas <- window(sesiones.ts, s.date, e.date)
sesiones_futuras <- window(sesiones.ts, f.s.date, f.e.date)

#Modelo ARIMA sobre la descargas con las sesiones como regresores
modelo.temporal <- auto.arima(descargas.ts, xreg=sesiones_pasadas, stepwise=FALSE, approximation=FALSE) #modelo
forecast <- forecast(modelo.temporal, xreg=sesiones_futuras) #realizamos la predicción
plot(forecast) 
summary(forecast) 

##############

# kk <- ts(goals_por_mes.df[,3:5], start=s.date, end=e.date, frequency=12)
# plot(kk)
# kk$year <- as.factor(kk$year)
# plot(goals_por_mes.df[,c(1,3)], xlab="Year",
#      main="Quarterly changes in US consumption and personal income")
# cor(goals_por_mes.df$descargas, goals_por_mes.df$reservas, method = 'pearson')
# 
# descargas.ts <- ts(goals_por_mes.df$descargas, start=s.date, end=f.e.date, frequency=12)
# reservas.ts <- ts(goals_por_mes.df$reservas, start=s.date, end=e.date, frequency=12)
# plot.ts(reservas.ts)
# descargas_pasadas <- window(descargas.ts, s.date, e.date)
# descargas_futuras <- window(descargas.ts, f.s.date, f.e.date)
# 
# modelo.temporal <- auto.arima(reservas.ts, xreg=descargas_pasadas, stepwise=FALSE, approximation=FALSE) #modelo
# forecast <- forecast(modelo.temporal, xreg=descargas_futuras) #realizamos la predicción
# plot(forecast) 
# summary(forecast) 
# 
# modelo.temporal <- auto.arima(reservas.ts) #modelo
# forecast <- forecast(modelo.temporal) #realizamos la predicción
# plot(forecast) 
# summary(forecast) 

# Fin: Regresores sobre la serie ------------------------------------------

