# -*- coding: utf-8 -*-
import scrapy
import re
from project_insurance_scrap.items import  ProjectInsuranceScrapItem

class A太平人寿Spider(scrapy.Spider):
    name = '太平人寿'
    #http://www.cntaiping.com/
    
    def start_requests(self):
        
        zaishou_urls = ['http://life.cntaiping.com/info-bxcp/']
        for url in zaishou_urls:        
                    yield scrapy.Request(url=url,callback=self.zaishou_parse)
                    
        tingshou_urls = ['http://life.cntaiping.com/info-bxcp/']
        for url in tingshou_urls:       
                   yield scrapy.Request(url=url,callback=self.tingshou_parse)

    def zaishou_parse(self, response):
        # 从每一行抽取数据
        result = response.css("tr").getall()
        for part in result:
                 # 在售保险的内容输入
            item = ProjectInsuranceScrapItem()            
            item['company_name'] = '太平人寿'
            
            item['product_type'] = ''
            item['product_id'] = ''
            item['product_name'] = re.findall('<td>(.*)?</td>',part)[0]
            item['product_sale_status'] = '在售'
            item['product_contract_link'] = re.findall('href=(.*)?>条款',part)
            item['product_price_link'] = ''
            
            item['product_start_date'] =  ''
            item['product_end_date'] = ''  
                # 输出数据
            yield item 
                
                   
                
    def tingshou_parse(self, response):                
        # 从每一行抽取数据
        result = response.css("tr").getall()
        for part in result:
            # 停售保险的内容输入
            item = ProjectInsuranceScrapItem()            
            item['company_name'] = '太平人寿'
            
            item['product_type'] = ''
            item['product_id'] = ''
            item['product_name'] = re.findall('<td>(.*)?</td>',part)[0]  
            item['product_sale_status'] = '停售'
            item['product_contract_link'] = re.findall('href=(.*)?>条款',part) 
            item['product_price_link'] = ''
            
            item['product_start_date'] =  ''
            item['product_end_date'] = ''  
            # 输出数据
            yield item 
       