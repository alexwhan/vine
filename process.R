nvids <- content(GET(paste0("https://api.vineapp.com/timelines/users/", 1050584674172583936)), "parsed")$data$count
userid <- 1050584674172583936
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

dates[grep("2014-11-11T04_02_44", dates)]
shell(paste0('ffmpeg32 -i "', urls[294], '" -c copy ', dates[294], ids[294], '.mp4'))
write_mp4(urls[294], paste0("ffmpegDownload2/", dates[294], ids[294], ".mp4"))
if(nvids %% 10 != 0){
  timelineListLast <- content(GET(paste0("https://api.vineapp.com/timelines/users/", userid, "?page=", ceiling(nvids/10))), "parse")
  for(j in (10*floor(nvids/10) + 1):(nvids)) {
    k <- floor(nvids/10)*10
    urls[j] <- timelineListLast$data$records[[j - k]]$videoUrl
    dates[j] <- gsub(":", "_", timelineListLast$data$records[[j - k]]$created)
    ids[j] <- gsub("[0-9]+([0-9]{5}$)", "\\1", timelineList$data$records[[j - k]]$postId/100)
  }
}
for(i in 1:nvids){
  shell(paste0('ffmpeg32 -i "', urls[i], '" -c copy ffmpegDownload2/', dates[i], ids[i], '.mp4'))
}

for(i in 101:length(urls)) {
  shell(paste0('ffmpeg32 -i ', urls[i], ' ffmpegDownload/', dates[i], ids[i], '.mp4'))
}

fffilessub <- list.files("ffmpegDownload/")
fffiles <- list.files("ffmpegDownload/", full.names = TRUE)

writeLines(text = paste0("file '../", fffiles, "'"), "ffmpegDownload/fffiles.txt", sep = "\n")
shell(paste0('ffmpeg32 -f concat -i ffmpegDownload/fffiles.txt -c copy ffmpegConcat.wmv'), intern = TRUE)

ffnewfiles <- list.files("ffmpegDownload/", pattern = ".mp4")
urlids <- paste0(dates, ids, ".mp4")
sum(urlids %in% ffnewfiles)
sum(ffnewfiles %in% urlids)

urls[!urlids %in% ffnewfiles]

for(i in which(!urlids %in% ffnewfiles)) {
  shell(paste0('ffmpeg32 -i ', urls[i], ' ffmpegDownload/', dates[i], ids[i], '.mp4')) 
}

for(i in 1:3) {
  shell(paste0('ffmpeg32 -i ', urls[i], '-c copy ffmpegDownload/', dates[i], ids[i], '_2.mp4')) 
}

shell('ffmpeg32 -i "http://mtc.cdn.vine.co/r/videos/47C6CF08E41288361639988645888_1450143517399172cc1fddc.mp4.mp4?versionId=h_yAXHECJGnqjzBWApNXeD5T0hCYa.Lt" -c copy ffmpegCopyTest.mp4')
shell('ffmpeg32 -i "http://mtc.cdn.vine.co/r/videos/47C6CF08E41288361639988645888_1450143517399172cc1fddc.mp4.mp4?versionId=h_yAXHECJGnqjzBWApNXeD5T0hCYa.Lt" ffmpegCopyTest_1.mp4')
for(file in files[groups == 29]) {
  shell(paste0('ffmpeg32 -i ', file, ' -c copy -bsf h264_mp4toannexb temp/', sub(".*/(.*).mp4", "\\1", file), '.ts'), intern = TRUE)
}

tempFiles <- list.files('temp/', full.names = TRUE)
tempFilessub <- list.files('temp/')
writeLines(text = paste0("file '../../", tempFiles, "'"), con = "temp/concatFiles/temp.txt", sep = "\n")
shell('ffmpeg32 -f concat -i temp/concatFiles/temp.txt -c copy -bsf aac_adtstoasc recodeTest.mp4')

files <- list.files("ffmpegDownload2/", pattern = ".mp4", full.names = TRUE)
filessub <- list.files("ffmpegDownload2/", pattern = ".mp4")
months <- sub("([0-9]+-[0-9]+)-.*", "\\1", filessub)

groups <- ceiling(1:length(files)/10)
for(group in unique(groups)) {
  writeLines(text = paste0("file '../", files[groups == group], "'"), con = paste0("ffmpegDownload2_concatFiles/", group, ".txt"), sep = "\n")
}
for(group in unique(groups)) {
  shell(paste0('ffmpeg32 -f concat -i ffmpegDownload2_concatFiles/', group, '.txt -c copy ffmpegDownload2_concatmp4/', group, '.mp4'), intern = TRUE)
}

shell('ffmpeg32 -auto_convert 1 -f concat -i ffmpegDownload2_concatFiles/29.txt -c copy manualTest29.mp4', intern = TRUE)


temp <- capture.output({
  shell('ffmpeg32 -i ffmpegDownload2/2014-02-26T22_20_32.00000091646.mp4 -af "volumedetect" -f null NUL')
  }, type = c("message"))

stdout <- vector('character')
con    <- textConnection('stdout', 'wr', local = TRUE)
sink(con, type = "message")
shell('ffmpeg32 -i ffmpegDownload2/2014-02-26T22_20_32.00000091646.mp4 -af "volumedetect" -f null NUL')
1:10
sink()
close(con)

zz <- file("all.txt", open = "wt")
sink(zz)
sink(zz, type = "message")
shell('ffmpeg32 -i ffmpegDownload2/2014-02-26T22_20_32.00000091646.mp4 -af "volumedetect" -f null NUL > temp.txt')
## back to the console
sink(type = "message")
sink()
file.show("all.txt")


