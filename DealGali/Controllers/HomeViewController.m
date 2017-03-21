//
//  HomeViewController.m
//  DealGali
//
//  Created by Virinchi Software on 18/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "HomeViewController.h"
#import "CompanyProfileVC.h"
#import "UIView+draggable.h"


@interface HomeViewController ()


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // [self.view enableDragging];
    //[self.dragableView enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
    [self.dragableView enableDragging];
    [self.dragableView.layer setCornerRadius:10];
    //[obj setDraggingArea:CGRectMake(0, 0, 100, 100)];
    //  }];
    
    self.viewAllBtn.titleLabel.text=VIEWALLButton;
    self.viewAllBtn.titleLabel.textColor=[UIColor DGWhiteColor];
    self.viewAllBtn.backgroundColor=[UIColor DGPinkColor];
    self.viewAllBtn.titleLabel.font=[UIFont DGActionButtonFont];
    self.catLBL.text=CATEGORIES;
    self.fastestLocalLbl.text=FASTESTLOCALBUZZ;
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    
    self.scrollView.delegate=self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.TestimonialCollView.pagingEnabled = YES;
    
    [self getData];
    
    CALayer * l = [self.lastImgView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.imgScrollCollView setCollectionViewLayout:flowLayout];
    UICollectionViewFlowLayout *flowLayout2 = [[UICollectionViewFlowLayout alloc] init];
    flowLayout2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.TestimonialCollView setCollectionViewLayout:flowLayout2];
    UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc] init];
    flowLayout1.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.CategoryCollView setCollectionViewLayout:flowLayout1];
    
    // Do any additional setup after loading the view, typically from a nib.
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    UIBarButtonItem * revealButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo.png"]]];
    
    self.navigationItem.leftBarButtonItems = @[revealButtonItem,revealButtonItem1];
    
    
    UIButton *a1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [a1 setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [a1 addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [a1 setImage:[UIImage imageNamed:@"Search.png"] forState:UIControlStateNormal];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:a1];
    
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    // NSLog(@"%f    %f",self.TestimonialCollView.frame.size.width,self.TestimonialCollView.contentOffset.x);
    CGFloat pageWidth = self.TestimonialCollView.frame.size.width;
    float currentPage = self.TestimonialCollView.contentOffset.x / pageWidth;
    
    if (0.0f != fmodf(currentPage, 1.0f))
    {
        self.pageControl.currentPage = currentPage + 1;
    }
    else
    {
        self.pageControl.currentPage = currentPage;
    }
    
    // NSLog(@"finishPage: %ld", (long)pageControl.currentPage);
}


-(void)previousecall{
    [[DealGaliInformation sharedInstance]HideWaiting];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        //responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    
    
    start=0;
    timer= [NSTimer scheduledTimerWithTimeInterval: 5.0 target: self
                                          selector: @selector(callAftertenySecond:) userInfo: nil repeats: YES];
    
    [timer fire];
    
    
    
    NSData *data = [NSUSERDEFAULTS objectForKey:@"HOMEDATA"];
    NSDictionary *retrievedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.responceData = [[NSDictionary alloc] initWithDictionary:retrievedDictionary];
    
    imgdic=[self.responceData objectForKey:@"HomeImageList"];
    catresArr=[self.responceData objectForKey:@"CategoryData"];
    test=[self.responceData objectForKey:@"UserTestimonial"];
    NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Priority" ascending:YES comparator:^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    categoryDic = [NSMutableArray arrayWithArray:[catresArr sortedArrayUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]]];
    
    if ([categoryDic count]<=6) {
        self.upperViewHt.constant=440;
        self.tableTop.constant=10;
        self.buttomViewTop.constant=10;
        [self.view layoutIfNeeded];
        self.viewAllBtn.hidden=YES;
    }
    
    int dataCount=(int)[categoryDic count]+1;
    self.tableHt.constant=565*dataCount+85*dataCount+40;
    self.buttomViewTop.constant=-20;
    //[self.tableView reloadData];
    [self.CategoryCollView reloadData];
    [self.imgScrollCollView reloadData];
    [self.TestimonialCollView reloadData];
    [self.tableView reloadData];
    
    
    
    // self.scrollHt.constant=3520;
    //    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 3000.0, 0.0);
    //    self.scrollView.contentInset = contentInsets;
    
    
}

