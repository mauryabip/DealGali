//
//  ShortFlixNetworkEngine.m
//  ShortFlix
//
//  Created by Appy on 14/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "DealGaliNetworkEngine.h"



@implementation DealGaliNetworkEngine
@synthesize callbackBlock;
- (id)init
{
    self = [super init];
    if (self) {
        responseData = [[NSMutableData alloc] init];
    }
    return self;
}

+ (DealGaliNetworkEngine *)sharedInstance {
    static DealGaliNetworkEngine *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[DealGaliNetworkEngine alloc] init];
    });
    return __instance;
}
//withCallback: (void(^) (NSString* response)) callback;



-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    [responseData  setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData  appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Some error in your Connection. Please try again.");
    
    [[DealGaliInformation sharedInstance]HideWaiting];
//    self.alertView = [[UIAlertView alloc] initWithTitle:NoInternetConnection message:TryAgainLater delegate:self cancelButtonTitle:OK otherButtonTitles:nil];
//    [self.alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
//        UIApplication *app = [UIApplication sharedApplication];
//        [app performSelector:@selector(suspend)];
       // [NSThread sleepForTimeInterval:2.0];
       // exit(0);
    }
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    NSLog(@"Received %lu Bytes", (unsigned long)[responseData length]);
//    NSString *json = [[NSString alloc] initWithBytes:
//                      [responseData mutableBytes] length:[responseData length] encoding:NSUTF8StringEncoding];
    //callback(nil,nil);
    NSDictionary *jsonObject=[NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:NSJSONReadingMutableLeaves
                              error:nil];
  // NSLog(@"jsonObject is %@",jsonObject);

   // NSLog(@"%@",json);
    callbackBlock(jsonObject);
}



-(void) postSignUPAPI:(NSString *) userName password:(NSString*)password emailid:(NSString*)emailid mobileNo:(NSString*)mobileNo deviceId:(NSString*)deviceId deviceType:(NSString*)deviceType deviceToken:(NSString*)deviceToken latitude:(NSString*)lat lon:(NSString*)lon dob:(NSString*)dob withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             
                             "<soap:Body>"
                             "<UserSignUp xmlns=\"http://www.virinchisoftware.com/\">"
                             "<userName>%@</userName>"
                             "<password>%@</password>"
                             "<email>%@</email>"
                             " <mobileNumber>%@</mobileNumber>"
                             "<deviceId>%@</deviceId>"
                             "<deviceType>%@</deviceType>"
                             "<deviceToken>%@</deviceToken>"
                             "<lat>%@</lat>"
                             "<lon>%@</lon>"
                             "<DateOfBirth>%@</DateOfBirth>"
                             "</UserSignUp>"
                             "</soap:Body>"
                             "</soap:Envelope>", userName,password,emailid,mobileNo,deviceId,deviceType,deviceToken,lat,lon,dob];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/UserSignUp" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
   connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;

}
-(void) facebookSignUPAPI:(NSString *) userName FacebookId:(NSString*)FacebookId  emailid:(NSString*)emailid mobileNo:(NSString*)mobileNo dob:(NSString*)dob deviceId:(NSString*)deviceId deviceType:(NSString*)deviceType deviceToken:(NSString*)deviceToken latitude:(NSString*)lat lon:(NSString*)lon  LoginType:(NSString*)LoginType withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             
                             "<soap:Body>"
                             "<UserSignUpWithFaceBook xmlns=\"http://www.virinchisoftware.com/\">"
                             "<userName>%@</userName>"
                             "<FacebookId>%@</FacebookId>"
                             "<email>%@</email>"
                             " <mobileNumber>%@</mobileNumber>"
                             "<DateOfBirth>%@</DateOfBirth>"
                             "<deviceId>%@</deviceId>"
                             "<deviceType>%@</deviceType>"
                             "<deviceToken>%@</deviceToken>"
                             "<lat>%@</lat>"
                             "<lon>%@</lon>"
                             "<LoginType>%@</LoginType>"
                             "</UserSignUpWithFaceBook>"
                             "</soap:Body>"
                             "</soap:Envelope>", userName,FacebookId,emailid,mobileNo,dob,deviceId,deviceType,deviceToken,lat,lon,LoginType];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/UserSignUpWithFaceBook" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

