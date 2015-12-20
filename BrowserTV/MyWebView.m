//
//  UIWebView.m
//  BrowserTV
//
//  Created by Sash Zats on 12/18/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

#import "MyWebView.h"
#import <dlfcn.h>

@implementation MyWebView
+ (void)load {
    [self _registerUserAgent];
}
+ (void)_registerUserAgent {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:@{
        @"UserAgent": @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/601.4.2 (KHTML, like Gecko) Version/9.0.3 Safari/601.4.2"
    }];
}
+ (instancetype)instance {
    return [[NSClassFromString(@"UIWebView") alloc] initWithFrame:CGRectZero];
}
- (void)loadRequest:(NSURLRequest *)request {
    // no-op
}
@end
