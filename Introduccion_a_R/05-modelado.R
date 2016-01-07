#############################################################################
# KS Master AW - R
# jose.ramon.cajide@gmail.com, 2015-01-09
#
# Caso práctico de modelado con R y Google Analytics 
#############################################################################

#install.packages("RGA")
library("RGA")
library("dplyr")
library("ggplot2")

dir <- "~/Documents/GitHub/KSMasterAW-R/"
setwd(dir)

#Conectamos a la api de Google Analytics
authorize(new.auth = TRUE)


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


dim(ga.df)
head(ga.df)


write.csv(ga.df, file = 'data/kschool_goals.csv', row.names = F)

goals.df <- read.csv('data/kschool_goals.csv', sep = ',', stringsAsFactors = F)
goals.df <- tbl_df(goals.df) 

#comprobamos que se ha identificado correctamente cada tipo de dato
glimpse(goals.df)

goals.df$date <- as.Date(goals.df$date)

names(goals.df) <- c('fecha', 'sesiones', 'descargas', 'reservas', 'contactos')

pairs(goals.df[,2:5])



correlation_matrix<-cor(goals.df[,2:5])
round(correlation_matrix,2)

install.packages('corrplot')
library(corrplot)
corrplot(correlation_matrix, method="color")
corrplot(correlation_matrix, method="number", type="lower", order="hclust")
corrplot(correlation_matrix, method="circle")
corrplot(correlation_matrix, method="pie")


plot(goals.df$sesiones, goals.df$descargas)
qplot(goals.df$sesiones, goals.df$descargas) 

modelo <- lm(descargas ~ sesiones, data=goals.df)

summary(modelo)

coefficients(modelo)

predict(modelo)

resid(modelo)

plot(resid(modelo))

plot(goals.df$sesiones, goals.df$descargas)
abline(modelo, col='red')

#con ggplot
qplot(goals.df$sesiones, goals.df$descargas) + geom_smooth(lwd = 1, se = T, method = "lm")


install.packages('forecast')
library(forecast)
prediccion <- forecast(modelo, newdata=data.frame(sesiones=c(12,311)))
prediccion
plot(prediccion, xlab="Sesiones", ylab="Descargas")




# time series -------------------------------------------------------------


install.packages('lubridate')
library(lubridate)

goals_por_mes.df <- goals.df %>% 
  mutate(mes = month(fecha), year = year(fecha)) %>% 
  group_by(year, mes) %>% 
  summarise(descargas = sum(descargas), sesiones = sum(sesiones), reservas = sum(reservas))


s.date <- c(2012,1)    
e.date <- c(2015,12)   

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


componentes <- decompose(descargas.ts)
plot(componentes)

#Ejercicio. Realiza lo mismo para la sesiones. ¿Hay estacionalidad en la serie?

sesiones.ts <- ...

#Comprobamos si el modelo se ajusta a la realidad
modelo_predictivo <- HoltWinters(descargas.ts)
plot(modelo_predictivo)


#Como sí se ajusta procedemos a realizar una predicción
forecast2 <- forecast.HoltWinters(modelo_predictivo, h=6)
plot(forecast2)
#lines(fitted(forecast2), col='red', lty= 'longdash')


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