-(void) VerifyAPI:(NSString *) UserId VerificationCode:(NSString*)VerificationCode withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<VerifyUserBaseOnUserId xmlns=\"http://www.virinchisoftware.com/\">"
                             "<UserId>%@</UserId>"
                             "<VerificationCode>%@</VerificationCode>"
                             "</VerifyUserBaseOnUserId>"
                             "</soap:Body>"
                             "</soap:Envelope>", UserId,VerificationCode];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/VerifyUserBaseOnUserId" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;

    
}
-(void) LoginAPI:(NSString *) mobileNumber password:(NSString*)password deviceId:(NSString*)deviceId deviceType:(NSString*) deviceType Lat:(NSString*)Lat  Lon:(NSString*)Lon withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<UserSignIn xmlns=\"http://www.virinchisoftware.com/\">"
                             "<mobileNumber>%@</mobileNumber>"
                             "<password>%@</password>"
                             "<deviceId>%@</deviceId>"
                             "<deviceType>%@</deviceType>"
                             "<Lat>%@</Lat>"
                             "<Lon>%@</Lon>"
                             "</UserSignIn>"
                             "</soap:Body>"
                             "</soap:Envelope>", mobileNumber,password,deviceId,deviceType,Lat,Lon];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/UserSignIn" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;

}
-(void) homeAPI:(NSString *) lat lon:(NSString*)lon UserId:(NSString*)UserId withCallback: (void(^) (NSDictionary* response)) callback{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetDealList xmlns=\"http://www.virinchisoftware.com/\">"
                             "<latitude>%@</latitude>"
                             "<longitude>%@</longitude>"
                             "<UserId>%@</UserId>"
                             "</GetDealList>"
                             "</soap:Body>"
                             "</soap:Envelope>", lat,lon,UserId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/GetDealList" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
    
}


