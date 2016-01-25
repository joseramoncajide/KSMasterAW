#############################################################################
# KS Master AW - R
# jose.ramon.cajide@gmail.com, 2016-01-09
#
# DATA WRANGLING - Práctica Gisela
#############################################################################

library("RGA")
library("tidyr")


# gen data ----------------------------------------------------------------

dir <- "~/Documents/GitHub/KSMasterAW-R/"

setwd(dir)

# authorize(new.auth = TRUE)
authorize()

ga.profileId <- '26384357' #gisela
start.date <- '2015-01-01'
end.date <- '2015-12-31'

ga.df <- get_ga(
  profile.id = ga.profileId,
  start.date = start.date,
  end.date = end.date,
  metrics = "
  ga:sessions
  ",
  dimensions = "
  ga:region,
  ga:month,
  ga:deviceCategory,
  ga:userAgeBracket,
  ga:userGender
  ",
  sort = "-ga:region",
  filters = "ga:country=@spain;ga:region!@not",
  max.results = '',
  sampling.level = "HIGHER_PRECISION"
)

dim(ga.df)
head(ga.df)
ga.df <- ga.df %>% spread(device.category, sessions)

write.csv(ga.df, file = 'data/gisela.csv', row.names = F)

rm(list = ls())



# práctica ----------------------------------------------------------------

library('tidyr')
library('dplyr')

dir <- "~/Documents/GitHub/KSMasterAW-R/"

setwd(dir)

gisela.df <- read.csv('data/gisela.csv', sep = ',', stringsAsFactors = F)
gisela.df <- tbl_df(gisela.df)
glimpse(gisela.df)

sesiones.df <- gisela.df %>%
  mutate (sessions = desktop + mobile + tablet) %>%
  filter(!is.na(sessions)) %>%
  group_by(region, month) %>%
  summarise(sessions = sum(sessions)) %>%
  ungroup()


# preview ggplot ----------------------------------------------------------

library("ggplot2")

plot.df <- sesiones.df %>%
  group_by(region,month) %>%
  summarise(sessions = sum(sessions,na.rm = TRUE)) %>%
  ungroup()

plot = ggplot(plot.df,aes(
  x = month,y = sessions,group = region,color = region
)) +
  geom_line(lwd = 1.5) +
  geom_point() +
  scale_x_continuous(breaks = seq(0,12)) +
  labs(x = "Mes",y = "Sesiones",title = "GISELA: Sesiones por Comunidad Autónoma y Mes") +
  theme(legend.position = "right")

plot


# práctica 2  -------------------------------------------------------------

library("tidyr")

head(gisela.df)

head( gisela.df %>% gather('device.category', 'sessions', 5:7, convert = T) )


# alumnos -----------------------------------------------------------------

# Asegúrate de que tu directorio de trabajo es el correcto

dir <- "~/" # adapta la ruta a la ubicación de tus archivos
setwd(dir)

# Crea un dataframe "gisela.df" e importa en él los datos del fichero gisela.csv usando la función read.csv

gisela.df <- ...

# Cargamos la librería dplyr
library("dplyr")

# Crea un dataframe sesiones.df a partir de gisela.df con que muestre el número total de sesiones del site por comunidad autónoma y por mes

sesiones.df <- ...

# Ejecuta el siguiente código para visualizar los resultados. 

library("ggplot2")

plot = ggplot(sesiones.df,aes(
  x = month,y = sessions,group = region,color = region
)) +
  geom_line(lwd = 1.5) +
  geom_point() +
  scale_x_continuous(breaks = seq(0,12)) +
  labs(x = "Mes",y = "Sesiones",title = "GISELA: Sesiones por Comunidad Autónoma y Mes") +
  theme(legend.position = "right")

plot

# ¿Te atreves?. Carga la librería tidyr y transforma las variables en gisela.df de (region month user.age.bracket user.gender desktop mobile tablet) a (region month user.age.bracket user.gender device.category sessions) usando la función gather (?gather)


