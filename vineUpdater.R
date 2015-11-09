noldvids <- length(list.files("videos"))
nvids <- content(GET(paste0("https://api.vineapp.com/timelines/users/1050584674172583936")), "parsed")$data$count
nnewvids <- nvids - noldvids

urls <- vector("character", nnewvids)
dates <- vector("character", nnewvids)
if(nnewvids > 10){
  for(i in 1:floor(nnewvids/10)) {
    # browser()
    timelineListraw <- GET(paste0("https://api.vineapp.com/timelines/users/1050584674172583936?page=", i))
    timelineList <- content(timelineListraw, "parsed")
    for(j in 1:10){
      urls[(i-1)*10 + j] <- timelineList$data$records[[j]]$videoUrl
      dates[(i-1)*10 + j] <- gsub(":", "_", timelineList$data$records[[j]]$created)
    }
  }
}

timelineListLast <- content(GET(paste0("https://api.vineapp.com/timelines/users/1050584674172583936?page=", ceiling(nnewvids/10))), "parse")
for(j in (10*floor(nnewvids/10) + 1):(nnewvids)) {
  urls[j] <- timelineListLast$data$records[[j]]$videoUrl
  dates[j] <- gsub(":", "_", timelineListLast$data$records[[j]]$created)
}

write_mp4 <- function(url, filename) {
  writeBin(GET(url)$content, filename)
}
write_mp4v <- Vectorize(write_mp4)
write_mp4v(urls, paste0("videos/", dates, ".mp4"))
