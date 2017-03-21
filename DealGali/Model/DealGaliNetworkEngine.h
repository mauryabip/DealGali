//
//  DealGaliNetworkEngine.h
//  ShortFlix
//
//  Created by Appy on 14/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//http://stalintechnologies.blogspot.in/2013/04/how-to-use-soap-webservice-api.html

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DealGaliInformation.h"


@interface DealGaliNetworkEngine : NSObject<NSURLConnectionDelegate, NSXMLParserDelegate,UIAlertViewDelegate>{
    NSURLConnection *connection;
    NSMutableData *responseData;    
    NSMutableDictionary *model;
    
}
@property (strong, nonatomic) UIAlertView *alertView;
@property (nonatomic, copy) void (^ callbackBlock)(NSDictionary *response);

+ (DealGaliNetworkEngine *)sharedInstance;

-(void) postSignUPAPI:(NSString *) userName password:(NSString*)password emailid:(NSString*)emailid mobileNo:(NSString*)mobileNo deviceId:(NSString*)deviceId deviceType:(NSString*)deviceType deviceToken:(NSString*)deviceToken latitude:(NSString*)lat lon:(NSString*)lon dob:(NSString*)dob withCallback: (void(^) (NSDictionary* response)) callback;

-(void) facebookSignUPAPI:(NSString *) userName FacebookId:(NSString*)FacebookId  emailid:(NSString*)emailid mobileNo:(NSString*)mobileNo dob:(NSString*)dob deviceId:(NSString*)deviceId deviceType:(NSString*)deviceType deviceToken:(NSString*)deviceToken latitude:(NSString*)lat lon:(NSString*)lon  LoginType:(NSString*)LoginType withCallback: (void(^) (NSDictionary* response)) callback;

-(void) VerifyAPI:(NSString *) UserId VerificationCode:(NSString*)VerificationCode withCallback: (void(^) (NSDictionary* response)) callback;

-(void) LoginAPI:(NSString *) mobileNumber password:(NSString*)password deviceId:(NSString*)deviceId deviceType:(NSString*) deviceType Lat:(NSString*)Lat  Lon:(NSString*)Lon withCallback: (void(^) (NSDictionary* response)) callback;

-(void) homeAPI:(NSString *) lat lon:(NSString*)lon UserId:(NSString*)UserId withCallback: (void(^) (NSDictionary* response)) callback;

-(void) GetHomeDetailAPI:(NSString *) lat lon:(NSString*)lon DealId1:(NSString*)DealId1 DealId2:(NSString*)DealId2 UserId:(NSString*)UserId withCallback: (void(^) (NSDictionary* response)) callback;

-(void) forgotPasswordAPI:(NSString *) phoneNo  withCallback: (void(^) (NSDictionary* response)) callback;

-(void) ResetPasswordAPI:(NSString *) UserId CurrentPassword:(NSString*)CurrentPassword NewPassword:(NSString*)NewPassword withCallback: (void(^) (NSDictionary* response)) callback;

-(void) verificationBasedOnMoNoAPI:(NSString *) MobileNumber VerificationCode:(NSString*)VerificationCode withCallback: (void(^) (NSDictionary* response)) callback;

-(void) setPaaswordAPI:(NSString *) MobileNumber NewPassword:(NSString*)NewPassword withCallback: (void(^) (NSDictionary* response)) callback;

-(void) homeImageListAPI:(NSString *)device  withCallback: (void(^) (NSDictionary* response)) callback;

-(void) homeCategoryListAPI:(NSString *)device  withCallback: (void(^) (NSDictionary* response)) callback;

-(void) GetSearchListNewAPI:(NSString *)SearchData UserId:(NSString*)UserId withCallback: (void(^) (NSDictionary* response)) callback;

-(void) postRequirementAPI:(NSString *) Name EmailId:(NSString*)EmailId MobileNumber:(NSString*)MobileNumber Message:(NSString*)Message deviceId:(NSString*)deviceId deviceType:(NSString*)deviceType withCallback: (void(^) (NSDictionary* response)) callback;

