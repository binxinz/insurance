shangetSA<-function(dat){

  text<-dat[grep("保险金额",dat)]

  #length(pos2);length(pos1)

  pos2<-gregexpr("元",text)[[1]]

  pos1<-gregexpr("金额",text)[[1]]


  if(pos2[1] > pos1[1]){
    text1<-substring(text, pos1[1], pos2[1])
    SA<-as.numeric(gsub("\\D","",text1))
  }

  if(pos2[1] < pos1[1]){
    text1<-substring(text, pos2[1], pos1[1],)
    SA<-as.numeric(gsub("\\D","",text1))
  }
  
return(SA)
}
