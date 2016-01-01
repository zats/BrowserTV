//
//  AppDelegate.swift
//  BrowserOSX
//
//  Created by Sash Zats on 12/19/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Cocoa
import WebKit
import MultipeerConnectivity

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
}


class WindowController: NSWindowController {
    
    private var storage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    private var advertiser: MCNearbyServiceAdvertiser!
    private var connectedSessoins: Set<MCSession> = []
    
    @IBOutlet weak var textField: NSTextField!
    
    private var URL: NSURL!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        window?.titleVisibility = .Hidden
        
        let peer = MCPeerID(displayName: NSHost.currentHost().localizedName ?? NSUUID().UUIDString)
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: "browser-tv")

        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
    }
    
    @IBAction func _sendButtonAction(sender: AnyObject) {
        guard URL != nil else {
            return
        }
        
        let website = Website(URL: URL, cookies: storage.cookies ?? [])
        let data = website.data
        connectedSessoins
            .filter{
                !$0.connectedPeers.isEmpty
            }
            .forEach{ session in
                do {
                    try session.sendData(data, toPeers: session.connectedPeers, withMode: .Reliable)
                } catch {
                    assertionFailure()
                }
            }
    }
    
    @IBAction func textFieldAction(sender: AnyObject) {
        storage.deleteAllCookies()

        let controller = window?.contentViewController as! ViewController
        let URLString = textField.stringValue.hasPrefix("http") || textField.stringValue.hasPrefix("https") ? textField.stringValue : "https://\(textField.stringValue)"
        textField.stringValue = URLString
        let URL = NSURL(string: URLString)!
        self.URL = URL
        
        let request = NSURLRequest(URL: URL)
        controller.webView.mainFrame.loadRequest(request)
    }
}

extension WindowController: MCNearbyServiceAdvertiserDelegate {
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {
        let peerId = advertiser.myPeerID
        let session = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .None)
        session.delegate = self
        connectedSessoins.insert(session)
        invitationHandler(true, session)
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
        
    }
}

extension WindowController: MCSessionDelegate {
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        switch state {
        case .NotConnected:
            connectedSessoins.remove(session)
        case .Connected:
            break
        case .Connecting:
            break
        }
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        // no-op
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // no-op
    }

    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        // no-op
    }
    

    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        // no-op
    }
    
}


class ViewController: NSViewController {
    
    @IBOutlet weak var webView: WebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

private extension NSHTTPCookieStorage {
    func deleteAllCookies() {
        if let cookies = cookies {
            for cookie in cookies {
                deleteCookie(cookie)
            }
        }

    }
}
