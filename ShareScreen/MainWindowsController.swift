//
//  MainWindowsController.swift
//  ShareScreen
//
//  Created by Admin on 1/18/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Cocoa
import AVFoundation

class MainWindowController : NSWindowController, NSWindowDelegate {

//    let key = "GifCaptureFrameKey"

    override func windowDidLoad() {
        super.windowDidLoad()
        self.windowFrameAutosaveName = "position"
//        NotificationCenter.default.addObserver(self, selector : #selector(windowWillClose(_:)), name : NSWindow.willCloseNotification, object : nil)
    }
    
    func windowShouldClose(sender: AnyObject) -> Bool {
        NSApp.hide(nil)
        return false
    }

//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        guard let data = UserDefaults.standard.data(forKey : key),
//            let frame = NSKeyedUnarchiver.unarchiveObject(with : data) as? NSRect else {
//                return
//        }
//
//        window?.setFrame(frame, display : true)
//    }
//
//    func windowWillClose(_ notification : Notification) {
//        guard let frame = window?.frame else {
//            return
//        }
//
//        if #available(OSX 10.11, *) {
//            let data = NSKeyedArchiver.archivedData(withRootObject : frame)
//        }
//        else {
//            // Fallback on earlier versions
//        }
//        UserDefaults.standard.set(data, forKey : key)
//    }
}
