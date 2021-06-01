
# load libraries ------------
library(httr)
library(readxl)
library(tidyr)
library(dplyr)
library(magrittr)
library(data.table)
library(readr)
library(stringr)

# Read data in datasets -----

demand_link <- "D:/Desktop/Network Rail WPS/new data from Arunava/"
detail_202021 <- "Work_Done_(On_Demand)_202021/Detail.csv"
detail_202122 <- "Work_Done_(On_Demand)_202122/Detail.csv"
asset_dload <- "Asset_Download_(On_Demand) (2)/Detail.csv"
library_pos <- "APP Data Feasibility - Library of Possessions.xlsx"

demand_202021_data <-
  read_csv(paste0(demand_link, detail_202021))

demand_202122_data <-
  read_csv(paste0(demand_link, detail_202122))

asset_dload_data <-
  read_csv(paste0(demand_link, asset_dload))

library_pos_data_1 <-
  read_excel(
    paste0(demand_link, library_pos),
    sheet = "Wales Target - 2745343",
    range = "A1:BA3"
  )

library_pos_data_2 <-
  read_excel(
    paste0(demand_link, library_pos),
    sheet = "Wales Target - 2862215",
    range = "A1:BA3"
  )

library_pos_data_3 <-
  read_excel(
    paste0(demand_link, library_pos),
    sheet = "Wales Target - 3125162",
    range = "A1:BA3"
  )


# select necessary columns -------

demand_202021_data <- demand_202021_data %>% dplyr::select(
  `Route`,
  `IMDM`,
  Discipline,
  Engineer,
  `Work Group Set`,
  `Work Group`,
  `Work Order Number`,
  `Standard Job Number & Desc`,
  `MNT Code & Desc`,
  `Asset Number`,
  `Structured Plant Number`,
  `ELR Code & Desc`,
  `Asset Desc 1`,
  `Asset Desc 2`,
  `Asset Start Mileage`,
  `Asset End Mileage`,
  `Work Order Mileage From`,
  `Work Order Mileage To`,
  `Raised Date`,
  # `Planned Start Date`,
  `Required Finish Date`
  # `Work Order Closed Date`
)

demand_202122_data <- demand_202122_data %>% dplyr::select(
  `Route`,
  `IMDM`,
  Discipline,
  Engineer,
  `Work Group Set`,
  `Work Group`,
  `Work Order Number`,
  `Standard Job Number & Desc`,
  `MNT Code & Desc`,
  `Asset Number`,
  `Structured Plant Number`,
  `ELR Code & Desc`,
  `Asset Desc 1`,
  `Asset Desc 2`,
  `Asset Start Mileage`,
  `Asset End Mileage`,
  `Work Order Mileage From`,
  `Work Order Mileage To`,
  `Raised Date`,
  # `Planned Start Date`,
  `Required Finish Date`
  # `Work Order Closed Date`
)

asset_dload_data <- demand_202122_data  %>% dplyr::select(
    `Route`,
    `IMDM`,
    Discipline,
    Engineer,
    `Work Group Set`,
    `Work Group`,
    `Work Order Number`,
    `Standard Job Number & Desc`,
    `MNT Code & Desc`,
    `Asset Number`,
    `Structured Plant Number`,
    `ELR Code & Desc`,
    `Asset Desc 1`,
    `Asset Desc 2`,
    `Asset Start Mileage`,
    `Asset End Mileage`,
    `Work Order Mileage From`,
    `Work Order Mileage To`,
    `Raised Date`,
    # `Planned Start Date`,
    `Required Finish Date`
    # `Work Order Closed Date`
  )

# bind the datasets
demand_data <- rbind(demand_202021_data,demand_202122_data,asset_dload_data)
library_pos_data <- rbind(library_pos_data_1,library_pos_data_2,library_pos_data_3)
demand_data[,10:20]


