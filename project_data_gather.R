#install.packages(c("tidycensus","tidyverse","plotly"))
library(tidycensus)
library(tidyverse)
library(dplyr)
rm(list=ls())

#api key
census_api_key("b7aacbae2d4a0a19480d8b842819caa851bb4f5b", install = TRUE)


realtorData<-read.csv("realtorData.csv")
# data needed from census
#estimate of whites,blacks,asians,american indian,hawaiian, some other race
#put into 2022 only
now<-subset(realtorData,startsWith(realtorData$month_date_yyyymm,"2022"))
#put into iowa counties only
iowa<-subset(now,endsWith(now$county_name,"ia"))
#fixing county names
# Capitalize the first letter of Adair
library(stringr)

for (i in 1:nrow(iowa)) {  # Loop through each row of the 'county_name' column
  # Split the current county name
  county_parts <- str_split(iowa$county_name[i], ",")[[1]]
  
  # Check if there are parts (avoid errors for single-word county names)
  if (length(county_parts) > 1) {
    # Format the county name with title case and add ", Iowa"
    iowa$county_name[i] <- paste0(str_to_title(county_parts[1]), " County, Iowa")
  } else {
    # Leave single-word county names unchanged
    iowa$county_name[i] <- str_to_title(iowa$county_name[i])  # Apply title case only
  }
}

#fixing the date
iowa$month_date_yyyymm<-as.numeric(iowa$month_date_yyyymm)
iowa$month_date_yyyymm<-as.Date(paste0(iowa$month_date_yyyymm, "01"), format = "%Y%m%d")
iowa$month_date_yyyymm<-format(iowa$month_date_yyyymm, "%m/%d/%Y")

yearly_averages<- iowa %>%
  group_by(county_name) %>%
  summarize(across(everything(), mean))

yearly_averages <- yearly_averages %>% 
  rename(
    County = county_name
  )

#get the race demographics from the census API

df1<-get_acs(
  geography = "county",
  variables = c("B02001_001E"),
  year = 2022,
  state = "iowa"
)
df1<-df1 %>%
  rename(
    County=NAME,
    B02001_001=variable,
    Total=estimate,
    Total_MOE = moe
  )
df2<-get_acs(
  geography = "county",
  variables = c("B02001_002E"),
  state = "iowa"
)
df2<-df2 %>%
  rename(
    County=NAME,
    B02001_002=variable,
    White = estimate,
    White_MOE = moe
  )
df3<-get_acs(
  geography = "county",
  variables = c("B02001_003E"),
  state = "iowa"
)
df3<-df3 %>%
  rename(
    County=NAME,
    B02001_002=variable,
    Black = estimate,
    Black_MOE = moe
  )
df4<-get_acs(
  geography = "county",
  variables = c("B02001_004E"),
  state = "iowa"
)
df4<-df4 %>%
  rename(
    County=NAME,
    B02001_002=variable,
    Native = estimate,
    Native_MOE = moe
  )
df5<-get_acs(
  geography = "county",
  variables = c("B02001_005E"),
  state = "iowa"
)
df5<-df5 %>%
  rename(
    County=NAME,
    B02001_002=variable,
    Asian = estimate,
    Asian_MOE = moe
  )
df6<-get_acs(
  geography = "county",
  variables = c("B02001_006E"),
  state = "iowa"
)
df6<-df6 %>%
  rename(
    County=NAME,
    B02001_006=variable,
    Islander = estimate,
    Islander_MOE = moe
  )
df7<-get_acs(
  geography = "county",
  variables = c("B02001_007E"),
  state = "iowa"
)
df7<-df7 %>%
  rename(
    County=NAME,
    B02001_007=variable,
    Other = estimate,
    Other_MOE = moe
  )


df_list <- list(df1, df2, df3, df4, df5, df6, df7)

# Initialize an empty dataframe to store the combined result
combined_df <- df1  # Start with df1, removing unnecessary columns

# Loop through the remaining dataframes
for (i in 2:length(df_list)) {
  combined_df <- cbind(combined_df, df_list[[i]][, -(1:2)])
}


cols_to_remove <- grep("B02001|variable", names(combined_df)) 

# Remove the columns 
combined_df <- combined_df[, -cols_to_remove]

final_df<-merge(combined_df,yearly_averages, by = "County")

final_df<-subset(final_df, select = c(GEOID, County, Total, White, Black, Native, Asian, Islander, Other, 
                                      median_listing_price, median_days_on_market, active_listing_count, 
                                      median_listing_price_per_square_foot,average_listing_price,median_square_feet,
                                      total_listing_count, pending_ratio))
#create percentage of total for counties
final_df$White_Percent<-round(final_df$White / final_df$Total, digits=4)
final_df$Black_Percent<-round(final_df$Black / final_df$Total,digits=4)
final_df$Native_Percent<-round(final_df$Native / final_df$Total,digits=4)
final_df$Asian_Percent<-round(final_df$Asian / final_df$Total,digits=4)
final_df$Islander_Percent<-round(final_df$Islander / final_df$Total,digits=4)
final_df$Other_Percent<-round(final_df$Other / final_df$Total,digits=4)

save(final_df, file = "data.RData")


library(choroplethr)
library(ggplot2)

final_df$GEOID<-as.numeric(final_df$GEOID)

county <- data.frame(region = final_df$GEOID,
                     value=final_df$median_listing_price)

county_choropleth(county, "Test", state_zoom = "iowa") + scale_fill_brewer("Test",palette="Blues")







