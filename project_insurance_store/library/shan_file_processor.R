#################################################################
# 批量阅读一个文件夹内的所有csv
shan_read_dir_csv<-function(path_out){
  
  result<-data.table()
  #获取文件夹内所有文件
  filepath <- paste0(path_out,os$listdir(path_out))
  
  for( file in filepath ){  
    #调用python读取csv
    dat <- shan_python_read_csv(file)
    dat<-matrix(unlist(dat), nrow=length(dat), byrow=T)

    dat1<-data.table(dat[-1,])
    colnames(dat1)<-dat[1,]
  
    result <- rbind(result,dat1)
  }
  
return(result)
}

  
  
  
  