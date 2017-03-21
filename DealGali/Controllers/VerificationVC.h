//
//  VerificationVC.h
//  DealGali
//
//  Created by Virinchi Software on 27/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "JFMinimalNotification.h"



@interface VerificationVC : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,JFMinimalNotificationDelegate>{
    NSDictionary *dic;
    UITextField *activeField;
}
@property (weak, nonatomic) IBOutlet UILabel *verifyLbl;
@property (weak, nonatomic) IBOutlet UITextField *verificationTXT;
- (IBAction)reenterAction:(id)sender;
- (IBAction)verifyAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *reenter;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (nonatomic, strong) JFMinimalNotification* minimalNotification;

@end
