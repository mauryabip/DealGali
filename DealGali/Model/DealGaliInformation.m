//
//  DealGaliInformation.m
//  DealGali
//
//  Created by Virinchi Software on 12/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "DealGaliInformation.h"
#import "Reachability.h"

@implementation DealGaliInformation
@synthesize arr;
+ (DealGaliInformation *)sharedInstance {
    static DealGaliInformation *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[DealGaliInformation alloc] init];
    });
    return __instance;
}

-(void)allocInit
{
    arr=[[NSMutableDictionary alloc]init];
}
//-(void)deallocInit
//{
//    arr=[[NSMutableDictionary alloc]init];
//}
-(id)Storyboard :(NSString*)ControllerId
{
    UIViewController *vv=  [[UIStoryboard storyboardWithName:STORYBOARD bundle:nil] instantiateViewControllerWithIdentifier:ControllerId];
    return vv;
}
-(void)showAlertWithMessage:(NSString *)message withTitle:(NSString *)title withCancelTitle:(NSString *)cancelTitle {
    
    self.alertview = nil;
    
    if (!self.alertview) {
        
        self.alertview = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:nil, nil];
        
        [self.alertview show];
    }
}

- (MBProgressHUD *)ShowWaiting:(NSString *)title {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelText = title;
    return hud;
}
- (void)HideWaiting {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD hideHUDForView:window animated:YES];
}

-(BOOL)networkReachability{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
       // NSLog(@"There IS NO internet connection");
    } else {
        return YES;
        //NSLog(@"There IS internet connection");
    }

}


@end
