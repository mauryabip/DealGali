//
//  SplashVC.h
//  DealGali
//
//  Created by Virinchi Software on 09/06/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"



@class SWRevealViewController;
@interface SplashVC : UIViewController<SWRevealViewControllerDelegate,NSURLConnectionDelegate>{
    NSArray *arrDealList;
    NSURLConnection *connection;
}
@property (strong, nonatomic) SWRevealViewController *viewController;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
