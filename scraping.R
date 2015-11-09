library(httr)
write_mp4 <- function(url, filename) {
  writeBin(GET(url)$content, filename)
}
write_mp4v <- Vectorize(write_mp4)

getAllVines <- function(userid, path) {
  #Vine user id: 1050584674172583936
  nvids <- content(GET(paste0("https://api.vineapp.com/timelines/users/", userid)), "parsed")$data$count
  
  urls <- vector("character", nvids)
  dates <- vector("character", nvids)
  ids <- vector("character", nvids)
  for(i in 1:floor(nvids/10)) {
    # browser()
    timelineListraw <- GET(paste0("https://api.vineapp.com/timelines/users/", userid, "?page=", i))
    timelineList <- content(timelineListraw, "parsed")
    for(j in 1:10){
      urls[(i-1)*10 + j] <- timelineList$data$records[[j]]$videoUrl
      dates[(i-1)*10 + j] <- gsub(":", "_", timelineList$data$records[[j]]$created)
      ids[(i-1)*10 + j] <- gsub("[0-9]+([0-9]{5}$)", "\\1", timelineList$data$records[[j]]$postId/100)
    }
  }
  
  timelineListLast <- content(GET(paste0("https://api.vineapp.com/timelines/users/", userid, "?page=", ceiling(nvids/10))), "parse")
  for(j in (10*floor(nvids/10) + 1):(nvids)) {
    urls[j] <- timelineListLast$data$records[[j - (nvids - 1)]]$videoUrl
    dates[j] <- gsub(":", "_", timelineListLast$data$records[[j - (nvids - 1)]]$created)
    ids[j] <- gsub("[0-9]+([0-9]{5}$)", "\\1", timelineList$data$records[[j - (nvids - 1)]]$postId/100)
  }
  
  write_mp4 <- function(url, filename) {
    writeBin(GET(url)$content, filename)
  }
  write_mp4v <- Vectorize(write_mp4)
  write_mp4v(urls, paste0(path, dates, ids, ".mp4"))
}