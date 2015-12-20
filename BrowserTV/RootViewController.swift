//
//  RootViewController.swift
//  BrowserTV
//
//  Created by Sash Zats on 12/19/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var preferencesTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var preferences: UIView!
    @IBOutlet weak var browser: UIView!

    private weak var preferencesVC: PreferencesViewController!

    @IBOutlet var menuTap: UITapGestureRecognizer!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let id = segue.identifier else {
            return
        }
        switch id {
        case "Preferences":
            preferencesVC = segue.destinationViewController as! PreferencesViewController
        default:
            assertionFailure()
        }
    }
}

// MARK: Actions
extension RootViewController {
    @IBAction func playTapAction(sender: AnyObject) {
        store.dispatch(
            Action(ActionKind.ShowPreferences.rawValue)
        )
    }

    @IBAction func menuTapAction(sender: AnyObject) {
        store.dispatch(
            Action(ActionKind.HidePreferences.rawValue)
        )
    }
    
}

// MARK: StoreSubscriber
extension RootViewController: StoreSubscriber {
    typealias StoreSubscriberStateType = AppState
    
    func newState(state: AppState) {
        let isVisible = preferencesTrailing.constant == 0
        let shouldBeVisible = state.preferences.isVisible
        guard isVisible != shouldBeVisible else {
            return
        }

        menuTap.enabled = shouldBeVisible
        
        // vc
        if shouldBeVisible {
            preferencesVC.beginAppearanceTransition(true, animated: true)
        } else {
            preferencesVC.beginAppearanceTransition(false, animated: true)
        }
        
        // animate
        preferencesTrailing.constant = shouldBeVisible ? 0 : -preferences.frame.width
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 300, initialSpringVelocity: 10, options: [.BeginFromCurrentState], animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.preferencesVC.endAppearanceTransition()
        })
    }
}
