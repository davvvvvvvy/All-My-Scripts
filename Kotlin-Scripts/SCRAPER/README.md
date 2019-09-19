# SCRAPER
Scraper for links of pics from Instagram

# Usage

Call class

    val scrape = SCRAPER()

Scrape pics or vids by searching username

    scrape.scrapeByUsername("username_goes_here")
    
Scrape pics or vids by searching username

    scrape.scrapeByHashtag("hashatag_goes_here")
   
Close driver using

    scrape.closeDriver()
