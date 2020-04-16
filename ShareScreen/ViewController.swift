//
//  ViewController.swift
//  ShareScreen
//
//  Created by Admin on 11/18/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Cocoa
import AVFoundation


class ViewController : NSViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
//    @IBOutlet weak var container : NSView!
    @IBOutlet weak var host_url  : NSTextField!
    @IBOutlet weak var btnShare  : NSButton!
    @IBOutlet weak var btnStartOrStop   : NSButton!
    @IBOutlet weak var btnHelp   : NSButton!
    @IBOutlet weak var btnExit   : NSButton!

    @IBOutlet weak var framerate_lbl : NSTextField!

    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let preferences = UserDefaults.standard

    var inAppPurchaseController: BuyMembershipWindowController!
    
    enum InterfaceStyle : String {
        case Dark, Light

        init() {
            let type = UserDefaults.standard.string(forKey : "AppleInterfaceStyle") ?? "Light"
            self = InterfaceStyle(rawValue : type)!
        }
    }

    let currentStyle = InterfaceStyle()

    private var server : HttpServer?

    private var running : UInt = 0

    private var session   : AVCaptureSession? = AVCaptureSession()
    private var input     : AVCaptureScreenInput?
    private var output    : AVCaptureVideoDataOutput?
    private var currentfr : Int = 0
    private var countfr   : Double = 0
    private let max_frame_rate : Int = 20
  
    lazy var sheetViewController : NSViewController = {
        return self.storyboard!.instantiateController(withIdentifier : "SheetViewController") as! NSViewController
    } ()

    override func viewDidLoad() {
        super.viewDidLoad()
        // set background
//        container.wantsLayer = true
//        container.layer?.backgroundColor = NSColor.darkGray.cgColor
//        container.layer?.cornerRadius = CGFloat(20)

//        if currentStyle.rawValue == "Light" {
//            btnShare.image = NSImage(named : "share_light.png")
//            btnHelp.image  = NSImage(named : "question_light.png")
//            btnExit.image  = NSImage(named : "exit_light.png")
//        }
//        else {
//            btnShare.image = NSImage(named : "share.png")
//            btnHelp.image  = NSImage(named : "question.png")
//            btnExit.image  = NSImage(named : "exit.png")
//        }
        // Do any additional setup after loading the view.
        host_url.stringValue = "http://" + getIpAddress() + ":8080"
//        host_url.textColor = NSColor.black
        framerate_lbl.stringValue = String(preferences.integer(forKey : "framerate_value"))
        launchServer()
//        initScreenCapture()
    }
    
    override func viewDidDisappear() {
        self.server?.stop()
    }

