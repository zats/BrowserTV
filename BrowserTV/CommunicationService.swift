//
//  CommunicationService.swift
//  BrowserTV
//
//  Created by Sash Zats on 12/22/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Foundation


class CommunicationService: NSObject {
    private let browser: MyNearbyServiceBrowser
    private let peer: MyPeerID
    private let session: MySession
    
    override init() {
        let peer = MyPeerID(displayName: UIDevice.currentDevice().name)
        self.peer = peer
        self.browser = MyNearbyServiceBrowser(peer: peer, serviceType: "browser-tv")
        self.session = MySession(peer: peer, securityIdentity: nil, encryptionPreference: .None)
        super.init()
        browser.delegate = self
        session.delegate = self
    }
    
    deinit {
        stop()
    }
    
    func start() {
        browser.startBrowsingForPeers()
    }
    
    func stop() {
        browser.stopBrowsingForPeers()
    }
}

extension CommunicationService: MyNearbyServiceBrowserDelegate {
    func browser(browser: MyNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError) {
        assertionFailure(error.description)
    }
    func browser(browser: MyNearbyServiceBrowser, foundPeer: MyPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(foundPeer, toSession: session, withContext: nil, timeout: 10)
        print(__FUNCTION__, foundPeer)
    }
    func browser(browser: MyNearbyServiceBrowser, lostPeer peerID: MyPeerID) {
        print(__FUNCTION__, peerID)
    }
}

extension CommunicationService: MySessionDelegate {
    func session(session: MySession, didReceiveData data: NSData, fromPeer peerID: MyPeerID) {
        print(__FUNCTION__)
        guard let website = Website(data: data) else {
            assertionFailure("Received entity is not a valid website")
            return
        }
        store.dispatch(
            Action(
                type: ActionKind.Add.rawValue,
                payload: [
                    "URL": website.URL,
                    "cookies": website.cookies
                ]
            )
        )
    }
    
    func session(session: MySession, peer peerID: MyPeerID, didChangeState state: MySessionState) {
        print(__FUNCTION__)
    }
    
    func session(session: MySession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MyPeerID) {
        print(__FUNCTION__)
    }
    
    func session(session: MySession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MyPeerID, withProgress progress: NSProgress) {
        print(__FUNCTION__)
    }
    
    func session(session: MySession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MyPeerID, atURL localURL: NSURL, withError error: NSError?) {
        print(__FUNCTION__)
    }
}
