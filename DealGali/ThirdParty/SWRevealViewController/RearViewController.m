

#import "RearViewController.h"
#import <FacebookSDK/FacebookSDK.h>


@interface RearViewController()
{
    NSInteger _presentedRow;
}

@end

@implementation RearViewController

@synthesize rearTableView = _rearTableView;


#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lblArr=[[NSArray alloc]initWithObjects:@"Home",@"MyGali",@"Add Seller",@"Post Requirement",@"Notification",@"About Us",@"Log Out", nil];
    imgArray=[[NSArray alloc]initWithObjects:@"Home",@"MyGali",@"addBtn",@"PostRequirement",@"Settings",@"about-us",@"LogOut", nil];
   // _rearTableView.backgroundColor=[UIColor colorWithRed:45/255.0f green:45/255.0f blue:45/255.0f alpha:1.0f];
   // self.title = NSLocalizedString(@"Rear View", nil);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getImage];
    [self.rearTableView reloadData];
    [self.navigationController setNavigationBarHidden:YES];   //it hides
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];    // it shows
}

#pragma marl - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [lblArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor=[UIColor whiteColor];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    UIImageView *myImageView = (UIImageView *)[cell viewWithTag:100];
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    UILabel *freeLbl = (UILabel *)[cell viewWithTag:1001];
    if (indexPath.row==2) {
//        label.frame=CGRectMake(label.frame.origin.x, label.frame.origin.y-5, label.frame.size.width, label.frame.size.height);
        freeLbl.hidden=NO;
    }else{
        freeLbl.hidden=YES;
    }
    
    
    myImageView.image=[UIImage imageNamed:[imgArray objectAtIndex:indexPath.row]];
    //cell.textLabel.textColor=[UIColor whiteColor];
    label.text = [lblArr objectAtIndex:indexPath.row];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 130)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 120)];
   
    //imageView.image=[UIImage imageNamed:@"back-ground-image-navigation-drawer"];
    imageView.backgroundColor=[UIColor blackColor];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(85, 55, 160, 20)];
    [label setFont:[UIFont DGActionButtonFont]];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(85, 75, 150, 30)];
    [label1 setFont:[UIFont DGTextViewFont]];
    label1.numberOfLines=2;
    label1.textColor=[UIColor whiteColor];
    label.textColor=[UIColor DGPurpleColor];

    
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 45, 60, 60)] ;
    imgView.layer.cornerRadius = imgView.frame.size.width / 2;
    imgView.layer.borderColor=[UIColor DGLightGrayColor].CGColor;
    imgView.layer.borderWidth=1.0;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    //        [NSUSERDEFAULTS setObject:@"PROFILE" forKey:@"PROFILE"];
    NSString *PROFILE = [NSUSERDEFAULTS stringForKey:@"PROFILE"];

    if ([PROFILE isEqualToString:@"PROFILE"]) {
        NSData *imgData = [[NSUserDefaults standardUserDefaults] dataForKey:@"ProfileImage"];
        UIImage *image = [[UIImage alloc]initWithData:imgData];
        
        if (image==nil) {
            NSString *path=[imagDic valueForKey:@"UserProfilePic"];
            
            if (path.length==0) {
                NSString *path = [NSUSERDEFAULTS stringForKey:@"pathUserProfile"];
                [imgView sd_setImageWithURL:[NSURL URLWithString:path]
                           placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

                //imgView.image=[UIImage imageNamed:@"profileImg"];
            }
            else{
                [imgView sd_setImageWithURL:[NSURL URLWithString:path]
                           placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                imgView.contentMode = UIViewContentModeScaleAspectFill;
                imgView.clipsToBounds = YES;
                NSData *imageData = UIImagePNGRepresentation(imgView.image);
                
                [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"ProfileImage"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
        }
        else
            imgView.image=image;
        
    }
    else{
        NSString *path = [NSUSERDEFAULTS stringForKey:@"ProfileImagePath"];
        
        if (path.length==0) {
            NSString *path = [NSUSERDEFAULTS stringForKey:@"pathUserProfile"];
            [imgView sd_setImageWithURL:[NSURL URLWithString:path]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

            //imgView.image=[UIImage imageNamed:@"profileImg"];
        }
        else{
            [imgView sd_setImageWithURL:[NSURL URLWithString:path]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            
        }
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
 }
    
   
      //  NSString *path=[imagDic valueForKey:@"UserProfilePic"];
    
//    imgView.layer.cornerRadius = imgView.frame.size.width / 2;
//    imgView.clipsToBounds = YES;
//    NSString *path=[imagDic valueForKey:@"UserProfilePic"];
//    [imgView sd_setImageWithURL:[NSURL URLWithString:path]
//                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
//    imgView.contentMode = UIViewContentModeScaleAspectFill;
//    imgView.clipsToBounds = YES;
////    NSData *imgData = [[NSUserDefaults standardUserDefaults] dataForKey:@"ProfileImage"];
////    UIImage *image = [[UIImage alloc]initWithData:imgData];
//    if (imgView.image==nil) {
//        imgView.image=[UIImage imageNamed:@"profileImg"];
//    }
//    else
//        imgView.image=imgView.image;
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"locationAddress"];//[[NSUserDefaults standardUserDefaults] stringForKey:@"UserMobileNumber"];
     NSString *savedValue1 = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
    
    label.text=savedValue1;
    label1.text=savedValue;

    [view addSubview:label];
    [view addSubview:label1];
    [view addSubview:imgView];
    [view setBackgroundColor:[UIColor blackColor]];
    //[view setBackgroundColor:[UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1.0]];
    
    UITapGestureRecognizer *singleTapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandler:)] ;
    [singleTapRecogniser setDelegate:self];
    singleTapRecogniser.numberOfTouchesRequired = 1;
    singleTapRecogniser.numberOfTapsRequired = 1;
    [view addGestureRecognizer:singleTapRecogniser];
    return view;
}
- (void) gestureHandler:(UIGestureRecognizer *)gestureRecognizer{
        UIViewController *Roottocontroller;
    
        ProfileViewController *profileVC = [[DealGaliInformation sharedInstance]Storyboard:PROFILESTORYBOARDID];
        Roottocontroller=profileVC;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
    [navController setViewControllers: @[Roottocontroller] animated: YES];
    
    [self.revealViewController setFrontViewController:navController];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 130;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UIViewController *Roottocontroller;
    
    if (indexPath.row==0) {
//        NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
//        NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
//        [[DealGaliNetworkEngine sharedInstance] GetHomeDetailAPI:lat lon:lon withCallback:^(NSDictionary *response) {
        [NSTimer scheduledTimerWithTimeInterval:0.0
                                         target:self
                                            selector:@selector(handleTimer:)
                                            userInfo:nil repeats:NO];
       // }];
        
    }
    else if (indexPath.row==1) {
//        NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
//        NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
//        
//        [[DealGaliNetworkEngine sharedInstance] GetHomeDetailAPI:lat lon:lon withCallback:^(NSDictionary *response) {
//            NSArray *catresArr=[response objectForKey:@"CategoryData"];
//            NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Priority" ascending:YES comparator:^(id obj1, id obj2) {
//                
//                if ([obj1 integerValue] > [obj2 integerValue]) {
//                    return (NSComparisonResult)NSOrderedDescending;
//                }
//                if ([obj1 integerValue] < [obj2 integerValue]) {
//                    return (NSComparisonResult)NSOrderedAscending;
//                }
//                return (NSComparisonResult)NSOrderedSame;
//            }];
//            categoryDic = [NSMutableArray arrayWithArray:[catresArr sortedArrayUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]]];
//            [NSTimer scheduledTimerWithTimeInterval:1.5
//                                             target:self
//                                           selector:@selector(mygali:)
//                                           userInfo:categoryDic repeats:NO];
//            
//        }];
        NSData *data = [NSUSERDEFAULTS objectForKey:@"CATEGORIES"];
       categoryDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        //categoryDic = [[NSDictionary alloc] initWithDictionary:retrievedDictionary];
        UIViewController *Roottocontroller;
        DealLiistViewController *dealListViewController = [[DealGaliInformation sharedInstance]Storyboard:DEALLISTSTORYBOARD];
        
        dealListViewController.ControllerName=@"all";
        dealListViewController.data=dic;
        dealListViewController.alldata=categoryDic;
        Roottocontroller=dealListViewController;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
        [navController setViewControllers: @[Roottocontroller] animated: YES];
        
        [self.revealViewController setFrontViewController:navController];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
       // [self.navigationController presentViewController:navController animated:NO completion:nil];
        
        
    }
    else if (indexPath.row==2) {
        SearchAndAddMSME *addMSMEVC = [[SearchAndAddMSME alloc] init];
        addMSMEVC.value=@"SideBar";
        Roottocontroller=addMSMEVC;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
        [navController setViewControllers: @[Roottocontroller] animated: YES];
        
        [self.revealViewController setFrontViewController:navController];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        
        
    }

    else if (indexPath.row==3) {
        PostRequirementViewController *postViewController = [[DealGaliInformation sharedInstance]Storyboard:POSTREQUIREMETSTORYBOARD];
        Roottocontroller=postViewController;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
        [navController setViewControllers: @[Roottocontroller] animated: YES];
        
        [self.revealViewController setFrontViewController:navController];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        
        
    }

    else if (indexPath.row==4) {
        NotificationViewController *notificationViewController = [[DealGaliInformation sharedInstance]Storyboard:NOTIFICATIONSTORYBOARD];
        Roottocontroller=notificationViewController;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
        [navController setViewControllers: @[Roottocontroller] animated: YES];
        
        [self.revealViewController setFrontViewController:navController];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        
        
    }
    else if (indexPath.row==5) {
        AboutUSViewController *aboutViewController = [[DealGaliInformation sharedInstance]Storyboard:ABOUTUSSTORYBOARD];
        Roottocontroller=aboutViewController;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
        [navController setViewControllers: @[Roottocontroller] animated: YES];
        
        [self.revealViewController setFrontViewController:navController];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        
        
    }

    else {
        //facebook logout
        [FBSession.activeSession closeAndClearTokenInformation];
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
      //google logout
        [[GIDSignIn sharedInstance] signOut];
        
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
   
}
-(void)getImage{
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
    
    [[DealGaliNetworkEngine sharedInstance] GetUserProfileAPI:savedValue withCallback:^(NSDictionary *response) {
        imagDic=[response objectForKey:@"STATUS"];
        [NSUSERDEFAULTS setObject:[NSKeyedArchiver archivedDataWithRootObject:imagDic] forKey:@"USERDETAILS"];
        [NSUSERDEFAULTS synchronize];
        [self.rearTableView reloadData];
        
    }];
}
//-(void)getData{
//    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
//    
//    [[DealGaliNetworkEngine sharedInstance] GetUserProfileAPI:savedValue withCallback:^(NSDictionary *response) {
//        dic=[response objectForKey:@"STATUS"];
//        [NSUSERDEFAULTS setObject:[NSKeyedArchiver archivedDataWithRootObject:dic] forKey:@"USERDETAILS"];
//        [NSUSERDEFAULTS synchronize];
//    }];
//}
//-(void)getData{
//    
//    NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
//    NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
//    [[DealGaliNetworkEngine sharedInstance] homeAPI:lat lon:lon withCallback:^(NSDictionary *response) {
//        dic=[response objectForKey:@"DealList"];
//        
//        
//    }];
//}

- (void)mygali:(NSTimer*)theTimer {
    
}
- (void)handleTimer:(NSTimer*)theTimer {
    UIViewController *Roottocontroller;
    HomeViewController *homeViewController = [[DealGaliInformation sharedInstance]Storyboard:HOMESTORYBOARDID];
   // homeViewController.responceData=theTimer.userInfo;
//    RearViewController *rearViewController = [[DealGaliInformation sharedInstance]Storyboard:REARSTORYBOARDID];
    
//    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
//    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    Roottocontroller=homeViewController;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
    [navController setViewControllers: @[Roottocontroller] animated: YES];
//    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
//    revealController.delegate = self;
   // [self.navigationController presentViewController:revealController animated:NO completion:nil];
   // self.viewController = revealController;
    [navController setViewControllers: @[Roottocontroller] animated: YES];
    
    [self.revealViewController setFrontViewController:navController];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
}



@end