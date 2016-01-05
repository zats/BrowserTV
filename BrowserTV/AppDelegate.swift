//
//  AppDelegate.swift
//  BrowserTV
//
//  Created by Sash Zats on 12/18/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import UIKit

var store = MainStore(
    reducer: MainReducer([BrowserReducer()]),
    appState: AppState()
)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        application.idleTimerDisabled = true
        store.dispatch(Action(ActionKind.LoadState.rawValue))
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        store.dispatch(Action(ActionKind.SaveState.rawValue))
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }
}

