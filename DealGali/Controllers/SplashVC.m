//
//  SplashVC.m
//  DealGali
//
//  Created by Virinchi Software on 09/06/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "SplashVC.h"
#import "DealGaliInformation.h"
#import "DealGaliNetworkEngine.h"
#import "HomeViewController.h"
#import "Reachability.h"

@interface SplashVC ()

@end

@implementation SplashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [DealGaliInformation sharedInstance].clickedDealForLike=@"";
    [DealGaliInformation sharedInstance].clickedDealForDisLike=@"";
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if (result.height == 480) {
            // 3.5 inch display - iPhone 4S and below
            NSLog(@"Device is an iPhone 4S or below");
            self.imgView.image=[UIImage imageNamed:@"splashVC.png"];
        }
        
        else if (result.height == 568) {
            // 4 inch display - iPhone 5
            NSLog(@"Device is an iPhone 5/S/C");
            self.imgView.image=[UIImage imageNamed:@"splashVC.png"];
        }
        
        else if (result.height == 667) {
            // 4.7 inch display - iPhone 6
            NSLog(@"Device is an iPhone 6");//splashPhone6
            self.imgView.image=[UIImage imageNamed:@"splashPhone6.png"];
        }
        
        else if (result.height == 736) {
            // 5.5 inch display - iPhone 6 Plus
            NSLog(@"Device is an iPhone 6 Plus");
            self.imgView.image=[UIImage imageNamed:@"splashPhone6.png"];
            
        }
    }
    
    else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // iPad 9.7 or 7.9 inch display.
        NSLog(@"Device is an iPad.");
        self.imgView.image=[UIImage imageNamed:@"splashPhone6.png"];
        
    }
    
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.clipsToBounds = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    
    BOOL avail= [[DealGaliInformation sharedInstance] networkReachability];
    
    if (avail) {
        NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
        if ([savedValue isKindOfClass:[NSNull class]] || ([savedValue length]==0)) {
            //facebook logout
            [FBSession.activeSession closeAndClearTokenInformation];
            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
            [login logOut];
            //google logout
            [[GIDSignIn sharedInstance] signOut];
            UIViewController *Roottocontroller;
            
            NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"Status"];
            savedValue=@"2";
            [[NSUserDefaults standardUserDefaults] setObject:savedValue forKey:@"Status"];
            LoginViewController *loginViewController = [[DealGaliInformation sharedInstance]Storyboard:LOGINSTORYBOARDID];
            Roottocontroller=loginViewController;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
            [navController setViewControllers: @[Roottocontroller] animated: YES];
            
            [self.revealViewController setFrontViewController:navController];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
            
        }
        else
            [self getallDealList];
        
    }
    else{
        [NSTimer scheduledTimerWithTimeInterval:0.0
                                         target:self
                                       selector:@selector(handleTimer:)
                                       userInfo:nil repeats:NO];
    }
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    
    self.revealViewController.panGestureRecognizer.enabled=NO;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    
    self.revealViewController.panGestureRecognizer.enabled=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getallDealList{
    NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
    NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
    NSString *UniqueUserId = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
    [[DealGaliNetworkEngine sharedInstance] homeAPI:lat lon:lon UserId:UniqueUserId  withCallback:^(NSDictionary *response) {
        arrDealList=[response objectForKey:@"DealList"];
        [NSUSERDEFAULTS setObject:[NSKeyedArchiver archivedDataWithRootObject:response] forKey:@"ALLDEALLIST"];
        [NSUSERDEFAULTS synchronize];
        [self getSearchData];
        
    }];
    
}

-(void)getSearchData{
    NSString *UniqueUserId = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
    [[DealGaliNetworkEngine sharedInstance] GetSearchListNewAPI:@"" UserId:UniqueUserId withCallback:^(NSDictionary *response) {
        NSArray *arr=[response objectForKey:@"SearchData"];
        [NSUSERDEFAULTS setObject:[NSKeyedArchiver archivedDataWithRootObject:arr] forKey:@"SEARCHDATA"];
        [NSUSERDEFAULTS synchronize];
        [self getData];
        
    }];
    
}

