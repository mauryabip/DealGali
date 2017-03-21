//
//  CallBackViewController.h
//  DealGali
//
//  Created by Virinchi Software on 21/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "JFMinimalNotification.h"

@interface CallBackViewController : UIViewController<JFMinimalNotificationDelegate,UITextViewDelegate>{
    UITextView* activeField;
    UIToolbar *_keyboardToolbar;
    UIBarButtonItem *_previous, *_next, *_done;
    UIView *_inputAccView;
    BOOL   keyboardVisible;
    CGSize keyboardSize;
}
@property (nonatomic, strong) JFMinimalNotification* minimalNotification;

@property (nonatomic, strong) NSString *CustomId;
@property (nonatomic, strong) NSString *currentPageURL;
@property (nonatomic, strong) NSString *companyPage;
@property (nonatomic, strong) NSString *DealCompanyLogo;
@property (nonatomic, strong) NSString *DealTitle;
@property (nonatomic, weak) IBOutlet UIImageView *loginOverlay;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextView *writeTXT;
- (IBAction)submitBtnAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *reQuestLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVwHT;

@end
