//
//  DealDescriptionViewController.m
//  DealGali
//
//  Created by Virinchi Software on 21/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "DealDescriptionViewController.h"
#import "DealGaliNetworkEngine.h"

@interface DealDescriptionViewController ()

@end

@implementation DealDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.faltOffLbl.textColor=[UIColor DGPinkColor];
    self.faltOffLbl.font=[UIFont DGTextFieldFont];
    self.dealTitle.textColor=[UIColor DGPurpleColor];
    self.dealTitle.font=[UIFont DGTextFieldFont];
    self.SpecilityLbl.textColor=[UIColor DGPurpleColor];
    self.SpecilityLbl.font=[UIFont DGTextFieldFont];
    self.DealDecLbl.textColor=[UIColor DGDarkGrayColor];
    self.DealDecLbl.font=[UIFont DGTextHome11Font];
    self.specilityDetailsLbl.textColor=[UIColor DGDarkGrayColor];
    self.specilityDetailsLbl.font=[UIFont DGTextHome11Font];
    self.bookAppointmentBtn.backgroundColor=[UIColor DGPurpleColor];
    self.bookAppointmentBtn.titleLabel.textColor=[UIColor DGWhiteColor];
    self.askForCallBtn.backgroundColor=[UIColor DGPinkColor];
    self.askForCallBtn.titleLabel.textColor=[UIColor DGWhiteColor];
    
    self.SimilarLbl.textColor=[UIColor DGPurpleColor];
    self.SimilarLbl.font=[UIFont DGActionButtonFont];
    self.specaliyiLblTop.constant=200;
    self.seperatorLblButtom.constant=500;
    self.shareTop.constant=5;
    self.tableTop.constant=20;
    
    //    BOOL avail= [[DealGaliInformation sharedInstance] networkReachability];
    //    if (avail) {
    //    }else{
    
    [self getData];
    // }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.imgScrollCollView setCollectionViewLayout:flowLayout];
    UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc] init];
    flowLayout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.categoryCollView setCollectionViewLayout:flowLayout1];
    
    // Do any additional setup after loading the view.
    UIButton *a1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [a1 setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [a1 addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [a1 setImage:[UIImage imageNamed:@"Search.png"] forState:UIControlStateNormal];
    rightSearchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:a1];
    
    self.navigationItem.rightBarButtonItem = rightSearchButtonItem;
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bckArr.png"] style:UIBarButtonItemStylePlain target:self action:@selector(previousecall)];
    
    
    
    UIBarButtonItem * revealButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo.png"]]];
    self.navigationItem.leftBarButtonItems = @[revealButtonItem,revealButtonItem1];
    
    self.scrollView.userInteractionEnabled=YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.upperView addGestureRecognizer:recognizer];
    
    
    
    
    
    //side menu
    UIView *twitterItem = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 50, 55)];
    [twitterItem setMenuActionWithBlock:^{
        [self twitterShareAction];
    }];
    UIImageView *twitterIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [twitterIcon setImage:[UIImage imageNamed:@"twitter"]];
    [twitterItem addSubview:twitterIcon];
    
    UIView *whatsappItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 55)];
    [whatsappItem setMenuActionWithBlock:^{
        [self whatsappShareAction];
    }];
    UIImageView *whatsappIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50 , 50)];
    [whatsappIcon setImage:[UIImage imageNamed:@"whatsapp"]];
    [whatsappItem addSubview:whatsappIcon];
    
    UIView *facebookItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 55)];
    [facebookItem setMenuActionWithBlock:^{
        [self facebookShareAction];
    }];
    UIImageView *facebookIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [facebookIcon setImage:[UIImage imageNamed:@"facebook"]];
    [facebookItem addSubview:facebookIcon];
    
    
    self.sideMenu = [[HMSideMenu alloc] initWithItems:@[facebookItem,twitterItem, whatsappItem]];
    [self.sideMenu setItemSpacing:5.0f];
    [self.view addSubview:self.sideMenu];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    start=0;
    timer= [NSTimer scheduledTimerWithTimeInterval: 3.0 target: self
                                          selector: @selector(callAftertenySecond:) userInfo: nil repeats: YES];
    [timer fire];
    
    
    self.revealViewController.panGestureRecognizer.enabled=NO;
    
    [[self.companyProfileBtn layer] setBorderWidth:2.0f];
    [[self.companyProfileBtn layer] setBorderColor:[UIColor DGPurpleColor].CGColor];
    self.companyProfileBtn.layer.cornerRadius = self.imgVwHT.constant / 2;
    self.companyProfileBtn.clipsToBounds = YES;
    self.companyLogoImgView.layer.cornerRadius = self.imgVwHT.constant / 2;
    self.companyLogoImgView.clipsToBounds = YES;
    //    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 200);
    //    self.scrollViewButtom.contentInset = contentInsets;
    [self.allDealButton addTarget:self
                           action:@selector(myAction)
                 forControlEvents:UIControlEventTouchUpInside];
    [[self.allDealButton imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [self.allDealButton setBackgroundColor:[UIColor DGPurpleColor]];
    //[self.allDealButton setBackgroundImage:[UIImage imageNamed:@"Cat-all_category.png"] forState:UIControlStateNormal];
    [self.addMSMEBtn addTarget:self
                        action:@selector(addMSMEAction)
              forControlEvents:UIControlEventTouchUpInside];
    [self.addMSMEBtn setBackgroundColor:[UIColor DGPurpleColor]];
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.revealViewController.panGestureRecognizer.enabled=YES;
}

-(void)getCategoryList{
    // [[DealGaliInformation sharedInstance]ShowWaiting:@"Loading..."];
    [[DealGaliNetworkEngine sharedInstance] homeCategoryListAPI:@"ios" withCallback:^(NSDictionary *response) {
        catResArray=[response objectForKey:@"CategoryList"];
        NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Priority" ascending:YES comparator:^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        categoryDic = [NSMutableArray arrayWithArray:[catResArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]]];
        
        self.allDealWT.constant=SCREENWIDTH/6.0f;
        self.addMSMELeading.constant=0;
        self.addMSMEWT.constant=SCREENWIDTH/6.0f;
        self.collWt.constant=(SCREENWIDTH/6.0f)*[categoryDic count];
        int len=(self.allDealWT.constant+self.addMSMEWT.constant+self.collWt.constant)-SCREENWIDTH;
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, len);
        self.scrollView.contentInset = contentInsets;
        [self.categoryCollView reloadData];
        [[DealGaliInformation sharedInstance]HideWaiting];
        
    }];
    
}