-(void)getData{
    
    
    NSData *data = [NSUSERDEFAULTS objectForKey:@"ALLDEALLIST"];
    NSDictionary *retrievedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    dic=[[[NSDictionary alloc] initWithDictionary:retrievedDictionary] objectForKey:@"DealList"];
    
    [self.tableView reloadData];
    
    //    NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
    //    NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
    //    [[DealGaliInformation sharedInstance]ShowWaiting:@"Loading..."];
    //    [[DealGaliNetworkEngine sharedInstance] homeAPI:lat lon:lon withCallback:^(NSDictionary *response) {
    //
    //        [[DealGaliInformation sharedInstance]HideWaiting];
    //        }];
}
-(void)getImgList{
    NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
    NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
    NSString *UniqueUserId = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
    [[DealGaliNetworkEngine sharedInstance] GetHomeDetailAPI:lat lon:lon DealId1:@"" DealId2:@"" UserId:UniqueUserId  withCallback:^(NSDictionary *response) {
        
        imgdic=[response objectForKey:@"HomeImageList"];
        catresArr=[response objectForKey:@"CategoryData"];
        test=[response objectForKey:@"UserTestimonial"];
        NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Priority" ascending:YES comparator:^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        categoryDic = [NSMutableArray arrayWithArray:[catresArr sortedArrayUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]]];
        int dataCount=(int)[categoryDic count]+1;
        self.tableHt.constant=575*dataCount+70*dataCount;
        self.buttomViewTop.constant=10;
        //[self.tableView reloadData];
        [self.CategoryCollView reloadData];
        [self.imgScrollCollView reloadData];
        [self.TestimonialCollView reloadData];
        [self getData];
        
        
    }];
    
    //response1=[DealGaliInformation sharedInstance].arr;
    
    NSLog(@"%@",[DealGaliInformation sharedInstance].arr);
    
}
-(void)getCategoryList{
    
    [[DealGaliNetworkEngine sharedInstance] homeCategoryListAPI:@"ios" withCallback:^(NSDictionary *response) {
        catresArr=[response objectForKey:@"CategoryList"];
        NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Priority" ascending:YES comparator:^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        categoryDic = [NSMutableArray arrayWithArray:[catresArr sortedArrayUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]]];
        [self.CategoryCollView reloadData];
        [self getData];
    }];
    
    
}
-(void)getDataByCatId{
    NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
    NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
    // for (int i=0; i<[categoryDic count]; i++) {
    
    NSString *catId=[NSString stringWithFormat:@"%@",[[categoryDic valueForKey:@"CategoryId"]objectAtIndex:0]];
    [[DealGaliNetworkEngine sharedInstance]getDealListByCategoryIdAPI:lat longitude:lon CategoryId:catId withCallback:^(NSDictionary *response) {
        catwiseDetails=[response objectForKey:@"DealList"];
        //  imgdic=[response objectForKey:@"HomeImageList"];//UserTestimonial CategoryData
        //  catresArr=[response objectForKey:@"CategoryData"];
        [self.tableView reloadData];
    }];
    
    // }
    
    
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
        
        return  [imgdic count];
    }
    if (collectionView==self.TestimonialCollView) {
        
        return  [test count];
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
        UIImageView *imagView = (UIImageView *)[flickerCell viewWithTag:100];
        NSString *path=[[imgdic valueForKey:@"ImagePath"]objectAtIndex:indexPath.row];
        [imagView sd_setImageWithURL:[NSURL URLWithString:path]
                    placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        imagView.contentMode = UIViewContentModeScaleAspectFill;
        imagView.clipsToBounds = YES;
        
        return flickerCell;
        
    }
    else if(collectionView==self.TestimonialCollView) {
        static NSString *identifier = @"TestimonialCell";
        UICollectionViewCell *testCell = (UICollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        NSString *count=[NSString stringWithFormat:@"%ld of %lu",indexPath.row+1,(unsigned long)[test count]];
        self.testCountLbl.text=count;
        UILabel *headingLbl = (UILabel *)[testCell viewWithTag:100];
        headingLbl.text=WHATOURCUSTMRSAYS;
        UILabel *decLbl = (UILabel *)[testCell viewWithTag:101];
        UILabel *companyLbl = (UILabel *)[testCell viewWithTag:102];
        
        UIImageView *companyLogoImgView = (UIImageView *)[testCell viewWithTag:1005];
        companyLogoImgView.layer.cornerRadius = 55 / 2;
        companyLogoImgView.contentMode = UIViewContentModeScaleAspectFill;
        companyLogoImgView.clipsToBounds = YES;
        [[companyLogoImgView layer] setBorderWidth:2.0f];
        [[companyLogoImgView layer] setBorderColor:[UIColor DGPurpleColor].CGColor];
        
        NSString *path1=[[test valueForKey:@"PictureUrl"]objectAtIndex:indexPath.row];
        if ([path1 isKindOfClass:[NSNull class]]) {
            NSString *path = [NSUSERDEFAULTS stringForKey:@"pathCompanyLogo"];
            [companyLogoImgView sd_setImageWithURL:[NSURL URLWithString:path]
                                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            //companyLogoImgView.image=[UIImage imageNamed:@"NoDealImage"];
        }
        else
            [companyLogoImgView sd_setImageWithURL:[NSURL URLWithString:path1]
                                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        companyLogoImgView.contentMode = UIViewContentModeScaleAspectFill;
        companyLogoImgView.clipsToBounds = YES;
        NSString *testimonialText = [NSString stringWithFormat:@"\"%@\"",[[test valueForKey:@"Testimonial"]objectAtIndex:indexPath.row]];
        
        decLbl.text=testimonialText;
        NSString *str=[[test valueForKey:@"CompanyName"]objectAtIndex:indexPath.row];
        if ([str isKindOfClass:[NSNull class]]) {
            
        }
        else
            companyLbl.text=str;
        
        int pages =floor(self.TestimonialCollView.contentSize.width/self.TestimonialCollView.frame.size.width);
        [self.pageControl setNumberOfPages:pages];
        return testCell;
    }
    else{
        static NSString *identifier = @"Cat";
        UICollectionViewCell *categoryCell = (UICollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        //categoryCell.backgroundColor = [UIColor colorWithRed:137/255.0f green:9/255.0f blue:178/255.0f alpha:1.0f];
        UIImageView *imagView = (UIImageView *)[categoryCell viewWithTag:101];
        UILabel *lbl = (UILabel *)[categoryCell viewWithTag:100];
        lbl.text=[[categoryDic valueForKey:@"CategoryName"]objectAtIndex:indexPath.row];
        NSString *path=[[categoryDic valueForKey:@"CategoryHoverIcon"]objectAtIndex:indexPath.row];
        [imagView sd_setImageWithURL:[NSURL URLWithString:path]
                    placeholderImage:[UIImage imageNamed:@""]];
        imagView.contentMode = UIViewContentModeScaleAspectFit;
        imagView.clipsToBounds = YES;
        
        return categoryCell;;
        
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView==self.imgScrollCollView ) {
        return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
    }
    else if (collectionView==self.TestimonialCollView){
        return UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    else{
        return UIEdgeInsetsMake(0, 10, 10, 10); // top, left, bottom, right
    }
    
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView==self.imgScrollCollView ) {
        return 0.0f;
    }
    else if (collectionView==self.TestimonialCollView){
        return 0.0f;
        
    }
    else{
        return 7.0f;
    }
    
}
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView==self.imgScrollCollView ) {
        CGFloat itemht = CGRectGetHeight(self.imgScrollCollView.frame);
        return CGSizeMake(SCREENWIDTH, itemht);
    }
    else if (collectionView==self.TestimonialCollView){
        CGFloat itemht = CGRectGetHeight(self.TestimonialCollView.frame);
        return CGSizeMake(SCREENWIDTH, itemht);
    }
    else{
        return CGSizeMake((SCREENWIDTH-35)/3.0f, 80);
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [timer invalidate];
    if (collectionView==self.imgScrollCollView ) {
        DealDescriptionViewController *dealDesViewController = [[DealGaliInformation sharedInstance]Storyboard:DEALDESCRIPTIONSTORYBOARD];
        dealDesViewController.screenName=@"home";
        NSString *dealCustomId=   [[imgdic valueForKey:@"CustomId"]objectAtIndex:indexPath.row];
        
        dealDesViewController.dealCustomId=dealCustomId;
        [self.navigationController pushViewController:dealDesViewController animated:YES];
        
    }
    else if (collectionView ==self.TestimonialCollView){
        
    }
    else{
        UICollectionViewCell *categoryCell =
        (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        UIImageView *imagView = (UIImageView *)[categoryCell viewWithTag:101];
        // categoryCell.backgroundColor = [UIColor colorWithRed:230/255.0f green:7/255.0f blue:126/255.0f alpha:1.0f];
        NSString *path=[[categoryDic valueForKey:@"CategoryHoverIcon"]objectAtIndex:indexPath.row];
        [imagView sd_setImageWithURL:[NSURL URLWithString:path]
                    placeholderImage:[UIImage imageNamed:@""]];
        imagView.contentMode = UIViewContentModeScaleAspectFill;
        imagView.clipsToBounds = YES;
        
        // NSDictionary *dataDic=[categoryDic objectAtIndex:indexPath.row];
        NSLog(@"%@",[categoryDic objectAtIndex:indexPath.row]);
        
        DealLiistViewController *dealListViewController = [[DealGaliInformation sharedInstance]Storyboard:DEALLISTSTORYBOARD];
        NSString *catid=   [[categoryDic valueForKey:@"CategoryId"]objectAtIndex:indexPath.row];
        dealListViewController.index=(int)indexPath.row;
        dealListViewController.ControllerName=@"home";
        dealListViewController.indextoid=catid;
        dealListViewController.data=categoryDic;
        dealListViewController.value=@"home";
        [self.navigationController pushViewController:dealListViewController animated:YES];
    }
    
    
}
-(void)collectionView:(UICollectionView *)collectionView
didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView==self.imgScrollCollView || collectionView==self.TestimonialCollView) {
        
    }
    else{
        UICollectionViewCell *categoryCell =
        (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        // categoryCell.backgroundColor = [UIColor colorWithRed:137/255.0f green:9/255.0f blue:178/255.0f alpha:1.0f];
        UIImageView *imagView = (UIImageView *)[categoryCell viewWithTag:101];
        NSString *path=[[categoryDic valueForKey:@"CategoryHoverIcon"]objectAtIndex:indexPath.row];
        [imagView sd_setImageWithURL:[NSURL URLWithString:path]
                    placeholderImage:[UIImage imageNamed:@""]];
        imagView.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    
    
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int count=(int)[categoryDic count]+1;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    //IsLike = 0;
    EducationTableViewCell *cell = (EducationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLbl.textColor=[UIColor DGPurpleColor];
    cell.nameLbl.font=[UIFont DGTextFieldFont];
    cell.descriptionLbl.textColor=[UIColor DGDarkGrayColor];
    cell.descriptionLbl.font=[UIFont DGTextHome11Font];
    
    [cell.callBtn addTarget:self action:@selector(callBackBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.calenderBtn addTarget:self action:@selector(appointmentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.likeBtn addTarget:self action:@selector(likeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.imgView.image = nil;
    if (indexPath.section==0) {
        cell.callBtn.tag=indexPath.section;
        cell.calenderBtn.tag=indexPath.section;
        cell.likeBtn.tag=indexPath.section;
        [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"heart_icon"] forState:UIControlStateNormal];
        
        BOOL likeStatus = [[[dic valueForKey:@"IsLike"]objectAtIndex:indexPath.row] boolValue];
        if (!likeStatus) {
            
        }
        else{
            [cell.likeBtn  setBackgroundImage:[UIImage imageNamed:@"like-hart"] forState:UIControlStateNormal];
            cell.likeBtn.selected=YES;
            
        }
        NSString *DealId=[[dic valueForKey:@"DealId"]objectAtIndex:indexPath.row];
        if ([[DealGaliInformation sharedInstance].clickedDealForLike rangeOfString:DealId].location == NSNotFound) {
            
        }
        else{
            [cell.likeBtn  setBackgroundImage:[UIImage imageNamed:@"like-hart"] forState:UIControlStateNormal];
        }
        if ([[DealGaliInformation sharedInstance].clickedDealForDisLike rangeOfString:[NSString stringWithFormat:@"NAK_%@",DealId]].location == NSNotFound) {
            
        }
        else{
            [cell.likeBtn  setBackgroundImage:[UIImage imageNamed:@"heart_icon"] forState:UIControlStateNormal];
        }
        
        NSString *path=[[dic valueForKey:@"DealImage"]objectAtIndex:indexPath.row];
        if ([path isKindOfClass:[NSNull class]]) {
            NSString *path = [NSUSERDEFAULTS stringForKey:@"pathDealImage"];
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:path]
                            placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            // cell.imgView.image=[UIImage imageNamed:@"NoDealImage"];
        }
        else
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:path]
                            placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        cell.imgView.contentMode = UIViewContentModeScaleAspectFill;
        cell.imgView.clipsToBounds = YES;
        
        NSString *str=[[dic valueForKey:@"DealDistance"]objectAtIndex:indexPath.row];
        NSArray *arr = [str componentsSeparatedByString:@"."];
        NSString * newString = [[arr objectAtIndex:1] substringWithRange:NSMakeRange(0, 1)];
        NSString *strSecond = [NSString stringWithFormat:@"%@%@",[arr objectAtIndex:0],KM];
        if ([strSecond isEqualToString:@"0KM"]) {
            NSString *addstr=[NSString stringWithFormat:@"0.%@%@",newString,KM];
            cell.distanceLbl.text=addstr;
        }
        else
            cell.distanceLbl.text=strSecond;
        
        //cell.imgView.layer.masksToBounds=YES;
        
        cell.nameLbl.text=[[dic valueForKey:@"DealTitle"]objectAtIndex:indexPath.row];
        cell.descriptionLbl.text=[[dic valueForKey:@"DealDescription"]objectAtIndex:indexPath.row];
        
        
        
    }
    else {//if(indexPath.section==1){
        cell.callBtn.tag=indexPath.section;
        cell.calenderBtn.tag=indexPath.section;
        cell.likeBtn.tag=indexPath.section;
        [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"heart_icon"] forState:UIControlStateNormal];
        
        if (indexPath.row==0) {
            catwiseDetails=[[categoryDic valueForKey:@"DealList"]objectAtIndex:indexPath.section-1];
            
        }
        BOOL likeStatus = [[[catwiseDetails valueForKey:@"IsLike"]objectAtIndex:0] boolValue];
        if (!likeStatus) {
            
        }
        else{
            [cell.likeBtn  setBackgroundImage:[UIImage imageNamed:@"like-hart"] forState:UIControlStateNormal];
            cell.likeBtn.selected=YES;
        }
        
        NSString *DealId=[[catwiseDetails valueForKey:@"DealId"]objectAtIndex:0];
        if ([[DealGaliInformation sharedInstance].clickedDealForLike rangeOfString:DealId].location == NSNotFound) {
        }
        else{
            [cell.likeBtn  setBackgroundImage:[UIImage imageNamed:@"like-hart"] forState:UIControlStateNormal];
        }
        
        if ([[DealGaliInformation sharedInstance].clickedDealForDisLike rangeOfString:[NSString stringWithFormat:@"NAK_%@",DealId]].location == NSNotFound) {
        }
        else{
            [cell.likeBtn  setBackgroundImage:[UIImage imageNamed:@"heart_icon"] forState:UIControlStateNormal];
        }
        
        
        NSString *path=[[catwiseDetails valueForKey:@"DealImage"]objectAtIndex:0];
        if ([path isKindOfClass:[NSNull class]]) {
            NSString *path = [NSUSERDEFAULTS stringForKey:@"pathDealImage"];
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:path]
                            placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            // cell.imgView.image=[UIImage imageNamed:@"NoDealImage"];
        }
        else
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:path]
                            placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        cell.imgView.contentMode = UIViewContentModeScaleAspectFill;
        cell.imgView.clipsToBounds = YES;
        
        NSString *str=[[catwiseDetails valueForKey:@"DealDistance"]objectAtIndex:0];
        NSArray *arr = [str componentsSeparatedByString:@"."];
        NSString * newString = [[arr objectAtIndex:1] substringWithRange:NSMakeRange(0, 1)];
        NSString *strSecond = [NSString stringWithFormat:@"%@%@",[arr objectAtIndex:0],KM];
        if ([strSecond isEqualToString:@"0KM"]) {
            NSString *addstr=[NSString stringWithFormat:@"0.%@%@",newString,KM];
            cell.distanceLbl.text=addstr;
        }
        else
            cell.distanceLbl.text=strSecond;
        
        //cell.imgView.layer.masksToBounds=YES;
        cell.nameLbl.text=[[catwiseDetails valueForKey:@"DealTitle"]objectAtIndex:0];
        cell.descriptionLbl.text=[[catwiseDetails valueForKey:@"DealDescription"]objectAtIndex:0];
        
    }
    
    
    if (indexPath.row %2==1) {
        static NSString *simpleTableIdentifier = @"Cell1";
        
        EducationTableViewCell *cell = (EducationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.cellFooterBtn.tag=indexPath.section;
        cell.nameLbl.textColor=[UIColor DGPurpleColor];
        cell.nameLbl.font=[UIFont DGTextFieldFont];
        cell.descriptionLbl.textColor=[UIColor DGDarkGrayColor];
        cell.descriptionLbl.font=[UIFont DGTextHome11Font];
        
        if (indexPath.section==0) {
            cell.callBtn.tag=indexPath.section;
            cell.calenderBtn.tag=indexPath.section;
            cell.likeBtn.tag=indexPath.section;
            
            
            [cell.cellFooterBtn setTitle:VIEWALLYOURNEARESTDEALS forState:UIControlStateNormal];
        }
        else
        {
            cell.callBtn.tag=indexPath.section;
            cell.calenderBtn.tag=indexPath.section;
            cell.likeBtn.tag=indexPath.section;
            
            [cell.cellFooterBtn setTitle:[NSString stringWithFormat:@"%@ %@ %@",VEIWALL,[[[categoryDic valueForKey:@"CategoryName"]objectAtIndex:indexPath.section-1] lowercaseString],DEALS] forState:UIControlStateNormal];
            
        }
        [cell.cellFooterBtn addTarget:self action:@selector(sectionFooterTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.callBtn addTarget:self action:@selector(callBackBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.calenderBtn addTarget:self action:@selector(appointmentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.likeBtn addTarget:self action:@selector(likeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.imgView.image = nil;
        
        
        [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"heart_icon"] forState:UIControlStateNormal];
        
        if (indexPath.section==0) {
            
            BOOL likeStatus = [[[dic valueForKey:@"IsLike"]objectAtIndex:indexPath.row] boolValue];
            if (!likeStatus) {
                
            }
            else{
                [cell.likeBtn  setBackgroundImage:[UIImage imageNamed:@"like-hart"] forState:UIControlStateNormal];
                cell.likeBtn.selected=YES;
                
            }
            NSString *DealId=[[dic valueForKey:@"DealId"]objectAtIndex:indexPath.row];
            if ([[DealGaliInformation sharedInstance].clickedDealForLike rangeOfString:DealId].location == NSNotFound) {
            }
            else{
                [cell.likeBtn  setBackgroundImage:[UIImage imageNamed:@"like-hart"] forState:UIControlStateNormal];
            }
            if ([[DealGaliInformation sharedInstance].clickedDealForDisLike rangeOfString:[NSString stringWithFormat:@"NAK_%@",DealId]].location == NSNotFound) {
            }
            else{
                [cell.likeBtn  setBackgroundImage:[UIImage imageNamed:@"heart_icon"] forState:UIControlStateNormal];
            }
            
            
            NSString *path=[[dic valueForKey:@"DealImage"]objectAtIndex:indexPath.row];
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
            NSString *str=[[dic valueForKey:@"DealDistance"]objectAtIndex:indexPath.row];
            NSArray *arr = [str componentsSeparatedByString:@"."];
            NSString * newString = [[arr objectAtIndex:1] substringWithRange:NSMakeRange(0, 1)];
            NSString *strSecond = [NSString stringWithFormat:@"%@%@",[arr objectAtIndex:0],KM];
            if ([strSecond isEqualToString:@"0KM"]) {
                NSString *addstr=[NSString stringWithFormat:@"0.%@%@",newString,KM];
                cell.distanceLbl.text=addstr;
            }
            else
                cell.distanceLbl.text=strSecond;
            
            cell.nameLbl.text=[[dic valueForKey:@"DealTitle"]objectAtIndex:indexPath.row];
            cell.descriptionLbl.text=[[dic valueForKey:@"DealDescription"]objectAtIndex:indexPath.row];
            
            
        }
        
        else {//if(indexPath.section==1){
            if (indexPath.row==1) {
                
                catwiseDetails=[[categoryDic valueForKey:@"DealList"]objectAtIndex:indexPath.section-1];
                
            }
            [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"heart_icon"] forState:UIControlStateNormal];
            
            BOOL likeStatus = [[[catwiseDetails valueForKey:@"IsLike"]objectAtIndex:1] boolValue];
            if (!likeStatus) {
                
            }
            else{
                [cell.likeBtn  setBackgroundImage:[UIImage imageNamed:@"like-hart"] forState:UIControlStateNormal];
                cell.likeBtn.selected=YES;
            }
            NSString *DealId=[[catwiseDetails valueForKey:@"DealId"]objectAtIndex:1];
            if ([[DealGaliInformation sharedInstance].clickedDealForLike rangeOfString:DealId].location == NSNotFound) {
            }
            else{
                [cell.likeBtn  setBackgroundImage:[UIImage imageNamed:@"like-hart"] forState:UIControlStateNormal];
            }
            
            if ([[DealGaliInformation sharedInstance].clickedDealForDisLike rangeOfString:[NSString stringWithFormat:@"NAK_%@",DealId]].location == NSNotFound) {
            }
            else{
                [cell.likeBtn  setBackgroundImage:[UIImage imageNamed:@"heart_icon"] forState:UIControlStateNormal];
            }
            
            
            NSString *path=[[catwiseDetails valueForKey:@"DealImage"]objectAtIndex:1];
            if ([path isKindOfClass:[NSNull class]]) {
                NSString *path = [NSUSERDEFAULTS stringForKey:@"pathDealImage"];
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:path]
                                placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                // cell.imgView.image=[UIImage imageNamed:@"NoDealImage"];
            }
            else
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:path]
                                placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            cell.imgView.contentMode = UIViewContentModeScaleAspectFill;
            cell.imgView.clipsToBounds = YES;
            NSString *str=[[catwiseDetails valueForKey:@"DealDistance"]objectAtIndex:1];
            NSArray *arr = [str componentsSeparatedByString:@"."];
            NSString * newString = [[arr objectAtIndex:1] substringWithRange:NSMakeRange(0, 1)];
            NSString *strSecond = [NSString stringWithFormat:@"%@%@",[arr objectAtIndex:0],KM];
            if ([strSecond isEqualToString:@"0KM"]) {
                NSString *addstr=[NSString stringWithFormat:@"0.%@%@",newString,KM];
                cell.distanceLbl.text=addstr;
            }
            else
                cell.distanceLbl.text=strSecond;
            
            cell.nameLbl.text=[[catwiseDetails valueForKey:@"DealTitle"]objectAtIndex:1];
            cell.descriptionLbl.text=[[catwiseDetails valueForKey:@"DealDescription"]objectAtIndex:1];
        }
        
        
        return cell;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [timer invalidate];
    DealDescriptionViewController *dealDesViewController = [[DealGaliInformation sharedInstance]Storyboard:DEALDESCRIPTIONSTORYBOARD];
    dealDesViewController.screenName=@"home";
    if (indexPath.section==0) {
        NSDictionary *dataDic=[dic objectAtIndex:indexPath.row];
        
        NSString *dealCustomId=   [dataDic valueForKey:@"DealCustomId"];
        
        dealDesViewController.dealCustomId=dealCustomId;
        
    }
    else{
        if (indexPath.row==0) {
            catwiseDetails=[[categoryDic valueForKey:@"DealList"]objectAtIndex:indexPath.section-1];
            dealDesViewController.dealCustomId=[[catwiseDetails valueForKey:@"DealCustomId"]objectAtIndex:0];
        }
        else
            dealDesViewController.dealCustomId=[[catwiseDetails valueForKey:@"DealCustomId"]objectAtIndex:1];
        
    }
    
    if (indexPath.row %2==1) {
        if (indexPath.section==0) {
            dealDesViewController.dealCustomId=[[dic valueForKey:@"DealCustomId"]objectAtIndex:indexPath.row];
            
        }
        else {//if(indexPath.section==1){
            if (indexPath.row==1) {
                catwiseDetails=[[categoryDic valueForKey:@"DealList"]objectAtIndex:indexPath.section-1];
                
                dealDesViewController.dealCustomId=[[catwiseDetails valueForKey:@"DealCustomId"]objectAtIndex:1];
            }
            else
                dealDesViewController.dealCustomId=[[catwiseDetails valueForKey:@"DealCustomId"]objectAtIndex:1];
        }
        
    }
    
    
    [self.navigationController pushViewController:dealDesViewController animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2==1) {
        return 295;
    }
    else
        return 270;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView                  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 15)];
    footerView.backgroundColor      = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:footerView.bounds byRoundingCorners:( UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path  = maskPath.CGPath;
    footerView.layer.mask = maskLayer;
    
    if (section==0) {
        UILabel *headerString           = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 15)];
        headerString.font=[UIFont fontWithName:@"Helvetica-Light" size:23];
        headerString.textAlignment      = NSTextAlignmentCenter;
        NSString *str=[NSString stringWithFormat:@"%@",DEALS];
        headerString.textColor=[UIColor clearColor];
        headerString.text=str;
        [footerView addSubview:headerString];
        
    }
    else{
        UILabel *headerString           = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 15)];
        headerString.font=[UIFont fontWithName:@"Helvetica-Light" size:23];
        headerString.textAlignment      = NSTextAlignmentCenter;
        NSString *str=[NSString stringWithFormat:@"%@ %@",[[categoryDic valueForKey:@"CategoryName"]objectAtIndex:section-1],DEALS];
        str = [str lowercaseString];
        headerString.textColor=[UIColor clearColor];
        headerString.text=str;
        [footerView addSubview:headerString];
    }
    return footerView;
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView                  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    UIView *headerView1                 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 60)];
    
    headerView.tag                   = section;
    headerView1.backgroundColor      = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f];
    headerView.backgroundColor       =[UIColor DGWhiteColor];
    [headerView addSubview:headerView1];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:headerView1.bounds byRoundingCorners:( UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path  = maskPath.CGPath;
    headerView1.layer.mask = maskLayer;
    
    if (section==0) {
        UILabel *headerString1          = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 20)];
        UILabel *headerString           = [[UILabel alloc] initWithFrame:CGRectMake(0, 17, self.view.frame.size.width, 25)];
        headerString.textAlignment      = NSTextAlignmentCenter;
        headerString.text = YOURNEARESTDEALS;
        headerString.font=[UIFont fontWithName:@"Helvetica-Light" size:20];
        NSString *savedValue = [NSString stringWithFormat:@"(%@)",[[NSUserDefaults standardUserDefaults] stringForKey:@"locationAddress"]];
        headerString1.text =savedValue;// @"(Noida sector 16)";
        headerString.textColor          = [UIColor DGPinkColor];
        headerString1.font=[UIFont fontWithName:@"Helvetica Neue" size:14];
        headerString1.textAlignment      = NSTextAlignmentCenter;
        headerString1.textColor          = [UIColor DGPurpleColor];
        [headerView addSubview:headerString];
        [headerView addSubview:headerString1];
    }
    else {
        UILabel *headerString           = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.view.frame.size.width, 25)];
        headerString.font=[UIFont fontWithName:@"Helvetica-Light" size:23];
        headerString.textAlignment      = NSTextAlignmentCenter;
        NSString *str=[NSString stringWithFormat:@"%@ %@",[[categoryDic valueForKey:@"CategoryName"]objectAtIndex:section-1],DEALS];
        str = [str lowercaseString];
        headerString.textColor=[UIColor DGDarkGrayColor];
        headerString.text=str;
        [headerView addSubview:headerString];
        
    }
    
    return headerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 60;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}



