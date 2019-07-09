####################################################
# 抽出多少种
shan_find_kind_number<-function(input){
  
  output<-shan_str_extract("(共|有)((\\d|[一二三四五六七八九十]| ){0,5})(种)",input)
  
  if( length(output)>0){
    output<-shan_transfer_number(output)
    output<-shan_str_extract("\\d+",output)
  }else{output<-0}
  
  return(output)
}
####################################################
# 抽出多少组
shan_find_group_number<-function(input){
  
  output<-shan_str_extract("(共|有|分为)((\\d|[一二三四五六七八九十ABCDEFG、]| ){0,20})(组)",input)
  
  if( length(output)>0){
    output<-shan_transfer_number(output)
    output<-shan_str_extract("\\d+",output)
  }else{output<-0}
  
  return(output)
}
####################################################
# 找多少种，是否有
shan_get_kind<-function(big_ill,middle_ill,small_ill,special_ill,word_end,kind_det1){
  
  big<-shan_str_extract(word_end,kind_det1[shan_str_detect(big_ill,kind_det1)])
  middle<-shan_str_extract(word_end,kind_det1[shan_str_detect(middle_ill,kind_det1)])
  small<-shan_str_extract(word_end,kind_det1[shan_str_detect(small_ill,kind_det1)])
  special<-shan_str_extract(word_end,kind_det1[shan_str_detect(special_ill,kind_det1)])
  
  if(length(big)==0){big<-""};if(length(middle)==0){middle<-""}
  if(length(small)==0){small<-""};if(length(special)==0){special<-""}
  big<-big[1];middle<-middle[1];small<-small[1];special<-special[1]
  
  output<-cbind(c("重疾","中症","轻症","特疾"),c(big,middle,small,special))
  
  colnames(output)<-c("疾病种类","疾病种数")
  rownames(output)<-1:4
  
  return(output)
}

