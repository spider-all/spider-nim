import os
import httpcore
import httpClient
import strformat
import json
import strutils
import db_sqlite

import table
import constants
import database

proc headerLink(headers: httpcore.HttpHeaders): string =
    for key, val in pairs(headers):
        if key == "link":
            for str in val.split(", "):
                let s = str.split("; ")
                if s[1] == "rel=\"next\"":
                    return s[0].replace("<", "").replace(">", "")
    return ""

proc request*(url: string, requestType: RequestType, token: string, conn: db_sqlite.DbConn) =
    let client = httpClient.newHttpClient()
    client.headers = httpClient.newHttpHeaders({
        "Authorization": fmt"Bearer {token}",
        "Accept" :"application/json",
        "Host": constants.HOST,
        "Time-Zone": constants.TIMEZONE,
        "User-Agent": constants.USERAGENT,
    })
    let response = httpClient.get(client, url)
    let content = json.parseJson(response.body)
    if requestType == TypeUserinfo:
        let user = table.User(id: content["id"].getInt(0), login: content["login"].getStr(""))
        database.Create(conn, user)
    elif requestType == TypeFlowering or requestType == TypeFollowers:
        for con in content:
            let user = table.User(id: con["id"].getInt(0), login: con["login"].getStr(""))
            database.Create(conn, user)
        let link = headerLink(response.headers)
        if link != "":
            os.sleep(3000)
            request(link, requestType, token, conn)