-(void) GetHomeDetailAPI:(NSString *) lat lon:(NSString*)lon DealId1:(NSString*)DealId1 DealId2:(NSString*)DealId2 UserId:(NSString*)UserId withCallback: (void(^) (NSDictionary* response)) callback{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetHomeDetail xmlns=\"http://www.virinchisoftware.com/\">"
                             "<latitude>%@</latitude>"
                             "<longitude>%@</longitude>"
                             "<DealId1>%@</DealId1>"
                             "<DealId2>%@</DealId2>"
                             "<UserId>%@</UserId>"
                             "</GetHomeDetail>"
                             "</soap:Body>"
                             "</soap:Envelope>", lat,lon,DealId1,DealId2,UserId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/GetHomeDetail" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}
-(void) forgotPasswordAPI:(NSString *) phoneNo  withCallback: (void(^) (NSDictionary* response)) callback{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<SendVerificationCode xmlns=\"http://www.virinchisoftware.com/\">"
                             "<mobileNumber>%@</mobileNumber>"
                             "</SendVerificationCode>"
                             "</soap:Body>"
                             "</soap:Envelope>", phoneNo];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/SendVerificationCode" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}
-(void) ResetPasswordAPI:(NSString *) UserId CurrentPassword:(NSString*)CurrentPassword NewPassword:(NSString*)NewPassword withCallback: (void(^) (NSDictionary* response)) callback{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<ResetPassword xmlns=\"http://www.virinchisoftware.com/\">"
                             "<UserId>%@</UserId>"
                             "<CurrentPassword>%@</CurrentPassword>"
                             "<NewPassword>%@</NewPassword>"
                             "</ResetPassword>"
                             "</soap:Body>"
                             "</soap:Envelope>", UserId,CurrentPassword,NewPassword];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/ResetPassword" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}


-(void) verificationBasedOnMoNoAPI:(NSString *) MobileNumber VerificationCode:(NSString*)VerificationCode withCallback: (void(^) (NSDictionary* response)) callback{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<VerifyUserBaseOnMobileNo xmlns=\"http://www.virinchisoftware.com/\">"
                             "<MobileNumber>%@</MobileNumber>"
                             "<VerificationCode>%@</VerificationCode>"
                             "</VerifyUserBaseOnMobileNo>"
                             "</soap:Body>"
                             "</soap:Envelope>", MobileNumber,VerificationCode];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/VerifyUserBaseOnMobileNo" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
    
}
-(void) setPaaswordAPI:(NSString *) MobileNumber NewPassword:(NSString*)NewPassword withCallback: (void(^) (NSDictionary* response)) callback{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<SetPassword xmlns=\"http://www.virinchisoftware.com/\">"
                             "<MobileNumber>%@</MobileNumber>"
                             "<NewPassword>%@</NewPassword>"
                             "</SetPassword>"
                             "</soap:Body>"
                             "</soap:Envelope>", MobileNumber,NewPassword];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/SetPassword" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
    
}
-(void) homeImageListAPI:(NSString *)device  withCallback: (void(^) (NSDictionary* response)) callback{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetHomeImageList xmlns=\"http://www.virinchisoftware.com/\">"
                             "</GetHomeImageList>"
                             "</soap:Body>"
                             "</soap:Envelope>"];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/GetHomeImageList" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
    
}
-(void) homeCategoryListAPI:(NSString *)device  withCallback: (void(^) (NSDictionary* response)) callback{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetCategoryList xmlns=\"http://www.virinchisoftware.com/\">"
                             "</GetCategoryList>"
                             "</soap:Body>"
                             "</soap:Envelope>"];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/GetCategoryList" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
    
}
-(void) GetSearchListNewAPI:(NSString *)SearchData UserId:(NSString*)UserId withCallback: (void(^) (NSDictionary* response)) callback{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetSearchListNew xmlns=\"http://www.virinchisoftware.com/\">"
                             "<SearchData>%@</SearchData>"
                             "<UserId>%@</UserId>"
                             "</GetSearchListNew>"
                             "</soap:Body>"
                             "</soap:Envelope>",SearchData,UserId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/GetSearchListNew" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

-(void) postRequirementAPI:(NSString *) Name EmailId:(NSString*)EmailId MobileNumber:(NSString*)MobileNumber Message:(NSString*)Message deviceId:(NSString*)deviceId deviceType:(NSString*)deviceType withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<SetContactUs xmlns=\"http://www.virinchisoftware.com/\">"
                             "<Name>%@</Name>"
                             "<EmailId>%@</EmailId>"
                             "<MobileNumber>%@</MobileNumber>"
                             "<Message>%@</Message>"
                             "<deviceId>%@</deviceId>"
                             "<deviceType>%@</deviceType>"
                             "</SetContactUs>"
                             "</soap:Body>"
                             "</soap:Envelope>",Name,EmailId,MobileNumber,Message,deviceId,deviceType];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/SetContactUs" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

-(void) getDealListByCategoryIdAPI:(NSString *) latitude longitude:(NSString*)longitude CategoryId:(NSString*)CategoryId withCallback: (void(^) (NSDictionary* response)) callback{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetDealListByCategoryId xmlns=\"http://www.virinchisoftware.com/\">"
                             "<latitude>%@</latitude>"
                             "<longitude>%@</longitude>"
                             "<CategoryId>%@</CategoryId>"
                             "</GetDealListByCategoryId>"
                             "</soap:Body>"
                             "</soap:Envelope>", latitude,longitude,CategoryId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/GetDealListByCategoryId" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
    
}

-(void) GetSerialisedDealDetailByIdAPI:(NSString *) dealCustomId userId:(NSString*)userId Lat:(NSString*)Lat Long:(NSString*)Long deviceId:(NSString*)deviceId deviceType:(NSString*)deviceType IsSync:(Boolean)IsSync withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetSerialisedDealDetailById xmlns=\"http://www.virinchisoftware.com/\">"
                             "<dealCustomId>%@</dealCustomId>"
                             "<userId>%@</userId>"
                             "<Lat>%@</Lat>"
                             "<Long>%@</Long>"
                             "<DeviceId>%@</DeviceId>"
                             "<deviceType>%@</deviceType>"
                             "<IsSync>%d</IsSync>"
                             "</GetSerialisedDealDetailById>"
                             "</soap:Body>"
                             "</soap:Envelope>",dealCustomId,userId,Lat,Long,deviceId,deviceType,IsSync];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/GetSerialisedDealDetailById" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}
