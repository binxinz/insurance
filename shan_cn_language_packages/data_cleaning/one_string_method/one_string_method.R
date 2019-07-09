#####################################################
# txt保险文档套路
shan_clean_dat<-function(dat){
  
  dat<-shan_clean_remove_pagenumber(dat)
  word<-paste(dat,collapse = " ")
  word<-shan_remove_space(shan_str_extract_all("\\d+ 日",word)[[1]],word)
  word<-shan_remove_space(shan_str_extract_all("\\d+ 天",word)[[1]],word)
  word<-shan_remove_space(shan_str_extract_all("\\d+ 期",word)[[1]],word)
  word<-shan_remove_space(shan_str_extract_all("\\d+ 型",word)[[1]],word)
  word<-shan_remove_space(shan_str_extract_all("\\d+ 倍",word)[[1]],word)
  word<-shan_remove_space(shan_str_extract_all("\\d+ 个",word)[[1]],word)
  word<-shan_remove_space(shan_str_extract_all("\\d+ 度",word)[[1]],word)
  word<-shan_remove_space(shan_str_extract_all("\\d+ 分",word)[[1]],word)
  word<-shan_remove_space(shan_str_extract_all("\\d+ 级",word)[[1]],word)
  word<-shan_remove_space(shan_str_extract_all("\\d+ 升",word)[[1]],word)
  word<-shan_remove_space(shan_str_extract_all("\\d+ 赫兹",word)[[1]],word)
  word<-shan_remove_space(shan_str_extract_all("\\d+ 小时",word)[[1]],word)
  word<-shan_remove_space(shan_str_extract_all("\\d+ 周岁",word)[[1]],word)
  word<-shan_remove_space(shan_str_extract_all("\\d+ 组",word)[[1]],word)
  word<-shan_remove_space(shan_str_extract_all("\\d+ 年",word)[[1]],word)
  word<-shan_remove_space(shan_str_extract_all("\\d+ 种",word)[[1]],word)
  
  word<-shan_remove_space(shan_str_extract_all("第 \\d+ 类",word)[[1]],word)
  
return(word)
}
###########################################
#  去除分页的字符
shan_clean_remove_pagenumber<-function(dat){
  
  # 去除数字分页
  word<-str_remove_all(dat,"[:space:]+")
  dat<-dat[!(word %in% 0:150)]
  
  # 去除 其它分页类型
  word<-str_remove_all(dat,"[:space:]")
  word<-str_remove_all(word,"[:punct:]")
  x<-c("本页内容结束","结束","本条款内容结束")
  
  dat<-dat[! (word %in% x) ]
  
  # 去除，页数分页
  word<-str_remove_all(dat,"[:space:]")
  word<-str_remove_all(word,"[:punct:]")
  word<-str_remove_all(word,"[:digit:]")
  word<-shan_str_replace_all("[一二三四五六七八九十]","",word)
  x<-c("第页共页","第页","页")
  dat<-dat[! (word %in% x) ]
  
  # 去除 \t , 去除空格
  dat<-shan_str_replace_all("\t"," ",dat)
  dat<-shan_str_replace_all("\\s+"," ",dat)
  dat<-str_trim(dat,side=c("both"))
  
  # 不要空字符
  dat<-dat[dat!=""]
  
  return(dat)
  
}
#################################################################
# 去除不想要的space
shan_remove_space<-function(replace,word){
  a<-replace
  if( length(a)>0){
    a<-a[!duplicated(a)]
    b<-str_remove_all(a," ")
    for(i in 1:length(a)){
      word<-shan_str_replace_all(a[i],b[i],word)
    }
  }
  return(word)
}