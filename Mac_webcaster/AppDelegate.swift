//
//  AppDelegate.swift
//  Mac_webcaster
//
//  Created by Admin on 11/16/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Cocoa
import AVFoundation
import VideoToolbox

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var window: NSWindow!

    var timer: Timer = Timer()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
       
//        self.makeScreenshots()
        self.launchServer()
        initScreenCapture()
        startTimer()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        stopTimer()
        server?.stop()
    }
     
    
    private var server: HttpServer?
    
    private var running:UInt = 0
    
    private var session:AVCaptureSession?
    private var input:AVCaptureScreenInput?
    private var output:AVCaptureVideoDataOutput?
    
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
    
    func initScreenCapture()
    {
        session = AVCaptureSession()
        input = AVCaptureScreenInput(displayID: kCGNullDirectDisplay)
        if session!.canAddInput(input!) {
            session!.addInput(input!)
        }
        
        output = AVCaptureVideoDataOutput()
        
        let videoSettings = [
            AVVideoCodecKey : AVVideoCodecType.jpeg,
//            AVVideoWidthKey : 1920,
//            AVVideoHeightKey : 1080
            /*AVVideoCompressionPropertiesKey: [
              AVVideoAverageBitRateKey:  NSNumber(value: 5000000)
            ]*/
        ] as [String : Any]
        
        output?.videoSettings = videoSettings
        
        output!.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate", attributes: []))
        
        if session!.canAddOutput(output!) {
            session!.addOutput(output!)
        }
    }
    
    func startTimer()
    {
        if session!.isRunning {
            return
        }
        session?.startRunning()
        
//        self.running = 1
//
//        let queue = DispatchQueue(label: "work-queue")
//        queue.async {
//            while(self.running == 1)
//            {
//                self.makeScreenshots()
//            }
//        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        if CMSampleBufferDataIsReady(sampleBuffer) != true {
            print("sampleBuffer data is not ready")
            return
        }
        
        // handle frame data
        guard let dataBuffer = CMSampleBufferGetDataBuffer(sampleBuffer) else {
            return
        }
        
        var lengthAtOffset: Int = 0
        var totalLength: Int = 0
        var dataPointer: UnsafeMutablePointer<Int8>?
        if CMBlockBufferGetDataPointer(dataBuffer, atOffset: 0, lengthAtOffsetOut: &lengthAtOffset, totalLengthOut: &totalLength, dataPointerOut: &dataPointer) == noErr {
            var intArray = Array(UnsafeBufferPointer(start: dataPointer, count: totalLength))
            sendDataToClient(array: intArray)
        }
    }
    
    func stopTimer() {
        self.running = 0
       
        if session?.isRunning == false {
            return
        }
        session?.stopRunning()
    }
    
    var init_flag = false
    
    func takeScreenshot(_ displayID:CGDirectDisplayID) -> Data? {
        let st:Double = NSDate().timeIntervalSince1970
        guard let imageRef = CGDisplayCreateImage(displayID) else { return nil }
        let et:Double = NSDate().timeIntervalSince1970
        print("---- Capture Image -----", et - st, "s")
            
        let bitmapRep = NSBitmapImageRep(cgImage: imageRef)
        let st1:Double = NSDate().timeIntervalSince1970
        guard let jpegData = bitmapRep.representation(using:.jpeg, properties: [.compressionFactor : 0.8]) else { return nil }
        
        let et1:Double = NSDate().timeIntervalSince1970
        print("---- Compress Image -----", et1 - st1, "s")
                
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

        if displayCount > 1 {
           displayCount = 1
        }
        
        for i in 0..<displayCount {
            let displayID = activeDisplays[Int(i)]
            let image = self.takeScreenshot(displayID)

            let count = image!.count / MemoryLayout<UInt8>.size
            var byteArray = [UInt8](repeating: 0, count: count)
            image?.copyBytes(to: &byteArray, count:count)
            let st:Double = NSDate().timeIntervalSince1970
//            sendDataToClient(array: byteArray)
            let et:Double = NSDate().timeIntervalSince1970
            print("---- Send Time -----", et - st, "s")
        }
        let gap = NSDate().timeIntervalSince1970 - curTime
        print("---- Total Time ----", gap, "s")
        curTime = NSDate().timeIntervalSince1970
    }


}

