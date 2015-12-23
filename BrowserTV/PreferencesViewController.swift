//
//  PreferencesViewController.swift
//  BrowserTV
//
//  Created by Sash Zats on 12/19/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var URLs: [String] = []
    
    private let service = CommunicationService()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
        service.start()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
        service.stop()
    }
}

// MARK: Gestures Handling
extension PreferencesViewController {
    
    @IBAction func playPauseGestureAction(sender: AnyObject) {
        tableView.editing = !tableView.editing
    }
    
    @IBAction func menuAction(sender: AnyObject) {
        store.dispatch(Action(ActionKind.HidePreferences.rawValue))
    }
    
}

extension PreferencesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        store.dispatch(
            Action(
                type: ActionKind.Remove.rawValue,
                payload:["index": indexPath.row]
            )
        )
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        store.dispatch(
            Action(
                type: ActionKind.SelectedTab.rawValue,
                payload: ["index": indexPath.row]
            )
        )
    }
}

extension PreferencesViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return URLs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let URLString = URLs[indexPath.row]
        cell.textLabel?.text = URLString
        return cell
    }
}

extension PreferencesViewController: StoreSubscriber {
    typealias StoreSubscriberStateType = AppState
    
    func newState(state: AppState) {
        let URLs = state.preferences.URLs.map{ String($0) }
        if self.URLs != URLs {
            self.URLs = URLs
            tableView.reloadData()
        }
        if let index = state.browser.selectedTabIndex {
            tableView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: true, scrollPosition: .Middle)
        }
    }
}
