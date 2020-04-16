//
//  AppDelegate.swift
//  ShareScreen
//
//  Created by Admin on 11/18/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Cocoa
import StoreKit

@NSApplicationMain
class AppDelegate : NSObject, NSApplicationDelegate, InAppPurchaseStateChangeProtocol {

    // com.app.displayapp
    @IBOutlet weak var menu_refreshtime : NSMenuItem!
    @IBOutlet weak var menu_framerate   : NSMenuItem!

    @IBOutlet weak var mainMenu         : NSMenu!
    @IBOutlet weak var settings_menu    : NSMenu!
    @IBOutlet weak var framerate_menu   : NSMenu!
    @IBOutlet weak var refreshtime_menu : NSMenu!

    let preferences = UserDefaults.standard
    let refreshrime_state : Int = 0
    let refreshtime_value : Int = 0
//    let framerate_value : Int = 0
    var refreshtime_arr   : [String] = []
    var framerate_arr     : [String] = []

    @objc
    var transactionObserver: ALTransationsManager!
    
    func applicationDidFinishLaunching(_ aNotification : Notification) {
        // Insert code here to initialize your application
//        menu_refreshtime.isEnabled = true
//        menu_framerate.isEnabled = true
//        refreshtime_0.state = .on
//        framerate_1.state = .on

//
//        var menuItem = settings_menu.addItem(withTitle : "AAAA", action : nil, keyEquivalent : "")
//        var submenu = NSMenu(title : "AAAA")
//        settings_menu.setSubmenu(submenu, for : menuItem)
//
//        menuItem = settings_menu.addItem(withTitle : "vvvv", action : nil, keyEquivalent : "")
//        submenu = NSMenu(title : NSLocalizedString("vvvv",  comment : "vvvv menu"))
//        settings_menu.setSubmenu(submenu, for : menuItem)
        

        refreshtime_arr = [
            "OFF",
            "5 Mins",
            "10 Mins",
            "20 Mins",
            "30 Mins",
            "40 Mins",
            "50 Mins",
            "60 Mins",
            "70 Mins",
            "80 Mins",
            "90 Mins",
            "100 Mins",
            "110 Mins"
        ]

        framerate_arr = [
            "refreshrate_0",
            "refreshrate_1",
            "refreshrate_2",
            "refreshrate_3",
            "refreshrate_4",
            "refreshrate_5",
            "refreshrate_6",
            "refreshrate_7",
            "refreshrate_8",
            "refreshrate_9"
        ]

        for i in 0..<framerate_arr.count {
            framerate_menu.addItem(
                withTitle     : "\((i+1)*2)",
                action        : Selector("framerate_\(i+1):"),
                keyEquivalent : ""
            )
        }

        refreshtime_menu.addItem(
            withTitle     : "OFF",
            action        : Selector("refresh_0:"),
            keyEquivalent : ""
        )

        for j in 1..<refreshtime_arr.count {
            refreshtime_menu.addItem(
                withTitle     : refreshtime_arr[j],
                action        : Selector("refresh_\(j):"),
                keyEquivalent : ""
            )
        }
//        preferences.doesContain("framerate_value")
//        preferences.removeObject(forKey : "framerate_value")
//        preferences.removeObject(forKey : "refreshtime_value")
//        preferences.removeObject(forKey : "refreshtime_state")
//        preferences.synchronize()
//        refresh_arr[preferences.integer(forKey : "refreshtime_state")]
//        ("refreshtime_\(preferences.integer(forKey : "refreshtime_state"))")

//        menu_refresh.addItem(NSMenuItem(title : "aaaa", action : #selector(refresh_10(_:)), keyEquivalent : ""))
//        let editMenuItem = NSMenuItem()
//        editMenuItem.title = "Sett"
//        let mainMenu = NSMenu()
//        mainMenu.addItem(editMenuItem)
//        mainMenu.setSubmenu(mainMenu, for : editMenuItem)
//        NSApplication.shared.menu = mainMenu
        if (preferences.object(forKey : "framerate_value") == nil) {
            preferences.set(10, forKey : "framerate_value")
            preferences.synchronize()
        }
        framerate_menu.item(at : preferences.integer(forKey : "framerate_value")-1)?.state = .on

        if (preferences.object(forKey : "refreshtime_state") == nil) {
            preferences.set(5, forKey : "refreshtime_value")
            preferences.set(1, forKey : "refreshtime_state")
            preferences.synchronize()
        }
        refreshtime_menu.item(at : preferences.integer(forKey : "refreshtime_state"))?.state = .on

//        preferences.string(forKey : "refreshtime_value")
//        preferences.string(forKey : "refreshtime_state")
//
//        preferences.set(11110, forKey : "refreshtime_value")
//        preferences.set(0, forKey : "refreshtime_state")
        if #available(OSX 10.14, *) {
            SKStoreReviewController.requestReview()
        } else {
            //Nothing to do
        }
        
