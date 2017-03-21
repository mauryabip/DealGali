//
//  DealDescriptionViewController.h
//  DealGali
//
//  Created by Virinchi Software on 21/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "HMSideMenu.h"
#import "AAShareBubbles.h"



@interface DealDescriptionViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,UIDocumentInteractionControllerDelegate,UIGestureRecognizerDelegate,NSURLConnectionDelegate,AAShareBubblesDelegate>{
    NSURLConnection *connection;
    int start;
    NSIndexPath *myIP;
    NSDictionary *dic;
    NSDictionary *dic1;
    NSDictionary *DealImages;
    NSArray *UserDetails;
    NSArray *dealSpecilities;
    NSArray *tableDic;
    NSString *specility;
    NSArray *categoryDic;
    NSArray *catResArray;
    NSTimer *timer;
    int indexRow;
    bool showHide;
    UIBarButtonItem *rightSearchButtonItem;
    NSInteger dealSpecilitiescount;
    int value;
    AAShareBubbles *shareBubbles;
    CGFloat offset_Y;
    
}


@property (nonatomic, assign) BOOL menuIsVisible;
@property (nonatomic, strong) HMSideMenu *sideMenu;

@property(nonatomic,retain) UIDocumentInteractionController *documentationInteractionController;
@property (nonatomic, strong) NSString *totalViews;
@property (nonatomic, strong) NSString *dealCustomId;
@property (nonatomic, strong) NSString *screenName;

@property int indexCat;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collWt;

@property (weak, nonatomic) IBOutlet UICollectionView *imgScrollCollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *categoryCollView;

@property (weak, nonatomic) IBOutlet UIButton *companyProfileBtn;

- (IBAction)companyProfileBtnAction:(id)sender;
- (IBAction)callBtnAction:(id)sender;
- (IBAction)shareBtnAction:(id)sender;
- (IBAction)appointmentBtnAction:(id)sender;
- (IBAction)mapBtnAction:(id)sender;
- (IBAction)addSellerAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *likeLbl;
@property (weak, nonatomic) IBOutlet UILabel *viewLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *upperView;
@property (weak, nonatomic) IBOutlet UIView *buttomView;
@property (weak, nonatomic) IBOutlet UIImageView *companyLogoImgView;
@property (weak, nonatomic) IBOutlet UILabel *dealTitle;
@property (weak, nonatomic) IBOutlet UILabel *DealDecLbl;
@property (weak, nonatomic) IBOutlet UILabel *SpecilityLbl;
@property (weak, nonatomic) IBOutlet UILabel *specilityDetailsLbl;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewButtom;
@property (weak, nonatomic) IBOutlet UILabel *faltOffLbl;
@property (weak, nonatomic) IBOutlet UILabel *SimilarLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specilityDecHt;
@property (weak, nonatomic) IBOutlet UIButton *allDealButton;

//nslayout outlet
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upperviewHt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomViewHt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collViewHt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collviewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dealDecHt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specaliyiLblTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperatorLblButtom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dealdecTOP;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dealtitleht;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specilitylblht;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVwHT;
@property(nonatomic,copy)void(^dealDescription)(NSString *, int,NSString *);

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specilitydetailtop;
@property (weak, nonatomic) IBOutlet UIButton *bookAppointmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *askForCallBtn;
@property (weak, nonatomic) IBOutlet UIButton *facebookBtn;
@property (weak, nonatomic) IBOutlet UIButton *twitterBtn;
@property (weak, nonatomic) IBOutlet UIButton *whatsappBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBTN;


@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
- (IBAction)likeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblCaptionSide;
@property (weak, nonatomic) IBOutlet UIButton *addMSMEBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addMSMEWT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allDealWT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addMSMELeading;

@end
