import java.io.File
import java.io.IOException
import java.util.concurrent.TimeUnit

fun main () {

    val path = File("C:\\Users\\ipi\\Desktop\\programs")
    val k = "cmd /C python coloring.py".runCommand(path)

    println(k)
}

fun String.runCommand(PATH: File = File("."), timeOut: Long = 60, timeUnit: TimeUnit = TimeUnit.SECONDS): String? {
    return try {
        ProcessBuilder(*this.split("\\s".toRegex()).toTypedArray())
            .directory(PATH)
            .redirectOutput(ProcessBuilder.Redirect.PIPE)
            .redirectError(ProcessBuilder.Redirect.PIPE)
            .start().apply {
                waitFor(timeOut, timeUnit)
            }.inputStream.bufferedReader().readText()
    } catch (e: IOException) {
        e.printStackTrace()
        null
    }
}