from virus.items import VirusItem
from scrapy import Spider, Request

class VirusSpider(Spider):
    name='virus_spider'
    allowed_urls=['https://www.worldometers.info/']
    start_urls = ['https://www.worldometers.info/coronavirus/#countries']

    def parse(self,response):
        # Find all the table rows in the main table
        rows = response.xpath('//*[@id="main_table_countries_today"]/tbody[1]/tr')  

        # The movie title could be of different styles so we need to provide all the possibilities.

        for row in rows:
            # extract() will return a Python list, extract_first() will return the first element in the list
            # If you know the first element is what you want, you can use extract_first()
            # Xpath for variable columns
            country = row.xpath('./td[2]/a/text()').extract_first()
            total = row.xpath('./td[3]/text()').extract_first()
            deaths = row.xpath('./td[5]/text()').extract_first()
            serious = row.xpath('./td[10]/text()').extract_first()
            cases_per_mil = row.xpath('./td[11]/text()').extract_first()
            tests=row.xpath('./td[12]/text()').extract_first()
            test_per_mil=row.xpath('./td[14]/text()').extract_first()
            population=row.xpath('./td[15]/a/text()').extract_first()
            # Initialize a new WikiItem instance for each movie.
            item = VirusItem()
            item['country'] = country
            item['total'] = total
            item['deaths'] = deaths
            item['serious'] = serious
            item['cases_per_mil']=cases_per_mil
            item['tests']=tests
            item['test_per_mil']=test_per_mil
            item['population']=population
            yield item
