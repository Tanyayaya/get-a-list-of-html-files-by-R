library(XML)
library(plyr)
library(stringr)
library(RCurl)
library(httr)
#get a list of urls based on its grammar
getPageURLs<-function(url){
  baseurl<-htmlParse(file=url)
  xpath<-"//td/a[@href]"
  attr<-xpathSApply(baseurl,xpath,xmlAttrs)
  urls_list<-str_c(url,attr,sep="")
  urls_list<-urls_list[grep("STAT490Mday.+",urls_list)]
  return(urls_list)
}

url<-"http://www.stat.purdue.edu/~mdw/490M/"
urls_list<-getPageURLs(url)
#download the list of urls into a folder
dlPages<-function(pageurl,folder,handle){
  dir.create(folder,showWarnings=FALSE)
  page_name<-str_c(str_extract(pageurl,"STAT490Mday.+"),".html")
  page_name<-str_replace(page_name,pattern = ".txt","")
  #download the files
  if(!file.exists(str_c(folder,"/",page_name))){
    #write the content into the files
    write(getURL(pageurl,curl = handle), str_c(folder,"/",page_name))
    Sys.sleep(1)
  }
}
handle<-getCurlHandle()
l_ply(urls_list,dlPages,folder="purdue",handle=handle)