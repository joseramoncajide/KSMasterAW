#############################################################################
# KS Master AW - R
# jose.ramon.cajide@gmail.com, 2016-01-09
#
# DATA WRANGLING
#############################################################################



# datasets ----------------------------------------------------------------

storms <- read.csv('data/storms.csv', sep = ',', stringsAsFactors = F)
storms <- tbl_df(storms)

pollution <- read.csv('data/pollution.csv', sep = ',', stringsAsFactors = F)
pollution <- tbl_df(pollution)


# dplyr -----------------------------------------------------------------------

install.packages('dplyr')
library(dplyr)

# dplyr::select Extract existing variables

?select

# utilizamos el dataset
storms

#seleccionar las variables 'storm' y 'pressure'
select(storms, storm, pressure)

#seleccionar todas las variables excepto 'storm'
select(storms, -storm)
select(storms, 2:4)
select(storms, wind:date)

#EJERCICIO

# 1- Mira la ayuda de 'select' (?select) para ver otras funciones especiales de 'select' 
# 2- Familiarízate con el dataset 'flights'


#install.packages('nycflights13')
library(nycflights13)
flights
glimpse(flights)
names(flights)

#Selecciona únicamente las siguientes columnas o variables: 
#1. 'dep_delay' y 'dep_time'
select(flights, starts_with('dep'))

#2. 'dep_time', 'arr_time' and 'air_time'
select(flights, ends_with('time'))

#3. 'dep_time', 'dep_delay', 'arr_time', 'arr_delay'
#select(flights, contains('_')) #también devuelve air_time
select(flights, dep_time:arr_delay)


# EL OPERADOR PIPE %>%

#Tiempo medio de retraso de salida de los vuelos
tmp <- flights$dep_delay
mean(tmp, na.rm = T)

#Win: CTRL+SHIFT+M
#Mac: CMD+SHIFT+M
tmp %>% mean(na.rm = T)


#Aplicado al ejercicio anterior
flights %>% select(starts_with('dep'))
flights %>% select(ends_with('time'))
flights %>% select(dep_time:arr_delay)


# dplyr::filter Extract existing observations

#Volvemos a storms
storms %>% 
  filter(wind >= 50)

#%in% Pertenencia a un grupo
storms %>% 
  filter(storm %in% c("Alberto","Ana"))

storms %>% 
  filter(wind >= 50, storm %in% c("Alberto","Ana"))


#EJERCICIO
#Usando flights devolver sólo aquellas observaciones en la que 'arr_delay' tiene valores





#¿Cuántas observaciones (filas) tienen datos sin valor para 'arr_delay'?
dim(flights)[1] - dim(flights %>% filter(!is.na(arr_delay)))[1]
# ó
nrow(flights %>% filter(is.na(arr_delay)))
# ó
sum(!complete.cases(flights$arr_delay))


#Volvemos a storms

# Encadenando comandos
storms %>% filter(wind >= 50) %>%  select(storm, pressure)


#EJERCICIO
#Usando flights, filtra aquellas variables que 'arr_delay' != NA y a continuación selecciona 'carrier' y 'arr_delay'

flights %>% 
  filter(...) %>% 
  ...


 

# dplyr::mutate (Derive new variables) 

storms %>% mutate(ratio = pressure / wind)

storms %>% mutate(ratio = pressure / wind, ratio_by_rank = rank(ratio))

#funciones útiles disponibles: cumsum, rank, mean, etc.

storms %>% mutate(wind_percent = wind / sum(wind) * 100) %>% select(storm, wind_percent) 


#EJERCICIO
#Usando flights, y las funciones mutate y select obtén un conjunto de datos con tres variables: 'carrier', 'arr_delay' y 'speed', siendo 'speed' = distance / air_time * 60

flights %>% 
  mutate(...) %>% 
  select(...)




# dplyr::summarize (Derive new observations) 

pollution %>% summarise(sum = sum(amount), n=n())

#otras funciones útiles: n_distinct, mean, median, sd

