#####################################
# max age 105
get_NB<-function(dat){
  
  max_age<-"105@"
  
  #text<-clean_grab_NB_word(dat)
  
  pos2<-unlist(gregexpr("保险期间",dat))
  
  a<-as.numeric(unlist(gregexpr("岁",text)))
  b<-as.numeric(unlist(gregexpr("年",text)))
  c<-as.numeric(unlist(gregexpr("终身",text)))+1
  
  temp1<-c(a,b,c)
  temp1<-temp1[temp1>0]
  temp1<-sort(temp1)
  
  for(i in 1: length(temp1)){
    if( i == 1){text1<-str_sub(text,start=pos2,end=temp1[1])
    }else{
      text1<-c(text1,str_sub(text,start=temp1[i-1],end=temp1[i]))
    }
  }
  
  NB<-as.numeric(gsub("\\D","",text1))
  
  NB[str_count(text1,"至")>0]<-paste(NB[gregexpr("至",text1)>0],"@",sep="")
  NB[gregexpr("终身",text1)>0]<-max_age
  
  # get NB
  NB<-NB[str_count(NB,"NA")==0]

return(NB)
}

max_age<-"105@"

#text<-clean_grab_NB_word(dat)

NB<-str_count(dat1,"保险期间")

NP<-str_count(dat1,"交费期间")+
      str_count(dat1,"交费方式")
  
det<-str_count(dat1,"岁")+
      str_count(dat1,"年")+
      str_count(dat1,"终身")

dat1[det>0]

text<-dat1[pos2>0]


a<-as.numeric(unlist(gregexpr("岁",text)))
b<-as.numeric(unlist(gregexpr("年",text)))
c<-as.numeric(unlist(gregexpr("终身",text)))+1


#temp1<-c(a,b,c)
#temp1<-temp1[temp1>0]
#temp1<-sort(temp1)

for(i in 1: length(temp1)){
  if( i == 1){text1<-str_sub(text,start=pos2,end=temp1[1])
  }else{
    text1<-c(text1,str_sub(text,start=temp1[i-1],end=temp1[i]))
  }
}

NB<-as.numeric(gsub("\\D","",text1))

NB[str_count(text1,"至")>0]<-paste(NB[gregexpr("至",text1)>0],"@",sep="")
NB[gregexpr("终身",text1)>0]<-max_age

# get NB
NB<-NB[str_count(NB,"NA")==0]





