#   Default -> Make two connections
from selenium.webdriver.chrome.options import Options
from selenium import webdriver
from selenium.common.exceptions import WebDriverException
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.common.keys import Keys
from tqdm import tqdm
import time

from bin.settings import Settings
from datetime import datetime



class LinkedinBot:

    def __init__(self, username, password, times=2):
        
        chromedriver_location = Settings.chromedriver_location
        chrome_options = webdriver.ChromeOptions()
        chrome_options.add_argument('--user-agent="Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1"')
        chrome_options.add_argument("--mute-audio")
        chrome_options.add_argument('--dns-prefetch-disable')
        chrome_options.add_argument('--lang=en-US')
        chrome_options.add_argument('-headless')
        self.driver = webdriver.Chrome(chrome_options=chrome_options, executable_path=chromedriver_location)
        self.username = username
        self.password = password
        self.times = times

    def close_driver(self):

        driver.close()

    def login(self):

        try:

            driver.get("https://www.linkedin.com/login")
            u = driver.find_element_by_id("username")
            u.send_keys(username)
            time.sleep(0.5)
            p = driver.find_element_by_id("password")
            p.send_keys(password)
            time.sleep(0.5)
            b = driver.find_element_by_xpath("//button[@type='submit']")
            b.click()
            time.sleep(0.5)

            print(f"Logged in succesfully\t{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

        except:

            pass


    def click_conn(self):

        driver.get("https://www.linkedin.com/mynetwork/")
        i = 0
        for i in range(0, times):

            try:

                conn = driver.find_element_by_xpath("//button[@data-control-name='invite']")
                time.sleep(1)
                #   Default sleep 10 min after 10 connections
                if i == 10:
                    print(f"Time to sleep for 10 minutes...\n")
                    time.sleep(600)

                i+=1

            except:

                pass