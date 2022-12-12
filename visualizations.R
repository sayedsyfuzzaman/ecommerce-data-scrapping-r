products=read.csv("data/cleaned_dataset.csv")
library(dplyr)

#Bar Chart of Frequency of each Category

install.packages(c("mosaicData", "ggplot2"))
library(ggplot2) 
theme_set(theme_bw()) 

freq_of_each_car <- ggplot(products, aes(x=Category)) + geom_bar() + 
  labs(title="Item frequency by Category", 
       x="Item Categories", 
       y="Frequency") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

ggsave(path = "D:/Classwork/10th Semester/Intro to Data Science/Project", filename = "Item Category vs Frequency.png")

#Jitter Plot of Price vs Category

prc_vs_cat <- ggplot(products, aes(x = Category, y = Price)) + geom_jitter()+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
ggsave(path = "D:/Classwork/10th Semester/Intro to Data Science/Project", filename = "Category vs price.png")

#Average Price by Category

meanByCategory = products %>% group_by(Category)  %>%
  summarise(meanPrice = mean(Price),
            .groups = 'drop')

avg_p_cat <- ggplot(meanByCategory)+
  geom_col(aes(x = reorder(Category, meanPrice), y = meanPrice)) +
  labs(title="Average Price per Category", x = "Category", y = "Average Price")+
  theme(axis.title = element_text(size = 15, face = "bold"),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        plot.title = element_text(size = 20, hjust = 0.5),
        plot.subtitle = element_text(size = 15, hjust= 0.5))

ggsave(path = "D:/Classwork/10th Semester/Intro to Data Science/Project", filename = "Average Price per Category.png")

# Maximum price and Minimum Price by Category
library(dplyr)
install.packages("tidyr")
library(tidyr)
maxMinByCategory = products %>% group_by(Category)  %>%
  summarise(maxPrice = max(Price),
            minPrice = min(Price),
            .groups = 'drop')

tidyr_maxMinByCategory <- tidyr::pivot_longer(maxMinByCategory, cols=c('maxPrice', 'minPrice'), names_to='variable', 
                           values_to="Price")

maxpandminp_by_cat <- ggplot(tidyr_maxMinByCategory, aes(x=Category, y=Price, fill=variable)) +
  geom_bar(stat='identity', position='dodge') +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
ggsave(path = "D:/Classwork/10th Semester/Intro to Data Science/Project", filename = "Max and Minimum Price.png")

#Pie Chart of Availability

install.packages("plotrix")
library(plotrix)

pos <- pie3D(table(products$Available), labels = c("Not Available", "Available"), labelrad=1.25)
pos[1]<- 0.4
dfFreq <-as.data.frame(table(products$Available)) 
pie3D(table(products$Available), labels = c(paste(format(round((dfFreq[1,]["Freq"]/sum(dfFreq$Freq))*100, 2), nsmall = 2),"%",sep = ""),paste(format(round((dfFreq[2,]["Freq"]/sum(dfFreq$Freq))*100, 2), nsmall = 2) ,"%",sep = "")), labelrad = 0.8, labelpos=pos, col = hcl.colors(2, "Spectral"))
legend(x= -1.05,y= 0.7, c("Not Available", "Available"), cex = 0.7, fill = hcl.colors(2, "Spectral"))


