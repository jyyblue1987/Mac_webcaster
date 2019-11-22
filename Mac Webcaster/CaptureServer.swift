//
//  DemoServer.swift
//  Swifter
//
//  Copyright (c) 2014-2016 Damian Kołakowski. All rights reserved.
//

import Foundation

var g_session: WebSocketSession?
var g_sessionList = Array<WebSocketSession>()
var g_readyList = Array<Bool>()
var g_timeList = Array<Double>()

var g_SignCode: String?



let lock = NSLock()

public func sendDataToClient(array: [Int8]) -> Int {
    var totalSize:Int = 0

    let curTime:Double = NSDate().timeIntervalSince1970
    lock.lock()
    for (index, session) in g_sessionList.enumerated() {
       
        let gap = curTime - g_timeList[index]
        if( g_readyList[index] == true || gap > 10 ) {  // send ready or timeout
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
    
    server["/"] = { .ok(.htmlBody("""
        """ + $0.path)) }
    
    server[""] = { .ok(.htmlBody("""
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
        <div id="container" style="width:100%; height:100%">
            <img id="image" src="" style="width:100%; height:100%; object-fit:contain">
        </div>

        <script>
            var host = window.location.hostname;
            if( host == "" )
                host = "localhost";
            
            console.log(host);

            function WebSocketTest() {
                if ("WebSocket" in window) {
                    // Let us open a web socket
                    var ws = new WebSocket("ws://" + host + ":8080/websocket");

                    ws.onopen = function() {
                        console.log("socket is connected")
                    };
                    
                    ws.onmessage = function (event) {
                        var data_type = typeof event.data;
                        if ( data_type == "string" ) {
                            console.log(event.data);
                            
                            var container = document.getElementById('image');
                            container.className = "rotate" + event.data;
                          
                            return;
                        }
                        
                        var reader = new FileReader();
                        reader.readAsDataURL(event.data);
                        reader.onloadend = function() {
                            var base64data = reader.result;
                            var res = base64data.replace("data:;base64", "data:image/jpeg;base64");
                            var img = document.getElementById('image');
                            img.src = res;
                            ws.send("ack");
                        }
                        
                    };
                    
                    ws.onclose = function() {
                        
                        // websocket is closed.
                        console.log("Connection is closed...");
                    };
                } else {
                    
                    // The browser doesn't support WebSocket
                    console.log("WebSocket NOT supported by your Browser!");
                }
            }

            setTimeout(function() {
                   WebSocketTest();
            }, 500);
            
        </script>

    """ + $0.path)) }
    
//    let publicDir = Bundle.main.resourcePath!
//    let files = shareFilesFromDirectory("/Users/admin/Desktop/sergey/mac_webcast/Mac_webcaster/Mac_webcaster/resource")
//    server["/public/:path"] = files
//    server["/public/"] = files    // needed to serve index file at root level
//
    server["/websocket"] = websocket(text: { (session, text) in
//        session.writeText(text)
        lock.lock()
        for (index, element) in g_sessionList.enumerated() {
            if element == session {
                print("Ack = ", index)
                g_readyList[index] = true
            }
        }
        lock.unlock()
    }, binary: { (session, binary) in
        session.writeBinary(binary)
    }, pong: { (_, _) in
        // Got a pong frame
    }, connected: { (session) in
//        g_session = session
        g_sessionList.append(session)
        g_readyList.append(true)
        g_timeList.append(0)
        
//        sendSigninQRCode()
        print("Websocket is connected")
        // New client connected
    }, disconnected: { (session) in
        // Client disconnected
        g_session = nil
        lock.lock()
        for (index, element) in g_sessionList.enumerated() {
            if element == session {
                g_sessionList.remove(at: index)

                g_readyList.remove(at: index)
                g_timeList.remove(at:index)
            }
        }
        lock.unlock()
        print("Websocket is disconnected")

    })
    
    return server
}
