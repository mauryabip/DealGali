//
//  AppDelegate.m
//  DealGali
//
//  Created by Virinchi Software on 18/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()<SWRevealViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //facebook
    [FBLoginView class];
    [FBProfilePictureView class];
    
    //google plus
    
    //    NSError* configureError;
    //    [[GGLContext sharedInstance] configureWithError: &configureError];
    //    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    //
    //    [GIDSignIn sharedInstance].delegate = self;
    
    [DealGaliInformation sharedInstance].arr=[[NSMutableDictionary alloc]init];
    
    [self getLocation];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:19.0f]                                                            }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"Status"];
    if ([savedValue isEqualToString:@"1"]) {
        
        
        UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window = window;
        SplashVC *homeViewController=[[DealGaliInformation sharedInstance]Storyboard:SPLASHVCSTORYBOARD];
        //        HomeViewController *homeViewController = [[DealGaliInformation sharedInstance]Storyboard:HOMESTORYBOARDID];
        RearViewController *rearViewController = [[DealGaliInformation sharedInstance]Storyboard:REARSTORYBOARDID];
        
        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
        
        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
        revealController.delegate = self;
        self.viewController = revealController;
        
        self.window.rootViewController = self.viewController;
        [self.window makeKeyAndVisible];
        
    }
    //-- Set Notification
    
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        
    }
    
    return YES;
}
-(void)getLocation{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    if([[self locationManager] respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [[self locationManager] requestWhenInUseAuthorization];
    }
    
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    } else {
        NSLog(@"Location services is not enabled");
    }
    [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyBest];
    location=[self.locationManager location];
    
    
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    geocoder = [[CLGeocoder alloc] init];
    NSLog(@"%f %f",loc.latitude,loc.longitude);
    
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // NSLog(@"didUpdateToLocation: %@", newLocation);
    location = newLocation;
    
    if (location != nil) {
        NSString *lon = [NSString stringWithFormat:@"%.8f", location.coordinate.longitude];//@"23.333"
        NSString *lat = [NSString stringWithFormat:@"%.8f", location.coordinate.latitude];//@"77.71717"
        [[NSUserDefaults standardUserDefaults] setObject:lat forKey:@"lat"];
        [[NSUserDefaults standardUserDefaults] setObject:lon forKey:@"lon"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSLog(@"Delegate :    lat  %@    long   %@",lat,lon);
    }
    
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        str=@"";
        if (error) {
            NSLog(@"Geocode failed with error: %@", error);
            return;
        }
        
        if (placemarks && placemarks.count > 0)
        {
            placemark = placemarks[0];
            NSDictionary *addressDictionary =
            placemark.addressDictionary;
            
            NSLog(@"%@ ", addressDictionary);
            NSArray *locArr=[addressDictionary valueForKey:@"FormattedAddressLines"];
            str=[NSString stringWithFormat:@"%@, %@",[locArr objectAtIndex:0],[locArr objectAtIndex:1]];
            
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"locationAddress"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }
        
    } ];
    [self.locationManager stopUpdatingLocation];
}

// Delegation methods
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"content---%@", token);
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"notification options %@", userInfo);
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication];
}
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}
/*
 - (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
 withError:(NSError *)error {
 // Perform any operations on signed in user here.
 NSString *userId = user.userID;                  // For client-side use only!
 
 if ([userId length]==0) {
 
 }
 else{
 [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"googleID"];
 [[NSUserDefaults standardUserDefaults]synchronize];
 //    NSString *idToken = user.authentication.idToken; // Safe to send to the server
 //    NSString *fullName = user.profile.name;
 //    NSString *givenName = user.profile.givenName;
 //    NSString *familyName = user.profile.familyName;
 //    NSString *email = user.profile.email;
 //    NSLog(@"idToken : %@    userId:  %@     userId: %@      userId: %@ ",idToken,userId,userId,userId);
 // ...
 UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
 self.window = window;
 SignUPWithFaceBookVC *homeViewController = [[DealGaliInformation sharedInstance]Storyboard:SIGNUPWITHFACEBOOKSTORYBOARD];
 homeViewController.name=@"google";
 //        HomeViewController *homeViewController = [[DealGaliInformation sharedInstance]Storyboard:HOMESTORYBOARDID];
 RearViewController *rearViewController = [[DealGaliInformation sharedInstance]Storyboard:REARSTORYBOARDID];
 
 UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
 UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
 
 SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
 revealController.delegate = self;
 
 self.viewController = revealController;
 
 self.window.rootViewController = self.viewController;
 [self.window makeKeyAndVisible];
 
 }
 
 }
 - (void)signIn:(GIDSignIn *)signIn  didDisconnectWithUser:(GIDGoogleUser *)user
 withError:(NSError *)error {
 // Perform any operations when the user disconnects from app here.
 // ...
 }
 */

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
