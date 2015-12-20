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

    func subscribe() {
        store.subscribe(self)
    }
    
    func unsubscriber() {
        store.unsubscribe(self)
    }
    
    func stop() {
        timer?.invalidate()
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
            resetTimer(state)
        } else {
            if self.interval != state.browser.switchInterval {
                start(state.browser.switchInterval)
            }
        }
    }
    
    private func resetTimer(state: AppState) {
        stop()
        store.dispatch(
            Action(ActionKind.AcknowledgeTimerReset.rawValue)
        )
        start(state.browser.switchInterval)
    }
}
