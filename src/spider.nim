import strformat
import json
import os

import http
import constants
import database

when isMainModule:
    echo "spider is running..."

    let conn = database.Initialize()
    let config = json.parseFile("config.json")
    let token = config["token"].getStr("")
    let entry = config["entry"].getStr("")

    http.request(fmt"https://{constants.HOST}/users/{entry}", constants.TypeUserinfo, token, conn)

    while true:
        let content = database.List(conn)
        for u in content:
            http.request(fmt"https://{constants.HOST}/users/{u}/followers", constants.TypeFlowering, token, conn)
            http.request(fmt"https://{constants.HOST}/users/{u}/following", constants.TypeFlowering, token, conn)
            os.sleep(5000)
