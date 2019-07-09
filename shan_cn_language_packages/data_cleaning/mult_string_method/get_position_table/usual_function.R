###############################################
#    只要数字data
clean_get_pure_numeric_data<-function(dat){
  # 不要文字，不要翻页符号
  det<-str_count(dat,"[:alpha:]")+
    str_count(dat,"/")
  
  # 得到纯数字列数
  dat<-dat[det==0]
  
  #dat<-str_replace(dat,"\\d+","")
  #dat<-str_replace(dat,"\\s+","")
return(dat)
}

###############################################
#    要文字data
clean_get_text_data<-function(dat){
  # 不要文字，不要翻页符号
  det<-str_count(dat,"[:alpha:]")+
    str_count(dat,"/")
  
  # 得到纯数字列数
  dat<-dat[det>0]

  return(dat)
}

################################################
# 压缩过长数据
clean_compress_age<-function(dat1){
  
  all_max<-max(str_count(dat1,"[:graph:]+"))
  num_max<-max(str_count(dat1,"[.0123456789]+"))
  
  i<-0
  while((all_max>num_max)&(i<=5)){
    
    which_max<-which.max(str_count(dat1,"[:graph:]+"))
    
    text<-dat1[which_max]
    
    number_position<-str_locate_all(text,"[.0123456789]+")[[1]]
    
    det<-number_position[,2]+1
    
    words<-unlist(str_split(text,""))
    
    det<-det[words[det]==" "]
    
    words[det]<-""
    
    dat1[which_max]<-paste(words,collapse = "")
    
    all_max<-max(str_count(dat1,"[:graph:]+"))
    
    i<-i+1
  }
  
  if(i ==5 ){
    dat1[str_count(dat1,"[:graph:]+")>num_max]<-
      str_replace_all(dat1[str_count(dat1,"[:graph:]+")>num_max],"\\s+","")
    
  }
  
  return(dat1)
}

