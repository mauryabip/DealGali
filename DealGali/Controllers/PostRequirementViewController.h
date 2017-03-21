//
//  PostRequirementViewController.h
//  DealGali
//
//  Created by Virinchi Software on 21/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "JFMinimalNotification.h"

@interface PostRequirementViewController : UIViewController<JFMinimalNotificationDelegate,UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,SWRevealViewControllerDelegate,UIGestureRecognizerDelegate>{
    UITextField* activeField;
     BOOL active;
}
@property (nonatomic, strong) JFMinimalNotification* minimalNotification;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) SWRevealViewController *viewController;

@property (weak, nonatomic) IBOutlet UITextView *writeRequirementTxt;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *profileImgView;
@property (weak, nonatomic) IBOutlet UITextField *nameTXT;
@property (weak, nonatomic) IBOutlet UITextField *mobileNoTXT;
@property (weak, nonatomic) IBOutlet UITextField *emailIDTXT;
- (IBAction)saveBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;
@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVwHT;

@end
