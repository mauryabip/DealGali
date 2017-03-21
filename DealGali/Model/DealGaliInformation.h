//
//  DealGaliInformation.h
//  DealGali
//
//  Created by Virinchi Software on 12/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface DealGaliInformation : NSObject
@property(strong,nonatomic)NSMutableDictionary *arr;
-(void)allocInit;


@property (nonatomic, strong) UIAlertView *alertview;
@property (nonatomic, strong) NSString *clickedDealForLike;
@property (nonatomic, strong) NSString *clickedDealForDisLike;
@property (nonatomic, strong) NSString *clickedDealForViews;
@property (nonatomic, strong) NSString *imageProfilePage;
@property BOOL latLongStatus;




@property MBProgressHUD *HUD;


-(BOOL)networkReachability;
-(void)showAlertWithMessage:(NSString *)message withTitle:(NSString *)title withCancelTitle:(NSString *)cancelTitle;
- (MBProgressHUD *)ShowWaiting:(NSString *)title;
- (void)HideWaiting;
-(id)Storyboard :(NSString*)ControllerId;
+ (DealGaliInformation *)sharedInstance;
@end
