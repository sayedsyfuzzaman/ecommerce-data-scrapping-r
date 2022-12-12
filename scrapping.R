library(rvest)
CategoryPage <- read_html("https://www.mffoodmart.com/shop/")
CategoryLink <- html_nodes(CategoryPage, "#woocommerce_product_categories-4 > ul > li >a") %>%
  html_attr("href")
CatagoryName <- html_nodes(CategoryPage, "#woocommerce_product_categories-4 > ul > li >a") %>%
  html_text()
CategoryData <- data.frame(CatagoryName, CategoryLink)


flag <- FALSE

for(row in 1:nrow(CategoryData)){
  #retrieve all product list
  all_products_in_a_page <- read_html(CategoryData[row, "CategoryLink"])
  Products_Link <- html_nodes(all_products_in_a_page, "h3.wd-entities-title > a")%>%
    html_attr("href")
  Products_Name <- html_nodes(all_products_in_a_page, "h3.wd-entities-title > a")%>%
    html_text()
  if(!identical(Products_Name, character(0)) && !identical(Products_Link, character(0))){
    Product_data <- data.frame(Products_Name,Products_Link)
    NextPageLink <- html_nodes(all_products_in_a_page, "a.next.page-numbers") %>%
      html_attr("href")
    NextPageLink
    while(!identical(NextPageLink, character(0))){
      all_products_in_a_page <- read_html(NextPageLink)
      Products_Link <- html_nodes(all_products_in_a_page, "h3.wd-entities-title > a")%>%
        html_attr("href")
      Products_Name <- html_nodes(all_products_in_a_page, "h3.wd-entities-title > a")%>%
        html_text()
      new_Product_data <- data.frame(Products_Name,Products_Link)
      Product_data <- rbind(Product_data,new_Product_data)
      NextPageLink <- html_nodes(all_products_in_a_page, "a.next.page-numbers") %>%
        html_attr("href")
    }
    
    #retrieve all product data
    
    for(row1 in 1:nrow(Product_data)){
      single_product_html <- read_html(Product_data[row1, "Products_Link"])
      single_product_category <- CategoryData[row, "CatagoryName"]
      single_product_name <- html_node(single_product_html,"h1.product_title.entry-title.wd-entities-title")%>%
        html_text()
      single_product_name <- gsub("[\r\n\t]", "", single_product_name)

      single_product_price_currency <- html_node(single_product_html,"div.row.product-image-summary-wrap > div > div > div.col-lg-6.col-12.col-md-6.text-left.summary.entry-summary > div > p > span > bdi")%>%
        html_text()
      single_product_price_currency <- strsplit(single_product_price_currency, " +")[[1]] 
      single_product_price <- single_product_price_currency[2]
      single_product_price
      single_product_currency <- single_product_price_currency[1]
      single_product_currency
      
      single_product_discription <- html_node(single_product_html,"div.woocommerce-product-details__short-description > p")%>%
        html_text()
      single_product_discription
      
      is_stock_Out <- html_node(single_product_html,"p.stock.out-of-stock.wd-style-default")
      is.na(is_stock_Out)
      single_product_availability <- "yes"
      if(!is.na(is_stock_Out)){
        single_product_availability <- "no"
      }
      
      newData <- data.frame(single_product_name,single_product_category,single_product_price,single_product_currency,single_product_discription,single_product_availability)
      print(newData)
      if(flag){
        dataset <- rbind(dataset,newData)
      }else{
        dataset <- newData
        flag <- TRUE
      }
    }
  }
  
}
write.csv(dataset, "G:/Fall 22-23/INTRODUCTION TO DATA SCIENCE/FinalProject/dataset.csv", row.names=FALSE)


