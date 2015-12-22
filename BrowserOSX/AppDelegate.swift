//
//  AppDelegate.swift
//  BrowserOSX
//
//  Created by Sash Zats on 12/19/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Cocoa
import WebKit


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
}


class WindowController: NSWindowController {
    
    private var storage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    private let server = VoucherServer(uniqueSharedId: "com.zats.browser")
    
    @IBOutlet weak var textField: NSTextField!
    
    private var URL: NSURL!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        window?.titleVisibility = .Hidden
    }
    
    @IBAction func _sendButtonAction(sender: AnyObject) {
        server.startAdvertisingWithRequestHandler { displayName, handler in
            print("Sending URL: \(self.URL)")
            let data = NSMutableData()
            let coder = NSKeyedArchiver(forWritingWithMutableData: data)
            coder.encodeObject(self.URL, forKey: "URL")
            if let cookies = self.storage.cookies {
                print("Sending cookies \(cookies)\n")
                coder.encodeObject(cookies, forKey: "cookies")
            }
            coder.finishEncoding()
            handler(data, nil)
            self.server.stop()
        }
    }
    
    @IBAction func textFieldAction(sender: AnyObject) {
        storage.deleteAllCookies()

        let controller = window?.contentViewController as! ViewController
        let URLString = textField.stringValue.hasPrefix("http") || textField.stringValue.hasPrefix("https") ? textField.stringValue : "https://\(textField.stringValue)"
        textField.stringValue = URLString
        let URL = NSURL(string: URLString)!
        self.URL = URL
        
        let request = NSURLRequest(URL: URL)
        controller.webView.mainFrame.loadRequest(request)
    }
}


class ViewController: NSViewController {
    
    @IBOutlet weak var webView: WebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension NSHTTPCookieStorage {
    func deleteAllCookies() {
        if let cookies = cookies {
            for cookie in cookies {
                deleteCookie(cookie)
            }
        }

    }
}

//private extension NSHTTPCookieStorage {
//    var data: [NSData]? {
//        guard let cookies = cookies else {
//            return nil
//        }
//        return cookies.flatMap{ $0.data }
//    }
//}
//
//private extension NSHTTPCookie {
//    var data: NSData? {
//        guard let properties = properties else {
//            return nil
//        }
//        let data = NSMutableData()
//        let coder = NSKeyedArchiver(forWritingWithMutableData: data)
//        coder.encodeObject(properties)
//        coder.finishEncoding()
//        return data
//    }
//}