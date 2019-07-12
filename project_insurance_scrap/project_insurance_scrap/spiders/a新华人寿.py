# -*- coding: utf-8 -*-
import scrapy
import re
from project_insurance_scrap.items import  ProjectInsuranceScrapItem


class A新华人寿Spider(scrapy.Spider):
    name = '新华人寿'
    
    #https://www.newchinalife.com/node/372
    
    def start_requests(self):
        #
        urls = ['https://www.newchinalife.com/node/372']#健康保障托管业务
       
        for url in urls:       
                   yield scrapy.Request(url=url,callback=self.parse)
                   
    def parse(self, response):
         # 从每一行抽取数据
        result =  response.css('tr').getall()
        result =  result[1:len(result)]
        for part in result:
                 # 在售保险的内容输入
                item = ProjectInsuranceScrapItem()            
                item['company_name'] = '新华人寿'
            
                item['product_type'] = ''
                item['product_id'] = ''
                item['product_name'] = re.findall("<td>(.*)?</td>",part)[1]  
                item['product_sale_status'] = '在售'
                item['product_contract_link'] = re.findall("<a href=(.*)?target",part) 
                item['product_price_link'] = ''
            
                item['product_start_date'] =  ''
                item['product_end_date'] = ''  
                # 输出数据
                yield item 
                
        # 找到下一页的代码
        next_pages = re.findall("/node/372_\d",response.text)
        for next_page in next_pages:
            yield response.follow(next_page, callback=self.parse)
    