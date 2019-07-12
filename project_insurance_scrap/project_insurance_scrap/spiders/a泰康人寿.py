# -*- coding: utf-8 -*-
import scrapy
import re
from project_insurance_scrap.items import  ProjectInsuranceScrapItem


class A泰康人寿Spider(scrapy.Spider):
    name = '泰康人寿'
    
    def start_requests(self):
      
        zaishou_urls = ['http://www.taikanglife.com/publicinfonew/basicnew/pubproduct/commonprodinfo/saleproductnew/list_397_1.html',                        ] 
        
        for url in zaishou_urls:        
                    yield scrapy.Request(url=url,callback=self.zaishou_parse)
        
            
        tingshou_urls = ['http://www.taikanglife.com/publicinfonew/basicnew/pubproduct/commonprodinfo/stopproductnew/list_398_1.html',  
                       ]
        
        for url in tingshou_urls:       
                   yield scrapy.Request(url=url,callback= self.tingshou_parse)
        
                
    def zaishou_parse(self, response):
        # 从每一行抽取数据
        result = result = response.css("tr").getall()
        
        for part in result:
                 # 在售保险的内容输入
                item = ProjectInsuranceScrapItem()            
                item['company_name'] = '太保人寿'
            
                item['product_type'] = ''
                item['product_id'] = ''
                item['product_name'] = re.findall('>(.*)?<',part[1])[0]
                item['product_sale_status'] = '在售'
                item['product_contract_link'] = "http://life.cpic.com.cn"+ re.sub('"','',part[0])
                item['product_price_link'] = ''
            
                item['product_start_date'] =  ''
                item['product_end_date'] = ''  
                # 输出数据
                yield item 
                
        # 找到下一页的代码
        next_pages = re.findall("index_\d+[.]shtml",response.text)
        for next_page in next_pages:
            yield response.follow(next_page, callback=self.zaiban_parse)
                   
                
    def tingban_parse(self, response):                
        # 从每一行抽取数据
        result = re.findall('<a href=(.*)?target(.*)?/a>',response.text)
        for part in result:
            # 停售保险的内容输入
            item = ProjectInsuranceScrapItem()            
            item['company_name'] = '太保人寿'
            
            item['product_type'] = ''
            item['product_id'] = ''
            item['product_name'] = re.findall('>(.*)?<',part[1])[0]
            item['product_sale_status'] = '停售'
            item['product_contract_link'] = "http://life.cpic.com.cn"+ re.sub('"','',part[0])
            item['product_price_link'] = ''
            
            item['product_start_date'] =  ''
            item['product_end_date'] = ''  
            # 输出数据
            yield item 
        # 找到下一页的代码
        next_pages = re.findall("index_\d+[.]shtml",response.text)
        for next_page in next_pages:
            yield response.follow(next_page, callback=self.tingban_parse)