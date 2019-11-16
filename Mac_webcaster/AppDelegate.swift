//
//  AppDelegate.swift
//  Mac_webcaster
//
//  Created by Admin on 11/16/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    var timer: Timer = Timer()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
       
//        self.makeScreenshots()
        self.launchServer()
        startTimer()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        stopTimer()
        server?.stop()
    }
     
    
    private var server: HttpServer?
    
    private var running:UInt = 0
    
    func launchServer() {
        do {
            let server = CaptureServer()
            try server.start(80)
            self.server = server
            
            print("Http Server is Started")
        } catch {
            print("Server start error: \(error)")
        }
    }
    
    func startTimer()
    {
        self.running = 1
        
        let queue = DispatchQueue(label: "work-queue")
        queue.async {
            while(self.running == 1)
            {
                self.makeScreenshots()
            }
        }
    }
    
    func stopTimer() {
        self.running = 0
    }
    
    func takeScreenshot(_ displayID:CGDirectDisplayID) -> Data? {
        let st:Double = NSDate().timeIntervalSince1970
        guard let imageRef = CGDisplayCreateImage(displayID) else { return nil }
        let et:Double = NSDate().timeIntervalSince1970
        print("---- Captuer Image -----", et - st, "s")
        let image = NSImage(cgImage: imageRef, size: NSZeroSize)

        guard let imageData = image.tiffRepresentation else { return nil }
        let bitmapRep = NSBitmapImageRep(data: imageData)
        guard let jpegData = bitmapRep?.representation(using:.jpeg, properties: [.compressionFactor : 0.8]) else { return nil }

        return jpegData
    }
    
    var curTime:Double = 0;
    @objc
    func makeScreenshots() {
        curTime = NSDate().timeIntervalSince1970
        
        let MAX_DISPLAYS : UInt32 = 16

        var displayCount: UInt32 = 0;
        let result = CGGetActiveDisplayList(0, nil, &displayCount)
        if result != .success {
            print("-- can't get active display list, error: \(result)")
            return
        }

        let allocated = Int(displayCount)
        let activeDisplays = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: allocated)

        let status : CGError = CGGetActiveDisplayList(MAX_DISPLAYS, activeDisplays, &displayCount)
        if status != .success {
            print("-- cannot get active display list, error \(status)")
        }

        for i in 0..<displayCount {
            let displayID = activeDisplays[Int(i)]
            let image = self.takeScreenshot(displayID)

            let count = image!.count / MemoryLayout<UInt8>.size
            var byteArray = [UInt8](repeating: 0, count: count)
            image?.copyBytes(to: &byteArray, count:count)
            let st:Double = NSDate().timeIntervalSince1970
            sendDataToClient(array: byteArray)
            let et:Double = NSDate().timeIntervalSince1970
            print("---- Send Time -----", et - st, "s")
        }
        let gap = NSDate().timeIntervalSince1970 - curTime
        print("---- Total Time ----", gap, "s")
        curTime = NSDate().timeIntervalSince1970
    }


}

