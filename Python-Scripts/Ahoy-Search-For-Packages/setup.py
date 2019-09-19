from setuptools import setup, find_packages
from setuptools.command.build_py import build_py as _build_py 

with open("r.txt", 'r') as f:
    dependencies = f.read().split("\n")


setup(
    name="ahoy",
    version="2019",
    description="Simple package to searching and installing python modules",
    url="",
    author="Ivan Pilipovic",
    author_email="ivan.pilipovic123@gmail.com",
    long_description="README.txt",
    long_description_content_type="text/markdown",
    packages=find_packages(),
    install_requires=[ "bs4", "click" ],
    include_package_data=True,
    python_requires=">=2.7",
    platforms=["win32", "linux", "linux2", "darwin"],
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
)