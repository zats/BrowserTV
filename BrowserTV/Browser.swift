//
//  Browser.swift
//  BrowserTV
//
//  Created by Sash Zats on 12/18/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import UIKit

class Browser: UIView {
    private class Tab: UIView {
        var URL: NSURL!
        let webView = MyWebView.instance()

        convenience init(URL: NSURL) {
            self.init(frame: .zero)
            self.URL = URL
            addSubview(webView)
            webView.frame = bounds
            webView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            webView.loadRequest(NSURLRequest(URL: URL))
        }
    }
    
    private var tabs: [Tab] = [] {
        willSet {
            tabs.forEach{ $0.removeFromSuperview() }
        }
        didSet {
            tabs.forEach {
                addSubview($0)
                $0.frame = bounds
                $0.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            }

            if selectedTabIndex == nil && tabs.count > 0 {
                selectedTabIndex = 0
            }
        }
    }
    
    var URLs: [NSURL] = [] {
        didSet {
            if tabs.map({$0.URL}) != URLs {
                tabs = URLs.map{ Tab(URL: $0) }
            }
        }
    }
    
    var selectedTabIndex: Int? {
        didSet {
            if selectedTabIndex >= tabs.count {
                selectedTabIndex = nil
            }
            updateVisibleTab()
        }
    }
    
    private func updateVisibleTab() {
        tabs.enumerate().forEach { index, tab in
            tab.hidden = (index != selectedTabIndex)
        }
    }
}

