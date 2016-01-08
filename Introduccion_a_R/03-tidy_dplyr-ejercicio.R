#############################################################################
# KS Master AW - R
# jose.ramon.cajide@gmail.com, 2016-01-09
#
# DATA WRANGLING - Práctica Gisela
#############################################################################


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
