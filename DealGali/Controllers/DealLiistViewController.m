//
//  DealLiistViewController.m
//  DealGali
//
//  Created by Virinchi Software on 21/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "DealLiistViewController.h"
#import "DealGaliNetworkEngine.h"
#import "SVPullToRefresh.h"
#import "AudioController.h"
#import "MSMEDealListTVCell.h"


@interface DealLiistViewController ()

@property (strong, nonatomic) AudioController *audioController;
@property (nonatomic, assign) IBInspectable BOOL disableExtensionView;
@property (nonatomic, assign) IBInspectable BOOL stickyNavigationBar;
@property (nonatomic, assign) IBInspectable BOOL stickyExtensionView;
@property (nonatomic, assign) IBInspectable NSInteger fadeBehavior;

@end

@implementation DealLiistViewController
@synthesize index;


#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getSearchData];
    self.title = NSLocalizedString(@"MyGali", nil);
    
    clickCustomDealId=@"";
    [DealGaliInformation sharedInstance].clickedDealForViews=@"";
    self.audioController = [[AudioController alloc] init];
    
    indexCount=1;
    allDEalByIndexArr = [[NSMutableArray alloc]init];
    __weak DealLiistViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf getdealbyindex];
    } position:SVPullToRefreshPositionBottom];
    
    
    searchStr=@"";
    indexNo=index;
    
    avail= [[DealGaliInformation sharedInstance] networkReachability];
    if (avail) {
        if ([_ControllerName isEqualToString:@"all"]) {
            
            //dic=self.data;
            [dic removeAllObjects];
            categoryDic=self.alldata;
            [self.collectionView reloadData];
            [self getdealbyindex];
            // NSLog(@"cat   %@",categoryDic);
            //  [self.tableView reloadData];
            // [self.tableView triggerPullToRefresh];
        }
        else if([self.ControllerName isEqualToString:@"MSME"]){
            [dic removeAllObjects];
            categoryDic=self.alldata;
            [self.collectionView reloadData];
            [self getMSMEDealData];
        }
        else if([_ControllerName isEqualToString:@"company"]){
            categoryDic=self.data;
            indexNo=index;
            [self getData];
            [self.collectionView reloadData];
            [self.tableView reloadData];
        }
        else{
            categoryDic=self.data;
            dic=[[categoryDic valueForKey:@"DealList"]objectAtIndex:indexNo];
            [self.tableView reloadData];
            [self getData];
        }
        
    }
    else{
        NSData *data = [NSUSERDEFAULTS objectForKey:@"ALLDEALLISTCATEGORY"];
        NSArray *retrievedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [allDEalByIndexArr addObjectsFromArray:retrievedDictionary];
        
        NSData *dataCat = [NSUSERDEFAULTS objectForKey:@"CATEGORIES"];
        categoryDic = [NSKeyedUnarchiver unarchiveObjectWithData:dataCat];
        
        if ([_ControllerName isEqualToString:@"home"]) {
            NSData *dataCatName = [NSUSERDEFAULTS objectForKey:@"CATEGORYNAMEFROMALLDEALLIST"];
            uniqueStates = [NSKeyedUnarchiver unarchiveObjectWithData:dataCatName];
            
            NSData *datacatArr = [NSUSERDEFAULTS objectForKey:@"DEALLISTBYCATEGORY"];
            arrCatName = [NSKeyedUnarchiver unarchiveObjectWithData:datacatArr];
            
            NSString *catName=[[categoryDic valueForKey:@"CategoryName"]objectAtIndex:indexNo];
            NSInteger indexValue = [uniqueStates indexOfObject:catName];
            BOOL isTheObjectThere = [uniqueStates containsObject:catName];
            if (isTheObjectThere) {
                dic=[[arrCatName valueForKey:catName]objectAtIndex:indexValue];
                [self.tableView reloadData];
            }
            else{
                dic=nil;
                [self.tableView reloadData];
            }
            
        }
        
        [self.collectionView reloadData];
        [self.tableView reloadData];
    }
    
    self.allBtnWT.constant=SCREENWIDTH/6.0f;
    self.msmeDealWT.constant=0;
    self.msmeDealWT.constant=SCREENWIDTH/6.0f;
    self.collWt.constant=(SCREENWIDTH/6.0f)*[categoryDic count];
    int len=(self.allBtnWT.constant+self.msmeDealWT.constant+self.collWt.constant)-SCREENWIDTH;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, len);
    self.scrollView.contentInset = contentInsets;
    //  }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    if ([self.value isEqualToString:@"home"]) {
        revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bckArr.png"] style:UIBarButtonItemStylePlain target:self action:@selector(previousecall)];
    }
    else{
        SWRevealViewController *revealController = [self revealViewController];
        [revealController panGestureRecognizer];
        [revealController tapGestureRecognizer];
        revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"]
                                                            style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    }
    
    
    
    UIBarButtonItem * revealButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo.png"]]];
    self.navigationItem.leftBarButtonItems = @[revealButtonItem,revealButtonItem1];
    
    
    UIButton *a1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [a1 setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [a1 addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [a1 setImage:[UIImage imageNamed:@"Search.png"] forState:UIControlStateNormal];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:a1];
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [self.tableView setShowsPullToRefresh:YES];
    
    
    
}
-(void)getSearchData{
    NSString *UniqueUserId = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
    [[DealGaliNetworkEngine sharedInstance] GetSearchListNewAPI:@"" UserId:UniqueUserId withCallback:^(NSDictionary *response) {
        NSArray *arr=[response objectForKey:@"SearchData"];
        [NSUSERDEFAULTS setObject:[NSKeyedArchiver archivedDataWithRootObject:arr] forKey:@"SEARCHDATA"];
        [NSUSERDEFAULTS synchronize];
        
    }];
    
}

