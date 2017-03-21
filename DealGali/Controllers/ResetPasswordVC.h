//
//  ResetPasswordVC.h
//  DealGali
//
//  Created by Virinchi Software on 21/07/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "JFMinimalNotification.h"



@interface ResetPasswordVC : UIViewController<JFMinimalNotificationDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    NSDictionary *dic;
    UITextField *activeField;
    BOOL active;

    
}
@property (nonatomic, strong) JFMinimalNotification* minimalNotification;

@property (weak, nonatomic) IBOutlet UITextField *currentPassTXT;
@property (weak, nonatomic) IBOutlet UITextField *neWPassTXT;
@property (weak, nonatomic) IBOutlet UITextField *retypePassTXT;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImgView;

- (IBAction)updateAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *updatePassBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVwHT;

@end