        ALTransationsManager.sharedInstance()
    }

    func applicationWillTerminate(_ aNotification : Notification) {
        // Insert code here to tear down your application
    }

    func applicationDidBecomeActive(_ notification : Notification) {
    }

    @IBAction func openURL(_ sender : AnyObject) {
        let url = URL(string : "http://www.99mobileapp.com/pp.html")!
        NSWorkspace.shared.open(url)
    }

    @objc func refresh_0(_ sender : Any) {
        for j in 0..<refreshtime_arr.count {
            refreshtime_menu.item(at : j)?.state = .off
        }
        refreshtime_menu.item(at : 0)?.state = .on
        preferences.set(11110, forKey : "refreshtime_value")
        preferences.set(0,     forKey : "refreshtime_state")
        preferences.synchronize()
    }

    @objc func refresh_1(_ sender : NSMenuItem) {
        for j in 0..<refreshtime_arr.count {
            refreshtime_menu.item(at : j)?.state = .off
        }
        refreshtime_menu.item(at : 1)?.state = .on
        preferences.set(5, forKey : "refreshtime_value")
        preferences.set(1, forKey : "refreshtime_state")
        preferences.synchronize()
    }

    @objc func refresh_2(_ sender : NSMenuItem) {
        for j in 0..<refreshtime_arr.count {
            refreshtime_menu.item(at : j)?.state = .off
        }
        refreshtime_menu.item(at : 2)?.state = .on
        preferences.set(10, forKey : "refreshtime_value")
        preferences.set(2,  forKey : "refreshtime_state")
        preferences.synchronize()
    }

    @objc func refresh_3(_ sender : NSMenuItem) {
        for j in 0..<refreshtime_arr.count {
            refreshtime_menu.item(at : j)?.state = .off
        }
        refreshtime_menu.item(at : 3)?.state = .on
        preferences.set(20, forKey : "refreshtime_value")
        preferences.set(3,  forKey : "refreshtime_state")
        preferences.synchronize()
    }

    @objc func refresh_4(_ sender : NSMenuItem) {
        for j in 0..<refreshtime_arr.count {
            refreshtime_menu.item(at : j)?.state = .off
        }
        refreshtime_menu.item(at : 4)?.state = .on
        preferences.set(30, forKey : "refreshtime_value")
        preferences.set(4,  forKey : "refreshtime_state")
        preferences.synchronize()
    }

    @objc func refresh_5(_ sender : NSMenuItem) {
        for j in 0..<refreshtime_arr.count {
            refreshtime_menu.item(at : j)?.state = .off
        }
        refreshtime_menu.item(at : 5)?.state = .on
        preferences.set(40, forKey : "refreshtime_value")
        preferences.set(5,  forKey : "refreshtime_state")
        preferences.synchronize()
    }

    @objc func refresh_6(_ sender : NSMenuItem) {
        for j in 0..<refreshtime_arr.count {
            refreshtime_menu.item(at : j)?.state = .off
        }
        refreshtime_menu.item(at : 6)?.state = .on
        preferences.set(50, forKey : "refreshtime_value")
        preferences.set(6,  forKey : "refreshtime_state")
        preferences.synchronize()
    }

    @objc func refresh_7(_ sender : NSMenuItem) {
        for j in 0..<refreshtime_arr.count {
            refreshtime_menu.item(at : j)?.state = .off
        }
        refreshtime_menu.item(at : 7)?.state = .on
        preferences.set(60, forKey : "refreshtime_value")
        preferences.set(7,  forKey : "refreshtime_state")
        preferences.synchronize()
    }

    @objc func refresh_8(_ sender : NSMenuItem) {
        for j in 0..<refreshtime_arr.count {
            refreshtime_menu.item(at : j)?.state = .off
        }
        refreshtime_menu.item(at : 8)?.state = .on
        preferences.set(70, forKey : "refreshtime_value")
        preferences.set(8,  forKey : "refreshtime_state")
        preferences.synchronize()
    }

    @objc func refresh_9(_ sender : NSMenuItem) {
        for j in 0..<refreshtime_arr.count {
            refreshtime_menu.item(at : j)?.state = .off
        }
        refreshtime_menu.item(at : 9)?.state = .on
        preferences.set(80, forKey : "refreshtime_value")
        preferences.set(9,  forKey : "refreshtime_state")
        preferences.synchronize()
    }

    @objc func refresh_10(_ sender : NSMenuItem) {
        for j in 0..<refreshtime_arr.count {
            refreshtime_menu.item(at : j)?.state = .off
        }
        refreshtime_menu.item(at : 10)?.state = .on
        preferences.set(90, forKey : "refreshtime_value")
        preferences.set(10, forKey : "refreshtime_state")
        preferences.synchronize()
    }

    @objc func refresh_11(_ sender : NSMenuItem) {
        for j in 0..<refreshtime_arr.count {
            refreshtime_menu.item(at : j)?.state = .off
        }
        refreshtime_menu.item(at : 11)?.state = .on
        preferences.set(100, forKey : "refreshtime_value")
        preferences.set(11,  forKey : "refreshtime_state")
        preferences.synchronize()
    }

    @objc func refresh_12(_ sender : NSMenuItem) {
        for j in 0..<refreshtime_arr.count {
            refreshtime_menu.item(at : j)?.state = .off
        }
        refreshtime_menu.item(at : 12)?.state = .on
        preferences.set(110, forKey : "refreshtime_value")
        preferences.set(12,  forKey : "refreshtime_state")
        preferences.synchronize()
    }


    @objc func framerate_1(_ sender : NSMenuItem) {
        for j in 0..<framerate_arr.count {
            framerate_menu.item(at : j)?.state = .off
        }
        framerate_menu.item(at : 0)?.state = .on
        framerate_value = 1
        preferences.set(1, forKey : "framerate_value")
        preferences.synchronize()
    }

    @objc func framerate_2(_ sender : NSMenuItem) {
        for j in 0..<framerate_arr.count {
            framerate_menu.item(at : j)?.state = .off
        }
        framerate_menu.item(at : 1)?.state = .on
        framerate_value = 2
        preferences.set(2, forKey : "framerate_value")
        preferences.synchronize()

    }

    @objc func framerate_3(_ sender : NSMenuItem) {
        for j in 0..<framerate_arr.count {
            framerate_menu.item(at : j)?.state = .off
        }
        framerate_menu.item(at : 2)?.state = .on
        framerate_value = 3
        preferences.set(3, forKey : "framerate_value")
        preferences.synchronize()
    }

    @objc func framerate_4(_ sender : NSMenuItem) {
        for j in 0..<framerate_arr.count {
            framerate_menu.item(at : j)?.state = .off
        }
        framerate_menu.item(at : 3)?.state = .on
        framerate_value = 4
        preferences.set(4, forKey : "framerate_value")
        preferences.synchronize()
    }

    @objc func framerate_5(_ sender : NSMenuItem) {
        for j in 0..<framerate_arr.count {
            framerate_menu.item(at : j)?.state = .off
        }
        framerate_menu.item(at : 4)?.state = .on
        framerate_value = 5
        preferences.set(5, forKey : "framerate_value")
        preferences.synchronize()
    }

    @objc func framerate_6(_ sender : NSMenuItem) {
        for j in 0..<framerate_arr.count {
            framerate_menu.item(at : j)?.state = .off
        }
        framerate_menu.item(at : 5)?.state = .on
        framerate_value = 6
        preferences.set(6, forKey : "framerate_value")
        preferences.synchronize()
    }

    @objc func framerate_7(_ sender : NSMenuItem) {
        for j in 0..<framerate_arr.count {
            framerate_menu.item(at : j)?.state = .off
        }
        framerate_menu.item(at : 6)?.state = .on
        framerate_value = 7
        preferences.set(7, forKey : "framerate_value")
        preferences.synchronize()
    }

    @objc func framerate_8(_ sender : NSMenuItem) {
        for j in 0..<framerate_arr.count {
            framerate_menu.item(at : j)?.state = .off
        }
        framerate_menu.item(at : 7)?.state = .on
        framerate_value = 8
        preferences.set(8, forKey : "framerate_value")
        preferences.synchronize()
    }

    @objc func framerate_9(_ sender : NSMenuItem) {
        for j in 0..<framerate_arr.count {
            framerate_menu.item(at : j)?.state = .off
        }
        framerate_menu.item(at : 8)?.state = .on
        framerate_value = 9
        preferences.set(9, forKey : "framerate_value")
        preferences.synchronize()
    }

    @objc func framerate_10(_ sender : NSMenuItem) {
        for j in 0..<framerate_arr.count {
            framerate_menu.item(at : j)?.state = .off
        }
        framerate_menu.item(at : 9)?.state = .on
        framerate_value = 10
        preferences.set(10, forKey : "framerate_value")
        preferences.synchronize()
    }
    
    @objc func subscriptionIsDoneSuccessfully(withPlan planID: String!) {
        
    }
    
    @objc func subscriptionIsRestoredSuccessfully(withPlan planId: String!) {
            
    }
    
    @objc func activatePremiumMembership() {
        
    }
    

}
