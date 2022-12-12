products=read.csv("data/dataset.csv")

print(products)

#Fixing the Column Names
colnames(products) <- c('Name','Category','Price','Currency','Description','Available')


#Fixing the null values of Currency column

products["Currency"][is.na(products["Currency"])] <- "CAD"


#Removing the rows where price is not available
library(dplyr)

products<-products %>%   filter(!is.na(Price))

#Replacing Available column value with 0 and 1
products$Available[products$Available == "yes"] <- 1
products$Available[products$Available == "no"] <- 0

#Exporting the cleaned dataset

write.csv(products, "data/cleaned_dataset.csv", row.names=FALSE)