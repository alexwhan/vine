library(httr)

#Vine user id: 1050584674172583936
urls <- vector("character", 546)
dates <- vector("character", 546)
for(i in 1:55) {
  # browser()
  timelineListraw <- GET(paste0("https://api.vineapp.com/timelines/users/1050584674172583936?page=", i))
  timelineList <- content(timelineListraw, "parsed")
  for(j in 1:10){
    urls[(i-1)*10 + j] <- timelineList$data$records[[j]]$videoUrl
    dates[(i-1)*10 + j] <- gsub(":", "_", timelineList$data$records[[j]]$created)
  }
}

write_mp4 <- function(url, filename) {
  writeBin(GET(url)$content, filename)
}
write_mp4v <- Vectorize(write_mp4)
write_mp4v(urls, paste0("videos/", dates, ".mp4"))
