#############################################################################
# KS Master AW - R
# jose.ramon.cajide@gmail.com, 2016-01-09
#
# DATAVIZ
#############################################################################

install.packages('ggplot2')
library(ggplot2)


# intro slides ------------------------------------------------------------

require(MASS)
data("Cars93")
Cars93
attach(Cars93)
plot(MPG.city, Horsepower)

ggplot(Cars93, aes(x=MPG.city, y=Horsepower)) + geom_point() 

ggplot(Cars93, aes(x=MPG.city, y=Horsepower, size = Price )) + geom_point()  

ggplot(Cars93, aes(x=MPG.city, y=Horsepower, size = Price )) + geom_point()  + geom_smooth(lwd = 1, se = F, method = "lm")

ggplot(Cars93, aes(x=MPG.city, y=Horsepower, size = Price )) + geom_point()  + geom_smooth(lwd = 1, se = T, method = "lm")

ggplot(Cars93, aes(x=MPG.city, y=Horsepower, col=factor(Cylinders), size = Price )) + geom_point()  

ggplot(Cars93, aes(x=MPG.city, y=Horsepower, col=factor(Cylinders), size = Price )) + geom_point()  + geom_smooth(lwd = 1, se = F, method = "lm") + facet_wrap(~ Cylinders)


# qplot -------------------------------------------------------------------

#ver la información del conjunto de datos
?mpg

#¿Qué relación hay entre la cilindrada 'displ' y las millas por galón 'hwy'?
#¿Cómo exolorar estos datos?

#scatter plot
qplot(displ, hwy, data = mpg) #quickplot
ggplot(mpg, aes(x=displ, y=hwy)) + geom_point()

#¿Siguen todos los puntos la misma tendencia? 
#Para los que no lo siguen, ¿puede haber alguna otra variable que explique ese comportamiento?: names(mpg)

#aesthetics y facetting permiten incorporar nuevas variables al gráfico

# aesthetics --------------------------------------------------------------

#Propiedades visuales

ggplot(mpg, aes(x=displ, y=hwy,color = class)) + geom_point() #podemos ver que esos coches son de 2 plazas (deportivos)
#lo mismo de dos formas posibles.

ggplot(mpg, aes(x=displ, y=hwy,shape = class)) + geom_point()

ggplot(mpg, aes(x=displ, y=hwy,size = class)) + geom_point()

ggplot(mpg, aes(x=displ, y=hwy,alpha = class)) + geom_point()


glimpse(mpg)
#Hemos asignado un color a una variable de tipo factor. Asigna ahora un color a una varibale continua. 

ggplot(mpg, aes(x=displ, y=hwy, color = class)) + geom_point() #Factor

ggplot(mpg, aes(x=displ, y=hwy, color = hwy)) + geom_point() #Continua

#¿Qué pasa si asginas un shape a una varible contínua?
ggplot(mpg, aes(x=displ, y=hwy, shape = model)) + geom_point()

#¿Qué pasa si asginas un shape a una varible discreta con muchos valores?
ggplot(mpg, aes(x=displ, y=hwy, shape = class)) + geom_point()

#Podemos combinar varias propiedades 'aesthetics' en un mismo gráfico.
ggplot(mpg, aes(x=displ, y=hwy, color = class, shape = factor(cyl))) + geom_point()

# faceting ----------------------------------------------------------------

ggplot(mpg, aes(x=displ, y=hwy)) + geom_point() + facet_grid(. ~ cyl) #columnas

ggplot(mpg, aes(x=displ, y=hwy)) + geom_point() + facet_grid(drv ~ .) #filas

ggplot(mpg, aes(x=displ, y=hwy)) + geom_point() + facet_grid(drv ~ cyl)

ggplot(mpg, aes(x=displ, y=hwy)) + geom_point() + facet_wrap(~ class)

# geoms -------------------------------------------------------------------
# Tipos de gráficos o de objetos geométricos

#Geometric objects

ggplot(mpg, aes(x=displ, y=hwy))  + geom_point()
ggplot(mpg, aes(x=displ, y=hwy))  + geom_line()
ggplot(mpg, aes(x=displ, y=hwy))  + geom_smooth()
ggplot(mpg, aes(x=displ, y=hwy))  + geom_point() + geom_smooth()


#Ejercicio: Dibuja el siguiente gráfico y transfórmalo en un boxplot. Ayuda: http://docs.ggplot2.org/current/

ggplot(mpg, aes(x=class, y=hwy))  + geom_point()

ggplot(mpg, aes(x=class, y=hwy)) + ...

# sol ---------------------------------------------------------------------

ggplot(mpg, aes(x=class, y=hwy)) + geom_boxplot() #respuesta



#El eje X se ordena alfabéticamente, un problema p.e. en cambios de idiomas de las etiquetas
#qplot(reorder(class, hwy), hwy, data = mpg, geom = 'boxplot') 
ggplot(mpg, aes(x=reorder(class, hwy), y=hwy)) + geom_boxplot() #reorder ordena por la media, no por la mediana
ggplot(mpg, aes(x=reorder(class, hwy, median), y=hwy)) + geom_boxplot()

