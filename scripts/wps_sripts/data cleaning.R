

# load libraries -----

library(httr)
library(readxl)
library(tidyr)
library(dplyr)
library(magrittr)


# Read data in -----

abp_list_data <-
  read_excel(
    "D:/Desktop/Network Rail WPS/Data from Akio/ABP List of Std Jobs with II Planning Info.xlsx",
    sheet = "Standard Job List",
    range = "A2:AB5949"
  )

track_eng_competency_data <-
  read_excel(
    "D:/Desktop/Network Rail WPS/Data from Akio/Sample competency data/Track eng Who has this competence 20200406.xlsx",
    sheet = "Sheet1",
    range = "A1:AF55099"
  )

names(track_eng_competency_data)

# select necessary columns
track_eng_competency_data_2 <- track_eng_competency_data %>%
  select(
    `Employee Number`,
    Competence,
    Endorsement,
    Status,
    `Date From`,
    `Valid Until`,
    `Supervisor Employee Number`,
    Route,
    `Delivery Unit`,
    Area
  )

# >>> NOTE: Plan is to use the Delivery Units to identify the "resources with competences" that can work on certain standard jobs
# >>> We also need the endorsement mapping with the standard jobs. Either this or the above will serve as the missing key to the standard jobs




# # To ensure the employee number is unique by spreading the endorsements
#
# pivoted_track_eng_competency_data_2 <- track_eng_competency_data_2 %>%
#   group_by(Endorsement) %>%
#   mutate(row = row_number()) %>%
#   pivot_wider(
#     names_from = Endorsement,
#     values_from = Endorsement,
#     values_fn = NULL
# ) %>%
#   distinct()

# select the necessary columns
abp_list_data_2 <- abp_list_data %>%
  select(
    `STD JOB DESC`,
    CREW_SIZE, # number of works
    CALC_LAB_HRS, # total number of work hours
    ACTIVE,
    STD_JOB_NO,
    STD_JOB_TASK,
    CFW,
    MNTCODE,
    `MNT DESCRIPTION`,
    `UNIT OF WORK`,
    `UNITS REQUIRED`,
    `CONVERSION FACTOR`,
    `Protection Required`,
    ASSET_CHANGE
  )

# >>> NOTE: The lab hours and gang size can help plan the roster.
# To plan jobs, add the Delivery Unit so that we know what gang is needed (with the DU assisting with the specific location targeting)
# and/or the Endorsement so we know what skills are required

# replicate the addition of DU and Endorsements
## DU
resource_DU <- unique(track_eng_competency_data_2$`Delivery Unit`)
DU <- rep(c(resource_DU),each = 1, length = nrow(abp_list_data_2))
abp_list_data_3 <- mutate(abp_list_data_2, DU = DU)

## Endorsements
resource_endorsement <- unique(track_eng_competency_data_2$Endorsement)
endorsement <- rep(c(resource_endorsement),each = 1, length = nrow(abp_list_data_2))
abp_list_data_3 <- mutate(abp_list_data_2, endorsement = endorsement)


# >>> NOTE: Now this is a link between the standard jobs and actual competencies.


# abp_list <- read_excel("//arcadiso365.sharepoint.com/teams/NRALPWPSPrivate/Documents/General/Incoming Documents/Data/WPS Sample Data from Routes/ABP List of Std Jobs with II Planning Info.xlsx")
#
#
# file_url <- "https://arcadiso365.sharepoint.com/:x:/r/teams/NRALPWPSPrivate/_layouts/15/Doc.aspx?sourcedoc=%7B9C0A7333-7CE6-4B4C-A5FB-F60AABBFC604%7D&file=ABP%20List%20of%20Std%20Jobs%20with%20II%20Planning%20Info.xlsx&action=default&mobileredirect=true"
# file_url <- "arcadiso365.sharepoint.com/teams/NRALPWPSPrivate/Documents/General/Incoming Documents/Data/WPS Sample Data from Routes/ABP List of Std Jobs with II Planning Info.xlsx"
# df <- read_excel(file_url)
