# -*- coding: utf-8 -*-
import scrapy


class A太平人寿Spider(scrapy.Spider):
    name = '太平人寿'
    allowed_domains = ['aaa.com']
    start_urls = ['http://aaa.com/']

    def parse(self, response):
        pass
