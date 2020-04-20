//
//  CaptureServer.swift
//  ShareScreen
//
//  Created by Admin on 11/18/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

var g_session : WebSocketSession?
var g_sessionList = Array<WebSocketSession>()
var g_readyList   = Array<Bool>()
var g_timeList    = Array<Double>()

var g_SignCode : String?
let preferences = UserDefaults.standard
//public var refreshtime : Bool = false
public var refreshtime     : Int = 10
public var framerate_value : Int = 1


let lock = NSLock()

public func sendDataToClient(array : [Int8]) -> Int {
    var totalSize : Int = 0

    let curTime : Double = NSDate().timeIntervalSince1970
    lock.lock()
    for (index, session) in g_sessionList.enumerated() {

        let gap = curTime - g_timeList[index]
        if (g_readyList[index] == true || gap > 10) {
            // send ready or timeout
            g_readyList[index] = false
            g_timeList[index] = curTime

            session.writeBinary(array)

            totalSize = totalSize + array.count
            print("Index = ", index, "Send Size = ", array.count, "Time Interval = ", gap)
        }
        else {
            print("Not Ready = ", index)
        }
    }
    lock.unlock()
   
    return totalSize
}

public func sendDataToClient(array : [UInt8]) -> Int {
    var totalSize : Int = 0

    let curTime : Double = NSDate().timeIntervalSince1970
    lock.lock()
    for (index, session) in g_sessionList.enumerated() {

        let gap = curTime - g_timeList[index]
        if (g_readyList[index] == true || gap > 10) {
            // send ready or timeout
            g_readyList[index] = false
            g_timeList[index] = curTime

            session.writeBinary(array)

            totalSize = totalSize + array.count
            print("Index = ", index, "Send Size = ", array.count, "Time Interval = ", gap)
        }
        else {
            print("Not Ready = ", index)
        }
    }
    lock.unlock()
   
    return totalSize
}

