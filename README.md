# Data_Wrangling_Project
This is my final project for BAIS 3250: Data Wrangling. This project utilizes R to combine data scraped from the US Census API and real estate data from Realtor.com to analyze demographic trends for Iowa counties. This project was created with Sneh Patel and Reid Erickson.

Data_Wrangling_Final_Report.docx includes a written report answering questions posed at the beginning of the project including finding distinct correlations among demographic and real estate statistics, geographic trends, and more.

Project_data_gather.R is an R file that imports the real estate data from https://www.realtor.com/research/data/ for Iowa counties specifically as well as gathering demographic data from the US Census API. It then cleans the data and horizontally integrates the data for each Iowa county. 

Project_data_analysis.R is an R file used to do simple analysis on the gathered data, including creating plots and chloropleths to visualize the data and statistically analyzing correlations and trends we noticed.

Project_data.RData is the combined US Census data and Realtor.com data gathered and cleaned from Project_data_gather.R. 
