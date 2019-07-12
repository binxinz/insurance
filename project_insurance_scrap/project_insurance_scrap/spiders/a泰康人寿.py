# -*- coding: utf-8 -*-
import scrapy
import re
from project_insurance_scrap.items import  ProjectInsuranceScrapItem

class A泰康人寿Spider(scrapy.Spider):
    name = '泰康人寿'
    
    def start_requests(self):
        
        header = {'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3',
                  'Accept-Encoding': 'gzip, deflate',
                  'Accept-Language': 'en-US,en;q=0.9',
                  'Connection': 'keep-alive',
                  'Content-Length': '0',
                  'Cookie': 'QINGCLOUDELB=203823e206d2e805997347e22a6ff50f29704824dd36b11cc8f8dd04b157ec62',
                  'Host': 'www.taikanglife.com',                 
                  'Referer': 'http://www.taikanglife.com/publicinfonew/basicnew/pubproduct/commonprodinfo/stopproductnew/list_398_1.html',
                  'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36'}
        
        
        zaishou_urls = ['http://www.taikanglife.com/publicinfonew/basicnew/pubproduct/commonprodinfo/saleproductnew/list_397_1.html',                        ] 
        
        for url in zaishou_urls:        
                    yield scrapy.Request(url=url,callback=self.zaishou_parse)
        
            
        tingshou_urls = ['http://www.taikanglife.com/publicinfonew/basicnew/pubproduct/commonprodinfo/stopproductnew/list_398_1.html',  
                       ]
        
        for url in tingshou_urls:       
                   yield scrapy.Request(url=url,headers=header,callback= self.tingshou_parse)
                     
    def zaishou_parse(self, response):
        # 从每一行抽取数据
        result = response.css("tr").getall()
        result = result[1:len(result)]
        for part in result:
                 # 在售保险的内容输入
                item = ProjectInsuranceScrapItem()  
                
                part = re.findall('<a(.*)?</a>',part)
                
                item['company_name'] = '泰康人寿'            
                item['product_type'] = ''
                item['product_id'] = ''
                name = re.sub(" ","",re.findall('>.*',part[0])[0])
                name = re.sub(">","",name)
                item['product_name'] = name
                item['product_sale_status'] = '在售'
                item['product_contract_link'] = re.findall('href="(.*)?" ',part[1])[0]
                item['product_price_link'] = ''
            
                item['product_start_date'] =  ''
                item['product_end_date'] = ''  
                # 输出数据
                yield item                  
                
    def tingshou_parse(self, response):                
        # 从每一行抽取数据
        result = response.css("tr").getall()
        result = result[1:len(result)]
        
        for part in result:
                # 停售保险的内容输入
                item = ProjectInsuranceScrapItem()    
                
                part = re.findall('<a(.*)?</a>',part)
                item['company_name'] = '泰康人寿'
                
                item['product_type'] = ''
                item['product_id'] = ''
                name = re.sub(" ","",re.findall('>.*',part[0])[0])
                name = re.sub(">","",name)
                item['product_name'] = name
                item['product_sale_status'] = '停售'
                item['product_contract_link'] = re.findall('href="(.*)?" ',part[1])[0]
                item['product_price_link'] = ''
            
                item['product_start_date'] =  ''
                item['product_end_date'] = ''  
                # 输出数据
                yield item 
        