public func CaptureServer() -> HttpServer {

    let server = HttpServer()

    server["/"] = { .ok(.htmlBody("" + $0.path)) }

    server[""] = { .ok(.htmlBody("""
        <!DOCTYPE html>
        <html><head>
            <meta http-equiv="cache-control" content="no-cache, must-revalidate, post-check=0, pre-check=0" />
            <meta http-equiv="cache-control" content="max-age=0" />
            <meta http-equiv="expires" content="0" />
            <meta http-equiv="expires" content="Tue, 01 Jan 1980 1:00:00 GMT" />
            <meta http-equiv="pragma" content="no-cache" />
            <style>
                .rotate0 {
                    transform-origin:   rotate(0deg);
                    -webkit-transform:  rotate(0deg);
                    -ms-transform:      rotate(0deg);
                    -moz-transform:     rotate(0deg);
                    -o-transform:       rotate(0deg);
                }
                .rotate90 {
                    transform:          rotate(90deg) scale(1.3);
                    -webkit-transform:  rotate(90deg) scale(1.3);
                    -ms-transform:      rotate(90deg) scale(1.3);
                    -moz-transform:     rotate(90deg) scale(1.3);
                    -o-transform:       rotate(90deg) scale(1.3);
                }
                .rotate180 {
                    transform:          rotate(180deg);
                    -webkit-transform:  rotate(180deg);
                    -ms-transform:      rotate(180deg);
                    -moz-transform:     rotate(180deg);
                    -o-transform:       rotate(180deg);
                }
                .rotate270 {
                    transform:          rotate(270deg) scale(1.3);
                    -webkit-transform:  rotate(270deg) scale(1.3);
                    -ms-transform:      rotate(270deg) scale(1.3);
                    -moz-transform:     rotate(270deg) scale(1.3);
                    -o-transform:       rotate(270deg) scale(1.3);
                }
            </style>
        </head>
        <body>
            <div id="container" style="width:100%; height:100%; text-align:center">
                <canvas id="image" src="" style="object-fit:contain">
            </div>

            <script>
                var host = window.location.hostname;
                var canvas = document.getElementById('image');
                if( host == "" )
                    host = "localhost";

                console.log(host);
                var ws = null;
                var start = 0;

                function drawImage(imgString) {
                    var reader = new FileReader();
                    reader.readAsDataURL(imgString);
                    reader.onloadend = function() {
                        var base64data = reader.result;
                        var res = base64data.replace("data:;base64", "data:image/jpeg;base64");
                        
                        var ctx = canvas.getContext("2d");
                        var img = new Image();
                        img.src = res;
                        img.onload = function() {
                          canvas.width = img.width;
                          canvas.height = img.height;
                          if( img.height != 500 )
                            canvas.style.height = '100%';
                          else
                            canvas.style.height = '';
        
                          ctx.drawImage(img, 0, 0);
                        };
                        if (ws) ws.send("ack");
                    }
                }
            
                function WebSocketTest() {
                    if ("WebSocket" in window) {
                        // Let us open a web socket
                        ws = new WebSocket("ws://" + host + ":8080/websocket");

                        ws.onopen = function() {
                            console.log("socket is connected");
                        };

                        ws.onmessage = function (event) {
                            var data_type = typeof event.data;
                            if ( data_type == "string" ) {
                                console.log(event.data);
                                var container = document.getElementById('image');
                                container.className = "rotate" + event.data;
                                return;
                            }
                            start = Date.now();
                            //setInterval(function() {
                                drawImage(event.data);
                            //}, 1000);
                        };
                        
                        ws.onclose = function() {
                            start = 0;
                            // websocket is closed.
                            console.log("Connection is closed...");
                            //setTimeout(function() {
                            //   WebSocketTest();
                            //}, 1000);
                        };
                        ws.onerror = function(err) {
                            console.error(err);
                            ws.close();
                        };
                    }
                    else {
                        // The browser doesn't support WebSocket
                        console.log("WebSocket NOT supported by your Browser!");
                    }
                }

                setTimeout(function() {
                       WebSocketTest();
                }, 1000);

                function detectmob() {
                    if (navigator.userAgent.match(/Android/i)
                     || navigator.userAgent.match(/webOS/i)
                     || navigator.userAgent.match(/iPhone/i)
                     || navigator.userAgent.match(/iPad/i)
                     || navigator.userAgent.match(/iPod/i)
                     || navigator.userAgent.match(/BlackBerry/i)
                     || navigator.userAgent.match(/Windows Phone/i)
                     ){
                        return true;
                    }
                    else {
                        return false;
                    }
                }
                //if (\(refreshtime)) {
                    if (detectmob()) {
                        setInterval(function() {
                            location.reload();
                        }, \(preferences.integer(forKey : "refreshtime_value")) * 60 * 1000);
                    }
                //}
            </script>
        </body>
    """ + $0.path)) }
    
//    let publicDir = Bundle.main.resourcePath!
//    let files = shareFilesFromDirectory("/Users/admin/Desktop/sergey/mac_webcast/ShareScreen/ShareScreen/resource")
//    server["/public/:path"] = files
//    server["/public/"] = files    // needed to serve index file at root level
//
    server["/websocket"] = websocket(
        text : { (session, text) in
//            session.writeText(text)
            lock.lock()
            for (index, element) in g_sessionList.enumerated() {
                if element == session {
                    print("Ack = ", index)
                    g_readyList[index] = true
                }
            }
            lock.unlock()
        },
        binary : { (session, binary) in
            session.writeBinary(binary)
        },
        pong : { (_, _) in
            // Got a pong frame
        },
        connected : { (session) in
//            g_session = session
            g_sessionList.append(session)
            g_readyList.append(true)
            g_timeList.append(0)
//            sendSigninQRCode()
            print("Websocket is connected")
            // New client connected
        },
        disconnected : { (session) in
            // Client disconnected
            g_session = nil
            lock.lock()
            for (index, element) in g_sessionList.enumerated() {
                if element == session {
                    g_sessionList.remove(at : index)
                    g_readyList.remove(at : index)
                    g_timeList.remove(at : index)
                }
            }
            lock.unlock()
            print("Websocket is disconnected")
        }
    )

    return server
}