-(void) GetSerialisedCompanyDetailByIdAPI:(NSString *) companyCustomId userId:(NSString*)userId Lat:(NSString*)Lat Long:(NSString*)Long deviceId:(NSString*)deviceId deviceType:(NSString*)deviceType IsSync:(Boolean)IsSync withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetSerialisedCompanyDetailById xmlns=\"http://www.virinchisoftware.com/\">"
                             "<companyCustomId>%@</companyCustomId>"
                             "<userId>%@</userId>"
                             "<Lat>%@</Lat>"
                             "<Long>%@</Long>"
                             "<DeviceId>%@</DeviceId>"
                             "<deviceType>%@</deviceType>"
                             "<IsSync>%d</IsSync>"
                             "</GetSerialisedCompanyDetailById>"
                             "</soap:Body>"
                             "</soap:Envelope>",companyCustomId,userId,Lat,Long,deviceId,deviceType,IsSync];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/GetSerialisedCompanyDetailById" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}
-(void) GetOtherDealListAPI:(NSString *) latitude longitude:(NSString*)longitude DealId:(NSString*)DealId UserId:(NSString*)UserId withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetOtherDealList xmlns=\"http://www.virinchisoftware.com/\">"
                             "<latitude>%@</latitude>"
                             "<longitude>%@</longitude>"
                             "<DealId>%@</DealId>"
                             "<UserId>%@</UserId>"
                             "</GetOtherDealList>"
                             "</soap:Body>"
                             "</soap:Envelope>",latitude,longitude,DealId,UserId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/GetOtherDealList" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

-(void) SetCallBack:(NSString *) userId dealId:(NSString*)dealId vendorId:(NSString*)vendorId Type:(NSString*)Type deviceId:(NSString*)deviceId deviceType:(NSString*)deviceType currentPageURL:(NSString*)currentPageURL userName:(NSString*)userName mobileNo:(NSString*)mobileNo email:(NSString*)email message:(NSString*)message withCallback: (void(^) (NSDictionary* response)) callback{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<SetCallBack xmlns=\"http://www.virinchisoftware.com/\">"
                             "<userId>%@</userId>"
                             "<dealId>%@</dealId>"
                             "<vendorId>%@</vendorId>"
                             "<Type>%@</Type>"
                             "<deviceId>%@</deviceId>"
                             "<deviceType>%@</deviceType>"
                             "<currentPageURL>%@</currentPageURL>"
                             "<userName>%@</userName>"
                             "<mobileNo>%@</mobileNo>"
                             "<email>%@</email>"
                             "<message>%@</message>"
                             "</SetCallBack>"
                             "</soap:Body>"
                             "</soap:Envelope>",userId,dealId,vendorId,Type,deviceId,deviceType,currentPageURL,userName,mobileNo,email,message];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/SetCallBack" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}



-(void) UpdateUserProfileAPI:(NSString *)UserId UserName:(NSString*)UserName EmailId:(NSString*)EmailId Address:(NSString*)Address State:(NSString*)State City:(NSString*)City Pin:(NSString*)Pin withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<UpdateUserProfile xmlns=\"http://www.virinchisoftware.com/\">"
                             "<UserId>%@</UserId>"
                             "<UserName>%@</UserName>"
                             "<EmailId>%@</EmailId>"
                             "<Address>%@</Address>"
                             "<State>%@</State>"
                             "<City>%@</City>"
                             "<Pin>%@</Pin>"
                             "</UpdateUserProfile>"
                             "</soap:Body>"
                             "</soap:Envelope>",UserId,UserName,EmailId,Address,State,City,Pin];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/UpdateUserProfile" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

-(void) UploadProfileImageAPI:(NSString *) uploadImage imageName:(NSString*)imageName userId:(NSString*)userId  withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<UploadProfileImage xmlns=\"http://www.virinchisoftware.com/\">"
                             "<uploadImage>%@</uploadImage>"
                             "<imageName>%@</imageName>"
                             "<userId>%@</userId>"
                             "</UploadProfileImage>"
                             "</soap:Body>"
                             "</soap:Envelope>",uploadImage,imageName,userId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/UploadProfileImage" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

