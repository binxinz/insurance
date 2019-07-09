# 将dat按行分类
###########################################################
# 并合并所有页数
sep_change_line<-function(dat){
  
  dat1<-get_position_vector(dat[[1]])   
  if(length(dat)>1){
    for(i in 2: length(dat)){
      dat1<-c(dat1,get_position_vector(dat[[i]]))
    }
  }
  return(dat1)
}

###################################################
# 通过识别local maximum进行表格分页
sep_find_cut_point<-function(dat){
  
  # 设置最大年龄，可修改
  maxage<-105
  
  # 提取第一个数字字符
  #det<-str_extract(dat,"[0123456789.]+")
   det<-sep_grab_first_word(dat)
  
  # 将不在年龄范围内的数字设为NA
  det[!(det %in% 0:maxage)]<-NA
  
  # 找到两组数字间的最大距离
  dist<-max(diff(which(det %in% 0:maxage)))
  
  # 仅保留数字项
  det<-as.numeric(det)
  
  # 通过年龄范围修正字符最大距离
  dist<-dist+as.integer((max(na.omit(det))-min(na.omit(det)))/3)
  
  # 填充NA项
  det[det %in% NA]<-0

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

#######################################################
# 将获得的分割点转化为各个小子数据集

sep_table<-function(dat,point){
  
  seperate<-point
  # create list vector
  seplist<-list()
  
  for( i in 1:length(seperate)){
    if(i==1){seplist[[i]]<-1:seperate[i]}else{
      seplist[[i]]<-(seperate[i-1]+1):seperate[i]}
  }
  
  if(max(seperate)<length(dat)){
    seplist[[i+1]]<-(seperate[i]+1):length(unlist(dat))
  }
  return(seplist)
}

# 提取首字符串的函数：
##############################################################
# dat为整行数据,提取数据每行第一个字符

sep_grab_first_word<-function(dat){
  
  # 去除开头空格
  dat[str_sub(dat,start=1,end=1)==" "]<-
    str_replace(dat[str_sub(dat,start=1,end=1)==" "],"\\s+","")
  # 提取首字符
  det<-str_extract(dat,"[:graph:]+")
  
  return(det)
}

################################################################
