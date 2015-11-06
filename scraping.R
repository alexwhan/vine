library(httr)

vid2 <- GET("http://v.cdn.vine.co/r/videos/2EE966080D1274251656577933312_47201dda519.0.0.4145043913657572806.mp4")
writeBin(vid2[["content"]], "vid2.mp4")


url1 <- GET("https://vine.co/v/eLXza2FjwWw")
writeBin(url1$content, "vid3.mp4")
url1.p <- content(url1, "parsed")

get_mp4_url <- function(url) {
  pageContent <- GET(url)
  browser()
  pageContent.p <- content(pageContent, "text")
  vidUrlraw <- sub('.*videoUrl\\\": \\\"(.*mp4).*', '\\1', pageContent.p)
  vidUrl <- gsub("\\\\", "", vidUrlraw)
}
get_mp4_url("https://vine.co/v/eLXza2FjwWw")

write_mp4 <- function(vidUrl, filename) {
  vidraw <- GET(vidUrl)
  writeBin(vidraw$content, filename)
}

user <- GET("https://api.vineapp.com/timelines/users/1050584674172583936")
temp <- content(user, "parsed")
str(temp$data$records)

user2 <- GET("https://api.vineapp.com/timelines/users/1050584674172583936?page=2")
temp2 <- content(user2, "parsed")
user3 <- GET("https://api.vineapp.com/timelines/users/1050584674172583936?page=3")
temp3 <- content(user3, "parsed")
for(i in 1:10) print(temp3$data$records[[i]]$description)
for(i in 1:10) print(temp2$data$records[[i]]$description)
writeBin(GET(temp2$data$records[[1]]$videoLowURL)$content, "vl.mp4")
writeBin(GET(temp2$data$records[[1]]$videoUrl)$content, "v.mp4")
temp2$data$records[[1]]$created
str(temp2$data$records)

user3 <- GET("https://vine.co/alexwhan", page = 2)
temp3 <- content(user3, "parsed")
str(temp2$data$records)

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

write_mp4(urls[1], paste0(dates[1], ".mp4"))

setwd()