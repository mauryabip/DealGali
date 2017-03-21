//
//  InternetRefreshVC.h
//  DealGali
//
//  Created by Virinchi Software on 16/09/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface InternetRefreshVC : UIViewController<NSURLConnectionDelegate,UIAlertViewDelegate>{
    NSURLConnection *connection;
    NSMutableData *responseData;
}

@property (strong, nonatomic) UIAlertView *alertView;

- (IBAction)refreshAction:(id)sender;
@end
