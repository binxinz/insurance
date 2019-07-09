#####################################################
# shan_str_replace
shan_str_replace<-function(pattern, replacement, x, ignore.case = FALSE, perl = FALSE,
                           fixed = FALSE, useBytes = FALSE){
            output<-base::sub(pattern, replacement, x, ignore.case = ignore.case, perl =perl,
                      fixed = fixed, useBytes = useBytes)
return(output)
}
######################################################
# shan_str_replace_all
shan_str_replace_all<-function(pattern, replacement, x, ignore.case = FALSE, perl = FALSE,
                               fixed = FALSE, useBytes = FALSE){
  output<-base::gsub(pattern, replacement, x, ignore.case = ignore.case, perl =perl,
                     fixed = fixed, useBytes = useBytes)
  return(output)
}
####################################################
# 查看是否存在指定字符, 实现多目标
shan_str_detect<-function(input,text){
  if(length(input)==1){
  
    output<-grepl(input,text)}else{
  
    output<-sapply(input,function(x){grepl(x,text)})
    output<-apply(output,1,sum)>0
  }
return(output)
}
############################################
#  抓取一个字符的出现次数
shan_str_count_one<-function(x,dat){
  
  vector<-grepl(x,dat)
  
  output<-rep(0,length(dat))
  
  output[vector]<-sapply(gregexpr(x,dat[vector]),length)
  
  return( unlist(output) )
}
####################################################
# 抓取一群字符的出现次数的和
shan_str_count<-function(x,dat){
  if(length(x)==1){
    output<-shan_str_count_one(x,dat)
  }else{
    long<-length(x)
    det<-matrix(0,ncol = long, nrow = length(dat))
    for(i in 1:long){
      det[,i]<-shan_str_count_one(x[i],dat)
    }
    output<-unlist( as.vector(apply(det,1,sum)) )
  }
  
  return(unlist(output)) 
}
#########################################################
# 抓取需要抓取的字符
shan_str_extract_all<-function(pattern,dat){
  m <- gregexpr(pattern, dat)
  return(regmatches(dat, m))
}
shan_str_extract<-function(pattern,dat){
  m <- regexpr(pattern, dat)
  return(regmatches(dat, m))
}
shan_str_extract_around<-function(pattern,dat,dist){
  m <- gregexpr(pattern, dat)
  start<-m[[1]]-dist
  end<-m[[1]]+attr(m[[1]],"match.length")+dist
return(str_sub(dat,start=start,end=end))
}
########################################################
# shan 模糊抓取函数, 对应一个文本，取最小值
shan_str_extract_between_smallest<-function(a,b,text,distance=999,
                                          want=1,ignore.case = FALSE, perl = FALSE,
                                          fixed = FALSE, useBytes = FALSE){
  # 设置最小距离，定义距离为两个字符之间的距离（所以+2）
  distance<-max(2,distance+2)
  
  if( base::grepl(a,text,ignore.case = ignore.case, perl =perl,
                  fixed = fixed, useBytes = useBytes)&base::grepl(b,text,ignore.case = ignore.case, 
                                                                  perl =perl, fixed = fixed, useBytes = useBytes) ){
    
    # 找到a的位置
    temp<-base::gregexpr(a,text,ignore.case = ignore.case, perl =perl,fixed = fixed, useBytes = useBytes)
    astart<-unlist(temp)
    aend<-astart+attr(temp[[1]],"match.length")-1
    # 找到b的位置
    temp<-base::gregexpr(b,text,ignore.case = ignore.case, perl =perl,fixed = fixed, useBytes = useBytes)
    bstart<-unlist(temp)
    bend<-bstart+attr(temp[[1]],"match.length")-1
    #做一个a位置到b位置的距离表
    DISTtable<-matrix(NA,nrow=length(astart),ncol=length(bstart))
    #输出距离表
    for(i in 1: length(astart) ){
      DISTtable[i,]<-bstart-aend[i]}
    # 不要负距离
    DISTtable[DISTtable<0]<-Inf
    #假设探测距离为distance
    long<-sum(DISTtable<=distance)
    long<-min(long,want)
    if( long >0 ){
      #最小距离表，先是第几个字符，再是对应的距离最小坑
      value<-matrix(ncol=2,nrow=long)
      #一个坑最多放一个字符
      for( i in 1:long){
        pos<-which(DISTtable==(min(DISTtable)), arr.ind = TRUE)[1,]
        value[i,]<-pos
        DISTtable[pos[1],      ]<-Inf
        DISTtable[      ,pos[2]]<-Inf
      }
      output<-rep(NA,long)
      for(i in 1:long){
        output[i]<-str_sub(text,start=astart[value[i,1]],end=bend[value[i,2]])
      }}else{output<-""}
  }else{output<-""}
  return(output)
}
# shan 模糊群抓取函数，对应一个文本，取最小值
shan_str_extract_between_largest<-function(a,b,text,distance=999,
                                          want=1,ignore.case = FALSE, perl = FALSE,
                                          fixed = FALSE, useBytes = FALSE){
  # 设置最小距离，定义距离为两个字符之间的距离（所以+2）
  distance<-max(2,distance+2)
  
  if( base::grepl(a,text,ignore.case = ignore.case, perl =perl,
                  fixed = fixed, useBytes = useBytes)&base::grepl(b,text,ignore.case = ignore.case, 
                                                                  perl =perl, fixed = fixed, useBytes = useBytes) ){
    
    # 找到a的位置
    temp<-base::gregexpr(a,text,ignore.case = ignore.case, perl =perl,fixed = fixed, useBytes = useBytes)
    astart<-unlist(temp)
    aend<-astart+attr(temp[[1]],"match.length")-1
    # 找到b的位置
    temp<-base::gregexpr(b,text,ignore.case = ignore.case, perl =perl,fixed = fixed, useBytes = useBytes)
    bstart<-unlist(temp)
    bend<-bstart+attr(temp[[1]],"match.length")-1
    #做一个a位置到b位置的距离表
    DISTtable<-matrix(NA,nrow=length(astart),ncol=length(bstart))
    #输出距离表
    for(i in 1: length(astart) ){
      DISTtable[i,]<-bstart-aend[i]}
    # 不要负距离
    DISTtable[DISTtable<0]<--Inf
    #假设探测距离为distance
    long<-sum(DISTtable>0)
    long<-min(long,want)
    if( long >0 ){
      #最小距离表，先是第几个字符，再是对应的距离最小坑
      value<-matrix(ncol=2,nrow=long)
      #一个坑最多放一个字符
      for( i in 1:long){
        pos<-which(DISTtable==(max(DISTtable)), arr.ind = TRUE)[1,]
        value[i,]<-pos
        DISTtable[pos[1],      ]<--Inf
        DISTtable[      ,pos[2]]<--Inf
      }
      output<-rep(NA,long)
      for(i in 1:long){
        output[i]<-str_sub(text,start=astart[value[i,1]],end=bend[value[i,2]])
      }}else{output<-""}
  }else{output<-""}
  return(output)
}
###############################################################################
# shan 模糊群抓取函数，对应一个文本，取最小值
shan_str_extract_between<-function(a,b,text,type = "smallest",distance=999,
                                             ignore.case = FALSE, perl = FALSE,
                                             fixed = FALSE, useBytes = FALSE){
  output<-rep("",length(text))
  if (type == "smallest") {
    for(i in 1: length(text)){
      output[i]<-shan_str_extract_between_smallest(a,b,text[i],distance=distance,want=1,
      ignore.case = ignore.case,perl =perl, fixed = fixed, useBytes = useBytes)}
  }else if (type == "largest") {
    for(i in 1: length(text)){
      output[i]<-shan_str_extract_between_largest(a,b,text[i],distance=distance,want=1,
      ignore.case = ignore.case,perl =perl, fixed = fixed, useBytes = useBytes)}
  }                                                               
return(output)
}
#########################################################
# 按照模式分割字符串
shan_str_split <- function(x,split,type = "remove",perl = FALSE,...) {
  if (type == "remove") {
                    # use base::strsplit
                    out <- base::strsplit(x = x, split = split, perl = perl, ...)
                        } else if (type == "before") {
                    # split before the delimiter and keep it
    out <- base::strsplit(x = x,
                          split = paste0("(?<=.)(?=", split, ")"),
                          perl = TRUE,
                          ...)
  } else if (type == "after") {
    # split after the delimiter and keep it
    out <- base::strsplit(x = x,
                          split = paste0("(?<=", split, ")"),
                          perl = TRUE,
                          ...)
  } else {
    # wrong type input
    stop("type must be remove, after or before!")
  }
  return(out)
}
#####################################################
# shan_str_split_first