pollution %>% 
  summarise(distint_cites = n_distinct(city), median = median(amount), mean = mean(amount), var = sd(amount))


#EJERCICIO
#Usando flights, eliminar las observaciones en la que 'air_time' y 'distance' son iguales a NA. Después crear un resumen que muestre:
# n: Cuantos vuelos hay en el dataset
# n_carriers: Cuantas compañías diferentes están recogidas en el dataset
# total_time: el tiempo total que los aviones han estado en vuelo

flights %>% 
  filter(!is.na(air_time), ...) %>% 
  summarise(...)





# dplyr::group_by

#Partimos de:
pollution %>% summarise(sum = sum(amount), n=n(), mean = mean(amount))
#sum/n = mean

#Queremos obtener la media por ciudad: group_by() + summarise()
pollution %>% group_by(city)
# Source: local data frame [6 x 3]
# Groups: city [3]
# 
# city  size amount
# (chr) (chr)  (dbl)
# 1 New York large     23
# 2 New York small     14
# 3   London large     22
# 4   London small     16
# 5  Beijing large    121
# 6  Beijing small     56

pollution %>% group_by(city) %>% summarise(sum = sum(amount), n=n(), mean = mean(amount))



#EJERCICIO
#Usando flights, eliminar las observaciones en la que 'arr_delay' es igual a NA. Después usa group_by() y summarise() para calcular 'avg_delay', es decir, la media de 'arr_delay' por 'carrier'. Guarda el resultado en una nuevo dataset llamado 'delays'

delays <- flights %>% 
  filter(!is.na(arr_delay)) %>%
  group_by(..) %>% 
  summarise(...)



#Con cada nivel se va elminando la última varible de la agrupación
flights %>% 
  select(origin, dest)

flights %>% 
  group_by(origin, dest) %>% 
  summarise(n = n())

flights %>% 
  group_by(origin, dest) %>% 
  summarise(n = n()) %>% 
  summarise(n2 = n())

# dplyr::ungroup()

# flights %>% 
#   group_by(origin, dest) %>% 
#   summarise(n = n()) %>% 
#   ungroup 


# dplyr::arrange()

storms %>% arrange(wind)

storms %>% arrange(desc(wind))

storms %>% arrange(wind, date) 

#EJERCICIO
#Usando delays, ordena las compañías 'carriers' de mayor a menor retraso medio

#delays ya está agrupado por carrier

delays %>% 
  ...





#dplyr::top_n()

delays %>% 
  arrange(desc(avg_delay)) %>% 
  top_n(5)


# offtopic -----------------------------------------------------------------------
library(circlize)

circos.par(start.degree = 90)

flights %>% 
  group_by(origin, dest) %>% 
  summarise(n = n()) %>% 
  ungroup() %>% 
  top_n(50) %>% 
  chordDiagram(directional = 1, direction.type = c("diffHeight"), link.arr.length = 0.2)

circos.clear()




#dplyr::sample_n, bind_rows(), bind_cols()
sample_1 <- sample_n(flights, 2)
sample_2 <- sample_n(flights, 2)

bind_rows(sample_1, sample_2)

cols_1 <- flights %>% select(year, month)
cols_2 <- flights %>% select(day, arr_delay)

bind_cols(cols_1, cols_2)

#dplyr:: xxx_join(): left_join(), inner_join(), semi_join(), anti_join()

delays
airlines


delays %>% 
  left_join(airlines, by = 'carrier') %>% 
  arrange(avg_delay)



# tidyr -----------------------------------------------------------------------

install.packages('tidyr')
library(tidyr)

#Ejercicio: tidyr::gather()

cases
cases %>% gather("year", 'n', 2:4, convert=T) 

tb
tb %>% gather("age", 'cases', 4:6, convert=T) 
tb %>% gather("age", 'cases', child:elderly, convert=T) 

pollution
pollution2 <- pollution %>% spread(size, amount)
#inverso
pollution2 %>% gather("size", "amount", 2:3)