/*
    func getIpAddress() -> String! {
        // This function is for only a Wifi
        var address : String?
        var ifaddr  : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family

                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    if let name : String = String(cString : (interface?.ifa_name)!), name == "en0" {
                        var hostname = [CChar](repeating : 0, count : Int(NI_MAXHOST))
                        getnameinfo(
                            interface?.ifa_addr,
                            socklen_t((interface?.ifa_addr.pointee.sa_len)!),
                            &hostname,
                            socklen_t(hostname.count),
                            nil,
                            socklen_t(0),
                            NI_NUMERICHOST
                        )
                        address = String(cString : hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address as? String ?? ""
    }
*/
    func getIpAddress() -> String {
        // This function is for Local Network IP
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return "" }
        guard let firstAddr = ifaddr else { return "" }

        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            let addr = ptr.pointee.ifa_addr.pointee

            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(
                            ptr.pointee.ifa_addr,
                            socklen_t(addr.sa_len),
                            &hostname,
                            socklen_t(hostname.count),
                            nil,
                            socklen_t(0),
                            NI_NUMERICHOST
                        ) == 0
                    ) {
                        let address = String(cString: hostname)
                        if address.starts(with: "192") {
                            return address
                        }
                    }
                }
            }
        }

        freeifaddrs(ifaddr)
        return ""
    }

    @IBAction func sliderValueChanged(sender : NSSlider) {
        preferences.set(sender.doubleValue, forKey : "framerate_value")
        framerate_lbl.stringValue = String(preferences.integer(forKey : "framerate_value"))
    }


    @IBAction func onStartStop(sender : NSButton) {
        actionCatpure()
    }


    @IBAction func onBtnShare(sender : NSButton) {
        let arrData : String = host_url.stringValue
        let arr = [URL(string : arrData)]
        let sharingServicePicker : NSSharingServicePicker = NSSharingServicePicker.init(items : arr as [AnyObject])
        sharingServicePicker.show(relativeTo : btnShare.bounds, of : btnShare, preferredEdge : NSRectEdge.maxX)
    }


    @IBAction func onShowHelp(sender : NSButton) {
        self.presentAsSheet(sheetViewController)
//        showIAPWindow()
    }


    @IBAction func onHideHelp(sender : NSButton) {
//        self.dismiss(sheetViewController)
    }


    func actionCatpure() {
        if session!.isRunning {
            
            session?.stopRunning()
            session?.removeInput(input!)
            session?.removeOutput(output!)
            countfr = 0
//            btnStartOrStop.image = NSImage(named : "circle_enable.png")
            btnStartOrStop.title = "Start"
            appDelegate.menu_refreshtime.isEnabled = true
            appDelegate.menu_framerate.isEnabled = true
        }
        else {
            initScreenCapture()
            session?.startRunning()
//            btnStartOrStop.image = NSImage(named : "circle_disable.png")
            btnStartOrStop.title = "Stop"
            appDelegate.menu_refreshtime.isEnabled = false
            appDelegate.menu_framerate.isEnabled = false
        }
    }


    public func launchServer() {
        do {
            let server = CaptureServer()
            try server.start(8080, forceIPv4 : true)
            self.server = server

            print("Http Server is Started")
        }
        catch {
            print("Server start error: \(error)")
            host_url.stringValue = "\(error)"
        }
    }


    func initScreenCapture() {
//        session = AVCaptureSession()
        input = AVCaptureScreenInput(displayID : kCGNullDirectDisplay)
        if session!.canAddInput(input!) {
            session!.addInput(input!)
        }
        framerate_lbl.stringValue = String(preferences.integer(forKey : "framerate_value"))
        currentfr = preferences.integer(forKey : "framerate_value") * 2
        input?.minFrameDuration = CMTimeMake(value : 1, timescale : Int32(max_frame_rate) /*Int32(currentfr)*/)

        output = AVCaptureVideoDataOutput()

        let videoSettings : [String : Any]?

        if #available(macOS 10.13, *) {
            // macOS 10.13 or later code path
            videoSettings = [
                AVVideoCodecKey : AVVideoCodecType.jpeg,
//                AVVideoWidthKey : 1920,
//                AVVideoHeightKey : 1080,
//                AVVideoCompressionPropertiesKey : [
//                    AVVideoAverageBitRateKey :  NSNumber(value: 5000000)
//                    AVVideoQualityKey: 0.1
//                ]
            ] as [String : Any]
        }
        else {
            // code for earlier than 10.13
            videoSettings = [
                AVVideoCodecKey : AVVideoCodecJPEG,
//                AVVideoWidthKey : 1920,
//                AVVideoHeightKey : 1080,
//                AVVideoCompressionPropertiesKey : [
//                    AVVideoAverageBitRateKey :  NSNumber(value : 5000000)
//                    AVVideoQualityKey : 0.1
//                ]
            ] as [String : Any]
        }

        output?.videoSettings = videoSettings
        output!.setSampleBufferDelegate(self, queue : DispatchQueue(label : "sample buffer delegate", attributes : []))
        if session!.canAddOutput(output!) {
            session!.addOutput(output!)
        }
    }


    func captureOutput(_ output : AVCaptureOutput, didOutput sampleBuffer : CMSampleBuffer, from connection : AVCaptureConnection) {

        if CMSampleBufferDataIsReady(sampleBuffer) != true {
            print("sampleBuffer data is not ready")
            return
        }

        // handle frame data
        guard let dataBuffer = CMSampleBufferGetDataBuffer(sampleBuffer) else {
            return
        }

        var lengthAtOffset : Int = 0
        var totalLength    : Int = 0
        var dataPointer    : UnsafeMutablePointer<Int8>?
        if CMBlockBufferGetDataPointer(dataBuffer, atOffset : 0, lengthAtOffsetOut : &lengthAtOffset, totalLengthOut : &totalLength, dataPointerOut : &dataPointer) == noErr {
            var intArray = Array(UnsafeBufferPointer(start : dataPointer, count : totalLength))
            countfr += 1
            print(countfr)
            if (countfr >= Double(max_frame_rate) / Double(currentfr)) {
                countfr -= Double(max_frame_rate) / Double(currentfr)
                print(countfr)
                sendDataToClient(array : intArray)
            }
        }
    }
    
    func showIAPWindow()
    {
        if inAppPurchaseController == nil {
            inAppPurchaseController = BuyMembershipWindowController.init(windowNibName: "BuyMembershipWindowController")
        }
        
        inAppPurchaseController.setSubscriptionPlansFromStoreCompetionBlock { (isComplete, isTransactionSuccessful, planName) in
            if isTransactionSuccessful {
                print("Unlocked", planName)
                self.preferences.set(1, forKey : "iap")
                self.appDelegate.subscriptionIsDoneSuccessfully(withPlan: planName)
            }
            
            if isComplete {
                self.inAppPurchaseController = nil
            }
        }
        
        inAppPurchaseController.showWindow(nil)
    }

}