//-(void) UploadMSMEDealImageAPI:(NSString *)dealId  imageName:(NSString*)imageName uploadImage:(NSString*)uploadImage  withCallback: (void(^) (NSDictionary* response)) callback
//{
//    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
//                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
//                             "<soap:Body>"
//                             "<UploadMSMEDealImage xmlns=\"http://www.virinchisoftware.com/\">"
//                             "<dealId>%@</dealId>"
//                             "<uploadImage>%@</uploadImage>"
//                             "<imageName>%@</imageName>"
//                            "</UploadMSMEDealImage>"
//                             "</soap:Body>"
//                             "</soap:Envelope>",dealId,uploadImage,imageName];
//    
//    
//    //Now create a request to the URL
//    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
//    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
//    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
//    
//    //ad required headers to the request
//    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
//    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    [theRequest addValue: @"http://www.virinchisoftware.com/UploadMSMEDealImage" forHTTPHeaderField:@"SOAPAction"];
//    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
//    [theRequest setHTTPMethod:@"POST"];
//    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
//    //initiate the request
//    connection =
//    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
//    
//    if(connection)
//    {
//        responseData = [NSMutableData data] ;
//    }
//    else
//    {
//        NSLog(@"Connection is NULL");
//    }
//    callbackBlock=callback;
//    
//}
-(void) GetUserProfileAPI:(NSString *) userId   withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetUserProfile xmlns=\"http://www.virinchisoftware.com/\">"
                             "<userId>%@</userId>"
                             "</GetUserProfile>"
                             "</soap:Body>"
                             "</soap:Envelope>",userId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/GetUserProfile" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

-(void) SetAppointmentAPI:(NSString *)userId  userName:(NSString *)userName vendorId:(NSString *)vendorId  dealId:(NSString *)dealId   price:(int)price   mobileNumber:(NSString *)mobileNumber   deviceId:(NSString *)deviceId   deviceType:(NSString *)deviceType   currentPageURL:(NSString *)currentPageURL   email:(NSString *)email   appointmentPaidStatus:(Boolean)appointmentPaidStatus   paymentMode:(NSString *)paymentMode   fromTime:(NSString *)fromTime   toTime:(NSString *)toTime   fromOperationDay:(NSString *)fromOperationDay toOperationDay:(NSString *)toOperationDay  date1:(NSString *)date1   date2:(NSString *)date2  date3:(NSString *)date3 dateTime1:(NSString *)dateTime1 dateTime2:(NSString *)dateTime2 dateTime3:(NSString *)dateTime3  message:(NSString *)message withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<SetAppointment xmlns=\"http://www.virinchisoftware.com/\">"
                             "<userId>%@</userId>"
                             "<userName>%@</userName>"
                             "<vendorId>%@</vendorId>"
                             "<dealId>%@</dealId>"
                             "<price>%d</price>"
                             "<mobileNumber>%@</mobileNumber>"
                             "<deviceId>%@</deviceId>"
                             "<deviceType>%@</deviceType>"
                             "<currentPageURL>%@</currentPageURL>"
                             "<email>%@</email>"
                             "<appointmentPaidStatus>%d</appointmentPaidStatus>"
                             "<paymentMode>%@</paymentMode>"
                             "<fromTime>%@</fromTime>"
                             "<toTime>%@</toTime>"
                             "<fromOperationDay>%@</fromOperationDay>"
                             "<toOperationDay>%@</toOperationDay>"
                             "<date1>%@</date1>"
                             "<date2>%@</date2>"
                             "<date3>%@</date3>"
                             "<dateTime1>%@</dateTime1>"
                             "<dateTime2>%@</dateTime2>"
                             "<dateTime3>%@</dateTime3>"
                             "<message>%@</message>"
                             "</SetAppointment>"
                             "</soap:Body>"
                             "</soap:Envelope>",userId,userName,vendorId,dealId,price,mobileNumber,deviceId,deviceType,currentPageURL,email,appointmentPaidStatus,paymentMode,fromTime,toTime,fromOperationDay,toOperationDay,date1,date2,date3,dateTime1,dateTime2,dateTime3,message];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/SetAppointment" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

-(void) GetUserDealNotificationAPI:(NSString *)userId  withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetUserDealNotification xmlns=\"http://www.virinchisoftware.com/\">"
                             "<UserId>%@</UserId>"
                            "</GetUserDealNotification>"
                             "</soap:Body>"
                             "</soap:Envelope>",userId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/GetUserDealNotification" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}
