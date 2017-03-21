//
//  ForgotPasswordVC.h
//  DealGali
//
//  Created by Virinchi Software on 27/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DealGaliNetworkEngine.h"
#import "DealGaliInformation.h"
#import "JFMinimalNotification.h"


@interface ForgotPasswordVC : UIViewController<UITextFieldDelegate,JFMinimalNotificationDelegate>{
    NSDictionary *dic;
    UITextField *activeField;
}
@property (nonatomic, strong) JFMinimalNotification* minimalNotification;

@property (weak, nonatomic) IBOutlet UITextField *phoneXT;
- (IBAction)cancelAction:(id)sender;
- (IBAction)resetAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end
