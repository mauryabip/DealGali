//
//  CreateAndSuggestMSMEVC.h
//  DealGali
//
//  Created by Virinchi Software on 08/09/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "RNGridMenu.h"
#import "JFMinimalNotification.h"


@interface CreateAndSuggestMSMEVC : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,RNGridMenuDelegate,JFMinimalNotificationDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>{
    NSString *imgName;
    NSString *path;
    NSString *WhoCanSee;
    BOOL   keyboardVisible;
    CGSize keyboardSize;
    BOOL active;
    NSArray *catresArr;
    NSArray *categoryDic;
}

@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@property (strong, nonatomic) NSDictionary *responceData;


@property (strong, nonatomic) IBOutlet UIView *ViewImgNameHolder;
@property (nonatomic, strong) JFMinimalNotification* minimalNotification;
@property (weak, nonatomic) IBOutlet UILabel *uploadImgLbl;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImgView;


@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *categoryID;
@property (nonatomic, strong) NSString *DealId;



@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *createNewORSuggestBtn;
- (IBAction)createNewAction:(id)sender;
- (IBAction)editImageAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTXT;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (weak, nonatomic) IBOutlet UITextField *mobileTXT;
- (IBAction)selectionPublicAction:(id)sender;
- (IBAction)selectionPrivateAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *publicBtn;
@property (weak, nonatomic) IBOutlet UIButton *privateBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnBottomLayout;

@end
