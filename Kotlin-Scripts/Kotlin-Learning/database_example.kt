import java.io.File
import java.lang.Exception
import java.sql.*

class DATABASE {
    var conn : Connection ?= null
    var filename = File("C:\\Users\\ipi\\Desktop\\tesst.db")

    init {
        val isNewFileCreated : Boolean = this.filename.createNewFile()

        if (isNewFileCreated) {
            getConnection()
            create()
            insert()
            select()
        }

        else {
            getConnection()
            select()

            //println("Just selected!")
        }
    }

    fun getConnection() {
        try {
            Class.forName("org.sqlite.JDBC")
            this.conn = DriverManager.getConnection("jdbc:sqlite:" + this.filename.toString())
        }
        catch (e : Exception) {
            println("ERROR\t$e")
        }
    }

    fun create() {
        val sql = """
            create table accounts (
            id  int  primary key    not null,
            username    varchar(255)    not null,
            email   varchar(255)    not null,
            password    varchar(255)    not null
            );
        """.trimIndent()

        val statement = this.conn?.createStatement()
        if (statement != null) {
            statement.executeUpdate(sql)
        }

        //println("Created!")
    }

    fun insert() {
        val sql = """
            insert into accounts (id, username, email, password)
            values (1, 'username', 'username@email.com', 'password');
        """.trimIndent()

        val statement = this.conn?.createStatement()
        if (statement != null) {
            statement.executeUpdate(sql)
        }

        //println("Inserted!")
    }

    fun select() {
        val sql = """
            select * from accounts;
        """.trimIndent()

        val statement = this.conn?.createStatement()
        if (statement != null) {
            val s = statement.executeQuery(sql)
            while (s.next()) {
                println("""
                    ${s.getInt("id")}
                    ${s.getString("username")}
                    ${s.getString("email")}
                    ${s.getString("password")}
                """.trimIndent())
            }
        }

        //println("Selected!")
    }
}

fun main () {

    val c = DATABASE()
}
