#####################################################
# 文档分多段 套路
shan_clean_documant<-function(dat){
  
  # function2
  dat<-shan_clean_remove_pagenumber(dat)
  # function3
  dat<-shan_clean_sep_by_sentence_mark(dat)
  # function4
  dat<-shan_clean_combine_dat(dat)
  
  return(dat)
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
  x<-c("本页内容结束")
  
  dat<-dat[! (word %in% x) ]
  
  return(dat)
  
}

###########################################
# 将dat重新按句号组号分类
shan_clean_sep_by_sentence_mark<-function(dat){
  
  dat<-paste(dat,collapse = "")
  # 将数据分句
  dat<-unlist(strsplit(dat,"。"))
  # 加回句号
  dat<-paste(dat,"。")
  
  return(dat)
}

####################################################
# 合并清理后的数据
shan_clean_combine_dat<-function(dat){
  
  det<-shan_grab_sep_location(dat)
  
  det<-c(1,det)
  
  if(det[length(det)]<length(dat)){
    # 在for loop中每个减去了1
    det<-c(det, (length(dat)+1) )
  }
  
  output<-rep(NA,( length(det)-1) )
  
  for( i in 1: (length(det)-1) ){
    #从当前位置到下个位置减一（最后一项直到最后）
    output[i]<-str_c(dat[ det[i] : (det[i+1]-1) ],collapse="")
  }
  
  return(output)
}

##############################################################
# dat为整行数据,提取数据每行第一个字符
shan_grab_first_word<-function(dat){
  
  # 提取首字符
  det<-str_extract(dat,"[:graph:]+")
  
  x<-c("一" ,"二", "三" ,"四" ,"五" ,"六" ,"七", "八", "九", "十",0:9)
  
  is_number<-which( (str_sub(det,start=1,end=1) %in% x ) )
  is_word<-which( !(str_sub(det,start=1,end=1) %in% x ) )
  
  det[is_word]<-str_sub(det[is_word],start=1,end=3)
  det[is_number]<-shan_str_extract("[一二三四五六七八九十0123456789.]+",det[is_number])
  
  det[is.na(det)]<-""
  
  return(det)
}
########################################################
# 抓取首数字函数，中文大写数字与阿拉伯数字兼容
shan_grab_sep_location<-function(dat){
  first_word<-shan_grab_first_word(dat)
  
  det<- shan_str_count("[一二三四五六七八九十]+",first_word)+
        str_count(first_word,"[0123456789.]+")
  
  return(which(det>0))
}
###################################################
# 通过识别local maximum进行表格分页
shan_sep_find_local_max<-function(dat){
  
  det<-shan_str_extract("\\d+",dat)
  det[!det %in% 1:200]<--Inf
  det<-as.numeric(det)
  
  dist<-2
  
  # 寻找最大距离定义内的local maximum
  point<-rep(NA,length(det))
  for(i in 1:length(det)){
    startpoint<-max(1,i-dist)
    endpoint<-min(length(det),i+dist)
    point[i]<-(det[i]==max(det[startpoint:endpoint]))
  }
  
  # 获取local maximum位置
  want<-which(point==TRUE)
return(want)
}
###################################################
# 通过识别local minimum进行表格分页
shan_sep_find_local_min<-function(dat){
  
  det<-det<-shan_str_extract("\\d+",dat)
  det[!det %in% 1:200]<-Inf
  det<-as.numeric(det)
  
  dist<-5
  
  # 寻找最大距离定义内的local maximum
  point<-rep(NA,length(det))
  for(i in 1:length(det)){
    startpoint<-max(1,i-dist)
    endpoint<-min(length(det),i+dist)
    point[i]<-(det[i]==min(det[startpoint:endpoint]))
  }
  
  # 获取local maximum位置
  want<-which(point==TRUE)
  return(want)
}  

