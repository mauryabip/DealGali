//
//  DealLiistViewController.h
//  DealGali
//
//  Created by Virinchi Software on 21/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>



@interface DealLiistViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SWRevealViewControllerDelegate,UIScrollViewDelegate,NSURLConnectionDelegate>{
    
    NSURLConnection *connection;
    NSArray *imgArray;
    NSArray *imgArray1;
    int indexNo;
    NSMutableArray *dic;
    NSArray *msmeArray;
    NSMutableArray *allDEalByIndexArr;
    int indexCount;
    NSArray *categoryDic;
    NSArray *catResArray;
    NSString *searchStr;
    NSUInteger _dataCount;
    NSMutableArray* arrCatName;
    NSArray *uniqueStates;
    BOOL avail;
    NSString *dealCustomId;
    NSString *clickCustomDealId;
    UIBarButtonItem *revealButtonItem;
    
    
}
@property (weak, nonatomic) IBOutlet UIButton *allDealBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collWt;
@property (strong, nonatomic) SWRevealViewController *viewController;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *ControllerName;
@property (nonatomic, strong) NSString *indextoid;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *alldata;
@property (nonatomic, strong) NSString *value;

@property  int index;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collLeadingConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollLeadingConsr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollWt;

- (IBAction)addMSMEAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allBtnWT;
@property (weak, nonatomic) IBOutlet UIButton *msmeDealBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msmeLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msmeDealWT;

@end