-(void)previousecall{
    [[DealGaliInformation sharedInstance]HideWaiting];
    
    //if ([self.value isEqualToString:@"home"]) {
    [self.navigationController popViewControllerAnimated:YES];
    
    //    }else{
    //
    //        [NSTimer scheduledTimerWithTimeInterval:0.0
    //                                         target:self
    //                                       selector:@selector(handleTimer:)
    //                                       userInfo:nil repeats:NO];
    //
    //    }
    
}
- (void)handleTimer:(NSTimer*)theTimer {
    UIViewController *Roottocontroller;
    HomeViewController *homeViewController = [[DealGaliInformation sharedInstance]Storyboard:HOMESTORYBOARDID];
    
    Roottocontroller=homeViewController;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
    [navController setViewControllers: @[Roottocontroller] animated: YES];
    
    [self.revealViewController setFrontViewController:navController];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    self.revealViewController.panGestureRecognizer.enabled=YES;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    
    if ([self.value isEqualToString:@"home"]) {
        self.revealViewController.panGestureRecognizer.enabled=NO;
    }
    
    [self.msmeDealBtn addTarget:self
                         action:@selector(msmeDealAction)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self.allDealBtn addTarget:self
                        action:@selector(myAction)
              forControlEvents:UIControlEventTouchUpInside];
    [[self.allDealBtn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    if ([self.ControllerName isEqualToString:@"all"]) {
        [self.allDealBtn setBackgroundColor:[UIColor DGPinkColor]];
        // [self myAction];
        [self.allDealBtn setBackgroundColor:[UIColor DGPinkColor]];
        indexNo=10;
        [self.collectionView reloadData];
        
    }
    else  if ([self.ControllerName isEqualToString:@"MSME"]) {
        [self.msmeDealBtn setBackgroundColor:[UIColor DGPinkColor]];
        indexNo=10;
        [self.collectionView reloadData];
        
    }
    else{
        [self.allDealBtn setBackgroundColor:[UIColor DGPurpleColor]];
    }
    
    
    
    
    
    [self.tableView reloadData];
}

-(void)getData{
    NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
    NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
    [[DealGaliInformation sharedInstance]ShowWaiting:FETCHINGDEALS];
    [[DealGaliNetworkEngine sharedInstance]getDealListByCategoryIdAPI:lat longitude:lon CategoryId:_indextoid withCallback:^(NSDictionary *response) {
        catResArray=[response objectForKey:@"DealList"];
        NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Priority" ascending:YES comparator:^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        dic = [NSMutableArray arrayWithArray:[catResArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]]];
        
        [self.tableView reloadData];
        [[DealGaliInformation sharedInstance]HideWaiting];
    }];
}
-(void)getAllData{
    NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
    NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
    NSString *UniqueUserId = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
    [[DealGaliNetworkEngine sharedInstance]homeAPI:lat lon:lon UserId:UniqueUserId withCallback:^(NSDictionary *response) {
        dic=[response objectForKey:@"DealList"];
        [self.tableView reloadData];
    }];
}

-(void)searchAction:(UIButton *)sender{
    SearchViewController *searchViewController = [[DealGaliInformation sharedInstance]Storyboard:SEARCHSTORYBOARD];
    [self.navigationController pushViewController:searchViewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectiobViewDelegate methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [categoryDic count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *identifier = @"Category";
    UICollectionViewCell *flickerCell = (UICollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    flickerCell.backgroundColor = [UIColor DGPurpleColor];
    UIImageView *imagView = (UIImageView *)[flickerCell viewWithTag:100];
    UILabel *lbl = (UILabel *)[flickerCell viewWithTag:111];
    lbl.text=[[categoryDic valueForKey:@"CategoryName"]objectAtIndex:indexPath.row];
    if (indexPath.row==indexNo) {
        flickerCell.backgroundColor=[UIColor DGPinkColor];
    }
    //  NSLog(@"%d",indexNo);
    NSString *path=[[categoryDic valueForKey:@"CategoryHoverIcon"]objectAtIndex:indexPath.row];
    [imagView sd_setImageWithURL:[NSURL URLWithString:path]
                placeholderImage:[UIImage imageNamed:@""]];
    imagView.contentMode = UIViewContentModeScaleAspectFit;
    imagView.clipsToBounds = YES;
    
    
    return flickerCell;
}
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat itemht = CGRectGetHeight(self.collectionView.frame);
    return CGSizeMake(SCREENWIDTH/6.0f, itemht);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *categoryCell =
    (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    indexNo=(int)indexPath.row;
    [self.collectionView reloadData];
    [self.allDealBtn setBackgroundColor:[UIColor DGPurpleColor]];
    [self.msmeDealBtn setBackgroundColor:[UIColor DGPurpleColor]];
    //[self.allDealBtn setBackgroundImage:[UIImage imageNamed:@"Cat-all_category.png"] forState:UIControlStateNormal];
    categoryCell.backgroundColor=[UIColor DGPinkColor];
    
    UIImageView *imagView = (UIImageView *)[categoryCell viewWithTag:100];
    NSString *path=[[categoryDic valueForKey:@"CategoryHoverIcon"]objectAtIndex:indexPath.row];
    [imagView sd_setImageWithURL:[NSURL URLWithString:path]
                placeholderImage:[UIImage imageNamed:@""]];
    imagView.contentMode = UIViewContentModeScaleAspectFit;
    imagView.clipsToBounds = YES;
    NSString *catid=   [[categoryDic valueForKey:@"CategoryId"]objectAtIndex:indexPath.row];
    _indextoid=catid;
    _ControllerName=@"alsdfsdfl";
    
    avail= [[DealGaliInformation sharedInstance] networkReachability];
    if (avail) {
        if ([allDEalByIndexArr count]>0) {
            NSString *catName=[[categoryDic valueForKey:@"CategoryName"]objectAtIndex:indexPath.row];
            NSInteger indexValue = [uniqueStates indexOfObject:catName];
            BOOL isTheObjectThere = [uniqueStates containsObject:catName];
            if (isTheObjectThere) {
                dic=[[arrCatName valueForKey:catName]objectAtIndex:indexValue];
            }
            else{
                [self getData];
            }
            
        }
        else{
            [self getData];
        }
    }
    
    else{
        NSData *data = [NSUSERDEFAULTS objectForKey:@"ALLDEALLISTCATEGORY"];
        allDEalByIndexArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        NSData *dataCatName = [NSUSERDEFAULTS objectForKey:@"CATEGORYNAMEFROMALLDEALLIST"];
        uniqueStates = [NSKeyedUnarchiver unarchiveObjectWithData:dataCatName];
        
        NSData *datacatArr = [NSUSERDEFAULTS objectForKey:@"DEALLISTBYCATEGORY"];
        arrCatName = [NSKeyedUnarchiver unarchiveObjectWithData:datacatArr];
        
        NSString *catName=[[categoryDic valueForKey:@"CategoryName"]objectAtIndex:indexPath.row];
        NSInteger indexValue = [uniqueStates indexOfObject:catName];
        BOOL isTheObjectThere = [uniqueStates containsObject:catName];
        if (isTheObjectThere) {
            dic=[[arrCatName valueForKey:catName]objectAtIndex:indexValue];
            [self.tableView reloadData];
        }
        else{
            dic=nil;
            [self.tableView reloadData];
        }
        
    }
    [self.tableView reloadData];
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *categoryCell =
    (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    categoryCell.backgroundColor = [UIColor DGPurpleColor];
    UIImageView *imagView = (UIImageView *)[categoryCell viewWithTag:100];
    
    NSString *path=[[categoryDic valueForKey:@"CategoryHoverIcon"]objectAtIndex:indexPath.row];
    [imagView sd_setImageWithURL:[NSURL URLWithString:path]
                placeholderImage:[UIImage imageNamed:@""]];
    imagView.contentMode = UIViewContentModeScaleAspectFit;
    imagView.clipsToBounds = YES;
    
    
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_ControllerName isEqualToString:@"all"]) {
        return [allDEalByIndexArr count];
    }
    else if ([_ControllerName isEqualToString:@"MSME"]) {
        return [msmeArray count];
    }
    else
        return [dic count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL msmeType;
    if ([_ControllerName isEqualToString:@"all"]) {
        msmeType = [[[allDEalByIndexArr valueForKey:@"IsMSME"]objectAtIndex:indexPath.section] boolValue];
        if (msmeType) {
            return 100;
        }
        else
            return 160;
    }else if ([_ControllerName isEqualToString:@"MSME"]){
        return 100;
        
    }
    else
        return 160;
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"DealGaliList";
    
    DealListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (!cell) {
        cell = [[DealListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    static NSString *simpleTableIdentifier1 = @"MSMEListCell";
    
    MSMEDealListTVCell *msmeCell =[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier1];
    
    if (!msmeCell) {
        msmeCell = [[MSMEDealListTVCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier1];
    }
    
    cell.contentView.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f];
    msmeCell.titleLbl.textColor=[UIColor DGPurpleColor];
    msmeCell.titleLbl.font=[UIFont DGTextFieldFont];
    msmeCell.catNameLbl.textColor=[UIColor DGDarkGrayColor];
    msmeCell.catNameLbl.font=[UIFont DGTextHome11Font];
    msmeCell.logoImgView.layer.cornerRadius = msmeCell.imgVwHT.constant / 2;
    msmeCell.logoImgView.clipsToBounds = YES;
    [[msmeCell.logoImgView layer] setBorderWidth:2.0f];
    [[msmeCell.logoImgView layer] setBorderColor:[UIColor DGPurpleColor].CGColor];
    
    msmeCell.callBtn.tag=indexPath.section;
    [msmeCell.callBtn addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:( UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(10.0, 10.0)];
    //
    //    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //    maskLayer.frame = self.view.bounds;
    //    maskLayer.path  = maskPath.CGPath;
    //    cell.layer.mask = maskLayer;
    cell.dealHeading.textColor=[UIColor DGPurpleColor];
    cell.dealHeading.font=[UIFont DGTextFieldFont];
    cell.dealDescrpt.textColor=[UIColor DGDarkGrayColor];
    cell.dealDescrpt.font=[UIFont DGTextHome11Font];
    cell.dealPrice.textColor=[UIColor DGPinkColor];
    cell.dealPrice.font=[UIFont DGTextFieldFont];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.companyLogoImgView.layer.cornerRadius = cell.imgVwHT.constant / 2;
    cell.companyLogoBtn.layer.cornerRadius = cell.imgVwHT.constant / 2;
    cell.companyLogoBtn.clipsToBounds = YES;
    [[cell.companyLogoBtn layer] setBorderWidth:2.0f];
    [[cell.companyLogoBtn layer] setBorderColor:[UIColor DGPurpleColor].CGColor];
    
    cell.companyLogoBtn.tag = indexPath.section;
    cell.callBtn.tag=indexPath.section;
    cell.appointmentBtn.tag=indexPath.section;
    
    [cell.companyLogoBtn addTarget:self action:@selector(companyLogoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.callBtn addTarget:self action:@selector(callBackBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.appointmentBtn addTarget:self action:@selector(appointmentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([_ControllerName isEqualToString:@"all"]) {
        //IsMSME
        BOOL msmeType = [[[allDEalByIndexArr valueForKey:@"IsMSME"]objectAtIndex:indexPath.section] boolValue];
        if (msmeType) {
            
            msmeCell.catNameLbl.text=[[allDEalByIndexArr valueForKey:@"CategoryName"]objectAtIndex:indexPath.section];
            NSString *path1=[[allDEalByIndexArr valueForKey:@"DealCompanyLogo"]objectAtIndex:indexPath.section];
            if ([path1 isKindOfClass:[NSNull class]]) {
                NSString *path = [NSUSERDEFAULTS stringForKey:@"pathCompanyLogo"];
                [msmeCell.logoImgView sd_setImageWithURL:[NSURL URLWithString:path]
                                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                // msmeCell.logoImgView.image=[UIImage imageNamed:@"NoDealImage"];
            }
            else
                [msmeCell.logoImgView sd_setImageWithURL:[NSURL URLWithString:path1]
                                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            msmeCell.logoImgView.contentMode = UIViewContentModeScaleAspectFill;
            msmeCell.logoImgView.clipsToBounds = YES;
            
            NSString *path=[[allDEalByIndexArr valueForKey:@"DealImage"]objectAtIndex:indexPath.section];
            if ([path isKindOfClass:[NSNull class]]) {
                NSString *path = [NSUSERDEFAULTS stringForKey:@"pathDealImage"];
                [msmeCell.imgView sd_setImageWithURL:[NSURL URLWithString:path]
                                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                //msmeCell.imgView.image=[UIImage imageNamed:@"NoDealImage"];
            }
            else{
                [msmeCell.imgView sd_setImageWithURL:[NSURL URLWithString:path]
                                    placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            }
            msmeCell.imgView.contentMode = UIViewContentModeScaleAspectFill;
            msmeCell.imgView.clipsToBounds = YES;

            msmeCell.titleLbl.text=[[allDEalByIndexArr valueForKey:@"DealTitle"]objectAtIndex:indexPath.section];
            
            
            NSString *str=[[allDEalByIndexArr valueForKey:@"DealDistance"]objectAtIndex:indexPath.section];
            if (![str containsString:@"."]) {
                msmeCell.distanceLbl.text=[NSString stringWithFormat:@"%@%@",str,KM];
            }
            else{
                NSArray *arr = [str componentsSeparatedByString:@"."];
                NSString * newString = [[arr objectAtIndex:1] substringWithRange:NSMakeRange(0, 1)];
                NSString *strSecond = [NSString stringWithFormat:@"%@%@",[arr objectAtIndex:0],KM];
                if ([strSecond isEqualToString:@"0KM"]) {
                    NSString *addstr=[NSString stringWithFormat:@"0.%@%@",newString,KM];
                    msmeCell.distanceLbl.text=addstr;
                }
                else
                    msmeCell.distanceLbl.text=strSecond;
            }
            NSString *totalView=[[allDEalByIndexArr valueForKey:@"DealTotalView"]objectAtIndex:indexPath.section];
            NSString *str2;
            if ([totalView isKindOfClass:[NSNull class]]) {
                str2 = [NSString stringWithFormat:@"0 View"];
            }
            else{
                NSString *matchCustonID=[[allDEalByIndexArr valueForKey:@"DealCustomId"]objectAtIndex:indexPath.section];
                int value = [totalView intValue];
                if ([[DealGaliInformation sharedInstance].clickedDealForViews rangeOfString:matchCustonID].location == NSNotFound) {
                    if (value==0 || value==1) {
                        str2 = [NSString stringWithFormat:@"%@ View",totalView];
                    }
                    else
                        str2 = [NSString stringWithFormat:@"%@ Views",totalView];
                    
                }
                else{
                    if (value==0) {
                        str2 = [NSString stringWithFormat:@"%d View",value+1];
                    }
                    else
                        str2 = [NSString stringWithFormat:@"%d Views",value+1];
                }
            }
            msmeCell.viewLbl.text=str2;
            
            return msmeCell;
        }
        else{
            NSString *path=[[allDEalByIndexArr valueForKey:@"DealImage"]objectAtIndex:indexPath.section];
            if ([path isKindOfClass:[NSNull class]]) {
                NSString *path = [NSUSERDEFAULTS stringForKey:@"pathDealImage"];
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:path]
                                placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                // cell.imgView.image=[UIImage imageNamed:@"NoDealImage"];
            }
            else{
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:path]
                                placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            }
            
            cell.imgView.contentMode = UIViewContentModeScaleAspectFill;
            cell.imgView.clipsToBounds = YES;
            
            NSString *path1=[[allDEalByIndexArr valueForKey:@"DealCompanyLogo"]objectAtIndex:indexPath.section];
            if ([path1 isKindOfClass:[NSNull class]]) {
                NSString *path = [NSUSERDEFAULTS stringForKey:@"pathCompanyLogo"];
                [cell.companyLogoImgView sd_setImageWithURL:[NSURL URLWithString:path]
                                placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                // cell.imgView.image=[UIImage imageNamed:@"NoDealImage"];
            }
            else
                [cell.companyLogoImgView sd_setImageWithURL:[NSURL URLWithString:path1]
                                           placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            cell.companyLogoImgView.contentMode = UIViewContentModeScaleAspectFill;
            cell.companyLogoImgView.clipsToBounds = YES;
            
            cell.dealDescrpt.text=[[allDEalByIndexArr valueForKey:@"DealDescription"]objectAtIndex:indexPath.section];
            cell.dealHeading.text=[[allDEalByIndexArr valueForKey:@"DealTitle"]objectAtIndex:indexPath.section];
            NSString *str=[[allDEalByIndexArr valueForKey:@"DealDistance"]objectAtIndex:indexPath.section];
            if (![str containsString:@"."]) {
                cell.distanceLbl.text=[NSString stringWithFormat:@"%@%@",str,KM];
            }
            else{
                NSArray *arr = [str componentsSeparatedByString:@"."];
                NSString * newString = [[arr objectAtIndex:1] substringWithRange:NSMakeRange(0, 1)];
                NSString *strSecond = [NSString stringWithFormat:@"%@%@",[arr objectAtIndex:0],KM];
                if ([strSecond isEqualToString:@"0KM"]) {
                    NSString *addstr=[NSString stringWithFormat:@"0.%@%@",newString,KM];
                    cell.distanceLbl.text=addstr;
                }
                else
                    cell.distanceLbl.text=strSecond;
            }
            
            NSString *nullll=[[allDEalByIndexArr valueForKey:@"DealPrice"]objectAtIndex:indexPath.section];
            if ([nullll isKindOfClass:[NSNull class]]) {
                cell.dealPrice.text=@"";
            }
            else{
                NSString *str1 = [NSString stringWithFormat:@"Rs. %@",nullll];
                cell.dealPrice.text=str1;
            }
            NSString *totalView=[[allDEalByIndexArr valueForKey:@"DealTotalView"]objectAtIndex:indexPath.section];
            NSString *str2;
            if ([totalView isKindOfClass:[NSNull class]]) {
                str2 = [NSString stringWithFormat:@"0 View"];
            }
            else{
                NSString *matchCustonID=[[allDEalByIndexArr valueForKey:@"DealCustomId"]objectAtIndex:indexPath.section];
                int value = [totalView intValue];
                if ([[DealGaliInformation sharedInstance].clickedDealForViews rangeOfString:matchCustonID].location == NSNotFound) {
                    if (value==0 || value==1) {
                        str2 = [NSString stringWithFormat:@"%@ View",totalView];
                    }
                    else
                        str2 = [NSString stringWithFormat:@"%@ Views",totalView];
                    
                }
                else{
                    if (value==0) {
                        str2 = [NSString stringWithFormat:@"%d View",value+1];
                    }
                    else
                        str2 = [NSString stringWithFormat:@"%d Views",value+1];
                }
            }
            cell.viewsLbl.text=str2;
            
            return cell;
        }
        
    }
    else if ([_ControllerName isEqualToString:@"MSME"]) {
        
        msmeCell.catNameLbl.text=[[msmeArray valueForKey:@"CategoryName"]objectAtIndex:indexPath.section];
        NSString *path1=[[msmeArray valueForKey:@"DealCompanyLogo"]objectAtIndex:indexPath.section];
        if ([path1 isKindOfClass:[NSNull class]]) {
            NSString *path = [NSUSERDEFAULTS stringForKey:@"pathCompanyLogo"];
            [msmeCell.logoImgView sd_setImageWithURL:[NSURL URLWithString:path]
                                    placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            // msmeCell.logoImgView.image=[UIImage imageNamed:@"NoDealImage"];
        }
        else
            [msmeCell.logoImgView sd_setImageWithURL:[NSURL URLWithString:path1]
                                    placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        msmeCell.logoImgView.contentMode = UIViewContentModeScaleAspectFill;
        msmeCell.logoImgView.clipsToBounds = YES;
        
        NSString *path=[[msmeArray valueForKey:@"DealImage"]objectAtIndex:indexPath.section];
        if ([path isKindOfClass:[NSNull class]]) {
            NSString *path = [NSUSERDEFAULTS stringForKey:@"pathDealImage"];
            [msmeCell.imgView sd_setImageWithURL:[NSURL URLWithString:path]
                                placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            //msmeCell.imgView.image=[UIImage imageNamed:@"NoDealImage"];
        }
        else{
            [msmeCell.imgView sd_setImageWithURL:[NSURL URLWithString:path]
                                placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        }
        msmeCell.imgView.contentMode = UIViewContentModeScaleAspectFill;
        msmeCell.imgView.clipsToBounds = YES;
        
        msmeCell.titleLbl.text=[[msmeArray valueForKey:@"DealTitle"]objectAtIndex:indexPath.section];
        
        
        NSString *str=[[msmeArray valueForKey:@"DealDistance"]objectAtIndex:indexPath.section];
        if (![str containsString:@"."]) {
            msmeCell.distanceLbl.text=[NSString stringWithFormat:@"%@%@",str,KM];
        }
        else{
            NSArray *arr = [str componentsSeparatedByString:@"."];
            NSString * newString = [[arr objectAtIndex:1] substringWithRange:NSMakeRange(0, 1)];
            NSString *strSecond = [NSString stringWithFormat:@"%@%@",[arr objectAtIndex:0],KM];
            if ([strSecond isEqualToString:@"0KM"]) {
                NSString *addstr=[NSString stringWithFormat:@"0.%@%@",newString,KM];
                msmeCell.distanceLbl.text=addstr;
            }
            else
                msmeCell.distanceLbl.text=strSecond;
        }
        
        
        NSString *totalView=[[msmeArray valueForKey:@"DealTotalView"]objectAtIndex:indexPath.section];
        NSString *str2;
        if ([totalView isKindOfClass:[NSNull class]]) {
            str2 = [NSString stringWithFormat:@"0 View"];
        }
        else{
            NSString *matchCustonID=[[msmeArray valueForKey:@"DealCustomId"]objectAtIndex:indexPath.section];
            int value = [totalView intValue];
            
            if ([[DealGaliInformation sharedInstance].clickedDealForViews rangeOfString:matchCustonID].location == NSNotFound) {
                if (value==0 || value==1) {
                    str2 = [NSString stringWithFormat:@"%@ View",totalView];
                }
                else
                    str2 = [NSString stringWithFormat:@"%@ Views",totalView];
                
            }
            else{
                if (value==0) {
                    str2 = [NSString stringWithFormat:@"%d View",value+1];
                }
                else
                    str2 = [NSString stringWithFormat:@"%d Views",value+1];
            }
        }
        msmeCell.viewLbl.text=str2;
        
        return msmeCell;
    }
    
    else{
        NSString *path=[[dic valueForKey:@"DealImage"]objectAtIndex:indexPath.section];
        if ([path isKindOfClass:[NSNull class]]) {
            NSString *path = [NSUSERDEFAULTS stringForKey:@"pathDealImage"];
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:path]
                            placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            //cell.imgView.image=[UIImage imageNamed:@"NoDealImage"];
        }
        else
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:path]
                            placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        cell.imgView.contentMode = UIViewContentModeScaleAspectFill;
        cell.imgView.clipsToBounds = YES;
        
        NSString *path1=[[dic valueForKey:@"DealCompanyLogo"]objectAtIndex:indexPath.section];
        if ([path1 isKindOfClass:[NSNull class]]) {
            NSString *path = [NSUSERDEFAULTS stringForKey:@"pathCompanyLogo"];
            [cell.companyLogoImgView sd_setImageWithURL:[NSURL URLWithString:path]
                            placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            //cell.imgView.image=[UIImage imageNamed:@"NoDealImage"];
        }
        else
            [cell.companyLogoImgView sd_setImageWithURL:[NSURL URLWithString:path1]
                                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        cell.companyLogoImgView.contentMode = UIViewContentModeScaleAspectFill;
        cell.companyLogoImgView.clipsToBounds = YES;
        
        cell.dealDescrpt.text=[[dic valueForKey:@"DealDescription"]objectAtIndex:indexPath.section];
        cell.dealHeading.text=[[dic valueForKey:@"DealTitle"]objectAtIndex:indexPath.section];
        NSString *str=[[dic valueForKey:@"DealDistance"]objectAtIndex:indexPath.section];
        if (![str containsString:@"."]) {
            cell.distanceLbl.text=[NSString stringWithFormat:@"%@%@",str,KM];
        }
        else{
            NSArray *arr = [str componentsSeparatedByString:@"."];
            NSString * newString = [[arr objectAtIndex:1] substringWithRange:NSMakeRange(0, 1)];
            NSString *strSecond = [NSString stringWithFormat:@"%@%@",[arr objectAtIndex:0],KM];
            if ([strSecond isEqualToString:@"0KM"]) {
                NSString *addstr=[NSString stringWithFormat:@"0.%@%@",newString,KM];
                cell.distanceLbl.text=addstr;
            }
            else
                cell.distanceLbl.text=strSecond;
        }
        
        NSString *nullll=[[dic valueForKey:@"DealPrice"]objectAtIndex:indexPath.section];
        if ([nullll isKindOfClass:[NSNull class]]) {
            cell.dealPrice.text=@"";
        }
        else{
            NSString *str1 = [NSString stringWithFormat:@"Rs. %@",nullll];
            cell.dealPrice.text=str1;
        }
        NSString *totalView=[[dic valueForKey:@"DealTotalView"]objectAtIndex:indexPath.section];
        NSString *str2;
        if ([totalView isKindOfClass:[NSNull class]]) {
            str2 = [NSString stringWithFormat:@"0 View"];
        }
        else{
            NSString *matchCustonID=[[dic valueForKey:@"DealCustomId"]objectAtIndex:indexPath.section];
            int value = [totalView intValue];
            
            if ([[DealGaliInformation sharedInstance].clickedDealForViews rangeOfString:matchCustonID].location == NSNotFound) {
                if (value==0 || value==1) {
                    str2 = [NSString stringWithFormat:@"%@ View",totalView];
                }
                else
                    str2 = [NSString stringWithFormat:@"%@ Views",totalView];
                
            }
            else{
                if (value==0) {
                    str2 = [NSString stringWithFormat:@"%d View",value+1];
                }
                else
                    str2 = [NSString stringWithFormat:@"%d Views",value+1];
            }
        }
        
        cell.viewsLbl.text=str2;
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDic;
    DealDescriptionViewController *dealDesViewController = [[DealGaliInformation sharedInstance]Storyboard:DEALDESCRIPTIONSTORYBOARD];
    
    if ([_ControllerName isEqualToString:@"all"]) {
        dataDic=[allDEalByIndexArr objectAtIndex:indexPath.section];
        dealCustomId=   [dataDic valueForKey:@"DealCustomId"];
        
        BOOL msmeType = [[[allDEalByIndexArr valueForKey:@"IsMSME"]objectAtIndex:indexPath.section] boolValue];
        if (msmeType) {
            MSMEDescVC *msmeDescVC = [[DealGaliInformation sharedInstance]Storyboard:MSMEDECSTORYBOARD];
            msmeDescVC.dealCustomId=dealCustomId;
            msmeDescVC.totalViews=[dataDic valueForKey:@"DealTotalView"];;
            [self.navigationController pushViewController:msmeDescVC animated:YES];
        }
        else{
            dealDesViewController.dealCustomId=dealCustomId;
            dealDesViewController.indexCat=indexNo;
            dealDesViewController.totalViews=[dataDic valueForKey:@"DealTotalView"];;
            
            [self.navigationController pushViewController:dealDesViewController animated:YES];
            
        }
    }
    else  if ([_ControllerName isEqualToString:@"MSME"]) {
        dataDic=[msmeArray objectAtIndex:indexPath.section];
        dealCustomId=   [dataDic valueForKey:@"DealCustomId"];
        MSMEDescVC *msmeDescVC = [[DealGaliInformation sharedInstance]Storyboard:MSMEDECSTORYBOARD];
        msmeDescVC.dealCustomId=dealCustomId;
        msmeDescVC.totalViews=[dataDic valueForKey:@"DealTotalView"];;
        [self.navigationController pushViewController:msmeDescVC animated:YES];
    }
    else{
        dataDic=[dic objectAtIndex:indexPath.section];
        dealCustomId=   [dataDic valueForKey:@"DealCustomId"];
        dealDesViewController.dealCustomId=dealCustomId;
        dealDesViewController.indexCat=indexNo;
        dealDesViewController.totalViews=[dataDic valueForKey:@"DealTotalView"];;
        
        [self.navigationController pushViewController:dealDesViewController animated:YES];
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    return 20;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView                = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    UIView *headerView1                = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 11)];
    headerView.backgroundColor       =[UIColor whiteColor];
    headerView1.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f];
    
    [headerView addSubview:headerView1];
    return headerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 20;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
- (IBAction)companyLogoBtnAction:(UIButton*)sender {
    //CompanyProfileViewController *companyVC=[[DealGaliInformation sharedInstance]Storyboard:COMPANYPROFILESTORYBOARD];
    // TestVC *companyVC = [[DealGaliInformation sharedInstance]Storyboard:@"TestVC"];
    CompanyProfileVC *companyVC = [[CompanyProfileVC alloc] init];
    NSDictionary *dataDic;
    if ([self.ControllerName isEqualToString:@"all"]) {
        dataDic=[allDEalByIndexArr objectAtIndex:sender.tag];
        
    }
    else
        dataDic=[dic objectAtIndex:sender.tag];
    companyVC.CompanyCustomId=[dataDic valueForKey:@"CompanyCustomId"];
    [self.navigationController pushViewController:companyVC animated:YES];
}
- (IBAction)appointmentBtnAction:(UIButton*)sender {
    AppointmentViewController *appointmentVC=[[DealGaliInformation sharedInstance]Storyboard:APPOINTMENTSTORYBOARD];
    
    if ([self.ControllerName isEqualToString:@"all"]) {
        NSDictionary *dataDic=[allDEalByIndexArr objectAtIndex:sender.tag];
        NSString *DealCustomId=   [dataDic valueForKey:@"DealId"];
        NSString *dealURL=[dataDic valueForKey:@"DealUrl"];
        appointmentVC.CustomId=DealCustomId;
        appointmentVC.currentPageURL=dealURL;
        appointmentVC.companyPage=@"appointmentVC";
        appointmentVC.DealCompanyLogo=[dataDic valueForKey:@"DealCompanyLogo"];
        appointmentVC.DealTitle=[dataDic valueForKey:@"DealTitle"];
    }
    else{
        NSDictionary *dataDic=[dic objectAtIndex:sender.tag];
        NSString *DealCustomId=   [dataDic valueForKey:@"DealId"];
        NSString *dealURL=[dataDic valueForKey:@"DealUrl"];
        appointmentVC.CustomId=DealCustomId;
        appointmentVC.currentPageURL=dealURL;
        appointmentVC.companyPage=@"appointmentVC";
        appointmentVC.DealCompanyLogo=[dataDic valueForKey:@"DealCompanyLogo"];
        appointmentVC.DealTitle=[dataDic valueForKey:@"DealTitle"];
    }
    [self.navigationController pushViewController:appointmentVC animated:YES];
    
}


- (IBAction)callBackBtnAction:(UIButton*)sender {
    CallBackViewController *callVC=[[DealGaliInformation sharedInstance]Storyboard:CALLBACKSTORYBOARD];
    if ([self.ControllerName isEqualToString:@"all"]) {
        NSDictionary *dataDic=[allDEalByIndexArr objectAtIndex:sender.tag];
        NSString *dealCustomId=   [dataDic valueForKey:@"DealId"];
        NSString *dealURL=[dataDic valueForKey:@"DealUrl"];
        callVC.CustomId=dealCustomId;
        callVC.currentPageURL=dealURL;
        callVC.DealCompanyLogo=[dataDic valueForKey:@"DealCompanyLogo"];
        callVC.DealTitle=[dataDic valueForKey:@"DealTitle"];
    }
    else{
        NSDictionary *dataDic=[dic objectAtIndex:sender.tag];
        NSString *dealCustomId=   [dataDic valueForKey:@"DealId"];
        NSString *dealURL=[dataDic valueForKey:@"DealUrl"];
        callVC.CustomId=dealCustomId;
        callVC.currentPageURL=dealURL;
        callVC.DealCompanyLogo=[dataDic valueForKey:@"DealCompanyLogo"];
        callVC.DealTitle=[dataDic valueForKey:@"DealTitle"];
    }
    
    [self.navigationController pushViewController:callVC animated:YES];
}

-(void)callAction:(UIButton*)sender{
    
    NSDictionary *dataDic=[allDEalByIndexArr objectAtIndex:sender.tag];
    NSString *mobileNumber=   [dataDic valueForKey:@"MobileNumber"];
    NSString *tellPh=[NSString stringWithFormat:@"tel:%@",mobileNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tellPh]];
    
}

-(void)myAction{
    _ControllerName=@"all";
    [self.allDealBtn setBackgroundColor:[UIColor DGPinkColor]];
    [self.msmeDealBtn setBackgroundColor:[UIColor DGPurpleColor]];
    
    // [self.allDealBtn setBackgroundImage:[UIImage imageNamed:@"Cat-all_category_pink.png"] forState:UIControlStateNormal];
    indexNo=100;
    [self.collectionView reloadData];
    indexCount=1;
    if ([allDEalByIndexArr count]>0) {
        
        [self.tableView reloadData];
    }
    else
        [self getdealbyindex];
    
}
-(void)msmeDealAction{
    _ControllerName=@"MSME";
    indexNo=101;
    [self.msmeDealBtn setBackgroundColor:[UIColor DGPinkColor]];
    [self.allDealBtn setBackgroundColor:[UIColor DGPurpleColor]];
    [self.collectionView reloadData];
    [self getMSMEDealData];
    
}

-(void)getdealbyindex{
    if ([_ControllerName isEqualToString:@"all"]) {
        if (indexCount>1) {
            //[self.audioController playSystemSound];
        }
    }
    else{
        // [self.audioController playSystemSound];
    }
    
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
    NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
    
    NSString *str=[NSString stringWithFormat:@"%d",indexCount];
    [[DealGaliInformation sharedInstance]ShowWaiting:FETCHINGDEALS];
    [[DealGaliNetworkEngine sharedInstance] GetDealListByPageIndexAPI:lat longitude:lon pageindex:str withCallback:^(NSDictionary *response) {
        NSString *status=[response valueForKey:@"Status"];
        if ([status isEqualToString:@"1"]) {
            
            
            indexCount=indexCount+1;
            NSArray *arrRes=[[NSArray alloc]init];
            arrRes=[response objectForKey:@"DealList"];
            
            [allDEalByIndexArr addObjectsFromArray:arrRes];
            
            //saving data
            [NSUSERDEFAULTS setObject:[NSKeyedArchiver archivedDataWithRootObject:allDEalByIndexArr] forKey:@"ALLDEALLISTCATEGORY"];
            [NSUSERDEFAULTS synchronize];
            
            arrCatName=[[NSMutableArray alloc]init];
            uniqueStates = [allDEalByIndexArr valueForKeyPath:@"@distinctUnionOfObjects.CategoryName"];
            // NSLog(@"%@",uniqueStates);
            for (NSString *restrict1 in uniqueStates) {
                NSMutableArray *arr2;
                arr2=[[NSMutableArray alloc]init];
                for (int i=0; i<[allDEalByIndexArr count]; i++) {
                    NSDictionary *delobh=[allDEalByIndexArr objectAtIndex:i];
                    if ([[delobh objectForKey:@"CategoryName"] isEqualToString:restrict1]) {
                        [arr2 addObject:delobh];
                    }
                }
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                [dict  setObject:arr2 forKey:restrict1];
                [arrCatName addObject:dict];
                
                //saving data
                [NSUSERDEFAULTS setObject:[NSKeyedArchiver archivedDataWithRootObject:arrCatName] forKey:@"DEALLISTBYCATEGORY"];
                [NSUSERDEFAULTS setObject:[NSKeyedArchiver archivedDataWithRootObject:uniqueStates] forKey:@"CATEGORYNAMEFROMALLDEALLIST"];
                [NSUSERDEFAULTS synchronize];
                
            }
            //  NSLog(@"%@",arrCatName);
            [[DealGaliInformation sharedInstance]HideWaiting];
            [self.tableView reloadData];
            // [self.tableView triggerPullToRefresh];
        }
        else{
            
            if ([status isEqualToString:@"7"]) {
                [[DealGaliInformation sharedInstance]HideWaiting];
                [self.tableView setShowsPullToRefresh:NO];
            }
        }
    }];
    [self.tableView.pullToRefreshView stopAnimating];
    
}


- (IBAction)addMSMEAction:(id)sender {
    SearchAndAddMSME *addMSMEVC = [[SearchAndAddMSME alloc] init];
    [self.navigationController pushViewController:addMSMEVC animated:YES];
    
}

-(void)getMSMEDealData{
    NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
    NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
    [[DealGaliInformation sharedInstance]ShowWaiting:FETCHINGDEALS];
    
    [[DealGaliNetworkEngine sharedInstance]GetMSMEDealListAPI:lat longitude:lon withCallback:^(NSDictionary *response) {
        msmeArray=[response objectForKey:@"DealList"];
        [[DealGaliInformation sharedInstance]HideWaiting];
        
        [self.tableView reloadData];
        
    }];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [[DealGaliInformation sharedInstance]HideWaiting];
    
    InternetRefreshVC *internetVC=[[DealGaliInformation sharedInstance]Storyboard:INTERNETREFRESHSTORYBOARD];
    [self.navigationController pushViewController:internetVC animated:YES];
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
}
@end
