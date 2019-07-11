# -*- coding: utf-8 -*-
import scrapy
#import re
from project_insurance_scrap.items import  ProjectInsuranceScrapItem

class A太保人寿Spider(scrapy.Spider):
    name = "太保人寿"
    allowed_domains = ["life.cpic.com.cn/"]
    #start_urls = ['http://life.cpic.com.cn//']

    def start_requests(self):
        zaiban_urls = ['http://life.cpic.com.cn/xrsbx/gkxxpl/jbxx/gsgk/jydbxcpmljtk/zbcp/sx/',  #寿险
                       'http://life.cpic.com.cn/xrsbx/gkxxpl/jbxx/gsgk/jydbxcpmljtk/zbcp/nj/',  #年金
                       'http://life.cpic.com.cn/xrsbx/gkxxpl/jbxx/gsgk/jydbxcpmljtk/zbcp/ywx/', #意外险
                       'http://life.cpic.com.cn/xrsbx/gkxxpl/jbxx/gsgk/jydbxcpmljtk/zbcp/jkx/', #健康险
                       ] 
        
        for url in zaiban_urls:
            yield scrapy.Request(url=url, callback=self.zaiban_parse)
            
        tingban_urls = ['http://life.cpic.com.cn/xrsbx/gkxxpl/jbxx/gsgk/jydbxcpmljtk/tbcp/sx/',   #寿险
                        'http://life.cpic.com.cn/xrsbx/gkxxpl/jbxx/gsgk/jydbxcpmljtk/tbcp/nj/',   #年金
                        'http://life.cpic.com.cn/xrsbx/gkxxpl/jbxx/gsgk/jydbxcpmljtk/tbcp/ywx/',  #意外险
                        'http://life.cpic.com.cn/xrsbx/gkxxpl/jbxx/gsgk/jydbxcpmljtk/tbcp/jkx/',  #健康险
                       ]
        
        for url in tingban_urls:
            yield scrapy.Request(url=url, callback=self.tingban_parse)
            
    def zaiban_parse(self, response):
        # 从每一行抽取数据
        result = response.css('tr')
        for part in result:
                 # 在售保险的内容输入
                item = ProjectInsuranceScrapItem()            
                item['company_name'] = '太保人寿'
            
                item['product_type'] = ''
                item['product_id'] = ''
                item['product_name'] = part.css("a::text").get()
                item['product_sale_status'] = '在办'
                item['product_contract_link'] = "http://life.cpic.com.cn"+str(part.css("::attr(href)").get())
                item['product_price_link'] = ''
            
                item['product_start_date'] =  ''
                item['product_end_date'] = ''  
                # 输出数据
                yield item 
                
                # 找到下一页的代码
        #next_page = response.css('.z_num::attr(href)').get()  
        #if next_page is not None:
            #next_page = 'http://www.cpic.com.cn/search/catalog/16315/pc/index_'+str(re.findall("\d+",next_page)[0]) + '.shtml'
            #yield scrapy.Request(next_page, callback=self.zaiban_parse)
                
    def tingban_parse(self, response):                
        # 从每一行抽取数据
        result = response.css('tr')
        for part in result:
            # 停售保险的内容输入
            item = ProjectInsuranceScrapItem()            
            item['company_name'] = '太保人寿'
            
            item['product_type'] = ''
            item['product_id'] = ''
            item['product_name'] = part.css("a::text").get()
            item['product_sale_status'] = '停办'
            item['product_contract_link'] = "http://life.cpic.com.cn"+str(part.css("::attr(href)").get())
            item['product_price_link'] = ''
            
            item['product_start_date'] =  ''
            item['product_end_date'] = ''  
            # 输出数据
            yield item 
            
            # 找到下一页的代码
        #next_page = response.css('.z_num::attr(href)').get()  
        #if next_page is not None:
            #next_page = 'http://www.cpic.com.cn/search/catalog/16319/pc/index_'+str(re.findall("\d+",next_page)[0]) 
            #+ '.shtml'
            #yield scrapy.Request(next_page, callback=self.tingban_parse)