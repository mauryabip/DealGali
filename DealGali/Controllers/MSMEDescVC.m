//
//  MSMEDescVC.m
//  DealGali
//
//  Created by Virinchi Software on 03/09/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "MSMEDescVC.h"
#import "DealGaliNetworkEngine.h"
#import "DealGaliInformation.h"
#import "EducationTableViewCell.h"

@interface MSMEDescVC ()

@end

@implementation MSMEDescVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getMSMEData];
    
    
    timer= [NSTimer scheduledTimerWithTimeInterval: 3.0 target: self
                                          selector: @selector(callAftertenySecond:) userInfo: nil repeats: YES];
    [timer fire];
    start=0;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    self.shareTop.constant=2000;
    self.lblBottom.constant=-200;
    
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.revealViewController.panGestureRecognizer.enabled=NO;
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    self.revealViewController.panGestureRecognizer.enabled=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)mapAction:(id)sender {
    NSString *nativeMapScheme = @"maps.apple.com";
    NSString *lat=[dic1 valueForKey:@"DealLat"];
    NSString *lon=[dic1 valueForKey:@"DealLon"];
    NSString* url = [NSString stringWithFormat:@"http://%@/maps?q=%@,%@", nativeMapScheme, lat, lon];
    NSURL *URL = [NSURL URLWithString:url];
    [[UIApplication sharedApplication] openURL:URL];
}

- (IBAction)callNowAction:(id)sender {
    NSString *tellPh=[NSString stringWithFormat:@"tel:%@",[dic1 valueForKey:@"DealContactNumber"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tellPh]];
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
        
    }
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
    NSString *deviceID = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceID"];
    [[DealGaliNetworkEngine sharedInstance]SetMSMEDealLikeAPI:userID deviceId:deviceID dealId:dealCustomId likeStatus:likeStatus withCallback:^(NSDictionary *response) {
        
    }];
}

