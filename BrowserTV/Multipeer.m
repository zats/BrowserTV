//
//  Multipeer.m
//  BrowserTV
//
//  Created by Sash Zats on 12/22/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

#import "Multipeer.h"
#import <dlfcn.h>


@interface Multipeer : NSObject
@end


@implementation Multipeer

+ (void)load {
    [self _loadFramework];
}

+ (void)_loadFramework {
    NSURL *URL = [NSBundle bundleForClass:[NSArray class]].bundleURL;
    URL = [[URL URLByDeletingLastPathComponent] URLByAppendingPathComponent:@"MultipeerConnectivity.framework/MultipeerConnectivity"];
    __unused void *handler = dlopen(URL.relativePath.UTF8String, RTLD_NOW);
    
}

@end


@implementation MySession
- (instancetype)initWithPeer:(MyPeerID *)myPeerID securityIdentity:(NSArray *)identity encryptionPreference:(MyEncryptionPreference)encryptionPreference {
    return [[NSClassFromString(@"MCSession") alloc] initWithPeer:myPeerID securityIdentity:identity encryptionPreference:encryptionPreference];
}
@end


@implementation MyPeerID

- (instancetype)initWithDisplayName:(NSString *)name {
    return [[NSClassFromString(@"MCPeerID") alloc] initWithDisplayName:name];
}

@end


@implementation MyNearbyServiceBrowser

- (instancetype)initWithPeer:(MyPeerID *)peer serviceType:(NSString *)serviceType {
    return [[NSClassFromString(@"MCNearbyServiceBrowser") alloc] initWithPeer:peer serviceType:serviceType];
}

- (void)invitePeer:(MyPeerID *)peer toSession:(MySession *)session withContext:(NSData *)context timeout:(NSTimeInterval)timeout {
    // no-op
}

- (void)startBrowsingForPeers {
    // no-op
}

- (void)stopBrowsingForPeers {
    // no-op
}

@end