-(void) getDealListByCategoryIdAPI:(NSString *) latitude longitude:(NSString*)longitude CategoryId:(NSString*)CategoryId withCallback: (void(^) (NSDictionary* response)) callback;

-(void) GetSerialisedDealDetailByIdAPI:(NSString *) dealCustomId userId:(NSString*)userId Lat:(NSString*)Lat Long:(NSString*)Long deviceId:(NSString*)deviceId deviceType:(NSString*)deviceType IsSync:(Boolean)IsSync withCallback: (void(^) (NSDictionary* response)) callback;

-(void) GetSerialisedCompanyDetailByIdAPI:(NSString *) companyCustomId userId:(NSString*)userId Lat:(NSString*)Lat Long:(NSString*)Long deviceId:(NSString*)deviceId deviceType:(NSString*)deviceType IsSync:(Boolean)IsSync withCallback: (void(^) (NSDictionary* response)) callback;


-(void) GetOtherDealListAPI:(NSString *) latitude longitude:(NSString*)longitude DealId:(NSString*)DealId UserId:(NSString*)UserId withCallback: (void(^) (NSDictionary* response)) callback;


-(void) SetCallBack:(NSString *) userId dealId:(NSString*)dealId vendorId:(NSString*)vendorId Type:(NSString*)Type deviceId:(NSString*)deviceId deviceType:(NSString*)deviceType currentPageURL:(NSString*)currentPageURL userName:(NSString*)userName mobileNo:(NSString*)mobileNo email:(NSString*)email message:(NSString*)message withCallback: (void(^) (NSDictionary* response)) callback;

//-(void) UploadMSMEDealImageAPI:(NSString *)dealId  imageName:(NSString*)imageName uploadImage:(NSString*)uploadImage  withCallback: (void(^) (NSDictionary* response)) callback;

-(void) UpdateUserProfileAPI:(NSString *)UserId UserName:(NSString*)UserName EmailId:(NSString*)EmailId Address:(NSString*)Address State:(NSString*)State City:(NSString*)City Pin:(NSString*)Pin withCallback: (void(^) (NSDictionary* response)) callback;

-(void) UploadProfileImageAPI:(NSString *) uploadImage imageName:(NSString*)imageName userId:(NSString*)userId  withCallback: (void(^) (NSDictionary* response)) callback;

-(void) GetUserProfileAPI:(NSString *) userId   withCallback: (void(^) (NSDictionary* response)) callback;

-(void) SetAppointmentAPI:(NSString *)userId  userName:(NSString *)userName vendorId:(NSString *)vendorId  dealId:(NSString *)dealId   price:(int)price   mobileNumber:(NSString *)mobileNumber   deviceId:(NSString *)deviceId   deviceType:(NSString *)deviceType   currentPageURL:(NSString *)currentPageURL   email:(NSString *)email   appointmentPaidStatus:(Boolean)appointmentPaidStatus   paymentMode:(NSString *)paymentMode   fromTime:(NSString *)fromTime   toTime:(NSString *)toTime   fromOperationDay:(NSString *)fromOperationDay toOperationDay:(NSString *)toOperationDay  date1:(NSString *)date1   date2:(NSString *)date2  date3:(NSString *)date3 dateTime1:(NSString *)dateTime1 dateTime2:(NSString *)dateTime2 dateTime3:(NSString *)dateTime3  message:(NSString *)message withCallback: (void(^) (NSDictionary* response)) callback;

-(void) GetUserDealNotificationAPI:(NSString *)userId  withCallback: (void(^) (NSDictionary* response)) callback;

-(void) SetBusinessLikeAPI:(NSString *)userId  deviceId:(NSString *)deviceId companyId:(NSString *)companyId  likeStatus:(int)likeStatus withCallback: (void(^) (NSDictionary* response)) callback;

