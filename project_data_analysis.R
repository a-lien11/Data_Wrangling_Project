#austin lien, sneh patel, reid erickson project part 2, data eval
rm(list=ls())
library(ggplot2)
library(dplyr)
load("data.RData")
cor(final_df[, c(17:22, 9:14)]) # Correlation between demographics and housing metrics
#NEED TO RETRIEVE ONLY THE ONES THAT CONNECT DEMOGRAPHICS AND PRICING OF HOMES

ggplot(final_df, aes(x = Black_Percent, y = median_listing_price)) +
  geom_point() + labs(title = "White Percentage vs. Median Listing Price")

cor(final_df$Black, final_df$median_listing_price)

#do certain ethnicities indicate a higher/lower price than average?
#average home price
#compare to high white percentage and high ethnicity percentage neighborhoods
#top 10 white counties
# Define all races in a vector
races <- c("White", "Black", "Islander", "Asian", "Native", "Other")
race_prices <- list()


#this should be made into loop, but i cannot figure out
top10_White<-head(final_df[order(final_df$White_Percent, decreasing = TRUE),],10)
top10_Black<-head(final_df[order(final_df$Black_Percent, decreasing = TRUE),],10)
top10_Islander<-head(final_df[order(final_df$Islander_Percent, decreasing = TRUE),],10)
top10_Asian<-head(final_df[order(final_df$Asian_Percent, decreasing = TRUE),],10)
top10_Native<-head(final_df[order(final_df$Native_Percent, decreasing = TRUE),],10)
top10_Other<-head(final_df[order(final_df$Other_Percent, decreasing = TRUE),],10)

#mean of 
avg_White<-mean(top10_White$median_listing_price)
avg_Black<-mean(top10_Black$median_listing_price)
avg_Islander<-mean(top10_Islander$median_listing_price)
avg_Asian<-mean(top10_Asian$median_listing_price)
avg_Native<-mean(top10_Native$median_listing_price)
avg_Other<-mean(top10_Other$median_listing_price)
#calculating with average and median listing price is vastly different, why?


price_by_race <- data.frame(
  race = c("White", "Black", "Islander", "Asian", "Native", "Other"),
  avg_price = c(avg_White, avg_Black, avg_Islander, avg_Asian, avg_Native, avg_Other)
)


library(choroplethr)
library(ggplot2)

final_df$GEOID<-as.numeric(final_df$GEOID)

county <- data.frame(region = final_df$GEOID,
                     value=final_df$median_listing_price)

county_choropleth(county, "Test", state_zoom = "iowa") + scale_fill_brewer("Test",palette="Blues")

