################################
# 剔除分页时的无效文字
clean_page_text<-function(dat){
  
  # 设置最大年龄，可修改
  maxage<-105
  
  # 提取第一个数字字符
  det<-sep_grab_first_word(dat)
  # 将不在年龄范围内的数字设为NA
  det[!(det %in% 0:maxage)]<-NA
  
  # 检验出第一个年龄数字，并记录下
###########################################################
  # 假设年龄是个1到3的等差数列，可修改
  det<-as.numeric(det)
  startpoint<-which(det==min(na.omit(det)))[1]
  true<-diff(det) %in% 1:3
  true<-c(true,rep(TRUE,1))

###########################################################
  # 最后一步，移除不想要保留的词,可添加新词
  # 不想要的词
  true1<-str_count(dat,"交")+
    str_count(dat,"至")+
    str_count(dat,"页")+
    str_count(dat,"/")
  
  # 以上语句出现0次
  true1<-(true1==0)
  
  # 不想要的词，与不想要的数字都剔除
  true<-true&true1
  
  # 第一个年龄数字之前的都要
  true[1:startpoint]<-TRUE
  
  # 截取为真的数据
  dat<-dat[true]

##############################################################
  # 截去过长的数据
  #a<-str_count(dat,"[:graph:]+")
  #
  #max(a[a!=max(a)])==max(a)
  #
  #if(!(max(a[a!=max(a)])==max(a))){
  #  dat[which(a==max(a))]<-
  #    str_replace_all(dat[which(a==max(a))],"[:space:]+","")
  #}
  
  return(dat)
}