# reorder(mpg$class, mpg$hwy)



#qplot

qplot(hwy, class, data=mpg) #histogram

qplot(hwy, data=mpg) #histogram

qplot(class, data=mpg) #bar chart

#Qué tenemos:
# qplot + 2 variables: scatterplot
# qplot + 1 variable continua: histogram
# qplot + 1 variable categórica: bar chart

head(mpg)
# position adjustments ----------------------------------------------------

ggplot(mpg, aes(x=manufacturer, y=hwy, fill=class)) + geom_bar(stat="identity")

ggplot(mpg, aes(x=manufacturer, y=hwy, fill=class)) + geom_bar(stat="identity", position = 'stack')

ggplot(mpg, aes(x=manufacturer, y=hwy, fill=class)) + geom_bar(stat="identity", position = 'dodge')

ggplot(mpg, aes(x=manufacturer, y=hwy, fill=class)) + geom_bar(stat="identity", position = 'identity') #overlap

ggplot(mpg, aes(x=manufacturer, y=hwy, fill=class)) + geom_bar(stat="identity", position = 'fill') 


#jitter
ggplot(mpg, aes(x=class, y=hwy)) + geom_point()

ggplot(mpg, aes(x=class, y=hwy)) + geom_point(position = 'jitter')

ggplot(mpg, aes(x=class, y=hwy)) + geom_jitter()


#histograms
qplot(hwy, data = mpg)
ggplot(mpg, aes(x=hwy)) + geom_histogram(binwidth = 5)
ggplot(mpg, aes(x=hwy)) + geom_freqpoly()
ggplot(mpg, aes(x=hwy)) + geom_density(aes(color=class)) #normalización: AUC = 1
ggplot(mpg, aes(x=hwy)) + geom_density(aes(fill=class, alpha = 0.5))
ggplot(mpg, aes(x=hwy)) + geom_density(aes(fill=class, alpha = 0.5)) + facet_wrap(~ class) 

# position adjustments recap: stack, identity, fill, dodge, jitter, density


# saving plots ------------------------------------------------------------

ggsave("my_plot.png")
ggsave("my_plot.pdf")
ggsave("my_plot.png", width = 6, height = 6)


# titles ------------------------------------------------------------------

ggplot(mpg, aes(x=manufacturer)) + geom_bar(aes(fill=class, position='dodge')) + ggtitle('Título') 


# coordenadas -------------------------------------------------------------

ggplot(mpg, aes(x=manufacturer)) + geom_bar(aes(fill=class, position='dodge')) + ggtitle('Título') + coord_flip()

ggplot(mpg, aes(x=manufacturer)) + geom_bar(aes(fill=class, position='dodge')) + ggtitle('Título')  + coord_polar()

#Básicamente esto es un gráfico de tarta

audi.df = subset(mpg, manufacturer == 'audi')

ggplot(audi.df, aes(x=manufacturer)) + geom_bar(aes(fill=class)) 

ggplot(audi.df, aes(x=manufacturer)) + geom_bar(aes(fill=class)) + coord_polar(theta = 'y') 

# color schemes -----------------------------------------------------------

install.packages('RColorBrewer')
library(RColorBrewer)
display.brewer.all()

basic <- ggplot(mpg, aes(x=manufacturer)) + geom_bar(aes(fill=class, position='dodge'))

basic + scale_fill_brewer()
basic + scale_fill_brewer(palette = "Blues")

ggplot(audi.df, aes(x=manufacturer)) + geom_bar(aes(fill=class)) + ggtitle('Título') + coord_polar(theta = 'y')  + scale_fill_brewer(palette = "Set1")


# themes ------------------------------------------------------------------

basic + theme_grey()
basic + theme_bw()
basic + theme(panel.border=element_rect(color = 'black', fill = NA))
basic + theme_minimal() + scale_fill_brewer(palette = "Blues")

#Crear nuestros propios temas
basic + theme(panel.border=element_rect(color = 'black', fill = NA))

basic + theme_grey()  + theme_minimal() + scale_fill_brewer(palette = "Blues") + theme(
  axis.title.x = element_text(size = 28), 
  text = element_text(family="Arial", colour="blue", size=16),
  panel.grid.major.y = element_blank(),
  panel.grid.minor.y = element_blank(),  
  panel.grid.major.x = element_blank(),
  panel.grid.minor.x = element_blank()
  ) + labs(title="Título")

install.packages("ggthemes")
#detach("package:ggplot2", unload=TRUE)
library("ggthemes")

basic + theme_excel() + scale_fill_excel()

basic + theme_economist() + scale_fill_economist()

basic + theme_wsj() + scale_fill_wsj(palette = "black_green")

basic + theme_tufte() + scale_fill_tableau()

#Más en https://github.com/wch/ggplot2/wiki/New-theme-system


# labels and legends ------------------------------------------------------

basic + ylab("Número") + xlab("Fabricantes")

basic + theme(legend.position = "bottom")


#Ejercicio
#Añade a un gráfico:
# - etiquetas en los ejes x e y
# - un título
# - una escala de colores personalizada
# - un tema 
