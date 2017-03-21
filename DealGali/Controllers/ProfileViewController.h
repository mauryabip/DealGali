//
//  ProfileViewController.h
//  DealGali
//
//  Created by Virinchi Software on 21/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DealGaliNetworkEngine.h"
#import "DealGaliInformation.h"
#import "JFMinimalNotification.h"
#import "SWRevealViewController.h"
#import "RNGridMenu.h"



@interface ProfileViewController : UIViewController<RNGridMenuDelegate,JFMinimalNotificationDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,SWRevealViewControllerDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>{
    bool newMedia;
    UITextField* activeField;
    NSDictionary *dic;
    BOOL active;
    NSString *emailStr;
    NSString *mobileStr;
    NSString *addressStr;
    NSString *stateStr;
    NSString *cityStr;
    NSString *pinStr;
    NSString *oldValue;
    
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVwHT;
@property (strong, nonatomic) IBOutlet UIView *ViewImgNameHolder;

@property (nonatomic, strong) JFMinimalNotification* minimalNotification;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)selectPhoto:(UIButton *)sender;
- (IBAction)editPassAction:(id)sender;


- (IBAction)saveBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) SWRevealViewController *viewController;

@property (weak, nonatomic) IBOutlet UITextField *emailTXT;
@property (weak, nonatomic) IBOutlet UITextField *phoneTXT;
@property (weak, nonatomic) IBOutlet UITextField *addressTXT;
@property (weak, nonatomic) IBOutlet UITextField *stateTXT;
@property (weak, nonatomic) IBOutlet UITextField *cityTXT;
@property (weak, nonatomic) IBOutlet UITextField *pinTXT;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetPassBtn;

@end
