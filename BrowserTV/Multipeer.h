//
//  Multipeer.h
//  BrowserTV
//
//  Created by Sash Zats on 12/22/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSInteger, MyEncryptionPreference) {
    MyEncryptionOptional = 0,                   // session preferred encryption but will accept unencrypted connections
    MyEncryptionRequired = 1,                   // session requires encryption
    MyEncryptionNone = 2,                       // session should not be encrypted
};

typedef NS_ENUM (NSInteger, MySessionState) {
    MySessionStateNotConnected,     // not in the session
    MySessionStateConnecting,       // connecting to this peer
    MySessionStateConnected         // connected to the session
};


@class MyPeerID;
@class MySession;


@protocol MySessionDelegate <NSObject>

- (void)session:(MySession *)session peer:(MyPeerID *)peerID didChangeState:(MySessionState)state;

- (void)session:(MySession *)session didReceiveData:(NSData *)data fromPeer:(MyPeerID *)peerID;

- (void)    session:(MySession *)session
   didReceiveStream:(NSInputStream *)stream
           withName:(NSString *)streamName
           fromPeer:(MyPeerID *)peerID;

- (void)                    session:(MySession *)session
  didStartReceivingResourceWithName:(NSString *)resourceName
                           fromPeer:(MyPeerID *)peerID
                       withProgress:(NSProgress *)progress;

@optional
- (void)session:(MySession *)session
didFinishReceivingResourceWithName:(NSString *)resourceName
       fromPeer:(MyPeerID *)peerID
          atURL:(NSURL *)localURL
      withError:(nullable NSError *)error;


@end

@interface MySession : NSObject
- (instancetype _Nonnull)initWithPeer:(MyPeerID * _Nonnull)myPeerID securityIdentity:(NSArray * _Nullable)identity encryptionPreference:(MyEncryptionPreference)encryptionPreference;
@property (nonatomic, weak) id<MySessionDelegate> delegate;
@end


@interface MyPeerID : NSObject
- (instancetype)initWithDisplayName:(NSString *_Nonnull)name;
@end


@class MyNearbyServiceBrowser;
@protocol MyNearbyServiceBrowserDelegate <NSObject>
- (void)browser:(MyNearbyServiceBrowser * _Nonnull)browser didNotStartBrowsingForPeers:(NSError * _Nonnull)error;
- (void)browser:(MyNearbyServiceBrowser * _Nonnull)browser foundPeer:(MyPeerID * _Nonnull)peerID withDiscoveryInfo:(NSDictionary<NSString *,NSString *> * _Nullable)info;
- (void)browser:(MyNearbyServiceBrowser * _Nonnull)browser lostPeer:(MyPeerID * _Nonnull)peerID;
@end


@interface MyNearbyServiceBrowser: NSObject
@property (nonatomic, weak) id<MyNearbyServiceBrowserDelegate> delegate;
- (instancetype _Nonnull)initWithPeer:(MyPeerID * _Nonnull)peer serviceType:(NSString *_Nonnull)serviceType;
- (void)invitePeer:(MyPeerID * _Nonnull)peer toSession:(MySession * _Nonnull)session withContext:(NSData * _Nullable)context timeout:(NSTimeInterval)timeout;
- (void)startBrowsingForPeers;
- (void)stopBrowsingForPeers;
@end


@class MyNearbyServiceAdvertiser;
@protocol MyNearbyServiceAdvertiserDelegate <NSObject>
- (void)advertiser:(MyNearbyServiceAdvertiser * _Nonnull)advertiser didNotStartAdvertisingPeer:(NSError * _Nonnull)error;
- (void)advertiser:(MyNearbyServiceAdvertiser * _Nonnull)advertiser didReceiveInvitationFromPeer:(MyPeerID * _Nonnull)peerID withContext:(NSData * _Nullable)context invitationHandler:(void (^ _Nonnull)(BOOL accept, MySession * _Nonnull session))invitationHandler;
@end


@interface MyNearbyServiceAdvertiser : NSObject
@property (nonatomic, weak) id<MyNearbyServiceAdvertiserDelegate> delegate;
- (instancetype _Nonnull)initWithPeer:(MyPeerID * _Nonnull)myPeerID discoveryInfo:(NSDictionary<NSString *,NSString *> * _Nullable)info serviceType:(NSString * _Nonnull)serviceType;
- (void)startAdvertisingPeer;
- (void)stopAdvertisingPeer;
@end



NS_ASSUME_NONNULL_END
