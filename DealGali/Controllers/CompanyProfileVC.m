//
//  TestVC.m
//  DealGali
//
//  Created by Virinchi Software on 10/08/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "CompanyProfileVC.h"
#import "UINavigationBar+PS.h"
#import "UIView+PS.h"
#import "ContentTVCell.h"
#import "PhotoTVCell.h"
#import "CollectionViewCell.h"
#import "SYPhotoBrowser/SYPhotoBrowser.h"
#import <CoreText/CoreText.h>

#define Max_OffsetY  50

#define WeakSelf(x)      __weak typeof (self) x = self

#define HalfF(x) ((x)/2.0f)

#define  kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define  kScreenHeight  [UIScreen mainScreen].bounds.size.height

#define  Statur_HEIGHT   [[UIApplication sharedApplication] statusBarFrame].size.height
#define  NAVIBAR_HEIGHT  (self.navigationController.navigationBar.frame.size.height)
#define  INVALID_VIEW_HEIGHT (Statur_HEIGHT + NAVIBAR_HEIGHT)


@interface CompanyProfileVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    CGFloat _lastPosition;
    UICollectionViewFlowLayout *flowLayout1;
    
}
@property (nonatomic,strong)UIScrollView * bottomBar;
@property (nonatomic,strong)UIButton * likeBtn;
@property (nonatomic,strong)UIImageView * avatarView;
@property (nonatomic,strong)UICollectionView * categoryCollView;

@property (nonatomic,strong)UILabel * messageLabel;
@property (nonatomic,strong)UILabel * OpeningTimeLBL;
@property (nonatomic,strong)UILabel * noOfEmployeeLBL;
@property (nonatomic,strong)UILabel * viewLBL;
@property (nonatomic,strong)UILabel * likeLBL;

@property (nonatomic,strong)UIView * headBackView;
@property (nonatomic,strong)UIImageView * headImageView;
@property (nonatomic,strong)UITableView * displayTableView;

@end

@implementation CompanyProfileVC


- (void)dealloc
{
    _headBackView = nil;
    _headImageView = nil;
    _displayTableView = nil;
    _bottomBar = nil;
}
#pragma mark -displayTableView-

- (UITableView*)displayTableView
{
    if (!_displayTableView) {
        _displayTableView  = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _displayTableView.delegate = self;
        _displayTableView.dataSource = self;
        _displayTableView.showsVerticalScrollIndicator = NO;
    }
    return _displayTableView;
}

- (UIScrollView*)bottomBar
{
    if (!_bottomBar) {
        _bottomBar.delegate=self;
        _bottomBar = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kScreenHeight - HalfF(100),kScreenWidth , HalfF(100))];
        
        _bottomBar.backgroundColor=[UIColor DGPurpleColor];
        _bottomBar.scrollEnabled=YES;
        _bottomBar.showsHorizontalScrollIndicator=NO;
        _bottomBar.showsVerticalScrollIndicator=NO;
        UIButton *allDeal = [UIButton buttonWithType:UIButtonTypeCustom];
        [allDeal addTarget:self
                    action:@selector(myAction)
          forControlEvents:UIControlEventTouchUpInside];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, (SCREENWIDTH/6.0)-20, 30)];
        label.text = @"A";
        label.textColor=[UIColor DGWhiteColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
        [allDeal addSubview:label];
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(3, 36, (SCREENWIDTH/6.0)-6, 9)];
        label1.text = @"All Category";
        label1.textColor=[UIColor DGWhiteColor];
        label1.textAlignment=NSTextAlignmentCenter;
        label1.font = [UIFont fontWithName:@"HelveticaNeue" size:7];
        [allDeal addSubview:label1];
        // [allDeal setTitle:@"A" forState:UIControlStateNormal];
        allDeal.backgroundColor=[UIColor DGPurpleColor];
        allDeal.titleLabel.font=[UIFont DGActionButtonFont];
        allDeal.frame = CGRectMake(0, 0, SCREENWIDTH/6.0, 50);
        [_bottomBar addSubview:allDeal];
        
        UIButton *MSMEDeal = [UIButton buttonWithType:UIButtonTypeCustom];
        [MSMEDeal addTarget:self action:@selector(addMSMEAction)
           forControlEvents:UIControlEventTouchUpInside];
        [MSMEDeal setTitle:@"MSME" forState:UIControlStateNormal];
        MSMEDeal.backgroundColor=[UIColor DGPurpleColor];
        MSMEDeal.titleLabel.font=[UIFont DGActionButtonFont];
        MSMEDeal.frame = CGRectMake(SCREENWIDTH/6.0, 0, SCREENWIDTH/6.0, 50);
        [_bottomBar addSubview:MSMEDeal];
        
        
        flowLayout1 = [[UICollectionViewFlowLayout alloc] init];
        flowLayout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [self.categoryCollView setCollectionViewLayout:flowLayout1];
        self.categoryCollView=[[UICollectionView alloc]initWithFrame:CGRectMake((SCREENWIDTH/6.0)*2, 0, 1000, 50) collectionViewLayout:flowLayout1];
        [self.categoryCollView setDataSource:self];
        [self.categoryCollView setDelegate:self];
        self.categoryCollView.backgroundColor=[UIColor DGPurpleColor];
        self.categoryCollView.scrollEnabled=NO;
        [self.categoryCollView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cat"];
        
        // [self.categoryCollView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
        [_bottomBar addSubview:self.categoryCollView];
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        _bottomBar.contentInset = contentInsets;
        
    }
    return _bottomBar;
}

