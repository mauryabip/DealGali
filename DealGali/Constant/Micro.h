//
//  Micro.h
//  DealGali
//
//  Created by Virinchi Software on 18/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#ifndef Micro_h
#define Micro_h
#define STORYBOARD @"Main"
#define SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define APPDELEGATE  ((AppDelegate *) [[UIApplication sharedApplication] delegate])
#define LOGINSTORYBOARDID @"LoginViewControllerID"
#define HOMESTORYBOARDID @"HomeViewControllerID"
#define PROFILESTORYBOARDID @"ProfileViewControllerID"
#define EDITPROFILESTORYBOARDID @"EditProfileViewControllerID"
#define REARSTORYBOARDID @"RearViewControllerID"
#define SIGNUPSTORYBOARDID @"SignUpViewControllerID"
#define NOTIFICATIONSTORYBOARD @"NotificationViewControllerID"
#define DEALLISTSTORYBOARD @"DealLiistViewControllerID"
#define PROFILESTORYBOARD @"ProfileViewControllerID"
#define DEALDESCRIPTIONSTORYBOARD @"DealDescriptionViewControllerID"
#define SEARCHSTORYBOARD @"SearchViewControllerID"
#define COMPANYPROFILESTORYBOARD @"CompanyProfileViewControllerID"
#define POSTREQUIREMETSTORYBOARD @"PostRequirementViewControllerID"
#define ABOUTUSSTORYBOARD @"AboutUSViewControllerID"
#define CALLBACKSTORYBOARD @"CallBackViewControllerID"
#define APPOINTMENTSTORYBOARD @"AppointmentViewControllerID"
#define FORGOTSTORYBOARD @"ForgotPasswordVCID"
#define VERIFICATIONSTORYBOARD @"VerificationVCID"
#define SAVEPASSWORDSTORYBOARD @"SavePasswordVCID"
#define VERIFYSIGNUPSTORYBOARD @"VerifySignUpVCID"
#define SPLASHVCSTORYBOARD @"SplashVCID"
#define TERMVCSTORYBOARD @"TermVCID"
#define SIGNUPWITHFACEBOOKSTORYBOARD @"SignUPWithFaceBookVCID"
#define RESETPASSSTORYBOARD @"ResetPasswordVCID"
#define MSMEDECSTORYBOARD @"MSMEDescVCID"
#define ADDMSMESTORYBOARD @"AddMSMEVCID"
#define ADDMSMEDESCSTRORYBOARD @"AddMSMEDescVCID"
#define CREATEANDSUGGESTMSMESTORYBOARD @"CreateAndSuggestMSMEVCID"
#define INTERNETREFRESHSTORYBOARD @"InternetRefreshVCID"

#define TELEPHONE @"tel:+919971702906"

#define TERMSANDCONDITIONSURL @"http://www.dealgali.com/terms-and-conditions"
#define ABOUTUSURL @"http://www.dealgali.com/about-us"

//Internet connection
#define NoInternetConnection @"No Internet Connection"
#define TryAgainLater @"You have no internet connection on your device, please check and try again later."

//success messages
#define LOGINSUCCESSFULLY @"Congratulations! you have successfully logged into DealGali"
#define SIGNUPSUCCESSFULLY @"OTP has been sent to the registered mobile number"
#define SIGNUPVERIFIESDSUCCESSFULLY @"OTP successfully verified"
#define FORGOTPASSWORDSUCCESSFULY @"OTP has been sent to the registered mobile number"
#define OTPVERIFIEDSUCCESSFULLY @"OTP verified"
#define PASSWORDSAVEDSUCCESSFULLY @"Password saved successfully"
#define PASSWORDUPDATEDSUCCESSFULLY @"Password updated successfully"
#define DETAILSUPDATEDSUCCESSFULLY @"Details updated successfully"
#define PROFILEUPDATEDSUCCESSFULLY @"Profile updated successfully"
#define POSTEDREQUIREMENTSUCCESSFULLY @"Your requirement has been posted successfully"
#define CALLBACKREQUIREMENTSUCCESSFULLY @"The seller will call you shortly."
#define APPOINTMENTSUCCESSFULLY @"The seller will contact you soon."





