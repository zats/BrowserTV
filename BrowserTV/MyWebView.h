//
//  UIWebView.h
//  BrowserTV
//
//  Created by Sash Zats on 12/18/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

@import UIKit;

@interface MyWebView : UIView
@property (nonatomic, copy) NSString *customUserAgent;
- (instancetype)initWithFrame:(CGRect)frame configuration:(id)configuration;
- (void)loadRequest:(NSURLRequest *)request;
@end