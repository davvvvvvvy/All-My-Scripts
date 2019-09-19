class COLORING {

    var DEFAULT : String   = "\u001B[0m"
    var BLACK : String     = "\u001B[90m"
    var RED : String       = "\u001B[91m"
    var GREEN : String     = "\u001B[92m"
    var YELLOW : String    = "\u001B[93m"
    var BLUE : String      = "\u001B[94m"
    var PURPLE : String    = "\u001B[95m"
    var CYAN : String      = "\u001B[96m"
    var WHITE : String     = "\u001B[97m"

    // BG COLORING
    var BG_BLACK : String  = "\u001B[100m"
    var BG_RED : String    = "\u001B[101m"
    var BG_GREEN : String  = "\u001B[102m"
    var BG_YELLOW : String = "\u001B[103m"
    var BG_BLUE : String   = "\u001B[104m"
    var BG_PURPLE : String = "\u001B[105m"
    var BG_CYAN : String   = "\u001B[106m"
    var BG_WHITE : String  = "\u001B[107m"

    init {
        println("COLOTING IN KOTLIN\n")
    }

}

fun main () {
    val red = COLORING()
    println("$red")
    println("${red.RED}RED")
    println("${red.PURPLE}PURPLE")
    println("${red.BG_YELLOW}${red.BLUE}YELLOW BG BLUE LETTERS")
}