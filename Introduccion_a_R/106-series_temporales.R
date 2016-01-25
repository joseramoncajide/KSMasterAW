library('xts')
library('ts')

rnorm(365)
Sys.Date()-365:1

xts(1:10, Sys.Date()+1:10)


# dat <- cumsum(rnorm(12*4))
# x <- ts(dat)
# stl(x, "periodic")
# xx <- ts(dat, frequency = 12)
# stl(xx, "periodic")

x <- xts(rnorm(20), order.by =Sys.Date()-20:1)
head(x)
index(x)
x['2014-01-25']
x['2014-01-25/2014-01-28']
lag(x)
lag(x, k=5)

x <- xts(rnorm(730), order.by = Sys.Date()-730:1)
plot(x)
x <- cumsum(x)
plot(x)
rm_x <- rollmean(x, k=100, align = 'right')
lines(rm_x, col = 'blue')
rm_xmax <- rollmax(x, k=100, align = 'right')
lines(rm_xmax, col = 'red')

rm_x <- rollapply(x, width = 50, FUN = mean, align = 'right')
head(rm_x, 60)
rsd_x <- rollapply(x, width = 50, FUN = sd, align = 'right')
head(rsd_x, 60)

nrow(x)
nrow(rm_x)
nrow(rsd_x)

x <- merge(x, rm_x, rsd_x)
head(x, 60)

plot(x[,1])
lines(x[,2], col= 'blue')
lines(x[,2] + 2*x[,3], col= 'red')
lines(x[,2] - 2*x[,3], col= 'red')

axTicksByTime(x, ticks.on='months')
plot(x[,1],major.ticks='months',minor.ticks=FALSE,main=NULL,col=3)
periodicity(x)
to.period(x,'months')
periodicity(to.period(x,'months'))
to.daily(x)
to.weekly(x)
to.monthly(x)

period.apply(x[,4],INDEX=endpoints(matrix_xts),FUN=max)
apply.monthly(to.monthly(x[,4]),FUN=max)

# decomp <- stl(x, s.window = 'periodic')
# data <- rnorm(365, m=10, sd=2)
# plot(data)
# # change is below, use ts() to create time series
# data_ts <- ts(cumsum(data), frequency=365, start=c(1919, 1))
# plot(data_ts)
# plot.ts(data_ts)
# attributes(data_ts)
# dcomp<-decompose(data_ts, type=c("additive"))
# plot(dcomp)