-(void) SetShowCaseLikeAPI:(NSString *)userId  deviceId:(NSString *)deviceId dealId:(NSString *)dealId  likeStatus:(int)likeStatus withCallback: (void(^) (NSDictionary* response)) callback;

-(void) SetMSMEDealLikeAPI:(NSString *)userId  deviceId:(NSString *)deviceId dealId:(NSString *)dealId  likeStatus:(int)likeStatus withCallback: (void(^) (NSDictionary* response)) callback;

-(void) GetDealListByPageIndexAPI:(NSString *)latitude  longitude:(NSString *)longitude pageindex:(NSString *)pageindex   withCallback: (void(^) (NSDictionary* response)) callback;

-(void) GetSerialisedMSMEDealDetailByIdAPI:(NSString *) dealCustomId userId:(NSString*)userId Lat:(NSString*)Lat Long:(NSString*)Long deviceId:(NSString*)deviceId deviceType:(NSString*)deviceType IsSync:(Boolean)IsSync withCallback: (void(^) (NSDictionary* response)) callback;

//-(void) AddMSMEDealAPI:(NSString *)TagId title:(NSString*)title subTitle:(NSString*)subTitle SEOTitle:(NSString*)SEOTitle description:(NSString*)description mobileNumber:(NSString*)mobileNumber  emailID:(NSString*)emailID lat:(NSString*)lat lon:(NSString*)lon contactPerson:(NSString*)contactPerson contactNumber:(NSString*)contactNumber address:(NSString*)address   withCallback: (void(^) (NSDictionary* response)) callback;

-(void) GetMSMETitleListAPI:(NSString *)UserId SearchData:(NSString*)SearchData Lat:(NSString*)Lat Lon:(NSString*)Lon withCallback: (void(^) (NSDictionary* responseData)) callback;

-(void) GetMSMEDealDetailByIdAPI:(NSString *)DealId  withCallback: (void(^) (NSDictionary* response)) callback;

-(void) AddMSMEDealAPI:(NSString *)TagId title:(NSString*)title description:(NSString*)description mobileNumber:(NSString*)mobileNumber WhoCanSee:(NSString*)WhoCanSee Lat:(NSString*)Lat Long:(NSString*)Long CategoryId:(NSString*)CategoryId DeviceId:(NSString*)DeviceId DeviceType:(NSString*)DeviceType  withCallback: (void(^) (NSDictionary* response)) callback;

-(void) UploadMSMEDealImageAPI:(NSString *)dealId uploadImage:(NSString*)uploadImage imageName:(NSString*)imageName  withCallback: (void(^) (NSDictionary* response)) callback;

-(void) UploadMSMEDealImageByIdAPI:(NSString *)dealId uploadImage:(NSString*)uploadImage imageName:(NSString*)imageName  UserId:(NSString*)UserId withCallback: (void(^) (NSDictionary* response)) callback;

-(void) UpdateMSMEDealByIdAPI:(NSString *)title description:(NSString*)description mobileNumber:(NSString*)mobileNumber WhoCanSee:(NSString*)WhoCanSee  DeviceId:(NSString*)DeviceId DeviceType:(NSString*)DeviceType  DealId:(NSString*)DealId UserId:(NSString*)UserId withCallback: (void(^) (NSDictionary* response)) callback;

-(void) GetDefaultImageAPI:(NSString *)title  withCallback: (void(^) (NSDictionary* response)) callback;

-(void) GetMSMEDealListAPI:(NSString *) latitude longitude:(NSString*)longitude  withCallback: (void(^) (NSDictionary* response)) callback;

-(void) SetDuplicateMSMEDealAPI:(NSString *) dealId userId:(NSString*)userId  withCallback: (void(^) (NSDictionary* response)) callback;

-(void) SetInAppropriateMSMEDealAPI:(NSString *) dealId userId:(NSString*)userId  withCallback: (void(^) (NSDictionary* response)) callback;

-(void) SetPrivateMSMEDealAPI:(NSString *) dealId userId:(NSString*)userId  withCallback: (void(^) (NSDictionary* response)) callback;



@end
