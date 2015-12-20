//
//  UIWebView.m
//  BrowserTV
//
//  Created by Sash Zats on 12/18/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

#import "MyWebView.h"
#import <dlfcn.h>

@interface Configuration : NSObject
@end

@implementation Configuration
- (instancetype)init {
    self = [[NSClassFromString(@"WKWebViewConfiguration") alloc] init];
    return self;
}
@end

@implementation MyWebView
+ (void)load {
    NSURL *uiKitURL = [NSBundle bundleForClass:[UIView class]].bundleURL;
    NSURL *webKitURL = [[uiKitURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:@"WebKit.framework/WebKit"];
    dlopen(webKitURL.relativePath.UTF8String, RTLD_NOW);
}
- (instancetype)initWithFrame:(CGRect)frame configuration:(id)configuration {
    self = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:frame configuration:configuration ?: [[Configuration alloc] init]];
    return self;
}
- (void)loadRequest:(NSURLRequest *)request {
    // no-op
}
@end
