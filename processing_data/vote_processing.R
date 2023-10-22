merge_final_v3 <- read.csv("merge_final_v3.csv")

# the following code finds the total vote population in 2020 
# fill in NA
merge_final_v3$rep_vote[merge_final_v3$county == "Kalawao"] = 1
merge_final_v3$rep_vote_pct[merge_final_v3$county == "Kalawao"] = 1/24
merge_final_v3$dem_vote[merge_final_v3$county == "Kalawao"] = 23
merge_final_v3$dem_vote_pct[merge_final_v3$county == "Kalawao"] = 23/24

# make sure sum of vote percentages for all counties equal to 1 
merge_final_v3 <- merge_final_v3 %>% mutate(vote_pop = round((rep_vote + dem_vote) / (rep_vote_pct + dem_vote_pct)))

write.csv(merge_final_v3, "merge_final_v4.csv")