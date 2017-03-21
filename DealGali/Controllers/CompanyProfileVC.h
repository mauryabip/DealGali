//
//  TestVC.h
//  DealGali
//
//  Created by Virinchi Software on 10/08/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "HMSideMenu.h"
#import "AAShareBubbles.h"



@interface CompanyProfileVC : UIViewController<NSURLConnectionDelegate,AAShareBubblesDelegate>{
    NSDictionary *dic;
    NSDictionary *userdetail;
    NSDictionary *serData;
    NSArray *dealSpecilities;
    NSString *specility;
    NSDictionary *OperatingHours;
    NSDictionary *compProfilePhotosList;
    NSDictionary *companyProfileViedoList;
    NSArray *dealURL;
    NSArray *categoryDic;
    NSArray *catResArray;
    NSInteger count;
    NSString *moreString;
    UIButton *loadMoreBtn;
    UIBarButtonItem *revealButtonItem1;
    UIBarButtonItem *rightButtonItem;
    UIBarButtonItem *revealButtonItem2;
    CGFloat offset_Y;
    int value;
    CGFloat heightCell;
    NSIndexPath *indexpath;
    NSURLConnection *connection;
    AAShareBubbles *shareBubbles;

}
@property (nonatomic, assign) BOOL menuIsVisible;
@property (nonatomic, strong) HMSideMenu *sideMenu;
@property (nonatomic, strong) NSString *CompanyCustomId;
@end
