//
//  AppState.swift
//  BrowserTV
//
//  Created by Sash Zats on 12/18/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Foundation


struct AppState: StateType {
    var timer: TimerState
    var browser: BrowserState
    var preferences: PreferencesState
    
    init(browser: BrowserState, preferences: PreferencesState, timer: TimerState) {
        self.browser = browser
        self.preferences = preferences
        self.timer = timer
    }

    init() {
        self.init(
            browser: BrowserState(switchInterval: 7, selectedTabIndex: nil, tabs: []),
            preferences: PreferencesState(isVisible: false, URLs: []),
            timer: TimerState()
        )
    }
}

struct TimerState {
    var shouldReset: Bool = false
}

struct BrowserState {
    var switchInterval: Double
    var selectedTabIndex: Int?
    var tabs: [BrowserTabState]
}

struct BrowserTabState {
    var URL: NSURL
}

struct PreferencesState {
    var isVisible: Bool
    var URLs: [String]
}