- (IBAction)shareAction:(id)sender {
    //    if (self.sideMenu.isOpen)
    //        [self.sideMenu close];
    //    else
    //        [self.sideMenu open];
    CGRect shareBtnFrame   = self.shareBTN.frame;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(shareBtnFrame.origin.x, shareBtnFrame.origin.y-offset_Y, 50.0, 50.0);
    
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
-(void)touch{
    if (self.sideMenu.isOpen)
        [self.sideMenu close];
    
}


-(void)getMSMEData{
    NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
    NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
    NSString *deviceId = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceID"];
    // NSLog(@"%@",self.dealCustomId);
    [[DealGaliInformation sharedInstance]ShowWaiting:@"Loading..."];
    [[DealGaliNetworkEngine sharedInstance] GetSerialisedMSMEDealDetailByIdAPI:self.dealCustomId userId:userId Lat:lat Long:lon deviceId:deviceId deviceType:@"ios" IsSync:true withCallback:^(NSDictionary *response) {
        dic=[response objectForKey:@"SerializedDeal"];//DealId
        dic1=[dic objectForKey:@"SerializedData"];
        DealImages=[dic1 objectForKey:@"DealImages"];
        UserDetails=[response objectForKey:@"OtherDetail"];
        dealSpecilities=[dic1 objectForKey:@"dealSpecilities"];
        
        NSString *CreatedOn=[NSString stringWithFormat:@"Created on %@",[UserDetails valueForKey:@"CreatedOn"]];
        NSString *CreatedBy=[NSString stringWithFormat:@"Created by %@",[UserDetails valueForKey:@"CreatedBy"]];
        if ( [[UserDetails valueForKey:@"DealCorrectedBy"] isEqualToString:@""]||([[UserDetails valueForKey:@"DealCorrectedBy"] length]==0)) {
            self.editedByLbl.hidden=YES;
            self.descLblTOPConst.constant=self.descLblTOPConst.constant-self.editLblHTConst.constant;
            self.editLblHTConst.constant=0;
        }
        else{
            NSString *DealCorrectedBy=[NSString stringWithFormat:@"Suggested by %@",[UserDetails valueForKey:@"DealCorrectedBy"]];
            self.editedByLbl.text=DealCorrectedBy;
        }
        self.addedONLbl.text=CreatedOn;
        self.addedByLbl.text=CreatedBy;
        self.catNameLbl.text=[UserDetails valueForKey:@"CategoryName"];
        NSString *path=[UserDetails valueForKey:@"CategoryImage"];
        if ([path isKindOfClass:[NSNull class]]) {
            NSString *path = [NSUSERDEFAULTS stringForKey:@"pathCompanyLogo"];
            [self.catLogoImageView sd_setImageWithURL:[NSURL URLWithString:path]
                                     placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            //self.catLogoImageView.image=[UIImage imageNamed:@"NoDealImage"];
        }
        else
            [self.catLogoImageView sd_setImageWithURL:[NSURL URLWithString:path]
                                     placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        self.catLogoImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.catLogoImageView.clipsToBounds = YES;
        
        
        BOOL likeStatus = [[UserDetails valueForKey:@"IsLike"] boolValue];
        if (!likeStatus) {
            
        }
        else{
            [self.likeBtn  setBackgroundImage:[UIImage imageNamed:@"like-hart"] forState:UIControlStateSelected];
            self.likeBtn.selected=YES;
        }
        
        [self.collectionView reloadData];
        
        //DealTitle
        self.titleLbl.numberOfLines = 0;
        self.titleLbl.text=[dic1 valueForKey:@"DealTitle"];
        [self.titleLbl sizeToFit];
        
        self.descLbl.numberOfLines = 0;
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setLineSpacing:2];
        
        NSDictionary *attributes = @{ NSFontAttributeName:[UIFont DGTextHome11Font], NSParagraphStyleAttributeName: paragraphStyle };
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[dic1 valueForKey:@"DealDescription"] attributes:attributes];
        
        [self.descLbl setAttributedText: attributedString];
        [self.descLbl sizeToFit];
        
        
        if ([self.totalViews isEqualToString:[UserDetails valueForKey:@"TotalView"]]) {
            //
            //            [DealGaliInformation sharedInstance].clickedDealForViews= [[DealGaliInformation sharedInstance].clickedDealForViews stringByReplacingOccurrencesOfString:_dealCustomId withString:@""];
            
        }
        else{
            [DealGaliInformation sharedInstance].clickedDealForViews=[[DealGaliInformation sharedInstance].clickedDealForViews stringByAppendingString:[NSString stringWithFormat:@"%@",_dealCustomId]];
        }
        
        
        NSString *similar=[dic1 valueForKey:@"DealTitle"];
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
        
        
        NSString *dealId=[dic valueForKey:@"DealId"];
        NSString *UniqueUserId = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
        
        [[DealGaliNetworkEngine sharedInstance]GetOtherDealListAPI:lat longitude:lon DealId:dealId UserId:UniqueUserId withCallback:^(NSDictionary *response) {
            
            NSString *status=[response valueForKey:@"Status"];
            if ([status isEqualToString:@"7"]) {
                self.SimilarLbl.text=@"No similar deals";
                self.tableTop.constant=0;
                self.lblBottom.constant=-200;
                self.shareTop.constant=20;
                self.descLblHt.constant=self.descLbl.frame.size.height;
                self.upperviewHt.constant=455+self.descLblHt.constant+self.editLblHTConst.constant;
                self.tableHt.constant=0;
                self.tableTop.constant=0;
                
            }
            else{
                tableDic=[response objectForKey:@"DealList"];
                self.descLblHt.constant=self.descLbl.frame.size.height;
                self.lblBottom.constant=0;
                self.shareTop.constant=20;
                self.upperviewHt.constant=415+self.descLblHt.constant+self.editLblHTConst.constant;
                self.tableTop.constant=0;
                self.tableHt.constant=[tableDic count]*260+[tableDic count]*10+44;
                self.tableTop.constant=10;
                
                NSString *stgSimilar=[NSString stringWithFormat:@"%@ %@",[response objectForKey:@"Title" ],similar];
                self.SimilarLbl.textColor=[UIColor DGPurpleColor];
                self.SimilarLbl.font=[UIFont DGTextFieldFont];
                self.SimilarLbl.text=stgSimilar;
                
                [self.tableView reloadData];
            }
            [self.view layoutIfNeeded];
            
            [[DealGaliInformation sharedInstance]HideWaiting];
            
        }];
        
        
    }];
    
}
#pragma mark UICollectiobViewDelegate methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([DealImages isKindOfClass:[NSNull class]]) {
        return 1;
    }
    else
        return [DealImages count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    
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
        if ([path isKindOfClass:[NSNull class]]) {
            NSString *path = [NSUSERDEFAULTS stringForKey:@"pathDealImage"];
            [imagView sd_setImageWithURL:[NSURL URLWithString:path]
                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            
            //imagView.image=[UIImage imageNamed:@"NoDealImage"];
        }
        else
            [imagView sd_setImageWithURL:[NSURL URLWithString:path]
                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
    }
    imagView.contentMode = UIViewContentModeScaleAspectFill;
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
    return CGSizeMake(SCREENWIDTH, itemht);
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
    cell.calenderBtn.hidden=YES;
    
    [cell.callBtn addTarget:self action:@selector(callBtnAction:) forControlEvents:UIControlEventTouchUpInside];
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
    self.shareTop.constant=5;
    self.tableTop.constant=20;
    self.lblBottom.constant=0;
    self.descLblHt.constant=0;
    start=0;
    NSString *dealCustomId=   [[tableDic valueForKey:@"DealCustomId"]objectAtIndex:indexPath.section];
    self.dealCustomId=dealCustomId;
    
    [self getMSMEData];
    
    [self.scrollView setContentOffset:CGPointZero animated:NO];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
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
    
    offset_Y = scrollView.contentOffset.y;
    
    if (self.sideMenu.isOpen)
        [self.sideMenu close];
    
    
    CGFloat sectionHeaderHeight = 20;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

-(void) callAftertenySecond:(NSTimer*)time
{
    if ([DealImages isKindOfClass:[NSNull class]]) {
        
    }
    else{
        if (start<[DealImages count]) {
            myIP=[NSIndexPath indexPathForRow:start inSection:0];
            //   NSLog(@"%ld",start);
            start=start+1;
        }
        else
            start=0;
        
        [self.collectionView scrollToItemAtIndexPath:myIP
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:YES];
    }
    
}
- (void)callBtnAction:(UIButton*)sender {
    
}
- (void)likeBtnAction:(UIButton*)sender{
    
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
-(void)targetedShare:(NSString *)serviceType {
    //NSString *textToShare = [dic1 valueForKey:@"DealTitle"];
     NSString *textToShare = @"Checkout this amazing seller I found on DealGali portraying the best from his store.Enjoy!";
    NSString *dealURL=[dic1 valueForKey:@"DealPublicURL"];
    NSString *webURL=[NSString stringWithFormat:@"Checkout more on: http://www.dealgali.com/%@",dealURL];
    if ([SLComposeViewController isAvailableForServiceType:serviceType]) {
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        
        [mySLComposerSheet setInitialText:textToShare];
        
        //[mySLComposerSheet addImage:self.companyLogoImgView.image];
        
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
