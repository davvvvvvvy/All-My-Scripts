import java.time.LocalDateTime
import java.*

class main {

    fun fakt (num: Int) : Int {
        if (num == 1) return 1

        else {
            return num * fakt(num-1)
        }
    }

    fun fib (num : Int) : Int {
        if (num <= 1) return num

        else {
            return fib(num-1) + fib(num-2)
        }
    }

    println(fakt(5))
    println(fib(16))

    val a : Int = 10
    val b : Int = 20

    val max = if (a < b) b else a
    var srcs : Array<String> = arrayOf("fsdf", "fdsfsd")
     // val a : IntArray = intArrayOf(1, 2, 3) Example of Arrays in kotlin
    
}

fun main () {

    val name = "+1"

    for (i in name) {
        if (i.isDigit()) {
            println(i)
        }
    }
}

private fun String.isDigit() {}

//  Check what OS is
    if (System.getProperty("os.name").toLowerCase().indexOf("win") >= 0) {
        println("win")
    }
