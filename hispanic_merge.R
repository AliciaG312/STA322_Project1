data <- read.csv("merge_vote.csv")
hispanic <- read.csv("hispanic.csv")

library(stringr)
hispanic$CTYNAME <- str_replace(hispanic$CTYNAME, " County", "")
hispanic$CTYNAME <- str_replace(hispanic$CTYNAME, " city", "")
hispanic$CTYNAME <- str_replace(hispanic$CTYNAME, " City and Borough", ", City and Borough of")

hispanic$CTYNAME[hispanic$CTYNAME == "Anchorage Municipality"] = "Anchorage, Municipality of"
hispanic$CTYNAME[hispanic$CTYNAME == "Do�a Ana"] = "Doña Ana"
hispanic$CTYNAME[hispanic$CTYNAME == "Larue"] = "LaRue"
hispanic$CTYNAME[hispanic$CTYNAME == "Prince of Wales-Hyder Census Area"] = "Prince of Wales – Hyder Census Area"
hispanic$CTYNAME[hispanic$CTYNAME == "Skagway Municipality"] = "Skagway, Municipality of"

hispanic$CTYNAME[hispanic$CTYNAME == "Yukon–Koyukuk Census Area"] = "Yukon–Koyukuk Census Area" #???

merge_final <- merge(data, hispanic, 
                     by.x = c("county", "state"), by.y = c("CTYNAME", "STNAME"), 
                     all.x = T)

merge_final_na_rows <- merge_final[is.na(merge_final$TOT_POP), ]

write.csv(merge_final, "merge_final.csv")

