//
//  NotificationViewController.m
//  DealGali
//
//  Created by Virinchi Software on 21/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "NotificationViewController.h"
#import "DealGaliNetworkEngine.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Notification", nil);
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    [self getData];
    //  self.title = NSLocalizedString(@"Notifications", nil);
    // Do any additional setup after loading the view.
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    
    
    UIButton *a1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [a1 setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [a1 addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [a1 setImage:[UIImage imageNamed:@"Search.png"] forState:UIControlStateNormal];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:a1];
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
    UIBarButtonItem * revealButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo.png"]]];
    self.navigationItem.leftBarButtonItems = @[revealButtonItem,revealButtonItem1];
    
}
- (void)refresh:(id)sender{
    // do your refresh here and reload the tablview
    [self getRefreshedData];
}
-(void)getRefreshedData{
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
    [[DealGaliNetworkEngine sharedInstance]GetUserDealNotificationAPI:userId withCallback:^(NSDictionary *response) {
        notificationArr=[response objectForKey:@"DealList"];
        
        [self.tableView reloadData];
        [refreshControl endRefreshing];
    }];
    
}

-(void)getData{
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
    [[DealGaliInformation sharedInstance]ShowWaiting:Loading];
    [[DealGaliNetworkEngine sharedInstance]GetUserDealNotificationAPI:userId/*@"U3439"*/ withCallback:^(NSDictionary *response) {
        notificationArr=[response objectForKey:@"DealList"];
        if ([notificationArr count]==0) {
            self.tableView.hidden=YES;
        }
        [[DealGaliInformation sharedInstance]HideWaiting];
        
        [self.tableView reloadData];
        
    }];
    
}
-(void)previousecall{
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

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [notificationArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Notification";
    
    NotificationTableViewCell *cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *imagView = (UIImageView *)[cell viewWithTag:100];
    UILabel *headingLbl = (UILabel *)[cell viewWithTag:101];
    UILabel *decLbl = (UILabel *)[cell viewWithTag:102];
    UILabel *timeLbl = (UILabel *)[cell viewWithTag:103];
    headingLbl.textColor=[UIColor DGBlackColor];
    headingLbl.font=[UIFont DGHeadingNotifiFont];
    decLbl.textColor=[UIColor DGDarkGrayColor];
    decLbl.font=[UIFont DGTextHome12Font];
    timeLbl.textColor=[UIColor DGLightGrayColor];
    timeLbl.font=[UIFont DGTextHome11Font];
    
    
    NSString *path=[[notificationArr valueForKey:@"CompanyLogo"]objectAtIndex:indexPath.section];
    [imagView sd_setImageWithURL:[NSURL URLWithString:path]
                placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    imagView.contentMode = UIViewContentModeScaleAspectFill;
    imagView.clipsToBounds = YES;
    
    NSString *text = [[[notificationArr valueForKey:@"CompanyName"]objectAtIndex:indexPath.section] capitalizedString];
    
    headingLbl.text=text;//[[notificationArr valueForKey:@"CompanyName"]objectAtIndex:indexPath.section];
    NSString *decStr=[[notificationArr valueForKey:@"DealAttractiveLine"]objectAtIndex:indexPath.section];
    if ([decStr isKindOfClass:[NSNull class]]) {
        
    }
    else{
        decLbl.text=decStr;
    }
    timeLbl.text=[[notificationArr valueForKey:@"DealCreatedOn"]objectAtIndex:indexPath.section];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDic=[notificationArr objectAtIndex:indexPath.section];
    
    NSString *dealCustomId=   [dataDic valueForKey:@"DealCustomId"];
    DealDescriptionViewController *dealDesViewController = [[DealGaliInformation sharedInstance]Storyboard:DEALDESCRIPTIONSTORYBOARD];
    dealDesViewController.dealCustomId=dealCustomId;
    [self.navigationController pushViewController:dealDesViewController animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    return 10;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView                = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    UIView *headerView1                = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 10)];
    headerView.backgroundColor       =[UIColor whiteColor];
    headerView1.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f];
    
    [headerView addSubview:headerView1];
    return headerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 10;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


@end