- (UIView*)headBackView{
    if (!_headBackView) {
        _headBackView = [UIView new];
        _headBackView.userInteractionEnabled = YES;
        _headBackView.frame = CGRectMake(0, 0, kScreenWidth,240);
    }
    
    return _headBackView;
}

- (UIImageView*)headImageView{
    if (!_headImageView)
    {
        _headImageView = [UIImageView new];
        // _headImageView.image = [UIImage imageNamed:@"bg"];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
        _headImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _headImageView;
}

- (UIImageView*)avatarView{
    if (!_avatarView) {
        _avatarView = [UIImageView new];
        //_avatarView.image = [UIImage imageNamed:@"qzl"];
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarView.size = CGSizeMake(90, 90);
        [[_avatarView layer] setBorderWidth:2.0f];
        [[_avatarView layer] setBorderColor:[UIColor DGPurpleColor].CGColor];
        [_avatarView setLayerWithCr:_avatarView.width / 2];
    }
    return _avatarView;
}


- (UILabel*)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont DGTextFieldFont];
        _messageLabel.textColor = [UIColor DGWhiteColor];
    }
    return _messageLabel;
}


#pragma mark --
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    self.revealViewController.panGestureRecognizer.enabled=NO;
    
    specility=@"";
    [self scrollViewDidScroll:self.displayTableView];
    self.avatarView.userInteractionEnabled=YES;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CompanyProfileView)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.avatarView addGestureRecognizer:recognizer];
    
}
-(void)CompanyProfileView{
    SYPhotoBrowser *photoBrowser = [[SYPhotoBrowser alloc] initWithImageSource:[serData valueForKey:@"CompanyLogoImage"] caption:@"" delegate:self];
    photoBrowser.initialPageIndex = 0;
    photoBrowser.pageControlStyle = SYPhotoBrowserPageControlStyleLabel;
    photoBrowser.enableStatusBarHidden = YES;
    [self presentViewController:photoBrowser animated:YES completion:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.revealViewController.panGestureRecognizer.enabled=YES;
    
    [self.navigationController.navigationBar ps_reset];
    [self.navigationController.navigationBar ps_setBackgroundColor:[NavigationBarBGColor colorWithAlphaComponent:1.0f]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSData *dataCat = [NSUSERDEFAULTS objectForKey:@"CATEGORIES"];
    categoryDic = [NSKeyedUnarchiver unarchiveObjectWithData:dataCat];
    
    [self getData];
    [self resetHeaderView];
    heightCell=400;
    self.displayTableView.tableHeaderView = self.headBackView;
    [self.displayTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.displayTableView];
    
    [self.view addSubview:self.bottomBar];
    CGFloat width=(kScreenWidth/6.0)*([categoryDic count]);
    _bottomBar.contentSize= CGSizeMake(45+width ,0);
    
    _displayTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.bottomBar.height)];
    UIButton *addSeller = [UIButton buttonWithType:UIButtonTypeCustom];
    [addSeller setFrame:CGRectMake(SCREENWIDTH-60, SCREENHEIGHT-110, 50, 50)];
    [addSeller addTarget:self action:@selector(addsellerAction) forControlEvents:UIControlEventTouchUpInside];
    [addSeller setImage:[UIImage imageNamed:@"addBtn.png"] forState:UIControlStateNormal];
    [self.view addSubview:addSeller];
    // [self.view bringSubviewToFront:addSeller];
    
    
    //    //导航
    //    [self.navigationController.navigationBar ps_setBackgroundColor:[UIColor clearColor]];
    //
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:(UIBarButtonItemStylePlain) target:nil action:nil];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Call" style:(UIBarButtonItemStylePlain) target:nil action:nil];
    
    UIImageView *callImgView =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,20,20)];
    UIImageView *calenderImgView =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,20,20)];
    callImgView.image=[UIImage imageNamed:@"call.png"];
    calenderImgView.image=[UIImage imageNamed:@"clander.png"];
    
    
    UIButton *a1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [a1 setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [a1 addTarget:self action:@selector(callBackBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [a1 setImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
    rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:a1];
    
    // revealButtonItem1 = [[UIBarButtonItem alloc] initWithImage:callImgView.image style:(UIBarButtonItemStylePlain) target:nil action:nil];
    
    UIButton *a2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [a2 setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [a2 addTarget:self action:@selector(appointmentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [a2 setImage:[UIImage imageNamed:@"clander.png"] forState:UIControlStateNormal];
    revealButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:a2];
    // rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clander.png"]]];
    
    self.navigationItem.rightBarButtonItems = nil;
    
    
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

-(void)previousecall{
    [[DealGaliInformation sharedInstance]HideWaiting];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resetHeaderView
{
    self.headImageView.frame = self.headBackView.bounds;
    [self.headBackView addSubview:self.headImageView];
    
    self.avatarView.centerX = self.headBackView.centerX;
    self.avatarView.centerY = self.headBackView.centerY -  HalfF(70);
    [self.headBackView addSubview:self.avatarView];
    
    //Map Button
    UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mapButton.frame = CGRectMake(10, 5, 40, 40);
    [mapButton setBackgroundImage:[UIImage imageNamed:@"map-icon.png"] forState:UIControlStateNormal];
    [mapButton addTarget:self action:@selector(mapBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headBackView addSubview:mapButton];
    
    _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeBtn.frame = CGRectMake(60, 5, 40, 40);
    [_likeBtn setBackgroundImage:[UIImage imageNamed:@"heart_icon.png"] forState:UIControlStateNormal];
    [_likeBtn addTarget:self action:@selector(likeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headBackView addSubview:_likeBtn];
    
    //self.messageLabel.text = @"Company Name";
    
    self.messageLabel.y = CGRectGetMaxY(self.avatarView.frame);
    self.messageLabel.size = CGSizeMake(kScreenWidth - HalfF(30), 50);
    self.messageLabel.numberOfLines=2;
    self.messageLabel.centerX = self.headBackView.centerX;
    
    //bg of hrs and employee
    
    UIImageView *imgBG =[[UIImageView alloc] initWithFrame:CGRectMake(0,190,kScreenWidth,50)];
    imgBG.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.headBackView addSubview:imgBG];
    
    //bg
    UIImageView *imgBGname =[[UIImageView alloc] init];
    imgBGname.y=self.messageLabel.y;
    imgBGname.size= self.messageLabel.size;
    imgBGname.centerX=self.messageLabel.centerX;
    imgBGname.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    // [self.headBackView addSubview:imgBGname];
    
    [self.headBackView addSubview:self.messageLabel];
    
    UIImageView *img =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-212,0,100,25)];
    img.image=[UIImage imageNamed:@"black-bg-left.png"];
    // [self.headBackView addSubview:img];
    
    UIImageView *likeImg =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-120,195,20,15)];
    likeImg.image=[UIImage imageNamed:@"like.png"];
    [self.headBackView addSubview:likeImg];
    
    _likeLBL =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-145,215,70,15)];
    _likeLBL.textColor=[UIColor whiteColor];
    _likeLBL.textAlignment = NSTextAlignmentCenter;
    _likeLBL.font=[UIFont DGTextViewFont];
    [self.headBackView  addSubview:_likeLBL];
    
    
    UIImageView *img1 =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-110,0,100,25)];
    img1.image=[UIImage imageNamed:@"black-bg-right.png"];
    //[self.headBackView addSubview:img1];
    
    UIImageView *ViewImg =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-50,195,20,15)];
    ViewImg.image=[UIImage imageNamed:@"eye-icon.png"];
    [self.headBackView  addSubview:ViewImg];
    
    _viewLBL =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-75,215,70,15)];
    _viewLBL.textColor=[UIColor whiteColor];
    _viewLBL.textAlignment = NSTextAlignmentCenter;
    _viewLBL.font=[UIFont DGTextViewFont];
    [self.headBackView  addSubview:_viewLBL];
    
    
    
    
    // Opening Hours
    
    UILabel *OpeningLBL =[[UILabel alloc] initWithFrame:CGRectMake(10,195,120,15)];
    OpeningLBL.textColor=[UIColor DGWhiteColor];
    OpeningLBL.font=[UIFont DGTextViewFont];
    OpeningLBL.text=@"opening hours:";
    [self.headBackView  addSubview:OpeningLBL];
    _OpeningTimeLBL =[[UILabel alloc] initWithFrame:CGRectMake(10,215,200,15)];
    _OpeningTimeLBL.textColor=[UIColor DGWhiteColor];
    _OpeningTimeLBL.font=[UIFont DGTextHome10Font];
    [self.headBackView  addSubview:_OpeningTimeLBL];
    
    //Employee
    
    UILabel *employeeLBL =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-140,195,120,15)];
    employeeLBL.textColor=[UIColor DGPinkColor];
    employeeLBL.textAlignment = NSTextAlignmentRight;
    employeeLBL.font=[UIFont DGTextViewFont];
    employeeLBL.text=@"Employee:";
    // [self.headBackView  addSubview:employeeLBL];
    
    _noOfEmployeeLBL =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-140,215,120,15)];
    _noOfEmployeeLBL.textColor=[UIColor DGPinkColor];
    _noOfEmployeeLBL.textAlignment = NSTextAlignmentRight;
    _noOfEmployeeLBL.font=[UIFont DGTextHome10Font];
    // [self.headBackView  addSubview:_noOfEmployeeLBL];
    
}

