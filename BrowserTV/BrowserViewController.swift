//
//  BrowserViewController.swift
//  BrowserTV
//
//  Created by Sash Zats on 12/19/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import UIKit

class BrowserViewController: UIViewController {
    
    private let tabSwitchingService = TabSwitchingService()
    @IBOutlet weak var browser: Browser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabSwitchingService.start()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        store.unsubscribe(self)
    }
    
}

extension BrowserViewController: StoreSubscriber {
    typealias StoreSubscriberStateType = AppState
    
    func newState(state: AppState) {
        let tabs = state.browser
        browser.URLs = tabs.tabs.map{ $0.URL }
        browser.selectedTabIndex = tabs.selectedTabIndex
    }
}