#define OK @"OK"
#define DEALS @"discounts"
#define VEIWALL @"view all"
#define KM @"KM"
#define SHOWCASE @"showcase"
#define SME @"MSME"
#define STORE @"store"
#define FETCHINGDEALS @"Fetching..."
#define UPDATING @"Updating..."
#define CREATING @"Creating..."
#define QOUTES @""




#define URLFORHTMLPAGE @"http://www.dealgali.com/"

#define Kcolorforkeyboardtoolabr [UIColor colorWithRed:(255.0f/255.0f) green:(255.0f/255.0f) blue:(255.0f/255.0f) alpha:1]


//home
#define FASTESTLOCALBUZZ @"Fastest Local Commerce Buzz"
#define CATEGORIES @"category"
#define YOURNEARESTDEALS @"your nearby discounts"
#define VIEWALLYOURNEARESTDEALS @"view other nearby discounts"
#define WHATOURCUSTMRSAYS @"what our clients say"
#define VIEWALLButton @"View All Deals"
#define VIEWALLOTHERSDEALS @"view all others discounts"
#define OTHERS @"others discounts"
#define MOREDEALSNOTAVAIL @"more discounts is not available"

//Deal DEsc
#define BOOKAPPOINTMENTButton @"book an appointment"
#define ASKFORCALL @"callback"

//Login
#define Loading @"Loading..."
#define PLEASEENTERALLFIELD @"Please enter all fields"
#define NSUSERDEFAULTS [NSUserDefaults standardUserDefaults]
#define ALERT @"Alert!"

//SIGNUP
#define VALIDEMAIL @"Please enter valid email id"
#define Enterusername @"Please enter name"
#define EnterNewPass @"Please enter new password"
#define EnterRetyprPass @"Please enter retype password"
#define EnterPassword @"Please enter password"
#define EnterPasswordValidation @"Password should be 3 characters minimum"
#define Validmobile @"Please enter valid mobile number"
#define ENTERBELOWOPT @"Please enter your otp below"

//verify
#define EnterVerificationCode @"Please enter correct verification code"
#define EnterVerification @"Please enter verification code"
#define EnterOTP @"Please enter otp"
#define Verifying @"Verifying..."
#define SENDVERIFICATIONCODEMO @"Verification code sent to the registered mobile number"

//forgot
#define SendVerificationCode @"Sending..."
#define SavingPassword @"Updating..."

//save
#define MatchPassword @"Password do not match"
#define MatchNewRetypePassword @"New and retype password do not match"


//reset
#define CURREENTPASS @"Please enter current password"
#define ENTERNEWPASS @"Please enter new password"
#define ENTERRETYPEPASS @"Please enter re-type password"


//profile
#define PROFILEUPDATING @"Updating..."
#define IMAGEUPLODATING @"Uploading..."
#define REQUESTFORCALLBACK @"request a callback"

//call back
#define WriteMSG @"enter your message and the seller will contact you shortly"
#define MSG @"Please enter your message"
#define REQUESTING @"Requesting..."

//Appointment
#define LBLMSG @"By submitting, you agree our"
#define CHOOSEMSG @"choose your preferred appointment time and we will contact you"
#define CONTACTMSG @"Contact information to reach you"
#define WRITETEXTVIEW @"the more specific details you provide, the better we can serve"
#define REQUESTINGAPPOINTMENT @"Requesting..."
#define PICKTIME @"Please Pick a Date and Time"

//Post requirement
#define POSTLBL @"Tell us what you are looking for"
#define POSTWRITEMSG @"enter your requirement details to get best discounts from nearby sellers"

//search
#define NOSEARCH @"No Results Found"
#define ADDDESCRIPTION @"write more about your services or products you sell"
#define EnterDescription @"Please write more about your services or products you sell"

//MSME
#define DUPLICATEDATA @"Duplicate data reported"
#define INAPPROPIATECONTENT @"Inappropiate Content"
#define PULICCONTENT @"Not a Public Place"

#endif /* Micro_h */