-(void)getData{
    NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
    NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
    NSString *dealid1=[[arrDealList valueForKey:@"DealId"]objectAtIndex:0];
    NSString *dealid2=[[arrDealList valueForKey:@"DealId"]objectAtIndex:1];
    NSString *UniqueUserId = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
    [[DealGaliNetworkEngine sharedInstance] GetHomeDetailAPI:lat lon:lon DealId1:dealid1 DealId2:dealid2 UserId:UniqueUserId    withCallback:^(NSDictionary *response) {
        
        [NSUSERDEFAULTS setObject:[NSKeyedArchiver archivedDataWithRootObject:response] forKey:@"HOMEDATA"];
        [NSUSERDEFAULTS synchronize];
        
        [self getDefaultImage];
    }];
    
}
-(void)getDefaultImage{
    
    [[DealGaliNetworkEngine sharedInstance]GetDefaultImageAPI:@"" withCallback:^(NSDictionary *response) {
        
        NSArray *data=[response objectForKey:@"SearchData"];
        
        NSString *pathUserProfile=[[data valueForKey:@"ImageUrl"]objectAtIndex:0];
        NSString *pathCompanyLogo=[[data valueForKey:@"ImageUrl"]objectAtIndex:1];
        NSString *pathDealImage=[[data valueForKey:@"ImageUrl"]objectAtIndex:2];
        [NSUSERDEFAULTS setObject:pathUserProfile forKey:@"pathUserProfile"];
        [NSUSERDEFAULTS setObject:pathCompanyLogo forKey:@"pathCompanyLogo"];
        [NSUSERDEFAULTS setObject:pathDealImage forKey:@"pathDealImage"];
        
        [NSUSERDEFAULTS synchronize];
        [self getCat];
        
    }];
}

-(void)getCat{
    NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
    NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
    NSString *dealid1=[[arrDealList valueForKey:@"DealId"]objectAtIndex:0];
    NSString *dealid2=[[arrDealList valueForKey:@"DealId"]objectAtIndex:1];
    NSString *UniqueUserId = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
    
    [[DealGaliNetworkEngine sharedInstance] GetHomeDetailAPI:lat lon:lon DealId1:dealid1 DealId2:dealid2 UserId:UniqueUserId withCallback:^(NSDictionary *response) {
        NSArray *catresArr=[response objectForKey:@"CategoryData"];
        NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Priority" ascending:YES comparator:^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        NSArray *categoryDic = [NSMutableArray arrayWithArray:[catresArr sortedArrayUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]]];
        [NSUSERDEFAULTS setObject:[NSKeyedArchiver archivedDataWithRootObject:categoryDic] forKey:@"CATEGORIES"];
        
        NSArray *msmeCat=[response objectForKey:@"MSMECategoryData"];
        [NSUSERDEFAULTS setObject:[NSKeyedArchiver archivedDataWithRootObject:msmeCat] forKey:@"MSMECATEGORIES"];
        [NSUSERDEFAULTS synchronize];
        
        [NSTimer scheduledTimerWithTimeInterval:0.0
                                         target:self
                                       selector:@selector(handleTimer:)
                                       userInfo:nil repeats:NO];
        
    }];
}

- (void)handleTimer:(NSTimer*)theTimer {
    UIViewController *Roottocontroller;
    HomeViewController *homeViewController = [[DealGaliInformation sharedInstance]Storyboard:HOMESTORYBOARDID];
    Roottocontroller=homeViewController;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
    [navController setViewControllers: @[Roottocontroller] animated: YES];
    
    [self.revealViewController setFrontViewController:navController];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    // homeViewController.responceData=theTimer.userInfo;
    //    RearViewController *rearViewController = [[DealGaliInformation sharedInstance]Storyboard:REARSTORYBOARDID];
    //
    //    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    //    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    //
    //    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    //    revealController.delegate = self;
    //    [self.navigationController presentViewController:revealController animated:NO completion:nil];
    //    self.viewController = revealController;
    
    
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
