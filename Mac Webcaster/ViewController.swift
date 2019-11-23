//
//  ViewController.swift
//  Mac Webcaster
//
//  Created by Admin on 11/18/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Cocoa
import AVFoundation


class ViewController: NSViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    @IBOutlet weak var container: NSView!
    @IBOutlet weak var host_url: NSTextField!
    @IBOutlet weak var broadcast_status: NSTextField!
    @IBOutlet weak var btnShare: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set background
        container.wantsLayer = true
        container.layer?.backgroundColor = NSColor.gray.cgColor
        container.layer?.borderColor = NSColor.darkGray.cgColor
        container.layer?.cornerRadius = CGFloat(20)

        // Do any additional setup after loading the view.
        host_url.stringValue = "http://" + getIpAddress() + ":8080"
        
        launchServer()
        initScreenCapture()
        
//        actionCatpure()
//        broadcast_status.stringValue = "Broadcast is not started."
    }
    
    func getIpAddress() -> String! {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    if let name: String = String(cString: (interface?.ifa_name)!), name == "en0" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(
                            interface?.ifa_addr,
                            socklen_t((interface?.ifa_addr.pointee.sa_len)!),
                            &hostname,
                            socklen_t(hostname.count),
                            nil,
                            socklen_t(0),
                            NI_NUMERICHOST
                        )
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address as? String ?? ""
    }
    
    @IBAction func onStartStop(sender: NSButton) {
        actionCatpure()
    }
    
    @IBAction func onBtnShare(sender: NSButton) {
        let arrData : [String] = [host_url.stringValue]
        let sharingServicePicker = NSSharingServicePicker (items: arrData )
        sharingServicePicker.show(relativeTo: btnShare.bounds, of: btnShare, preferredEdge: NSRectEdge.maxX)
    }
    
    @IBAction func onShowHelp(sender: NSButton) {
   }
    
    func actionCatpure() {
        if session!.isRunning {
            session?.stopRunning()
            broadcast_status.stringValue = "Broadcast is stoped."
        }
        else {
            session?.startRunning()
            broadcast_status.stringValue = "Broadcast is started."
        }
    }
    
    private var server: HttpServer?
        
    private var running:UInt = 0
    
    private var session:AVCaptureSession?
    private var input:AVCaptureScreenInput?
    private var output:AVCaptureVideoDataOutput?
        
    func launchServer() {
        do {
            let server = CaptureServer()
            try server.start(8080, forceIPv4:true)
            self.server = server
            
            print("Http Server is Started")
        } catch {
            print("Server start error: \(error)")
            host_url.stringValue = "\(error)"
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
        
        let videoSettings : [String : Any]?
        
        if #available(macOS 10.13, *) {
              // macOS 10.13 or later code path
            videoSettings = [
                AVVideoCodecKey : AVVideoCodecType.jpeg,
            //            AVVideoWidthKey : 1920,
            //            AVVideoHeightKey : 1080,
            //            AVVideoCompressionPropertiesKey: [
            ////              AVVideoAverageBitRateKey:  NSNumber(value: 5000000)
            //                AVVideoQualityKey: 0.1
            //            ]
                    ] as [String : Any]
        } else {
              // code for earlier than 10.13
            videoSettings = [
                        AVVideoCodecKey : AVVideoCodecJPEG,
            //            AVVideoWidthKey : 1920,
            //            AVVideoHeightKey : 1080,
            //            AVVideoCompressionPropertiesKey: [
            ////              AVVideoAverageBitRateKey:  NSNumber(value: 5000000)
            //                AVVideoQualityKey: 0.1
            //            ]
                    ] as [String : Any]
        }
        
        output?.videoSettings = videoSettings
        
        output!.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate", attributes: []))
        
        if session!.canAddOutput(output!) {
            session!.addOutput(output!)
        }
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

}

