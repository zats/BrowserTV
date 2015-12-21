//
//  VoucherService.swift
//  BrowserTV
//
//  Created by Sash Zats on 12/19/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Foundation

class VoucherService {
    private let client = VoucherClient(uniqueSharedId: "com.zats.browser")
    
    func start() {
        client.startSearchingWithCompletion { data, displayName, error in
            guard let data = data else {
                assertionFailure()
                return
            }
            self.process(data: data)
        }
    }
    
    func stop() {
        client.stop()
    }
    
    private func process(data data: NSData) {
        let coder = NSKeyedUnarchiver(forReadingWithData: data)
        guard let URL = coder.decodeObjectForKey("URL") as? NSURL else {
            assertionFailure()
            return
        }
        if let cookies = coder.decodeObjectForKey("cookies") as? [NSHTTPCookie] {
            let storage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
            for cookie in cookies {
                storage.setCookie(cookie)
            }
            print("Received cookies: \(cookies)")
        } else {
            assertionFailure()
        }
        store.dispatch(
            Action(
                type: ActionKind.Add.rawValue,
                payload: ["URL": URL]
            )
        )       
    }
}