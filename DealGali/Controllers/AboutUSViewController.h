//
//  AboutUSViewController.h
//  DealGali
//
//  Created by Virinchi Software on 21/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NJKWebViewProgress.h"

@interface AboutUSViewController : UIViewController<UIWebViewDelegate,NJKWebViewProgressDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
