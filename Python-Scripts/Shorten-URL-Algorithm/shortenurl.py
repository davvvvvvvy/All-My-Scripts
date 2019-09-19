import string

class ShortenURL:

    i = 10000000000
    url_i = {}

    def shorten_url(self, orig_url):
        if orig_url in self.url_i:
            i = self.url_i[orig_url]
            shorten_url = self.encode(i)

        else:
            self.url_i[orig_url] = self.i
            shorten_url = self.encode(self.i)
            self.i += 1

        return "ipi.local/" + shorten_url


    def encode(self, i):

        char = string.ascii_letters + "0123456789"
        base = len(char)
        r = []

        while i > 0:
            u = i % base
            r.append(char[u])
            i = i // base

        return "".join(r[::-1])


if __name__ == '__main__':

    urls = [ "google.com", "youtube.com", "facebook.com", "twitter.com/fdsjfsd", "flick.com/fjdsfsd" ]
    i = ShortenURL()

    for url in urls:
        print(i.shorten_url(url))