-(void) SetBusinessLikeAPI:(NSString *)userId  deviceId:(NSString *)deviceId companyId:(NSString *)companyId  likeStatus:(int)likeStatus withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<SetBusinessLike xmlns=\"http://www.virinchisoftware.com/\">"
                             "<userId>%@</userId>"
                             "<deviceId>%@</deviceId>"
                             "<companyId>%@</companyId>"
                             "<likeStatus>%d</likeStatus>"
                             "</SetBusinessLike>"
                             "</soap:Body>"
                             "</soap:Envelope>",userId,deviceId,companyId,likeStatus];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/SetBusinessLike" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

-(void) SetShowCaseLikeAPI:(NSString *)userId  deviceId:(NSString *)deviceId dealId:(NSString *)dealId  likeStatus:(int)likeStatus withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<SetShowCaseLike xmlns=\"http://www.virinchisoftware.com/\">"
                             "<userId>%@</userId>"
                             "<deviceId>%@</deviceId>"
                             "<dealId>%@</dealId>"
                             "<likeStatus>%d</likeStatus>"
                             "</SetShowCaseLike>"
                             "</soap:Body>"
                             "</soap:Envelope>",userId,deviceId,dealId,likeStatus];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/SetShowCaseLike" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

-(void) SetMSMEDealLikeAPI:(NSString *)userId  deviceId:(NSString *)deviceId dealId:(NSString *)dealId  likeStatus:(int)likeStatus withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<SetMSMEDealLike xmlns=\"http://www.virinchisoftware.com/\">"
                             "<userId>%@</userId>"
                             "<deviceId>%@</deviceId>"
                             "<dealId>%@</dealId>"
                             "<likeStatus>%d</likeStatus>"
                             "</SetMSMEDealLike>"
                             "</soap:Body>"
                             "</soap:Envelope>",userId,deviceId,dealId,likeStatus];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/SetMSMEDealLike" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}


-(void) GetDealListByPageIndexAPI:(NSString *)latitude  longitude:(NSString *)longitude pageindex:(NSString *)pageindex   withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetDealListByPageIndex xmlns=\"http://www.virinchisoftware.com/\">"
                             "<latitude>%@</latitude>"
                             "<longitude>%@</longitude>"
                             "<pageindex>%@</pageindex>"
                             "</GetDealListByPageIndex>"
                             "</soap:Body>"
                             "</soap:Envelope>",latitude,longitude,pageindex];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/GetDealListByPageIndex" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

-(void) GetSerialisedMSMEDealDetailByIdAPI:(NSString *) dealCustomId userId:(NSString*)userId Lat:(NSString*)Lat Long:(NSString*)Long deviceId:(NSString*)deviceId deviceType:(NSString*)deviceType IsSync:(Boolean)IsSync withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetSerialisedMSMEDealDetailById xmlns=\"http://www.virinchisoftware.com/\">"
                             "<dealCustomId>%@</dealCustomId>"
                             "<userId>%@</userId>"
                             "<Lat>%@</Lat>"
                             "<Long>%@</Long>"
                             "<DeviceId>%@</DeviceId>"
                             "<deviceType>%@</deviceType>"
                             "<IsSync>%d</IsSync>"
                             "</GetSerialisedMSMEDealDetailById>"
                             "</soap:Body>"
                             "</soap:Envelope>",dealCustomId,userId,Lat,Long,deviceId,deviceType,IsSync];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/GetSerialisedMSMEDealDetailById" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

