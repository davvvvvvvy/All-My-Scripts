import re
import requests
import requests.exceptions
from urllib.parse import urlsplit
from collections import deque
from bs4 import BeautifulSoup

from tqdm import tqdm

f = open("emails.txt", "a")

starting_url = ''

unprocessed_urls = deque([starting_url])

processed_urls = set()

emails = set()

while tqdm(len(unprocessed_urls)):

    url = unprocessed_urls.popleft()
    processed_urls.add(url)

    parts = urlsplit(url)
    base_url = "{0.scheme}://{0.netloc}".format(parts)
    path = url[:url.rfind('/')+1] if '/' in parts.path else url

    try:
        response = requests.get(url)
    except (requests.exceptions.MissingSchema, requests.exceptions.ConnectionError):
        continue

    new_emails = set(re.findall(
        r"[a-z0-9\.\-+_]+@[a-z0-9\.\-+_]+\.[a-z]+", response.text, re.I))
    emails.update(new_emails)
    #print(emails)
    soup = BeautifulSoup(response.text, 'lxml')

    for anchor in soup.find_all("a"):
        link = anchor.attrs["href"] if "href" in anchor.attrs else ''

        if link.startswith('/'):
            link = base_url + link
        elif not link.startswith('http'):
            link = path + link
        if not link in unprocessed_urls and not link in processed_urls:
            unprocessed_urls.append(link)

for email in emails:
    f.write(email)
    f.write("\n")
    
f.close()
