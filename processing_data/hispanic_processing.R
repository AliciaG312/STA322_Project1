library(readr)
library(dplyr)

hispanic2010 <- read_csv("raw_data/cc-est2011-alldata.csv")
hispanic2020 <- read_csv("raw_data/cc-est2022-all.csv")

# keep interested variable only 
hispanic2010_processed <- hispanic2010 %>% 
  filter(AGEGRP == 0) %>%
  filter(YEAR == 1) %>% 
  mutate("total_non_hispanic" = NH_MALE + NH_FEMALE, 
         "total_hispanic" = H_MALE + H_FEMALE) %>%
  select("STATE","COUNTY","STNAME","CTYNAME","TOT_POP",
         "total_non_hispanic", "total_hispanic") %>%
  mutate("check" = ifelse(total_non_hispanic+total_hispanic == TOT_POP, 1, 0))

hispanic2020_processed <- hispanic2020 %>% 
  filter(AGEGRP == 0) %>%
  filter(YEAR == 1) %>% 
  mutate("total_non_hispanic" = NH_MALE + NH_FEMALE, 
         "total_hispanic" = H_MALE + H_FEMALE) %>%
  select("STATE","COUNTY","STNAME","CTYNAME","TOT_POP",
         "total_non_hispanic", "total_hispanic") %>%
  mutate("check" = ifelse(total_non_hispanic+total_hispanic == TOT_POP, 1, 0))

# sanity check 
hispanic2010_processed %>% group_by(check) %>% count()
hispanic2020_processed %>% group_by(check) %>% count()

hispanic2010_processed <- hispanic2010_processed %>% select(-"check")
hispanic2020_processed <- hispanic2020_processed %>% select(-"check")

# merge datasets 
hispanic2010_processed <- hispanic2010_processed %>% 
  select("STNAME","CTYNAME", "total_hispanic")

hispanic <- merge(hispanic2020_processed, hispanic2010_processed, 
                  by = c("STNAME", "CTYNAME"),
                  all.x = T)
hispanic <- hispanic %>% rename("total_hispanic_2010" = "total_hispanic.y",
                                "total_hispanic_2020" = "total_hispanic.x") %>%
  select(-"total_non_hispanic")

# NA processing 
hispanic_na_rows <- hispanic[is.na(hispanic$total_hispanic_2010), ]
hispanic$total_hispanic_2010[hispanic$CTYNAME == "Petersburg Borough"] = 130
hispanic$total_hispanic_2010[hispanic$CTYNAME == "LaSalle Parish"] = 9135
hispanic <- hispanic %>% filter(STNAME != "Connecticut")

write.csv(hispanic, "hispanic.csv")
