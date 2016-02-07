rm(list = ls())


# RGA ---------------------------------------------------------------------

# Instalamos el paquete RGA. En este momento la versión en la 0.4.1
install.packages("RGA")

# Lo cargamos en nuestro entorno
library("RGA")

# Nos autorizamos en Google con la cuenta de Alumnos de Kschool
authorize()
authorize(username = "kschool.alumnos@gmail.com")

# Especificamos la vista de GA a la que nos vamos a conectar
ga.profileId <- '46728973'

# Fechas
start.date <- '2012-01-01'
end.date = '2015-12-31'

# Obtenemos los datos
ga.df <-
  get_ga(
    profileId = ga.profileId,
    start.date = start.date,
    end.date = end.date,
    metrics = "
    ga:sessions,
    ga:goal1Completions,
    ga:goal2Completions,
    ga:goal3Completions
    ",
    dimensions = "ga:date",
    sort = "-ga:date",
    segment = 'gaid::-12',
    filters = ""
  )

# Examinamos los datos
head(ga.df)
summary(ga.df)



# ganalytics --------------------------------------------------------------

install.packages("devtools")
devtools::install_github("jdeboer/ganalytics")

# Reinicia R

# Lo cargamos en nuestro entorno
library(ganalytics)

# Especificamos la vista de GA a la que nos vamos a conectar
ga.profileId <- '46728973'

# Fechas
start.date <- '2012-01-01'
end.date = '2015-12-31'

myQuery <- GaQuery(ga.profileId)
DateRange(myQuery) <- c(start.date, end.date)
Metrics(myQuery) <- c(
  'ga:sessions',
  'ga:goal1Completions',
  'ga:goal2Completions',
  'ga:goal3Completions'
)
Dimensions(myQuery) <- c("ga:date")
Segment(myQuery) <- 'gaid::-12'
SortBy(myQuery) <- "-date"

ga2.df <- GetGaData(myQuery)

# Examinamos los datos
head(ga2.df)
summary(ga2.df)
