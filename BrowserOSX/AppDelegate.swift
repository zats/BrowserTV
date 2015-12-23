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
        
        let payload = [
            "URL": URL.absoluteString
//            "cookies": storage.cookies?.flatMap{ $0.properties } ?? []
        ]
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(payload, options: [])
        connectedSessoins.forEach{ session in
            do {
                try session.sendData(jsonData, toPeers: session.connectedPeers, withMode: .Reliable)
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
        connectedSessoins.insert(session)
        invitationHandler(true, session)
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
        
    }
    
}

extension WindowController: DTBonjourServerDelegate {
    func bonjourServer(server: DTBonjourServer!, didAcceptConnection connection: DTBonjourDataConnection!) {
        print("Server \(server) did accept connection \(connection)")
    }
    
    func bonjourServer(server: DTBonjourServer!, didReceiveObject object: AnyObject!, onConnection connection: DTBonjourDataConnection!) {
        print("Server \(server) did receive object \(object) on connection \(connection)")
    }
}


class ViewController: NSViewController {
    
    @IBOutlet weak var webView: WebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension NSHTTPCookieStorage {
    func deleteAllCookies() {
        if let cookies = cookies {
            for cookie in cookies {
                deleteCookie(cookie)
            }
        }

    }
}
