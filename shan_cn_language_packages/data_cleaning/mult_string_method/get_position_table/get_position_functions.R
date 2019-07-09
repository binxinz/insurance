###################################################
# 获得一个行的字符位置，输入的为一行的数据
get_position_a<-function(dat){
  
  # 获得位置
  det<-str_locate_all(dat[1],"[:graph:]+")[[1]]
  
  # 得到位置表
   a<-cbind(1:dim(det)[1],data.table(det))
  colnames(a)<-c("word","start","end")
  
  return(a)
}

#########################################################
# 获得一个数据（row*column)的字符位置
get_position_location_all<-function(dat){
  # 获得位置
  det<-str_locate_all(dat,"[:graph:]+")
  
  # 得到位置表
  a<-data.table(cbind(1,det[[1]]))
  colnames(a)<-c("line","start","end")
  if( length(det)> 1){
    for(line in 2:length(det)){
      a<-rbind(a,cbind(line,data.table(det[[line]])))
    }
  }
  return(a)
}

#######################################################
# function to get b
# 获得一个标准化框架区间 （取最大范围）
get_position_b<-function(dat){
  
  a<-get_position_location_all(dat)
  
  # 制作总统计表
  b<-a[,.N,c("line")]
  dat_max_length<-max(b$N)
  
  # 得到所有有最多字符的行
  list<-b[N==dat_max_length]$line
  a<-a[line %in% list]
  
  min<-max<-rep(NA,dat_max_length)
  # 记录median的位置
  for(i in 1:dat_max_length){
    min[i]<-mean(na.omit(a[,.SD[i,],c("line")]$start))
    max[i]<-mean(na.omit(a[,.SD[i,],c("line")]$end))
  }
  
  b<-data.table(cbind(1:dat_max_length,min,max))
  colnames(b)<-c("column","min","max")
  
  # 取位置中值
  b$position<-(b$max+b$min)/2
  
  return(b)
}
#################################################
#制作位置true false识别行，dat输入为一行的数据
get_position_TFline<-function(dat,b){  
  
  #得到一行数据的所有字符位置
  a<-get_position_a(dat)
  #标记中点为位置
  a$position<-(a$end+a$start)/2
  #做一个中点位置到平均位置的距离表
  DISTtable<-matrix(nrow=dim(a)[1],ncol=dim(b)[1])
  #输出距离表
  for(i in 1:dim(a)[1]){
    DISTtable[i,]<-abs(a$position[i]-b$position)
  }
  #最小距离表，先是第几个字符，再是对应的距离最小坑
  value<-matrix(ncol=2,nrow=dim(a)[1])
  #一个坑最多放一个字符
  for( i in 1:dim(a)[1]){
    pos<-which(DISTtable==(min(DISTtable)), arr.ind = TRUE)[1,]
    value[i,]<-pos
    DISTtable[pos[1],      ]<-Inf
    DISTtable[      ,pos[2]]<-Inf
  }
  #只需要知道占了哪些坑就行
  return(value[,2])
}
#################################################
# 制作位置true false表
get_position_TFtable<-function(dat){
  
  # 先得到平均距离
  b<-get_position_b(dat)
  # 制作真值表
  TFtable<-matrix(FALSE,ncol=max(b$column),nrow=length(dat))
  # 通过真值行函数构建真值表
  for(j in 1:length(dat)){
    TFtable[j,get_position_TFline(dat[j],b)]<-TRUE
  }
  
  
  return(TFtable)
}

#############################################################
# 抓取数值与文字，将真值表转化为数据
get_position_datatable<-function(dat){
  
  # 提取位置真值表
  det<-get_position_TFtable(dat)
  
  # 去除开头空格
  dat[str_sub(dat,start=1,end=1)==" "]<-
    str_replace(dat[str_sub(dat,start=1,end=1)==" "],"\\s+","")
  
  # 解开dat，输入进value
  dat<-str_split(dat,"\\s+")
  
  # 建立value表
  value<-matrix("",nrow=dim(det)[1],ncol=dim(det)[2])
  
  # 设置表格的内容
  for(i in 1:dim(det)[1]){
    value[i,det[i,]]<-dat[[i]]
  }  
  # 返回表
  return(value)
}

#########################################################
# 对data进行位置标记，再用分隔符号分割
# 并将标好位置的data转回向量形式

get_position_vector<-function(dat){
  
  # 通过寻找local maximum的方式获取分割点
  a<-sep_find_cut_point(dat)
  seplist<-sep_table(dat,a)
  
  det<-c()
  for(i in 1:length(seplist)){
    #获取一个页的数据
    dat1<-dat[seplist[[i]]]
    
    #文字项不做改动
    a<-clean_get_text_data(dat1)
    
    # 将数字项压缩
    b<-clean_get_pure_numeric_data(dat1)
    if(length(b)>0){
      b<-get_position_datatable(
        clean_get_pure_numeric_data(dat1))
      b<-apply(b,1,function(x){paste(x,collapse=" seperate")})
    }
    #合并
    dat1<-c(a,b)
    det<-c(det,dat1)
  }
  return(det)
}

###########################################################
# get output
get_result_table<-function(dat){
  
  # 获得当页的最大列数
  max_length<-max(str_count(dat," seperate"))+1
  # 将字符分割
  b<-str_split(dat," seperate")
  # 输出
  output<- matrix(NA,nrow=length(b),ncol=max_length)
  
  for( i in 1:length(b) ){
    length(b[[i]])<-max_length
    output[i,]<-b[[i]]
  } 
  # 不要NA
  output[which(is.na(output), arr.ind = TRUE)]<-""
  
  return(output)
}