//-(void) AddMSMEDealAPI:(NSString *)TagId title:(NSString*)title subTitle:(NSString*)subTitle SEOTitle:(NSString*)SEOTitle description:(NSString*)description mobileNumber:(NSString*)mobileNumber  emailID:(NSString*)emailID lat:(NSString*)lat lon:(NSString*)lon contactPerson:(NSString*)contactPerson contactNumber:(NSString*)contactNumber address:(NSString*)address   withCallback: (void(^) (NSDictionary* response)) callback
//{
//    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
//                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
//                             "<soap:Body>"
//                             "<AddMSMEDeal xmlns=\"http://www.virinchisoftware.com/\">"
//                             "<TagId>%@</TagId>"
//                             "<title>%@</title>"
//                             "<subTitle>%@</subTitle>"
//                             "<SEOTitle>%@</SEOTitle>"
//                             "<description>%@</description>"
//                             "<mobileNumber>%@</mobileNumber>"
//                             "<emailID>%@</emailID>"
//                             "<lat>%@</lat>"
//                             "<lon>%@</lon>"
//                             "<contactPerson>%@</contactPerson>"
//                             "<contactNumber>%@</contactNumber>"
//                             "<address>%@</address>"
//                             "</AddMSMEDeal>"
//                             "</soap:Body>"
//                             "</soap:Envelope>",TagId,title,subTitle,SEOTitle,description,mobileNumber,emailID,lat,lon,contactPerson,contactNumber,address];
//    
//    
//    //Now create a request to the URL
//    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
//    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
//    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
//    
//    //ad required headers to the request
//    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
//    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    [theRequest addValue: @"http://www.virinchisoftware.com/AddMSMEDeal" forHTTPHeaderField:@"SOAPAction"];
//    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
//    [theRequest setHTTPMethod:@"POST"];
//    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
//    //initiate the request
//    connection =
//    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
//    
//    if(connection)
//    {
//        responseData = [NSMutableData data] ;
//    }
//    else
//    {
//        NSLog(@"Connection is NULL");
//    }
//    callbackBlock=callback;
//    
//}

-(void) GetMSMETitleListAPI:(NSString *)UserId SearchData:(NSString*)SearchData Lat:(NSString*)Lat Lon:(NSString*)Lon withCallback: (void(^) (NSDictionary* responseData)) callback{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetMSMETitleList xmlns=\"http://www.virinchisoftware.com/\">"
                              "<UserId>%@</UserId>"
                             "<SearchData>%@</SearchData>"
                             "<Lat>%@</Lat>"
                             "<Lon>%@</Lon>"
                             "</GetMSMETitleList>"
                             "</soap:Body>"
                             "</soap:Envelope>",UserId,SearchData,Lat,Lon];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/GetMSMETitleList" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

-(void) GetMSMEDealDetailByIdAPI:(NSString *)DealId  withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetMSMEDealDetailById xmlns=\"http://www.virinchisoftware.com/\">"
                             "<DealId>%@</DealId>"
                            "</GetMSMEDealDetailById>"
                             "</soap:Body>"
                             "</soap:Envelope>",DealId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/GetMSMEDealDetailById" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

-(void) AddMSMEDealAPI:(NSString *)TagId title:(NSString*)title description:(NSString*)description mobileNumber:(NSString*)mobileNumber WhoCanSee:(NSString*)WhoCanSee Lat:(NSString*)Lat Long:(NSString*)Long CategoryId:(NSString*)CategoryId DeviceId:(NSString*)DeviceId DeviceType:(NSString*)DeviceType  withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<AddMSMEDeal xmlns=\"http://www.virinchisoftware.com/\">"
                             "<TagId>%@</TagId>"
                             "<title>%@</title>"
                             "<description>%@</description>"
                             "<mobileNumber>%@</mobileNumber>"
                             "<WhoCanSee>%@</WhoCanSee>"
                             "<lat>%@</lat>"
                             "<lon>%@</lon>"
                             "<CategoryId>%@</CategoryId>"
                             "<DeviceId>%@</DeviceId>"
                             "<DeviceType>%@</DeviceType>"
                             "</AddMSMEDeal>"
                             "</soap:Body>"
                             "</soap:Envelope>",TagId,title,description,mobileNumber,WhoCanSee,Lat,Long,CategoryId,DeviceId,DeviceType];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/AddMSMEDeal" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}
-(void) UploadMSMEDealImageAPI:(NSString *)dealId uploadImage:(NSString*)uploadImage imageName:(NSString*)imageName  withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<UploadMSMEDealImage xmlns=\"http://www.virinchisoftware.com/\">"
                             "<dealId>%@</dealId>"
                             "<uploadImage>%@</uploadImage>"
                             "<imageName>%@</imageName>"
                             "</UploadMSMEDealImage>"
                             "</soap:Body>"
                             "</soap:Envelope>",dealId,uploadImage,imageName];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/UploadMSMEDealImage" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}
