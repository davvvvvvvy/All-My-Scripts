#!/usr/bin/python3

# Searching PyPi page for modules
# Using BS4 for parsing web
# Using pip for installing

import click
from bs4 import BeautifulSoup
import urllib
from urllib import request
import string
import subprocess

@click.command()
@click.option('--search', '-s', help="To search python modules  --usage ahoy --search [MODULE NAME]")
@click.option('--install', '-i', help="To install python modules --usage ahoy  --install [MODULE NAME]")

def ahoy(search, install):
    if search:
        page = urllib.request.urlopen("https://pypi.org/search/?q={}".format(search)).read()
        soup = BeautifulSoup(page, features="lxml")
        soup.prettify()
        for i in soup.findAll("span", { "class": "package-snippet__name" }):
            click.echo(i.text)

    if install:
        try:
            subprocess.run("python -m pip install {}".format(install))
        except:
            subprocess.run("py -m pip install {}".format(install))

if __name__ == "__main__":
    ahoy()
