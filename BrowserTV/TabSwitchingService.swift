//
//  ViewController.swift
//  BrowserTV
//
//  Created by Sash Zats on 12/18/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import UIKit

class TabSwitchingService {
    private var timer: NSTimer?
    private(set) var interval: Double?

    func start() {
        store.subscribe(self)
    }
    
    func stop() {
        timer?.invalidate()
        store.unsubscribe(self)
    }

    private func start(interval: Double) {
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "timerHandler", userInfo: nil, repeats: true)
        self.interval = interval
    }
    

    @objc private func timerHandler() {
        store.dispatch(
            Action(ActionKind.AdvanceTab.rawValue)
        )
    }
}

extension TabSwitchingService: StoreSubscriber {
    func newState(state: AppState) {
        if state.timer.shouldReset {
            stop()
        }
        let interval = state.browser.switchInterval
        if self.interval != interval || state.timer.shouldReset {
            start(interval)
        }
    }
}