# fix the elr
demand_data <- demand_data %>%
  as.data.table() %>%
  dplyr::mutate(c = str_split(`ELR Code & Desc`, " - "),
         ELR = purrr::map(c, 1)) %>%
  dplyr::select(-c(`ELR Code & Desc`, c))

# fix the track id for CNH3 and HNL1
demand_data_2_possessions <- demand_data %>%
  dplyr::filter(ELR == "CNH3" | ELR == "HNL1" ) %>%
  as.data.table() %>%
  dplyr::mutate(c = str_split(`Structured Plant Number`, " "),
         TrackID = purrr::map(c, 1)) %>%
  dplyr::select(-c(`Structured Plant Number`, c))
demand_data_2_possessions$TrackID <-
  substring(demand_data_2_possessions$TrackID,
            5,
            nchar(demand_data_2_possessions$TrackID))

# fix the track id for SHL
demand_data_1_possession <- demand_data %>%
  dplyr::filter(ELR == "SHL") %>%
  as.data.table() %>%
  dplyr::mutate(c = str_split(`Structured Plant Number`, " "),
         TrackID = purrr::map(c, 2)) %>%
  dplyr::select(-c(`Structured Plant Number`, c))

# merge all 3 possessions
demand_data_possessions <- rbind(demand_data_1_possession,demand_data_2_possessions)

# unlist the lists
demand_data_possessions$ELR <- as.character(demand_data_possessions$ELR)
demand_data_possessions$TrackID <- as.character(demand_data_possessions$TrackID)

# fix the mileage on the 3 possessions data ---------------------

# From Mileage
# remove the m
library_pos_data_clean <- library_pos_data %>%
  as.data.table() %>%
  dplyr::mutate(a = str_split(`From Mileage`, "m"),
         b = purrr::map(a, 1),
         c = purrr::map(a, 2)) %>%
  dplyr::select(-c(`From Mileage`, a))

# remove the ch and convert the chain to miles
library_pos_data_clean$c <-
  substring(library_pos_data_clean$c, 1,
            nchar(library_pos_data_clean$c) - 2)
library_pos_data_clean$c <- as.integer(library_pos_data_clean$c)
library_pos_data_clean <- library_pos_data_clean %>%
  dplyr::mutate(c = c/80,
         b = as.numeric(b),
         `From Mileage`= b+c) %>%
  dplyr::select(-c(b,c))

# To Mileage
# remove the m
library_pos_data_clean <- library_pos_data_clean %>%
  as.data.table() %>%
  dplyr::mutate(a = str_split(`To Mileage`, "m"),
                b = purrr::map(a, 1),
                c = purrr::map(a, 2)) %>%
  dplyr::select(-c(`To Mileage`, a))

# remove the ch and convert the chain to miles
library_pos_data_clean$c <-
  substring(library_pos_data_clean$c, 1,
            nchar(library_pos_data_clean$c) - 2)
library_pos_data_clean$c <- as.integer(library_pos_data_clean$c)
library_pos_data_clean <- library_pos_data_clean %>%
  dplyr::mutate(c = c/80,
                b = as.numeric(b),
                `To Mileage`= b+c) %>%
  dplyr::select(-c(b,c))

# join by elr and track id
the_join <- library_pos_data_clean %>%
  dplyr::select(
    BusinessPossRef,
    PossessionYearN,
    PossessionStatus,
    `From ELR`,
    `To ELR`,
    `From Track IDs`,
    `To Track ID`,
    ProtectionType,
    `From Mileage`,
    `To Mileage`
  ) %>% left_join(demand_data_possessions,
                  by = c("From ELR" = "ELR", "From Track IDs" = "TrackID"))

the_intersections <- the_join %>%
  dplyr::mutate(`Asset Start Mileage` = as.numeric(`Asset Start Mileage`),
                `Asset End Mileage` = as.numeric(`Asset End Mileage`)) %>%
  dplyr::filter(`Asset Start Mileage` >= `From Mileage`,
                `Asset End Mileage` <= `To Mileage`)


# write out the file
getwd()
fwrite(the_intersections,"the_intersections.csv")