#pragma mark - gesture tapped
- (void)sectionFooterTapped:(UIButton *)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:sender.tag];
    // NSDictionary *dataDic=[dic objectAtIndex:indexPath.row];
    DealLiistViewController *dealListViewController = [[DealGaliInformation sharedInstance]Storyboard:DEALLISTSTORYBOARD];
    
    
    if (indexPath.section==0) {
        dealListViewController.ControllerName=@"all";
        dealListViewController.data=dic;
        dealListViewController.alldata=categoryDic;
    }
    else{
        NSString *catid=   [[categoryDic valueForKey:@"CategoryId"]objectAtIndex:indexPath.section-1];
        dealListViewController.value=@"home";
        dealListViewController.index=(int)indexPath.section-1;
        dealListViewController.ControllerName=@"home";
        dealListViewController.indextoid=catid;
        dealListViewController.data=categoryDic;
    }
    [self.navigationController pushViewController:dealListViewController animated:YES];
    
}


- (IBAction)viewAllDealAction:(id)sender {
    DealLiistViewController *dealListViewController = [[DealGaliInformation sharedInstance]Storyboard:DEALLISTSTORYBOARD];
    dealListViewController.ControllerName=@"all";
    dealListViewController.value=@"home";
    //dealListViewController.data=dic;
    dealListViewController.alldata=categoryDic;
    
    [self.navigationController pushViewController:dealListViewController animated:YES];
    
}

