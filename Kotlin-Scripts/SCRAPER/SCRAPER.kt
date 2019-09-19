import org.openqa.selenium.WebDriver
import org.openqa.selenium.chrome.ChromeDriver
import org.openqa.selenium.chrome.ChromeOptions
import org.openqa.selenium.JavascriptExecutor
import org.openqa.selenium.WebElement
import java.lang.Exception
import kotlin.reflect.jvm.internal.impl.protobuf.LazyStringArrayList

class SCRAPER {
    val driver = ChromeDriver()
    val options = ChromeOptions()

    init {
        System.setProperty("webdriver.chrome.driver", "C:\\Users\\ipi\\Desktop\\chromedriver.exe") // set webdriver path
        this.options.addArguments("--user-agent='Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1'")
        this.options.addArguments("--dns-prefetch-disable")
        this.options.addArguments("--lang=en-US")
    }

    fun setOptions(headless : Boolean = true, mute : Boolean = true) {
        if (headless) {
            this.options.addArguments("-headless")
        }

        if (mute) {
            this.options.addArguments("--mute-audio")
        }
    }

    fun scrapeByUsername(username:String) {
        val url = "https://www.instagram.com/$username/"
        driver.get(url)

        if (driver.findElementByXPath("//div[@class='error-container']").isEnabled) {
            println("Wrong url")
        }

        var srcs : ArrayList<String> = ArrayList()

        try {

            var i : Int = 0
            var x : String

            for (i in (1..7)) {
                driver.executeScript("window.scrollTo(0, document.body.scrollHeight);")

                val img = driver.findElementsByTagName("a")

                var src : ArrayList<Int> = ArrayList()

                for (x in img) {
                    srcs.add(x.getAttribute("href"))
                }
            }

            srcs.forEach { println(it) }
        }

        catch (e:Exception) {
            println("ERROR at\t$e")
        }
    }

    fun scrapeByHashtag(hashtag:String) {
        val url = "https://www.instagram.com/explore/tags/$hashtag/"
        driver.get(url)

        if (driver.findElementByXPath("//div[@class='error-container']").isEnabled) {
            println("Wrong url")
        }

        var srcs : ArrayList<String> = ArrayList()

        try {

            var i : Int = 0
            var x : String

            for (i in (1..7)) {
                driver.executeScript("window.scrollTo(0, document.body.scrollHeight);")

                val img = driver.findElementsByTagName("a")

                var src : ArrayList<Int> = ArrayList()

                for (x in img) {
                    srcs.add(x.getAttribute("href"))
                }
            }

            srcs.forEach { println(it) }
        }

        catch (e:Exception) {
            println("ERROR at\t$e")
        }
    }

    fun closeDriver() {
        driver.close()
    }

}

fun main () {

    val scrape = SCRAPER()

    scrape.scrapeByUsername("username_goes_here")
    scrape.scrapeByHashtag("hashatag_goes_here")

    scrape.closeDriver()
}
