//
//  MSMEDescVC.h
//  DealGali
//
//  Created by Virinchi Software on 03/09/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AAShareBubbles.h"


@interface MSMEDescVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,AAShareBubblesDelegate>{
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

@property (nonatomic, strong) NSString *totalViews;
@property (nonatomic, strong) NSString *dealCustomId;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *shareBTN;

@property (weak, nonatomic) IBOutlet UIView *upperView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)mapAction:(id)sender;
- (IBAction)callNowAction:(id)sender;
- (IBAction)likeAction:(id)sender;
- (IBAction)shareAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *likeLbl;
@property (weak, nonatomic) IBOutlet UILabel *viewLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *catLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *catNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *addedONLbl;
@property (weak, nonatomic) IBOutlet UILabel *addedByLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *SimilarLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upperviewHt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareTop;
@property (weak, nonatomic) IBOutlet UILabel *editedByLbl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descLblHt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editLblHTConst;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descLblTOPConst;


@end