- (IBAction)viewAllAction:(id)sender {
    //self.viewAllBtn.hidden=YES;
    if ([categoryDic count]>6 && [categoryDic count]<10) {
        self.catCollHeight.constant=280;
        self.upperViewHt.constant=510;
        self.tableTop.constant=10;
        self.buttomViewTop.constant=10;
        [self.view layoutIfNeeded];
        self.viewAllBtn.hidden=YES;
    }
    else if ([categoryDic count]>9 && [categoryDic count]<13) {
        self.catCollHeight.constant=420;
        self.upperViewHt.constant=650;
        self.tableTop.constant=10;
        self.buttomViewTop.constant=10;
        [self.view layoutIfNeeded];
        self.viewAllBtn.hidden=YES;
    }
    
    else{
        [[DealGaliInformation sharedInstance]showAlertWithMessage:MOREDEALSNOTAVAIL withTitle:nil withCancelTitle:OK];
    }
}
-(void) callAftertenySecond:(NSTimer*)time
{
    
    if (start<[imgdic count]) {
        myIP=[NSIndexPath indexPathForRow:start inSection:0];
        start=start+1;
    }
    else{
        start=0;
        
    }
    
    [self.imgScrollCollView scrollToItemAtIndexPath:myIP atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
}

- (IBAction)appointmentBtnAction:(UIButton*)sender {
    AppointmentViewController *appointmentVC=[[DealGaliInformation sharedInstance]Storyboard:APPOINTMENTSTORYBOARD];
    appointmentVC.companyPage=@"appointmentVC";
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath1 = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexPath1.row inSection:sender.tag];
    if (indexPath.section==0) {
        NSDictionary *dataDic=[dic objectAtIndex:indexPath.row];
        appointmentVC.CustomId=   [dataDic valueForKey:@"DealId"];
        appointmentVC.currentPageURL=[dataDic valueForKey:@"DealUrl"];
        appointmentVC.DealCompanyLogo=[dataDic valueForKey:@"DealCompanyLogo"];
        appointmentVC.DealTitle=[dataDic valueForKey:@"DealTitle"];
    }
    else{
        if (indexPath.row==0) {
            catwiseDetails=[[categoryDic valueForKey:@"DealList"]objectAtIndex:indexPath.section-1];
            appointmentVC.CustomId=   [[catwiseDetails valueForKey:@"DealId"]objectAtIndex:0];
            appointmentVC.currentPageURL=   [[catwiseDetails valueForKey:@"DealUrl"]objectAtIndex:0];
            appointmentVC.DealCompanyLogo=[[catwiseDetails valueForKey:@"DealCompanyLogo"]objectAtIndex:0];
            appointmentVC.DealTitle=[[catwiseDetails valueForKey:@"DealTitle"]objectAtIndex:0];
            
        }
        else{
            appointmentVC.CustomId=   [[catwiseDetails valueForKey:@"DealId"]objectAtIndex:1];
            appointmentVC.currentPageURL=   [[catwiseDetails valueForKey:@"DealUrl"]objectAtIndex:1];
            appointmentVC.DealCompanyLogo=[[catwiseDetails valueForKey:@"DealCompanyLogo"]objectAtIndex:1];
            appointmentVC.DealTitle=[[catwiseDetails valueForKey:@"DealTitle"]objectAtIndex:1];
            
        }
    }
    
    if (indexPath.row %2==1) {
        if (indexPath.section==0) {
            appointmentVC.CustomId=   [[dic valueForKey:@"DealId"]objectAtIndex:indexPath.row];
            appointmentVC.currentPageURL=   [[dic valueForKey:@"DealUrl"]objectAtIndex:indexPath.row];
            appointmentVC.DealCompanyLogo=[[dic valueForKey:@"DealCompanyLogo"]objectAtIndex:indexPath.row];
            appointmentVC.DealTitle=[[dic valueForKey:@"DealTitle"]objectAtIndex:indexPath.row];
            
        }
        else {//if(indexPath.section==1){
            if (indexPath.row==1) {
                catwiseDetails=[[categoryDic valueForKey:@"DealList"]objectAtIndex:indexPath.section-1];
                appointmentVC.CustomId=   [[catwiseDetails valueForKey:@"DealId"]objectAtIndex:1];
                appointmentVC.currentPageURL=   [[catwiseDetails valueForKey:@"DealUrl"]objectAtIndex:1];
                appointmentVC.DealCompanyLogo=[[catwiseDetails valueForKey:@"DealCompanyLogo"]objectAtIndex:1];
                appointmentVC.DealTitle=[[catwiseDetails valueForKey:@"DealTitle"]objectAtIndex:1];
            }
            else{
                appointmentVC.CustomId=   [[catwiseDetails valueForKey:@"DealId"]objectAtIndex:1];
                appointmentVC.currentPageURL=   [[catwiseDetails valueForKey:@"DealUrl"]objectAtIndex:1];
                appointmentVC.DealCompanyLogo=[[catwiseDetails valueForKey:@"DealCompanyLogo"]objectAtIndex:1];
                appointmentVC.DealTitle=[[catwiseDetails valueForKey:@"DealTitle"]objectAtIndex:1];
            }
        }
    }
    [self.navigationController pushViewController:appointmentVC animated:YES];
}