#pragma mark UICollectiobViewDelegate methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [categoryDic count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cat";
    CollectionViewCell *categoryCell = (CollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    categoryCell.backgroundColor=[UIColor DGPurpleColor];
    categoryCell.catNameLbl.text=[[categoryDic valueForKey:@"CategoryName"]objectAtIndex:indexPath.row];
    NSString *path=[[categoryDic valueForKey:@"CategoryHoverIcon"]objectAtIndex:indexPath.row];
    [categoryCell.imgView sd_setImageWithURL:[NSURL URLWithString:path]
                            placeholderImage:[UIImage imageNamed:@""]];
    categoryCell.imgView.contentMode = UIViewContentModeScaleAspectFit;
    categoryCell.imgView.clipsToBounds = YES;
    return categoryCell;
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
    
    // CGFloat itemht = CGRectGetHeight(self.categoryCollView.frame);
    return CGSizeMake((kScreenWidth)/6.0f, 50);
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *categoryCell =
    (CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    categoryCell.backgroundColor=[UIColor DGPinkColor];
    
    DealLiistViewController *dealListViewController = [[DealGaliInformation sharedInstance]Storyboard:DEALLISTSTORYBOARD];
    NSString *catid=   [[categoryDic valueForKey:@"CategoryId"]objectAtIndex:indexPath.row];
    dealListViewController.index=(int)indexPath.row;
    dealListViewController.ControllerName=@"company";
    dealListViewController.indextoid=catid;
    dealListViewController.data=categoryDic;
    dealListViewController.value=@"company";
    [self.navigationController pushViewController:dealListViewController animated:YES];
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *categoryCell =(CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    categoryCell.backgroundColor = [UIColor DGPurpleColor];
    
}

#pragma mark -tableview delegate-
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([compProfilePhotosList isKindOfClass:[NSNull class]]) {
        return 1;
    }
    return [compProfilePhotosList count]+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return heightCell;
    }
    else
        return 210;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"contentCell";
    static NSString *simpleTableIdentifier1 = @"photoCell";
    
    
    ContentTVCell *contentCell = (ContentTVCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (contentCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContentTVCell" owner:self options:nil];
        contentCell = (ContentTVCell *)[nib objectAtIndex:0];
    }
    PhotoTVCell *photoCell = (PhotoTVCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier1];
    if (photoCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PhotoTVCell" owner:self options:nil];
        photoCell = (PhotoTVCell *)[nib objectAtIndex:0];
    }
    photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row==0) {
        indexpath=indexPath;
        contentCell.bookAppointmentBtn.backgroundColor=[UIColor DGPurpleColor];
        contentCell.callBackBtn.backgroundColor=[UIColor DGPinkColor];
        [contentCell.bookAppointmentBtn  addTarget:self action:@selector(appointmentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [contentCell.callBackBtn  addTarget:self action:@selector(callBackBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        contentCell.shareBtn.tag=indexPath.row;
        [contentCell.shareBtn  addTarget:self action:@selector(ShareAction:) forControlEvents:UIControlEventTouchUpInside];
        
        contentCell.headingLbl.numberOfLines = 0;
        contentCell.headingLbl.text=[serData valueForKey:@"CompanyHeading"];
        [contentCell.headingLbl sizeToFit];
        
        contentCell.headingHT.constant=contentCell.headingLbl.frame.size.height;
        contentCell.headingDecTop.constant=10;
        
        contentCell.headingDecLbl.numberOfLines = 0;
        contentCell.headingDecLbl.text=[serData valueForKey:@"CompanyDetails"];
        [contentCell.headingDecLbl sizeToFit];
        
        contentCell.headindDecHT.constant=contentCell.headingDecLbl.frame.size.height;
        contentCell.specilityTop.constant=20;
        
        if([dealSpecilities isKindOfClass:[NSNull class]]){
            contentCell.specilityHT.constant=0;
            contentCell.specilityDecTOP.constant=0;
            contentCell.specilityDecHT.constant=0;
            contentCell.shareTop.constant=3;
        }
        else{
            
            contentCell.specilityLbl.numberOfLines = 0;
            contentCell.specilityLbl.text=[serData valueForKey:@"CompanyCaption"];
            [contentCell.specilityLbl sizeToFit];
            
            contentCell.specilityHT.constant=contentCell.specilityLbl.frame.size.height;
            contentCell.specilityDecTOP.constant=10;
            
            contentCell.specilityDecLbl.numberOfLines = 0;
            contentCell.specilityDecLbl.text=specility;
            [contentCell.specilityDecLbl sizeToFit];
            
            contentCell.specilityDecHT.constant=contentCell.specilityDecLbl.frame.size.height;
            contentCell.shareTop.constant=3;
        }
        
        heightCell=contentCell.headingHT.constant+ contentCell.headindDecHT.constant+ contentCell.specilityHT.constant+ contentCell.specilityDecHT.constant+155;
        
        return contentCell;
    }
    else{
        if ([compProfilePhotosList isKindOfClass:[NSNull class]]) {
            return nil;
        }
        else{
            NSString *path=[[compProfilePhotosList valueForKey:@"CompanyDealImgURLOriginalSize"]objectAtIndex:indexPath.row-1];
            photoCell.imgView.layer.borderColor=[UIColor colorWithRed:240/255.0 green:240/255.0  blue:240/255.0  alpha:1].CGColor;
            photoCell.imgView.layer.borderWidth=1.0;
            
            [photoCell.imgView sd_setImageWithURL:[NSURL URLWithString:path]
                                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            photoCell.imgView.contentMode = UIViewContentModeScaleAspectFill;
            photoCell.imgView.clipsToBounds = YES;
            
            return photoCell;
            
        }
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.sideMenu.isOpen)
        [self.sideMenu close];
    
    if (indexPath.row==0) {
        
    }
    else{
        
        SYPhotoBrowser *photoBrowser = [[SYPhotoBrowser alloc] initWithImageSourceArray:[compProfilePhotosList valueForKey:@"CompanyDealImgURLOriginalSize"] caption:@"" delegate:self];
        photoBrowser.initialPageIndex = indexPath.row-1;
        photoBrowser.pageControlStyle = SYPhotoBrowserPageControlStyleLabel;
        photoBrowser.enableStatusBarHidden = YES;
        [self presentViewController:photoBrowser animated:YES completion:nil];
    }
    
}


#pragma mark - SYPhotoBrowser Delegate

- (void)photoBrowser:(SYPhotoBrowser *)photoBrowser didLongPressImage:(UIImage *)image {
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"LongPress" message:@"Do somethings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //    [alertView show];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.sideMenu.isOpen)
        [self.sideMenu close];
    
    
    offset_Y = scrollView.contentOffset.y;
    
    // NSLog(@"Offset valuve   OffsetY:%f ->",offset_Y);
    
    if (offset_Y==-63.500000) {
        
        [self.displayTableView reloadData];
    }
    if (offset_Y>=224.000000) {//224.000000
        
        //[self addToCartTapped:indexpath];
        self.navigationItem.rightBarButtonItems = @[rightButtonItem,revealButtonItem1];
    }else{
        self.navigationItem.rightBarButtonItems = nil;
    }
    CGFloat imageH = self.headBackView.size.height;
    CGFloat imageW = kScreenWidth;
    
    if (offset_Y < 0)
    {
        CGFloat totalOffset = imageH + ABS(offset_Y);
        CGFloat f = totalOffset / imageH;
        
        self.headImageView.frame = CGRectMake(-(imageW * f - imageW) * 0.5, offset_Y, imageW * f, totalOffset);
    }
    else
    {
        self.headImageView.frame = self.headBackView.bounds;
    }
    
    
    if (offset_Y > Max_OffsetY)
    {
        CGFloat alpha = MIN(1, 1 - ((Max_OffsetY + INVALID_VIEW_HEIGHT - offset_Y) / INVALID_VIEW_HEIGHT));
        
        [self.navigationController.navigationBar ps_setBackgroundColor:[NavigationBarBGColor colorWithAlphaComponent:alpha]];
        
        if (offset_Y - _lastPosition > 5)
        {
            _lastPosition = offset_Y;
            
            [self bottomForwardDownAnimation];
        }
        else if (_lastPosition - offset_Y > 5)
        {
            _lastPosition = offset_Y;
            
            [self bottomForwardUpAnimation];
            
        }
        
        self.title = alpha > 0.8? self.messageLabel.text:@"";
        
    }
    else
    {
        [self.navigationController.navigationBar ps_setBackgroundColor:[NavigationBarBGColor colorWithAlphaComponent:0]];
        
        [self bottomForwardUpAnimation];
    }
    
    
    if (offset_Y < 0) {
        [self bottomForwardUpAnimation];
        
    }
    
    CGSize size = _displayTableView.contentSize;
    
    float y = offset_Y + _displayTableView.height;
    float h = size.height;
    float reload_distance = 10;
    
    if (y > h - _bottomBar.height + reload_distance)
    {
        [self bottomForwardUpAnimation];
    }
}

- (void)bottomForwardDownAnimation
{
    WeakSelf(ws);
    [UIView animateWithDuration:0.2 animations: ^{
        ws.bottomBar.transform = CGAffineTransformMakeTranslation(0, ws.bottomBar.height);
    } completion: ^(BOOL finished) {
    }];
}

- (void)bottomForwardUpAnimation
{
    WeakSelf(ws);
    [UIView animateWithDuration:0.2 animations: ^{
        ws.bottomBar.transform = CGAffineTransformIdentity;
    } completion: ^(BOOL finished) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)mapBtnAction:(id)sender {
    NSString *nativeMapScheme = @"maps.apple.com";
    NSString *lat=[serData valueForKey:@"CompanyLat"];
    NSString *lon=[serData valueForKey:@"CompanyLon"];
    NSString* url = [NSString stringWithFormat:@"http://%@/maps?q=%@,%@", nativeMapScheme, lat, lon];
    NSURL *URL = [NSURL URLWithString:url];
    [[UIApplication sharedApplication] openURL:URL];
}

-(void)getData{
    NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
    NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
    NSString *deviceId = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceID"];
    [[DealGaliInformation sharedInstance]ShowWaiting:Loading];
    [[DealGaliNetworkEngine sharedInstance]GetSerialisedCompanyDetailByIdAPI:self.CompanyCustomId userId:userId Lat:lat Long:lon deviceId:deviceId deviceType:@"ios" IsSync:true withCallback:^(NSDictionary *response) {
        dic=[response objectForKey:@"SerializedCompany"];
        userdetail=[response objectForKey:@"OtherDetail"];
        serData=[dic objectForKey:@"SerializedData"];
        
        self.messageLabel.text=[serData valueForKey:@"CompanyName"];
        NSString *messageStr=[NSString stringWithFormat:@" %@ ",self.messageLabel.text];
        UIColor *color = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.5f];
        NSDictionary *attrs = @{ NSBackgroundColorAttributeName : color };
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:messageStr attributes:attrs];
        self.messageLabel.attributedText = attrStr;
        //        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrStr);
        //
        //        CGColorRef highlightColor = (color) ? color.CGColor : [UIColor yellowColor].CGColor;//CGContextFillRect(attrStr, self.messageLabel.bounds);
        //        UIBezierPath *path11 = [UIBezierPath bezierPathWithRoundedRect:self.messageLabel.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(3.0f, 3.0f)];[color setFill];
        //        [path11 fill];
        
        
        
        dealSpecilities=[serData objectForKey:@"CompanySpecialities"];
        OperatingHours=[serData objectForKey:@"OperatingHours"];
        NSString *path=[serData valueForKey:@"CompanyLogoImage"];
        compProfilePhotosList=[serData objectForKey:@"compProfilePhotosList"];
        companyProfileViedoList=[serData objectForKey:@"companyProfileViedoList"];
        dealURL=[serData objectForKey:@"dealURL"];
        
        BOOL likeStatus = [[userdetail valueForKey:@"IsLike"] boolValue];
        if (!likeStatus) {
            
        }
        else{
            [self.likeBtn  setBackgroundImage:[UIImage imageNamed:@"like-hart"] forState:UIControlStateSelected];
            self.likeBtn.selected=YES;
        }
        
        
        if ([path isKindOfClass:[NSNull class]]) {
            NSString *path = [NSUSERDEFAULTS stringForKey:@"pathCompanyLogo"];
            [self.avatarView sd_setImageWithURL:[NSURL URLWithString:path]
                               placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        }
        else
            [self.avatarView sd_setImageWithURL:[NSURL URLWithString:path]
                               placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        NSString *path1=[serData valueForKey:@"CompanyCoverImage"];
        if ([path1 isKindOfClass:[NSNull class]]) {
            NSString *path = [NSUSERDEFAULTS stringForKey:@"pathDealImage"];
            [self.avatarView sd_setImageWithURL:[NSURL URLWithString:path]
                               placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        }
        else
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:path1]
                                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        //        NSString *strLike=[NSString stringWithFormat:@"%@ Likes",[userdetail valueForKey:@"TotalLike"]];
        //        _likeLBL.text=strLike;
        //        value = [[userdetail valueForKey:@"TotalLike"] intValue];
        //
        //        NSString *strViews=[NSString stringWithFormat:@"%@ Views",[userdetail valueForKey:@"TotalView"]];
        //        _viewLBL.text=strViews;
        
        NSString *likeStr;
        value = [[userdetail valueForKey:@"TotalLike"] intValue];
        if (value==0 || value==1){
            likeStr=[NSString stringWithFormat:@"%@ Like",[userdetail valueForKey:@"TotalLike"]];
        }
        else
            likeStr=[NSString stringWithFormat:@"%@ Likes",[userdetail valueForKey:@"TotalLike"]];
        
        _likeLBL.text=likeStr;
        int viewCount = [[userdetail valueForKey:@"TotalView"] intValue];
        NSString *viewStr;
        if (viewCount==0 || viewCount==1) {
            viewStr=[NSString stringWithFormat:@"%@ View",[userdetail valueForKey:@"TotalView"]];
        }
        else{
            viewStr=[NSString stringWithFormat:@"%@ Views",[userdetail valueForKey:@"TotalView"]];
        }
        _viewLBL.text=viewStr;
        
        
        _noOfEmployeeLBL.text=[serData valueForKey:@"CompanyEmployee"];
        NSString *timing=[NSString stringWithFormat:@"%@ %@",[OperatingHours valueForKey:@"FirstCombinationLabel"],[OperatingHours valueForKey:@"FirstCombinationTime"]];
        _OpeningTimeLBL.text=timing;
        
        if([dealSpecilities isKindOfClass:[NSNull class]]){
        }
        else{
            for (int i=0; i<[dealSpecilities count]; i++) {
                
                NSDictionary *dataDic=[dealSpecilities objectAtIndex:i];
                NSString *str=[dataDic valueForKey:@"SpecialitiesTitle"];
                NSString *spe=[NSString stringWithFormat:@"  \u2022  %@\n",str];
                specility =[specility stringByAppendingString:spe];
            }
        }
        
        [[DealGaliInformation sharedInstance]HideWaiting];
        [self.displayTableView reloadData];
        
    }];
}


- (IBAction)callBackBtnAction:(id)sender {
    NSArray *compShowcases=[serData objectForKey:@"compShowcases"];
    CallBackViewController *callVC=[[DealGaliInformation sharedInstance]Storyboard:CALLBACKSTORYBOARD];
    NSString *VendorId= [[compShowcases valueForKey:@"VendorId"]objectAtIndex:0];
    NSString *URL=[[compShowcases valueForKey:@"ShowcaseURL"]objectAtIndex:0];
    callVC.companyPage=@"companyPage";
    callVC.CustomId=VendorId;
    callVC.currentPageURL=URL;
    callVC.DealCompanyLogo=[serData valueForKey:@"CompanyLogoImage"];
    callVC.DealTitle=[serData valueForKey:@"CompanyName"];
    [self.navigationController pushViewController:callVC animated:YES];
}

- (IBAction)appointmentBtnAction:(id)sender {
    AppointmentViewController *appointmentVC=[[DealGaliInformation sharedInstance]Storyboard:APPOINTMENTSTORYBOARD];
    NSArray *compShowcases=[serData objectForKey:@"compShowcases"];
    NSString *VendorId= [[compShowcases valueForKey:@"VendorId"]objectAtIndex:0];
    NSString *URL=[[compShowcases valueForKey:@"ShowcaseURL"]objectAtIndex:0];
    appointmentVC.CustomId=VendorId;
    appointmentVC.currentPageURL=URL;
    appointmentVC.DealCompanyLogo=[serData valueForKey:@"CompanyLogoImage"];
    appointmentVC.DealTitle=[serData valueForKey:@"CompanyName"];
    appointmentVC.companyPage=@"company";
    [self.navigationController pushViewController:appointmentVC animated:YES];
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
    
    // [self targetedShare:SLServiceTypeFacebook];
    //NSString *textToShare = [serData valueForKey:@"CompanyHeading"];
     NSString *textToShare = @"Checkout this amazing seller I found on DealGali portraying the best from his store.";
    NSArray *compShowcases=[serData objectForKey:@"compShowcases"];
    NSString *URL=[[compShowcases valueForKey:@"ShowcaseURL"]objectAtIndex:0];
    NSString *webURL=[NSString stringWithFormat:@"Enjoy! Checkout more on: %@%@",URLFORHTMLPAGE,URL];
    NSString * urlWhatsURL = [NSString stringWithFormat:@"whatsapp://send?text=%@ %@",textToShare,webURL];
    
    
    NSURL * whatsappURL = [NSURL URLWithString:[urlWhatsURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    } else {
        // Cannot open whatsapp  photos (UTI: public.image)  web URLs (UTI: public.url)
    }
    
}

-(void)targetedShare:(NSString *)serviceType {
    //NSString *textToShare = [serData valueForKey:@"CompanyHeading"];
     NSString *textToShare = @"Checkout this amazing seller I found on DealGali portraying the best from his store.Enjoy!";
    NSArray *compShowcases=[serData objectForKey:@"compShowcases"];
    NSString *URL=[[compShowcases valueForKey:@"ShowcaseURL"]objectAtIndex:0];
    NSString *webURL=[NSString stringWithFormat:@"Checkout more on: %@%@",URLFORHTMLPAGE,URL];
    if ([SLComposeViewController isAvailableForServiceType:serviceType]) {
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        
        [mySLComposerSheet setInitialText:textToShare];
        
       // [mySLComposerSheet addImage:self.headImageView.image];
        
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
-(void)myAction{
    //[self.allDealButton setBackgroundImage:[UIImage imageNamed:@"Cat-all_category_pink"] forState:UIControlStateNormal];
    [self.categoryCollView reloadData];
    DealLiistViewController *dealListViewController = [[DealGaliInformation sharedInstance]Storyboard:DEALLISTSTORYBOARD];
    dealListViewController.index=100;
    dealListViewController.ControllerName=@"all";
    dealListViewController.alldata=categoryDic;
    [self.navigationController pushViewController:dealListViewController animated:YES];
    // [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)addMSMEAction{
    [self.categoryCollView reloadData];
    DealLiistViewController *dealListViewController = [[DealGaliInformation sharedInstance]Storyboard:DEALLISTSTORYBOARD];
    dealListViewController.index=101;
    dealListViewController.ControllerName=@"MSME";
    dealListViewController.alldata=categoryDic;
    
    [self.navigationController pushViewController:dealListViewController animated:YES];
}


-(void)ShareAction:(UIButton*)sender{
    //    if (self.sideMenu.isOpen)
    //        [self.sideMenu close];
    //    else
    //        [self.sideMenu open];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.displayTableView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(buttonPosition.x, buttonPosition.y-offset_Y, 50.0, 50.0);
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
- (void)likeBtnAction:(UIButton*)sender {
    sender.selected  = ! sender.selected;
    NSString *dealCustomId= [serData valueForKey:@"CompanyId"];
    int likeStatus;
    if (sender.selected){
        [_likeBtn setBackgroundImage:[UIImage imageNamed:@"like-hart"] forState:UIControlStateSelected];
        likeStatus=1;
        BOOL likeStatus = [[userdetail valueForKey:@"IsLike"] boolValue];
        if (!likeStatus) {
            self.likeLBL.text = [NSString stringWithFormat:@"%d Likes",value+1];
        }
        else{
            self.likeLBL.text = [NSString stringWithFormat:@"%d Likes",value];
        }
        
    }
    else{
        [_likeBtn setBackgroundImage:[UIImage imageNamed:@"heart_icon"] forState:UIControlStateNormal];
        likeStatus=0;
        BOOL likeStatus = [[userdetail valueForKey:@"IsLike"] boolValue];
        if (!likeStatus) {
            self.likeLBL.text = [NSString stringWithFormat:@"%d Likes",value];
            
        }
        else{
            self.likeLBL.text = [NSString stringWithFormat:@"%d Likes",value-1];
            
        }
        
    }
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
    NSString *deviceID = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceID"];
    
    [[DealGaliNetworkEngine sharedInstance]SetBusinessLikeAPI:userID deviceId:deviceID companyId:dealCustomId likeStatus:likeStatus withCallback:^(NSDictionary *response) {
        
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
-(void)addsellerAction{
    SearchAndAddMSME *addMSMEVC = [[SearchAndAddMSME alloc] init];
    [self.navigationController pushViewController:addMSMEVC animated:YES];
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

@end
