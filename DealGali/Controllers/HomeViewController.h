//
//  HomeViewController.h
//  DealGali
//
//  Created by Virinchi Software on 18/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "TestCollCell.h"


@interface HomeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,NSURLConnectionDelegate,UIAlertViewDelegate>{
    NSMutableArray      *sectionTitleArray;
    NSMutableDictionary *sectionContentDict;
    NSMutableArray      *arrayForBool;
    int start;
    int start1;
    NSIndexPath *myIP;
    NSArray *dic;
    NSDictionary *dic1;
    NSDictionary *imgdic;
    NSDictionary *test;
    NSArray *catresArr;
    NSDictionary *response1;
    NSArray *categoryDic;
    NSMutableArray *catwiseDetails;
    NSMutableDictionary *storeDic;
    NSTimer *timer;
    NSURLConnection *connection;
    
}
@property (strong, nonatomic) UIAlertView *alertView;


@property (weak, nonatomic) IBOutlet UICollectionView *TestimonialCollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upperViewHt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomViewTop;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollHt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allCatTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHt;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) NSDictionary *responceData;
@property (strong, nonatomic) NSString *name;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *viewAllBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *catCollHeight;
- (IBAction)viewAllDealAction:(id)sender;

- (IBAction)viewAllAction:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *CategoryCollView;
@property (weak, nonatomic) IBOutlet UICollectionView *imgScrollCollView;
@property (weak, nonatomic) IBOutlet UIImageView *lastImgView;
@property (weak, nonatomic) IBOutlet UILabel *testCountLbl;

@property (weak, nonatomic) IBOutlet UILabel *fastestLocalLbl;
@property (weak, nonatomic) IBOutlet UILabel *catLBL;
- (IBAction)addMSMEAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *dragableView;

@end