- (IBAction)callBackBtnAction:(UIButton*)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath1 = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexPath1.row inSection:sender.tag];
    
    CallBackViewController *callVC=[[DealGaliInformation sharedInstance]Storyboard:CALLBACKSTORYBOARD];
    
    if (indexPath.section==0) {
        NSDictionary *dataDic=[dic objectAtIndex:indexPath.row];
        callVC.CustomId=   [dataDic valueForKey:@"DealId"];
        callVC.currentPageURL=[dataDic valueForKey:@"DealUrl"];
        callVC.DealCompanyLogo=[dataDic valueForKey:@"DealCompanyLogo"];
        callVC.DealTitle=[dataDic valueForKey:@"DealTitle"];
    }
    else{
        if (indexPath.row==0) {
            catwiseDetails=[[categoryDic valueForKey:@"DealList"]objectAtIndex:indexPath.section-1];
            callVC.CustomId=   [[catwiseDetails valueForKey:@"DealId"]objectAtIndex:0];
            callVC.currentPageURL=   [[catwiseDetails valueForKey:@"DealUrl"]objectAtIndex:0];
            callVC.DealCompanyLogo=[[catwiseDetails valueForKey:@"DealCompanyLogo"]objectAtIndex:0];
            callVC.DealTitle=[[catwiseDetails valueForKey:@"DealTitle"]objectAtIndex:0];
            
        }
        else{
            callVC.CustomId=   [[catwiseDetails valueForKey:@"DealId"]objectAtIndex:1];
            callVC.currentPageURL=   [[catwiseDetails valueForKey:@"DealUrl"]objectAtIndex:1];
            callVC.DealCompanyLogo=[[catwiseDetails valueForKey:@"DealCompanyLogo"]objectAtIndex:1];
            callVC.DealTitle=[[catwiseDetails valueForKey:@"DealTitle"]objectAtIndex:1];
        }
    }
    
    if (indexPath.row %2==1) {
        if (indexPath.section==0) {
            callVC.CustomId=   [[dic valueForKey:@"DealId"]objectAtIndex:indexPath.row];
            callVC.currentPageURL=   [[dic valueForKey:@"DealUrl"]objectAtIndex:indexPath.row];
            callVC.DealCompanyLogo=[[dic valueForKey:@"DealCompanyLogo"]objectAtIndex:indexPath.row];
            callVC.DealTitle=[[dic valueForKey:@"DealTitle"]objectAtIndex:indexPath.row];
            
        }
        else {//if(indexPath.section==1){
            if (indexPath.row==1) {
                catwiseDetails=[[categoryDic valueForKey:@"DealList"]objectAtIndex:indexPath.section-1];
                callVC.CustomId=   [[catwiseDetails valueForKey:@"DealId"]objectAtIndex:1];
                callVC.currentPageURL=   [[catwiseDetails valueForKey:@"DealUrl"]objectAtIndex:1];
                callVC.DealCompanyLogo=[[catwiseDetails valueForKey:@"DealCompanyLogo"]objectAtIndex:1];
                callVC.DealTitle=[[catwiseDetails valueForKey:@"DealTitle"]objectAtIndex:1];
            }
            else{
                callVC.CustomId=   [[catwiseDetails valueForKey:@"DealId"]objectAtIndex:1];
                callVC.currentPageURL=   [[catwiseDetails valueForKey:@"DealUrl"]objectAtIndex:1];
                callVC.DealCompanyLogo=[[catwiseDetails valueForKey:@"DealCompanyLogo"]objectAtIndex:1];
                callVC.DealTitle=[[catwiseDetails valueForKey:@"DealTitle"]objectAtIndex:1];
            }
        }
    }
    
    [self.navigationController pushViewController:callVC animated:YES];
}
- (IBAction)likeBtnAction:(UIButton*)sender {
    sender.selected  = ! sender.selected;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath1 = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexPath1.row inSection:sender.tag];
    int likeStatus;
    NSString *dealCustomId=@"";
    EducationTableViewCell *cell = (EducationTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    
    if (sender.selected)
    {
        [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"like-hart"] forState:UIControlStateSelected];
        
        likeStatus=1;
    }
    else
    {
        [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"heart_icon"] forState:UIControlStateNormal];
        likeStatus=0;
    }
    
    
    //get customdealid
    
    NSString *str=[DealGaliInformation sharedInstance].clickedDealForLike;
    
    
    if (indexPath.section==0) {
        NSDictionary *dataDic=[dic objectAtIndex:indexPath.row];
        dealCustomId=   [dataDic valueForKey:@"DealId"];
        if(likeStatus==1){
            str=[str stringByAppendingString:[NSString stringWithFormat:@"%@",dealCustomId]];
        }
        else{
            str= [str stringByReplacingOccurrencesOfString:dealCustomId withString:@""];
        }
    }
    else{
        if (indexPath.row==0) {
            catwiseDetails=[[categoryDic valueForKey:@"DealList"]objectAtIndex:indexPath.section-1];
            dealCustomId=   [[catwiseDetails valueForKey:@"DealId"]objectAtIndex:0];
            if(likeStatus==1){
                str=[str stringByAppendingString:[NSString stringWithFormat:@"%@",dealCustomId]];
            }
            else{
                str= [str stringByReplacingOccurrencesOfString:dealCustomId withString:@""];
            }
        }
        else{
            dealCustomId=   [[catwiseDetails valueForKey:@"DealId"]objectAtIndex:1];
            if(likeStatus==1){
                str=[str stringByAppendingString:[NSString stringWithFormat:@"%@",dealCustomId]];
            }
            else{
                str= [str stringByReplacingOccurrencesOfString:dealCustomId withString:@""];
            }
        }
    }
    
    if (indexPath.row %2==1) {
        if (indexPath.section==0) {
            dealCustomId=   [[dic valueForKey:@"DealId"]objectAtIndex:indexPath.row];
            if(likeStatus==1){
                str=[str stringByAppendingString:[NSString stringWithFormat:@"%@",dealCustomId]];
            }
            else{
                str= [str stringByReplacingOccurrencesOfString:dealCustomId withString:@""];
            }
        }
        else {//if(indexPath.section==1){
            if (indexPath.row==1) {
                catwiseDetails=[[categoryDic valueForKey:@"DealList"]objectAtIndex:indexPath.section-1];
                dealCustomId=   [[catwiseDetails valueForKey:@"DealId"]objectAtIndex:1];
                if(likeStatus==1){
                    str=[str stringByAppendingString:[NSString stringWithFormat:@"%@",dealCustomId]];
                }
                else{
                    str= [str stringByReplacingOccurrencesOfString:dealCustomId withString:@""];
                }
            }
            else{
                dealCustomId=   [[catwiseDetails valueForKey:@"DealId"]objectAtIndex:1];
                if(likeStatus==1){
                    str=[str stringByAppendingString:[NSString stringWithFormat:@"%@",dealCustomId]];
                }
                else{
                    str= [str stringByReplacingOccurrencesOfString:dealCustomId withString:@""];
                }
            }
        }
    }
    
    [DealGaliInformation sharedInstance].clickedDealForLike=str;
    // NSLog(@"%@",[DealGaliInformation sharedInstance].clickedDealForLike);
    
    /*
     if (indexPath.section==0) {
     if (indexPath.row==0) {
     NSDictionary *dataDic=[dic objectAtIndex:0];
     dealCustomId=   [dataDic valueForKey:@"DealId"];
     }
     else{
     NSDictionary *dataDic=[dic objectAtIndex:1];
     dealCustomId=   [dataDic valueForKey:@"DealId"];
     }
     }
     else{
     if (indexPath.row==0) {
     NSDictionary *dataDic=[dic objectAtIndex:0];
     dealCustomId=   [dataDic valueForKey:@"DealId"];
     }
     else{
     NSDictionary *dataDic=[dic objectAtIndex:1];
     dealCustomId=   [dataDic valueForKey:@"DealId"];
     }
     }
     */
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
    NSString *deviceID = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceID"];
    
    [[DealGaliNetworkEngine sharedInstance]SetShowCaseLikeAPI:userID deviceId:deviceID dealId:dealCustomId likeStatus:likeStatus withCallback:^(NSDictionary *response) {
        
    }];
    //[self.tableView reloadData];
    
}

- (IBAction)addMSMEAction:(id)sender {
    SearchAndAddMSME *addMSMEVC = [[SearchAndAddMSME alloc] init];
    [self.navigationController pushViewController:addMSMEVC animated:YES];
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
