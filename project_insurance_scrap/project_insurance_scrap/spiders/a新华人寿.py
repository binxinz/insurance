# -*- coding: utf-8 -*-
import scrapy


class A新华人寿Spider(scrapy.Spider):
    name = '新华人寿'
    allowed_domains = ['aaa.com']
    start_urls = ['http://aaa.com/']

    def parse(self, response):
        pass
