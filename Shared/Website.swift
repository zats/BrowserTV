//
//  Website.swift
//  BrowserTV
//
//  Created by Sash Zats on 12/22/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Foundation


struct Website {
    typealias SerializedCookies = [String: String]
    
    let URL: NSURL
    let cookies: [NSHTTPCookie]
    
    init(URL: NSURL, cookies: [NSHTTPCookie]) {
        self.URL = URL
        self.cookies = cookies
    }
}

extension Website {
    init?(data: NSData) {
        let coder = NSKeyedUnarchiver(forReadingWithData: data)
        guard let URL = coder.decodeObjectForKey("URL") as? NSURL else {
            return nil
        }
        self.URL = URL
        guard let cookies = coder.decodeObjectForKey("cookies") as? [NSHTTPCookie] else {
            return nil
        }
        self.cookies = cookies
    }
    
    var data: NSData {
        let data = NSMutableData()
        let coder = NSKeyedArchiver(forWritingWithMutableData: data)
        coder.encodeObject(URL, forKey: "URL")
        coder.encodeObject(cookies, forKey: "cookies")
        coder.finishEncoding()
        return data
    }
}