-(void) UploadMSMEDealImageByIdAPI:(NSString *)dealId uploadImage:(NSString*)uploadImage imageName:(NSString*)imageName  UserId:(NSString*)UserId withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<UploadMSMEDealImageById xmlns=\"http://www.virinchisoftware.com/\">"
                             "<dealId>%@</dealId>"
                             "<uploadImage>%@</uploadImage>"
                             "<imageName>%@</imageName>"
                             "<UserId>%@</UserId>"
                             "</UploadMSMEDealImageById>"
                             "</soap:Body>"
                             "</soap:Envelope>",dealId,uploadImage,imageName,UserId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/UploadMSMEDealImageById" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}


-(void) UpdateMSMEDealByIdAPI:(NSString *)title description:(NSString*)description mobileNumber:(NSString*)mobileNumber WhoCanSee:(NSString*)WhoCanSee  DeviceId:(NSString*)DeviceId DeviceType:(NSString*)DeviceType  DealId:(NSString*)DealId UserId:(NSString*)UserId withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<UpdateMSMEDealById xmlns=\"http://www.virinchisoftware.com/\">"
                             "<title>%@</title>"
                             "<description>%@</description>"
                             "<mobileNumber>%@</mobileNumber>"
                             "<WhoCanSee>%@</WhoCanSee>"
                             "<DeviceId>%@</DeviceId>"
                             "<DeviceType>%@</DeviceType>"
                             "<DealId>%@</DealId>"
                             "<UserId>%@</UserId>"
                             "</UpdateMSMEDealById>"
                             "</soap:Body>"
                             "</soap:Envelope>",title,description,mobileNumber,WhoCanSee,DeviceId,DeviceType,DealId,UserId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/UpdateMSMEDealById" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

-(void) GetDefaultImageAPI:(NSString *)title  withCallback: (void(^) (NSDictionary* response)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetDefaultImage xmlns=\"http://www.virinchisoftware.com/\">"
                             "</GetDefaultImage>"
                             "</soap:Body>"
                             "</soap:Envelope>"];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/GetDefaultImage" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}
-(void) GetMSMEDealListAPI:(NSString *) latitude longitude:(NSString*)longitude  withCallback: (void(^) (NSDictionary* response)) callback{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetMSMEDealList xmlns=\"http://www.virinchisoftware.com/\">"
                             "<latitude>%@</latitude>"
                             "<longitude>%@</longitude>"
                             "</GetMSMEDealList>"
                             "</soap:Body>"
                             "</soap:Envelope>", latitude,longitude];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/GetMSMEDealList" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
    
}

-(void) SetDuplicateMSMEDealAPI:(NSString *) dealId userId:(NSString*)userId  withCallback: (void(^) (NSDictionary* response)) callback{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<SetDuplicateMSMEDeal xmlns=\"http://www.virinchisoftware.com/\">"
                             "<dealId>%@</dealId>"
                             "<userId>%@</userId>"
                             "</SetDuplicateMSMEDeal>"
                             "</soap:Body>"
                             "</soap:Envelope>", dealId,userId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/SetDuplicateMSMEDeal" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

-(void) SetInAppropriateMSMEDealAPI:(NSString *) dealId userId:(NSString*)userId  withCallback: (void(^) (NSDictionary* response)) callback{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<SetInAppropriateMSMEDeal xmlns=\"http://www.virinchisoftware.com/\">"
                             "<dealId>%@</dealId>"
                             "<userId>%@</userId>"
                             "</SetInAppropriateMSMEDeal>"
                             "</soap:Body>"
                             "</soap:Envelope>", dealId,userId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/SetInAppropriateMSMEDeal" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

-(void) SetPrivateMSMEDealAPI:(NSString *) dealId userId:(NSString*)userId  withCallback: (void(^) (NSDictionary* response)) callback{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<SetPrivateMSMEDeal xmlns=\"http://www.virinchisoftware.com/\">"
                             "<dealId>%@</dealId>"
                             "<userId>%@</userId>"
                             "</SetPrivateMSMEDeal>"
                             "</soap:Body>"
                             "</soap:Envelope>", dealId,userId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.dealgali.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/SetPrivateMSMEDeal" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}
@end