#####################################################
# 找分了多少组
shan_find_group<-function(big_ill,middle_ill,small_ill,special_ill,word_end,group_det2,table){
  
  word_start<-paste0(big_ill,"|",middle_ill, "|", small_ill ,"|",special_ill , collapse="")
  
  big<-shan_str_extract(word_end,group_det2[shan_str_detect(big_ill,group_det2)])
  middle<-shan_str_extract(word_end,group_det2[shan_str_detect(middle_ill,group_det2)])
  small<-shan_str_extract(word_end,group_det2[shan_str_detect(small_ill,group_det2)])
  special<-shan_str_extract(word_end,group_det2[shan_str_detect(special_ill,group_det2)])
  
  if(length(big)==0){big<-""};if(length(middle)==0){middle<-""}
  if(length(small)==0){small<-""};if(length(special)==0){special<-""}
  big<-big[1];middle<-middle[1];small<-small[1];special<-special[1]
  
  output<-c(big,middle,small,special)
  
  output<-cbind(table,output)
  colnames(output)<-c("疾病种类","疾病种数","分组类别")
  rownames(output)<-1:4
  
  return(output)
}
######################################################################
# 聚类分析分割文本
shan_cluster_text<-function(dat2,detect_length=50){
  temp<-gregexpr(" ", dat2)
  sep<-rep(NA,length(temp))
  for(i in 1:length(temp)){
    temp1<-temp[[i]][temp[[i]]<detect_length]
    if (length(temp1)==1){
      sep[i]<-temp1[1]
    }else if(length(temp1)>1){
      temp2<-c(0,temp1,detect_length)
      sss<-kmeans(temp2,2)
      sep[i]<-temp2[which(diff(sss$cluster)!=0)]
    }else if(length(temp1)==1){
      sep[i]<-0
    }
  }
  return(sep)
}
######################################################################
# r group function
shan_get_kind_input<-function(dat_ill_index,dat_ill_name,cluster_num){
  dat_kind_name<-rep("",length(dat_ill_index))
  
  index_det<-c(1,1+cumsum(abs(diff(as.numeric(dat_ill_index)))))
  sss<-kmeans(index_det,cluster_num)
  group<-list()
  
  for(i in 1: cluster_num){
    group[[i]]<-which(sss$cluster==i)
  }
  
  kind<-c("重疾","中症","轻症","特疾")
  for(i in 1: cluster_num){
    
    test<-rep(0,4)
    for(j in 1:4){
      test[j]<-sum(shan_str_replace_all("（|）|、|：|:","",dat_ill_name[group[[i]]]) %in% as.character(
        list[which(list$疾病种类==kind[j]),]$`疾病名称`))
    }
    
    dat_kind_name[group[[i]]]<-kind[which.max(test)]
  }
  return(dat_kind_name)
}
#######################################################################
shan_find_cancer<-function(word,marka,markb,index){
  
  index1<-paste0("[",index[1],index[2],"]",collapse = "")
  
  #  正则表达式符号
  replace_mark<-c( "^" , "$" , "." , "|" , "?" , "*" , "+" , "(" , ")" )
  
  mark<-paste0(marka,".{0,5}",markb,collapse="")
  sep_det<-shan_str_extract_around(mark,word,10)
  det<-gregexpr(marka,sep_det)[[1]]
  sep_det<-str_sub(sep_det,end = det[length(det)])
  
  det<-gregexpr(index1,sep_det)[[1]]
  form_after <- str_sub(sep_det, start= (det[length(det)]+1) , end= (nchar(sep_det)-1) )
  
  det1<-gregexpr("\\S+",sep_det)[[1]]
  det2<-det1+attr(det1,"match.length")
  det2<-det2[det2<det[length(det)]]
  
  form_before <- str_sub(sep_det, start= det2[length(det2)] , end= (det[length(det)]-1) )
  
  #标识出正则表达式
  for( i in 1:length(replace_mark) ){
    form_before<-shan_str_replace_all(paste0("\\",replace_mark[i],collapse=""),paste0("[",replace_mark[i],"]",collapse=""),form_before)
    form_after<-shan_str_replace_all(paste0("\\",replace_mark[i],collapse=""),paste0("[",replace_mark[i],"]",collapse=""),form_after)
  }
  
  #form_after<-paste0(form_after,"\\w",collapse="")
  
  det_num<-str_sub(sep_det , start = det[length(det)] , end = det[length(det)] )
  if(det_num==index[1] ){
    form<-paste0(form_before,"\\d+",form_after)
    index_type<-"arabic"
  }else if(det_num==index[2]){
    form<-paste0(form_before,"[一二三四五六七八九十百零〇]+",form_after)
    index_type<-"chinese_small"
  }
  
  return(c(form_before,form_after,form,index_type))
}
####################################################################
shan_sep_word<-function(word,type="kind"){
  
  if(type == "kind"){
    det1<-regexpr("第.{0,3}(类|组)",word)
    det<-regexpr("(共|有|计)((\\d|[一二三四五六七八九十百零〇]| ){0,10})种",word)
    sentence<-gregexpr("。",word)[[1]]
    word1<-str_sub(word, start = max(sentence[sentence<det])+1)
  }else{
    word1<-word
  }
  
  return(word1)
}
#####################################################################
shan_process_dat<-function(form,form_before,dat1,index_type){
  
  dat_ill_group<-dat1[1]
  dat1<-dat1[2:length(dat1)]
  dat_ill_index<-shan_str_extract(form,dat1)
  dat_ill_index<-shan_str_replace(form_before,"",dat_ill_index)
  dat_ill_index<-shan_str_extract("[0123456789一二三四五六七八九十百零〇]+",dat_ill_index)
  if(index_type=="chinese_small"){dat_ill_index<- sapply(dat_ill_index,function(x){chinese_to_arabic(x)})}
  
  index_det<-c(1,diff(as.numeric(dat_ill_index)))
  
  i<-1
  while(i < length(index_det)){
    
    if(index_det[i]!=1){
      for( l in 1:(length(index_det)-i)){
        if(cumsum(index_det[i:(i+l)])[l+1]==1){break}
      }
      index_det[i+l]<-1
      i<-i+l
    }else{
      i<-i+1
    }
  }
  
  delete<-which(index_det!=1)
  
  for(i in length(delete):1 ){
    dat1[(delete[i]-1)]<-paste0( dat1[(delete[i]-1)] , dat1[delete[i]] , collapse="")
    dat1[delete[i]]<-""
  }
  
  dat1<-dat1[dat1!=""]
  dat_ill_index<-dat_ill_index[index_det==1]
  
  # 文本聚类分析识别分割点
  dat2<-shan_str_replace(form,"",dat1)
  sep<-shan_cluster_text(dat2,detect_length = 50)
  # 病名与简介
  dat_ill_name<-shan_str_replace_all(" ","",str_sub(dat2,end=sep))
  dat_ill_describe<-shan_str_replace_all(" ","",str_sub(dat2,start=sep))
  
  output<-data.table(cbind(dat_ill_group,dat_ill_index,dat_ill_name,dat_ill_describe))
  colnames(output)<-c("分组","编号","疾病名称","简介")
  return(output)
}
