//
//  SavePasswordVC.h
//  DealGali
//
//  Created by Virinchi Software on 27/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "JFMinimalNotification.h"


@interface SavePasswordVC : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,JFMinimalNotificationDelegate>
{
    NSDictionary *dic;
    UITextField *activeField;
    NSDictionary *dic1;
}
@property (nonatomic, strong) JFMinimalNotification* minimalNotification;

@property (weak, nonatomic) IBOutlet UITextField *neWPassTXT;
@property (weak, nonatomic) IBOutlet UITextField *retypePassTXT;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

- (IBAction)updateAction:(id)sender;
@end
