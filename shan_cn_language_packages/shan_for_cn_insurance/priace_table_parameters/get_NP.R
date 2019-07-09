#####################################
# max age 105
shangetNP<-function(dat){
  
  text<-dat[grep("交费期间",dat)]
  
  text[grep("趸交",text)]
  
  pos<-unlist(gregexpr("趸交",text))
  pos
  
  if(pos<0){
    onepayment<-FALSE
  }else{
    onepayment<-TRUE
  }
  
  text<-substring(text, pos+2)
  
  text<-unlist(strsplit(text, "年"))
  
  text<-gsub("\\D","",text)
  
  if(onepayment==TRUE){
    NP<-c("1",text)
  }
  
  return(NP)
}




