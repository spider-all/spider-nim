import db_sqlite

import table

const TableUserSQL = sql"""CREATE TABLE IF NOT EXISTS `users` (
    id INTEGER PRIMARY KEY,
    login TEXT NOT NULL
)"""

proc Initialize*(): db_sqlite.DbConn =
    let conn = db_sqlite.open("spider.db", "", "", "")
    conn.exec(TableUserSQL)
    return conn

proc Create*(conn: db_sqlite.DbConn, user: table.User) =
    echo user
    try:
        conn.exec(sql"INSERT OR REPLACE INTO `users` (`id`, `login`) VALUES (?, ?)", user.id, user.login)
    except:
        echo "insert row into sqlite3 database with error: ", getCurrentExceptionMsg()

proc List*(conn: db_sqlite.DbConn): seq[string] =
    var users: seq[string]
    for x in conn.fastRows(sql"SELECT `login` FROM `users` ORDER BY random() limit 100"):
        users.add(x[0])
    return users