-(void)previousecall{
    [[DealGaliInformation sharedInstance]HideWaiting];
    
    [timer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
    
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
    if (collectionView==self.imgScrollCollView) {
        if ([DealImages isKindOfClass:[NSNull class]]) {
            return 1;
        }
        else
            return [DealImages count];
    }
    else
        return [categoryDic count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    if (collectionView==self.imgScrollCollView) {
        static NSString *identifier = @"flickerCell";
        UICollectionViewCell *flickerCell = (UICollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        flickerCell.backgroundColor = [UIColor whiteColor];
        UIImageView *imagView = (UIImageView *)[flickerCell viewWithTag:100];//DealImages
        if ([DealImages isKindOfClass:[NSNull class]]) {
            NSString *path = [NSUSERDEFAULTS stringForKey:@"pathDealImage"];
            [imagView sd_setImageWithURL:[NSURL URLWithString:path]
                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            //imagView.image=[UIImage imageNamed:@"NoDealImage"];
        }
        else{
            NSString *path=[[DealImages valueForKey:@"MediumImage"]objectAtIndex:indexPath.row];
            [imagView sd_setImageWithURL:[NSURL URLWithString:path]
                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            
        }
        imagView.contentMode = UIViewContentModeScaleAspectFill;
        imagView.clipsToBounds = YES;
        
        return flickerCell;
        
    }
    else{
        static NSString *identifier = @"Cat";
        UICollectionViewCell *categoryCell = (UICollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        categoryCell.backgroundColor = [UIColor whiteColor];
        categoryCell.backgroundColor = [UIColor DGPurpleColor];
        UIImageView *imagView = (UIImageView *)[categoryCell viewWithTag:101];
        UILabel *lbl = (UILabel *)[categoryCell viewWithTag:111];
        lbl.text=[[categoryDic valueForKey:@"CategoryName"]objectAtIndex:indexPath.row];
        NSString *path=[[categoryDic valueForKey:@"CategoryHoverIcon"]objectAtIndex:indexPath.row];
        [imagView sd_setImageWithURL:[NSURL URLWithString:path]
                    placeholderImage:[UIImage imageNamed:@""]];
        imagView.contentMode = UIViewContentModeScaleAspectFit;
        imagView.clipsToBounds = YES;
        
        return categoryCell;
    }
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
    if (collectionView==self.imgScrollCollView) {
        CGFloat itemht = CGRectGetHeight(self.imgScrollCollView.frame);
        return CGSizeMake(SCREENWIDTH, itemht);
    }
    else{
        CGFloat itemht = CGRectGetHeight(self.categoryCollView.frame);
        return CGSizeMake((SCREENWIDTH)/6.0f, itemht);
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [timer invalidate];
    if (collectionView==self.imgScrollCollView) {
        
    }
    else{
        UICollectionViewCell *categoryCell =
        (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [self.allDealButton setBackgroundColor:[UIColor DGPurpleColor]];
        // [self.allDealButton setBackgroundImage:[UIImage imageNamed:@"Cat-all_category.png"] forState:UIControlStateNormal];
        UIImageView *imagView = (UIImageView *)[categoryCell viewWithTag:101];
        UILabel *lbl = (UILabel *)[categoryCell viewWithTag:111];
        lbl.text=[[categoryDic valueForKey:@"CategoryName"]objectAtIndex:indexPath.row];
        categoryCell.backgroundColor=[UIColor DGPinkColor];
        NSString *path=[[categoryDic valueForKey:@"CategoryHoverIcon"]objectAtIndex:indexPath.row];
        [imagView sd_setImageWithURL:[NSURL URLWithString:path]
                    placeholderImage:[UIImage imageNamed:@""]];
        imagView.contentMode = UIViewContentModeScaleAspectFit;
        imagView.clipsToBounds = YES;
        NSString *catid=   [[categoryDic valueForKey:@"CategoryId"]objectAtIndex:indexPath.row];
        
        
        if ([self.screenName isEqualToString:@"home"]) {
            DealLiistViewController *dealListViewController = [[DealGaliInformation sharedInstance]Storyboard:DEALLISTSTORYBOARD];
            
            dealListViewController.index=(int)indexPath.row;
            dealListViewController.ControllerName=@"company";
            dealListViewController.indextoid=catid;
            dealListViewController.data=categoryDic;
            //[self.navigationController popViewControllerAnimated:YES];
            UINavigationController *navigationController =
            [[UINavigationController alloc] initWithRootViewController:dealListViewController];
            
            //now present this navigation controller modally
            [self presentViewController:navigationController
                               animated:YES
                             completion:^{
                                 
                             }];
            
        }
        else{
            NSLog(@"%d",self.indexCat);
            if ((int)indexPath.row==self.indexCat) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                DealLiistViewController *dealListViewController = [[DealGaliInformation sharedInstance]Storyboard:DEALLISTSTORYBOARD];
                
                dealListViewController.index=(int)indexPath.row;
                dealListViewController.ControllerName=@"company";
                dealListViewController.indextoid=catid;
                dealListViewController.data=categoryDic;
                [self.navigationController pushViewController:dealListViewController animated:YES];
            }
            
        }
    }
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView==self.imgScrollCollView) {
        
    }
    else{
        UICollectionViewCell *categoryCell =(UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        categoryCell.backgroundColor = [UIColor DGPurpleColor];
        UIImageView *imagView = (UIImageView *)[categoryCell viewWithTag:101];
        UILabel *lbl = (UILabel *)[categoryCell viewWithTag:111];
        lbl.text=[[categoryDic valueForKey:@"CategoryName"]objectAtIndex:indexPath.row];
        NSString *path=[[categoryDic valueForKey:@"CategoryHoverIcon"]objectAtIndex:indexPath.row];
        [imagView sd_setImageWithURL:[NSURL URLWithString:path]
                    placeholderImage:[UIImage imageNamed:@""]];
        imagView.contentMode = UIViewContentModeScaleAspectFit;
        imagView.clipsToBounds = YES;
        
    }
    
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [tableDic count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    EducationTableViewCell *cell = (EducationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:( UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(10.0, 10.0)];
    //
    //    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //    maskLayer.frame = self.view.bounds;
    //    maskLayer.path  = maskPath.CGPath;
    //
    //    cell.layer.mask = maskLayer;
    
    cell.nameLbl.textColor=[UIColor DGPurpleColor];
    cell.nameLbl.font=[UIFont DGTextFieldFont];
    cell.descriptionLbl.textColor=[UIColor DGDarkGrayColor];
    cell.descriptionLbl.font=[UIFont DGTextHome11Font];
    
    cell.contentView.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f];
    
    cell.callBtn.tag=indexPath.section;
    cell.likeBtn.tag=indexPath.section;
    cell.calenderBtn.tag=indexPath.section;
    
    [cell.callBtn addTarget:self action:@selector(callBtnAction1:) forControlEvents:UIControlEventTouchUpInside];
    [cell.calenderBtn addTarget:self action:@selector(appointmentBtnAction1:) forControlEvents:UIControlEventTouchUpInside];
    [cell.likeBtn addTarget:self action:@selector(likeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.imgView.image = nil;
    BOOL likeStatus = [[[tableDic valueForKey:@"IsLike"]objectAtIndex:indexPath.section] boolValue];
    if (!likeStatus) {
        
    }
    else{
        [cell.likeBtn  setBackgroundImage:[UIImage imageNamed:@"like-hart"] forState:UIControlStateNormal];
    }
    
    NSString *path=[[tableDic valueForKey:@"DealImage"]objectAtIndex:indexPath.section];
    if ([path isKindOfClass:[NSNull class]]) {
        NSString *path = [NSUSERDEFAULTS stringForKey:@"pathDealImage"];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:path]
                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        //cell.imgView.image=[UIImage imageNamed:@"NoDealImage"];
    }
    else{
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:path]
                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    
    cell.imgView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imgView.clipsToBounds = YES;
    
    NSString *str=[[tableDic valueForKey:@"DealDistance"]objectAtIndex:indexPath.section];
    NSArray *arr = [str componentsSeparatedByString:@"."];
    NSString *strSecond = [NSString stringWithFormat:@"%@KM",[arr objectAtIndex:0]];
    NSString * newString = [[arr objectAtIndex:1] substringWithRange:NSMakeRange(0, 1)];
    if ([strSecond isEqualToString:@"0KM"]) {
        NSString *addstr=[NSString stringWithFormat:@"0.%@KM",newString];
        cell.distanceLbl.text=addstr;
    }
    else
        cell.distanceLbl.text=strSecond;
    cell.descriptionLbl.text=[[tableDic valueForKey:@"DealDescription"]objectAtIndex:indexPath.section];
    cell.nameLbl.text=[[tableDic valueForKey:@"DealTitle"]objectAtIndex:indexPath.section];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 250;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.sideMenu.isOpen)
        [self.sideMenu close];
    
    self.specaliyiLblTop.constant=200;
    self.seperatorLblButtom.constant=500;
    self.shareTop.constant=5;
    self.tableTop.constant=20;
    self.seperatorLblButtom.constant=0;
    self.dealdecTOP.constant=25;
    self.dealDecHt.constant=0;
    self.dealtitleht.constant=0;
    self.specilitylblht.constant=0;
    self.specilityDecHt.constant=0;
    start=0;
    NSString *dealCustomId=   [[tableDic valueForKey:@"DealCustomId"]objectAtIndex:indexPath.section];
    self.dealCustomId=dealCustomId;
    
    [self getData];
    
    [self.scrollView setContentOffset:CGPointZero animated:NO];
    //[self viewDidLoad];
    
    // [self.tableView reloadData];
    //    NSString *dealCustomId=   [dataDic valueForKey:@"DealCustomId"];
    //    DealDescriptionViewController *dealDesViewController = [[DealGaliInformation sharedInstance]Storyboard:DEALDESCRIPTIONSTORYBOARD];
    //    dealDesViewController.dealCustomId=dealCustomId;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView                = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    UIView *headerView1                = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 11)];
    headerView.backgroundColor       =[UIColor whiteColor];
    headerView1.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f];
    
    //    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:headerView1.bounds byRoundingCorners:( UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(10.0, 10.0)];
    //
    //    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //    maskLayer.frame = self.view.bounds;
    //    maskLayer.path  = maskPath.CGPath;
    //    headerView1.layer.mask = maskLayer;
    [headerView addSubview:headerView1];
    return headerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
     offset_Y = scrollView.contentOffset.y;
    // NSLog(@"offset %f",offset_Y);
    if (offset_Y>310.000000) {
        if (self.sideMenu.isOpen)
            [self.sideMenu close];
        
        UIButton *a1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [a1 setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
        [a1 addTarget:self action:@selector(callBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [a1 setImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
        UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:a1];
        
        // revealButtonItem1 = [[UIBarButtonItem alloc] initWithImage:callImgView.image style:(UIBarButtonItemStylePlain) target:nil action:nil];
        
        UIButton *a2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [a2 setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
        [a2 addTarget:self action:@selector(appointmentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [a2 setImage:[UIImage imageNamed:@"clander.png"] forState:UIControlStateNormal];
        UIBarButtonItem* revealButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:a2];
        self.navigationItem.rightBarButtonItems = @[rightButtonItem,revealButtonItem1];
        
    }
    else if (offset_Y==0.000000){
        
    }
    
    else{
        self.navigationItem.rightBarButtonItems=nil;
        self.navigationItem.rightBarButtonItem = rightSearchButtonItem;
        
    }
    CGFloat sectionHeaderHeight = 20;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


-(void) callAftertenySecond:(NSTimer*)time
{
    if ([DealImages isKindOfClass:[NSNull class]] || [DealImages count]==0) {
        
    }
    else{
        if (start<[DealImages count]) {
            myIP=[NSIndexPath indexPathForRow:start inSection:0];
            //   NSLog(@"%ld",start);
            start=start+1;
        }
        else{
            start=0;
            myIP=[NSIndexPath indexPathForRow:start inSection:0];
        }
        
        
        [self.imgScrollCollView scrollToItemAtIndexPath:myIP
                                       atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                               animated:YES];
    }
    
    // [self.imgScrollCollView reloadData];
    //  NSLog(@"red");
}

- (IBAction)companyProfileBtnAction:(UIButton*)sender {
    
    
    CompanyProfileVC *companyVC = [[CompanyProfileVC alloc] init];
    companyVC.CompanyCustomId=[UserDetails valueForKey:@"CompanyCustomId"];
    [self.navigationController pushViewController:companyVC animated:YES];
    
    
    //    CompanyProfileViewController *companyVC=[[DealGaliInformation sharedInstance]Storyboard:COMPANYPROFILESTORYBOARD];
    //
    //    companyVC.CompanyCustomId=[UserDetails valueForKey:@"CompanyCustomId"];
    //
    //    [self.navigationController pushViewController:companyVC animated:YES];
}
- (IBAction)callBtnAction1:(UIButton*)sender {
    CallBackViewController *callVC=[[DealGaliInformation sharedInstance]Storyboard:CALLBACKSTORYBOARD];
    
    NSDictionary *dataDic=[tableDic objectAtIndex:sender.tag];
    
    NSString *dealCustomId=   [dataDic valueForKey:@"DealId"];
    NSString *dealURL=[dataDic valueForKey:@"DealUrl"];
    callVC.CustomId=dealCustomId;
    callVC.currentPageURL=dealURL;
    callVC.DealCompanyLogo=[dataDic valueForKey:@"DealCompanyLogo"];
    callVC.DealTitle=[dataDic valueForKey:@"DealTitle"];
    [self.navigationController pushViewController:callVC animated:YES];
    
}
- (IBAction)appointmentBtnAction1:(UIButton*)sender {
    AppointmentViewController *appointmentVC=[[DealGaliInformation sharedInstance]Storyboard:APPOINTMENTSTORYBOARD];
    
    NSDictionary *dataDic=[tableDic objectAtIndex:sender.tag];
    
    NSString *dealCustomId=   [dataDic valueForKey:@"DealId"];
    NSString *dealURL=[dataDic valueForKey:@"DealUrl"];
    appointmentVC.CustomId=dealCustomId;
    appointmentVC.currentPageURL=dealURL;
    appointmentVC.DealCompanyLogo=[dataDic valueForKey:@"DealCompanyLogo"];
    appointmentVC.DealTitle=[dataDic valueForKey:@"DealTitle"];
    appointmentVC.companyPage=@"appointmentVC";
    [self.navigationController pushViewController:appointmentVC animated:YES];
    
}

- (IBAction)callBtnAction:(UIButton*)sender {
    CallBackViewController *callVC=[[DealGaliInformation sharedInstance]Storyboard:CALLBACKSTORYBOARD];
    NSString *dealCustomId= [dic1 valueForKey:@"DealId"];
    NSString *dealURL=[dic1 valueForKey:@"DealPublicURL"];
    callVC.CustomId=dealCustomId;
    callVC.currentPageURL=dealURL;
    callVC.DealCompanyLogo=[dic1 valueForKey:@"CompanyLogo"];
    callVC.DealTitle=[dic1 valueForKey:@"DealTitle"];
    [self.navigationController pushViewController:callVC animated:YES];
}


- (IBAction)appointmentBtnAction:(id)sender {
    AppointmentViewController *appointmentVC=[[DealGaliInformation sharedInstance]Storyboard:APPOINTMENTSTORYBOARD];
    NSString *dealCustomId= [dic1 valueForKey:@"DealId"];
    NSString *dealURL=[dic1 valueForKey:@"DealPublicURL"];
    appointmentVC.CustomId=dealCustomId;
    appointmentVC.currentPageURL=dealURL;
    appointmentVC.DealCompanyLogo=[dic1 valueForKey:@"CompanyLogo"];
    appointmentVC.DealTitle=[dic1 valueForKey:@"DealTitle"];
    appointmentVC.companyPage=@"appointmentVC";
    [self.navigationController pushViewController:appointmentVC animated:YES];
}

- (IBAction)mapBtnAction:(id)sender {
    NSString *nativeMapScheme = @"maps.apple.com";
    NSString *lat=[dic1 valueForKey:@"DealLat"];
    NSString *lon=[dic1 valueForKey:@"DealLon"];
    NSString* url = [NSString stringWithFormat:@"http://%@/maps?q=%@,%@", nativeMapScheme, lat, lon];
    NSURL *URL = [NSURL URLWithString:url];
    [[UIApplication sharedApplication] openURL:URL];
    
}

- (IBAction)addSellerAction:(id)sender {
    SearchAndAddMSME *addMSMEVC = [[SearchAndAddMSME alloc] init];
    [self.navigationController pushViewController:addMSMEVC animated:YES];
    
}
- (IBAction)likeBtnAction:(UIButton*)sender {
    sender.selected  = ! sender.selected;
    static NSString *simpleTableIdentifier = @"Cell";
    NSString *dealCustomId=   [[tableDic valueForKey:@"DealId"]objectAtIndex:sender.tag];
    int likeStatus;
    EducationTableViewCell *cell = (EducationTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (sender.selected)
    {
        [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"like-hart"] forState:UIControlStateSelected];
        likeStatus=1;
        
        
        [DealGaliInformation sharedInstance].clickedDealForLike=[[DealGaliInformation sharedInstance].clickedDealForLike stringByAppendingString:[NSString stringWithFormat:@"%@",dealCustomId]];
    }
    else
    {
        [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"heart_icon"] forState:UIControlStateNormal];
        
        likeStatus=0;
        
        [DealGaliInformation sharedInstance].clickedDealForLike= [[DealGaliInformation sharedInstance].clickedDealForLike stringByReplacingOccurrencesOfString:dealCustomId withString:@""];
        
    }
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
    NSString *deviceID = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceID"];
    
    [[DealGaliNetworkEngine sharedInstance]SetShowCaseLikeAPI:userID deviceId:deviceID dealId:dealCustomId likeStatus:likeStatus withCallback:^(NSDictionary *response) {
        
    }];
    
    
}
-(void)myAction{
    [self.allDealButton setBackgroundColor:[UIColor DGPinkColor]];
    [self.categoryCollView reloadData];
    DealLiistViewController *dealListViewController = [[DealGaliInformation sharedInstance]Storyboard:DEALLISTSTORYBOARD];
    dealListViewController.index=100;
    dealListViewController.ControllerName=@"all";
    dealListViewController.alldata=categoryDic;
    if (self.indexCat==100) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
        [self.navigationController pushViewController:dealListViewController animated:YES];
    
    
}

-(void)addMSMEAction{
    [self.addMSMEBtn setBackgroundColor:[UIColor DGPinkColor]];
    [self.categoryCollView reloadData];
    DealLiistViewController *dealListViewController = [[DealGaliInformation sharedInstance]Storyboard:DEALLISTSTORYBOARD];
    dealListViewController.index=101;
    dealListViewController.ControllerName=@"MSME";
    dealListViewController.alldata=categoryDic;
    if (self.indexCat==100) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
        [self.navigationController pushViewController:dealListViewController animated:YES];
}

- (IBAction)shareBtnAction:(id)sender {
    //    if (self.sideMenu.isOpen)
    //        [self.sideMenu close];
    //    else
    //        [self.sideMenu open];
    //NSLog(@"%f",self.shareBTN.frame.origin.y);
    //    if (showHide) {
    //        [self showBtn];
    //    }
    //    else
    //        [self hideBtn];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.view];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(buttonPosition.x, buttonPosition.y, 50.0, 50.0);
    if(shareBubbles) {
        shareBubbles = nil;
    }
    shareBubbles = [[AAShareBubbles alloc] initWithPoint:button.center radius:95 inView:self.view];
    shareBubbles.delegate = self;
    shareBubbles.bubbleRadius = 25;
    shareBubbles.showFacebookBubble = YES;
    shareBubbles.showTwitterBubble = YES;
    shareBubbles.showGooglePlusBubble = YES;
    shareBubbles.showTumblrBubble = YES;
    shareBubbles.showVkBubble = YES;
    shareBubbles.showLinkedInBubble = YES;
    shareBubbles.showYoutubeBubble = YES;
    shareBubbles.showVimeoBubble = YES;
    shareBubbles.showRedditBubble = YES;
    shareBubbles.showPinterestBubble = YES;
    shareBubbles.showInstagramBubble = YES;
    shareBubbles.showWhatsappBubble = YES;
    
    [shareBubbles show];
    
}


-(void)targetedShare:(NSString *)serviceType {
    //NSString *textToShare = [dic1 valueForKey:@"DealTitle"];
     NSString *textToShare = @"Checkout this amazing seller I found on DealGali portraying the best from his store.Enjoy!";
    NSString *dealURL=[dic1 valueForKey:@"DealPublicURL"];
    NSString *webURL=[NSString stringWithFormat:@"Checkout more on: http://www.dealgali.com/%@",dealURL];
    if ([SLComposeViewController isAvailableForServiceType:serviceType]) {
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        
        [mySLComposerSheet setInitialText:textToShare];
        
       // [mySLComposerSheet addImage:self.companyLogoImgView.image];
        
        [mySLComposerSheet addURL:[NSURL URLWithString:webURL]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
    
    else {
        
        UIAlertView *alert;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"You do not have this service"
                 message:nil
                 delegate:self
                 cancelButtonTitle:@"OK"
                 otherButtonTitles:nil];
        
        [alert show];
    }
    
}



-(void)touch{
    if (self.sideMenu.isOpen)
        [self.sideMenu close];
    
}

- (void)facebookShareAction {
    [self.sideMenu close];
    [self targetedShare:SLServiceTypeFacebook];
}
- (void)twitterShareAction {
    [self.sideMenu close];
    
    [self targetedShare:SLServiceTypeTwitter];
}
- (void)whatsappShareAction {
    [self.sideMenu close];
    //NSString *textToShare = [dic1 valueForKey:@"DealTitle"];
     NSString *textToShare = @"Checkout this amazing seller I found on DealGali portraying the best from his store.Enjoy!";
    NSString *dealURL=[dic1 valueForKey:@"DealPublicURL"];
    NSString *webURL=[NSString stringWithFormat:@"Checkout more on: http://www.dealgali.com/%@",dealURL];
    
    NSString * urlWhatsURL = [NSString stringWithFormat:@"whatsapp://send?text=%@ %@",textToShare,webURL];
    
    
    NSURL * whatsappURL = [NSURL URLWithString:[urlWhatsURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    } else {
        // Cannot open whatsapp  photos (UTI: public.image)  web URLs (UTI: public.url)
    }
}



- (IBAction)likeAction:(UIButton*)sender {
    sender.selected  = ! sender.selected;
    NSString *dealCustomId=  [dic1 valueForKey:@"DealId"];
    int likeStatus;
    
    if (sender.selected)
    {
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"like-hart"] forState:UIControlStateSelected];
        
        likeStatus=1;
        BOOL likeStatus = [[UserDetails valueForKey:@"IsLike"] boolValue];
        if (!likeStatus) {
            self.likeLbl.text = [NSString stringWithFormat:@"%d Likes",value+1];
            
        }
        else{
            self.likeLbl.text = [NSString stringWithFormat:@"%d Likes",value];
            
        }
        
        [DealGaliInformation sharedInstance].clickedDealForLike=[[DealGaliInformation sharedInstance].clickedDealForLike stringByAppendingString:[NSString stringWithFormat:@"%@",dealCustomId]];
        [DealGaliInformation sharedInstance].clickedDealForDisLike=[[DealGaliInformation sharedInstance].clickedDealForDisLike stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"NAK_%@",dealCustomId] withString:@""];
        
    }
    else
    {
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"heart_icon"] forState:UIControlStateNormal];
        likeStatus=0;
        BOOL likeStatus = [[UserDetails valueForKey:@"IsLike"] boolValue];
        if (!likeStatus) {
            self.likeLbl.text = [NSString stringWithFormat:@"%d Likes",value];
            
        }
        else{
            self.likeLbl.text = [NSString stringWithFormat:@"%d Likes",value-1];
            
        }
        
        [DealGaliInformation sharedInstance].clickedDealForLike= [[DealGaliInformation sharedInstance].clickedDealForLike stringByReplacingOccurrencesOfString:dealCustomId withString:@""];
        [DealGaliInformation sharedInstance].clickedDealForDisLike=[[DealGaliInformation sharedInstance].clickedDealForDisLike stringByAppendingString:[NSString stringWithFormat:@"NAK_%@",dealCustomId]];
    }
    
    NSLog(@"String :   %@",[DealGaliInformation sharedInstance].clickedDealForLike);
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
    NSString *deviceID = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceID"];
    
    [[DealGaliNetworkEngine sharedInstance]SetShowCaseLikeAPI:userID deviceId:deviceID dealId:dealCustomId likeStatus:likeStatus withCallback:^(NSDictionary *response) {
        
    }];
    
}


-(void)getData{
    NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
    NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
    NSString *deviceId = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceID"];
    // NSLog(@"%@",self.dealCustomId);
    [[DealGaliInformation sharedInstance]ShowWaiting:@"Loading..."];
    [[DealGaliNetworkEngine sharedInstance] GetSerialisedDealDetailByIdAPI:self.dealCustomId userId:userId Lat:lat Long:lon deviceId:deviceId deviceType:@"ios" IsSync:true withCallback:^(NSDictionary *response) {
        dic=[response objectForKey:@"SerializedDeal"];//DealId
        dic1=[dic objectForKey:@"SerializedData"];
        DealImages=[dic1 objectForKey:@"DealImages"];
        UserDetails=[response objectForKey:@"OtherDetail"];
        dealSpecilities=[dic1 objectForKey:@"dealSpecilities"];
        BOOL likeStatus = [[UserDetails valueForKey:@"IsLike"] boolValue];
        if (!likeStatus) {
            
        }
        else{
            [self.likeBtn  setBackgroundImage:[UIImage imageNamed:@"like-hart"] forState:UIControlStateSelected];
            self.likeBtn.selected=YES;
        }
        
        
        [self.imgScrollCollView reloadData];
        NSString *path=[dic1 valueForKey:@"CompanyLogo"];
        if ([path isKindOfClass:[NSNull class]]) {
            NSString *path = [NSUSERDEFAULTS stringForKey:@"pathCompanyLogo"];
            [self.companyLogoImgView sd_setImageWithURL:[NSURL URLWithString:path]
                                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            //self.companyLogoImgView.image=[UIImage imageNamed:@"NoDealImage"];
        }
        else
            [self.companyLogoImgView sd_setImageWithURL:[NSURL URLWithString:path]
                                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        self.companyLogoImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.companyLogoImgView.clipsToBounds = YES;
        
        //DealTitle
        self.dealTitle.numberOfLines = 0;
        self.dealTitle.text=[dic1 valueForKey:@"DealTitle"];
        [self.dealTitle sizeToFit];
        
        self.DealDecLbl.numberOfLines = 0;
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setLineSpacing:2];
        
        NSDictionary *attributes = @{ NSFontAttributeName:[UIFont DGTextHome11Font], NSParagraphStyleAttributeName: paragraphStyle };
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[dic1 valueForKey:@"DealDescription"] attributes:attributes];
        
        
        [self.DealDecLbl setAttributedText: attributedString];
        [self.DealDecLbl sizeToFit];
        
        
        // NSString *similar=[dic1 valueForKey:@"DealTitle"];
        NSString *likeStr;
        value = [[UserDetails valueForKey:@"TotalLike"] intValue];
        if (value==0 || value==1){
            likeStr=[NSString stringWithFormat:@"%@ Like",[UserDetails valueForKey:@"TotalLike"]];
        }
        else
            likeStr=[NSString stringWithFormat:@"%@ Likes",[UserDetails valueForKey:@"TotalLike"]];
        
        self.likeLbl.text=likeStr;
        int viewCount = [[UserDetails valueForKey:@"TotalView"] intValue];
        NSString *viewStr;
        if (viewCount==0 || viewCount==1) {
            viewStr=[NSString stringWithFormat:@"%@ View",[UserDetails valueForKey:@"TotalView"]];
        }
        else{
            viewStr=[NSString stringWithFormat:@"%@ Views",[UserDetails valueForKey:@"TotalView"]];
        }
        self.viewLbl.text=viewStr;
        
        
        if ([self.totalViews isEqualToString:[UserDetails valueForKey:@"TotalView"]]) {
            //
            //            [DealGaliInformation sharedInstance].clickedDealForViews= [[DealGaliInformation sharedInstance].clickedDealForViews stringByReplacingOccurrencesOfString:_dealCustomId withString:@""];
            
        }
        else{
            [DealGaliInformation sharedInstance].clickedDealForViews=[[DealGaliInformation sharedInstance].clickedDealForViews stringByAppendingString:[NSString stringWithFormat:@"%@",_dealCustomId]];
        }
        
        NSString *like=[dic1 valueForKey:@"DealAttractiveLine"];
        if (![like isKindOfClass:[NSNull class]]) {
            self.faltOffLbl.text=like;
        }
        else{
            self.lblCaptionSide.hidden=YES;
        }
        
        if([dealSpecilities isKindOfClass:[NSNull class]]){
            //           self.specilityDecHt.constant=0;
            //            self.specilityDecHt.constant=0;
        }
        else{
            self.SpecilityLbl.numberOfLines = 0;
            self.SpecilityLbl.text=[dic1 valueForKey:@"DealSubTitle"];
            [self.SpecilityLbl sizeToFit];
            
            specility=@"";
            dealSpecilitiescount=[dealSpecilities count];
            for (int i=0; i<dealSpecilitiescount; i++) {
                NSDictionary *dataDic=[dealSpecilities objectAtIndex:i];
                NSString *str=[dataDic valueForKey:@"SpecialitiesTitle"];//\U2022
                // str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                NSRange replaceRange = [str rangeOfString:@"\n"];
                if (replaceRange.location != NSNotFound){
                    str = [str stringByReplacingCharactersInRange:replaceRange withString:@""];
                }
                NSString *spe;
                if ([str rangeOfString:@"\n"].location == NSNotFound) {
                    spe=[NSString stringWithFormat:@"  \u2022  %@\n",str];
                } else {
                    spe=[NSString stringWithFormat:@"  \u2022  %@",str];
                }
                
                
                specility =[specility stringByAppendingString:spe];
                
            }
            self.specilityDetailsLbl.numberOfLines = 0;
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [paragraphStyle setLineSpacing:2];
            
            NSDictionary *attributes = @{ NSFontAttributeName:[UIFont DGTextHome11Font], NSParagraphStyleAttributeName: paragraphStyle };
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:specility attributes:attributes];
            
            [self.specilityDetailsLbl setAttributedText: attributedString];
            // self.specilityDetailsLbl.text=specility;
            [self.specilityDetailsLbl sizeToFit];
            
            
        }
        
        NSString *dealId=[dic valueForKey:@"DealId"];
        NSString *UniqueUserId = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
        
        [[DealGaliNetworkEngine sharedInstance]GetOtherDealListAPI:lat longitude:lon DealId:dealId UserId:UniqueUserId withCallback:^(NSDictionary *response) {
            
            NSString *status=[response valueForKey:@"Status"];
            if ([status isEqualToString:@"7"]) {
                self.SimilarLbl.text=@"No similar discounts";
                self.shareTop.constant=0;
                self.tableTop.constant=0;
                self.collectionTop.constant=0;
                self.dealDecHt.constant=self.DealDecLbl.frame.size.height;
                self.specilitylblht.constant=self.SpecilityLbl.frame.size.height;
                self.specilityDecHt.constant=self.specilityDetailsLbl.frame.size.height;
                
                self.upperviewHt.constant=453+self.DealDecLbl.frame.size.height+self.specilitylblht.constant+self.dealtitleht.constant+self.specilitylblht.constant;
                
                self.dealdecTOP.constant=5;
                self.specaliyiLblTop.constant=15;
                self.specilitydetailtop.constant=10;
                self.tableHt.constant=0;
                self.collviewTop.constant=0;
                self.seperatorLblButtom.constant=-50;
            }
            else{
                tableDic=[response objectForKey:@"DealList"];
                
                self.shareTop.constant=0;
                self.dealdecTOP.constant=5;
                self.dealtitleht.constant=self.dealTitle.frame.size.height;
                self.dealDecHt.constant=self.DealDecLbl.frame.size.height;
                if([dealSpecilities isKindOfClass:[NSNull class]]){
                    self.specilityDecHt.constant=0;
                    self.specilitylblht.constant=0;
                }
                else{
                    self.specilitylblht.constant=self.SpecilityLbl.frame.size.height;
                    self.specilityDecHt.constant=self.specilityDetailsLbl.frame.size.height;
                }
                
                self.upperviewHt.constant=413+self.DealDecLbl.frame.size.height+self.specilityDecHt.constant+self.dealtitleht.constant+self.specilitylblht.constant;
                self.tableHt.constant=[tableDic count]*260+[tableDic count]*10+44;
                self.tableTop.constant=10;
                self.specaliyiLblTop.constant=15;
                self.collectionTop.constant=0;
                self.collviewTop.constant=0;
                self.specilitydetailtop.constant=5;
                self.seperatorLblButtom.constant=0;
                
                NSString *stgSimilar=[NSString stringWithFormat:@"%@",[response objectForKey:@"Title" ]];
                self.SimilarLbl.textColor=[UIColor DGPurpleColor];
                self.SimilarLbl.font=[UIFont DGActionButtonFont];
                self.SimilarLbl.text=stgSimilar;
                
                [self.tableView reloadData];
            }
            [self.view layoutIfNeeded];
            
            [self getCategoryList];
        }];
        
        // [[DealGaliInformation sharedInstance]HideWaiting];
        
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

#pragma mark AAShareBubbles

-(void)aaShareBubbles:(AAShareBubbles *)shareBubbles tappedBubbleWithType:(AAShareBubbleType)bubbleType
{
    switch (bubbleType) {
        case AAShareBubbleTypeFacebook:
            [self targetedShare:SLServiceTypeFacebook];
            break;
        case AAShareBubbleTypeTwitter:
            [self targetedShare:SLServiceTypeTwitter];
            break;
        case AAShareBubbleTypeWhatsApp:
            [self whatsappShareAction];
            break;
        default:
            break;
    }
}

-(void)aaShareBubblesDidHide:(AAShareBubbles*)bubbles {
    NSLog(@"All Bubbles hidden");
}

- (void)viewDidUnload {
    [self setShareBTN:nil];
    [super viewDidUnload];
}


@end
