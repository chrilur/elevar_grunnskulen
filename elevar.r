#Skript som lagar ein grafisk oversikt over talet på grunnskuleelevar
#pr.skule i norske kommunar. 

#install.packages("ggplot2")
library(ggplot2)

#Last inn rådata
elevar <- read.csv("elevar/elevar.csv", sep=";")
fjern <- 2:6

# Fjern kolonnar vi ikkje treng
elevar <- elevar[-fjern]
names(elevar) <- c("region", "tal_2020")

#Fjerne "tomme" kommunar
fjern.tomme <- which(elevar$tal_2020 == ".")
elevar <- elevar[-fjern.tomme,]

#Ta vekk kommunenummer
elevar$region <- substr(elevar$region, 6, nchar(elevar$region))
elevar$tal_2020 <- as.numeric(elevar$tal_2020)

ggplot(elevar, aes(x=region, y=tal_2020)) + geom_point()

elevar$gruppe <- cut(elevar$tal_2020, breaks = c(0,100,200,300,400,Inf))
ggplot(elevar, aes(x=region, y=tal_2020, color=gruppe)) + geom_point() +
  geom_text(aes(label=ifelse(tal_2020 > 400, as.character(region), "")), hjust=1.1, vjust=0) +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank()) +
  ggtitle("Tal på elevar i norske grunnskular pr. kommune (2020)")

ggsave("elevar.pdf")