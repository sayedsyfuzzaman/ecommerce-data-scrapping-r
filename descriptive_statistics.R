products=read.csv("data/cleaned_dataset.csv")

#Descriptive Statistics

#Mean Of Price
meanPrice <- format(round(mean(products$Price), 2), nsmall = 2)
print(paste0("Mean of Price Attribute: ", meanPrice))

mode <- function(x){
  unique_values <- unique(x)
  table <- tabulate(match(x, unique_values))
  unique_values[table==max(table)]
}

#Mode of Category
print(paste0("Mode of Cateogry attribute: ", mode(products$Category)))

#Variance of Price
print(paste0("Variance of Price Attribute: ", var(products$Price)))

#Standard Variation of Price
print(paste0("Standard Deviation of Price Attribute: ", sd(products$Price)))

#Quantile
print("Quartile of Price Attribute: ")
quantile(products$Price)

#Histogram
png(file = "new.png")
hist(products$Price,breaks=50)
dev.off()
