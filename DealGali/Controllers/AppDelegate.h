//
//  AppDelegate.h
//  DealGali
//
//  Created by Virinchi Software on 18/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealGaliInformation.h"
#import "SWRevealViewController.h"
#import "HomeViewController.h"
#import "RearViewController.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "EducationTableViewCell.h"
#import "NotificationViewController.h"
#import "NotificationTableViewCell.h"
#import "DealLiistViewController.h"
#import "DealListTableViewCell.h"
#import "ProfileViewController.h"
#import "DealDescriptionViewController.h"
#import "SearchViewController.h"
#import "PhotosVideoTableViewCell.h"
#import "PostRequirementViewController.h"
#import "AboutUSViewController.h"
#import "CallBackViewController.h"
#import "AppointmentViewController.h"
#import "DealGaliNetworkEngine.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import <AddressBook/AddressBook.h>
#import "SplashVC.h"
#import "TermVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SignUPWithFaceBookVC.h"
#import "ResetPasswordVC.h"
#import <Google/SignIn.h>
#import "CompanyProfileVC.h"
#import "MSMEDescVC.h"
#import "AddMSMEVC.h"
#import "AddMSMEDescVC.h"
#import "CreateAndSuggestMSMEVC.h"
#import "SearchAndAddMSME.h"
#import "InternetRefreshVC.h"


@class SWRevealViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>{
    CLLocation *location;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *str;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SWRevealViewController *viewController;
@property(nonatomic, strong)CLLocationManager *locationManager;
@end

