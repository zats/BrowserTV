//
//  Website.swift
//  BrowserTV
//
//  Created by Sash Zats on 12/22/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Foundation

struct Website {
    let URL: NSURL
    let cookies: [NSHTTPCookie]
    
    init(URL: NSURL, cookies: [NSHTTPCookie]) {
        self.URL = URL
        self.cookies = cookies
    }
}

extension Website {
    init?(jsonValue: [String: AnyObject]) {
        guard let URLString = jsonValue["URL"] as? String, URL = NSURL(string: URLString) else {
            return nil
        }
        self.URL = URL
        guard let cookies = jsonValue["cookies"] as? [[String: String]] else {
            return nil
        }
        self.cookies = cookies.flatMap{ NSHTTPCookie.cookiesWithResponseHeaderFields($0, forURL: URL) }
    }
    
    var jsonValue: [String: AnyObject] {
        return [
            "URL": URL.absoluteString,
            "cookies": cookies.jsonValue
        ]
    }
}

extension Array where Element: NSHTTPCookie {
    var jsonValue: [String: String] {
        return NSHTTPCookie.requestHeaderFieldsWithCookies(self)
    }
}
