//
//  ProfileViewController.m
//  DealGali
//
//  Created by Virinchi Software on 21/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setting for font and color
    self.nameLbl.textColor=[UIColor DGLightGrayColor];
    self.nameLbl.font=[UIFont DGTextFieldFont];
    self.emailTXT.textColor=[UIColor DGBlackColor];
    self.emailTXT.font=[UIFont DGTextFieldFont];
    self.phoneTXT.textColor=[UIColor DGBlackColor];
    self.phoneTXT.font=[UIFont DGTextFieldFont];
    self.addressTXT.textColor=[UIColor DGBlackColor];
    self.addressTXT.font=[UIFont DGTextFieldFont];
    self.stateTXT.textColor=[UIColor DGBlackColor];
    self.stateTXT.font=[UIFont DGTextFieldFont];
    self.cityTXT.textColor=[UIColor DGBlackColor];
    self.cityTXT.font=[UIFont DGTextFieldFont];
    self.pinTXT.textColor=[UIColor DGBlackColor];
    self.pinTXT.font=[UIFont DGTextFieldFont];
    self.saveBtn.backgroundColor=[UIColor DGLightGrayColor];
    self.saveBtn.titleLabel.font=[UIFont DGActionButtonFont];
    self.saveBtn.titleLabel.textColor=[UIColor DGWhiteColor];
    self.resetPassBtn.titleLabel.font=[UIFont DGHyperLineButtonFont];
    self.resetPassBtn.titleLabel.textColor=[UIColor DGPurpleColor];
    
    [self getData];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myMethod)];
    
    
    UIBarButtonItem * revealButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo.png"]]];
    self.navigationItem.leftBarButtonItems = @[revealButtonItem,revealButtonItem1];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.scrollView addGestureRecognizer:recognizer];
    
}
-(void)previousecall{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)myMethod{
    [[[self revealViewController] view] endEditing:YES];
    //[self.view endEditing:YES];
    SWRevealViewController *reveal = self.revealViewController;
    [reveal revealToggleAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //    NSData *imgData = [[NSUserDefaults standardUserDefaults] dataForKey:@"ProfileImage"];
    //    UIImage *image = [[UIImage alloc]initWithData:imgData];
    //    if (image==nil) {
    //        self.imageView.image=[UIImage imageNamed:@"profileImg"];
    //    }
    //    else
    //        self.imageView.image=image;
    
}


-(void)getData{
    
    NSData *data = [NSUSERDEFAULTS objectForKey:@"USERDETAILS"];
    dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    self.emailTXT.text=[dic valueForKey:@"Email"];
    self.nameLbl.text=[dic valueForKey:@"UserName"];
    self.phoneTXT.text=[dic valueForKey:@"MobileNo"];
    
    self.imageView.layer.cornerRadius = self.imgVwHT.constant/ 2;
    self.imageView.layer.borderColor=[UIColor DGLightGrayColor].CGColor;
    self.imageView.layer.borderWidth=1.0;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    
    NSString *PROFILE = [NSUSERDEFAULTS stringForKey:@"PROFILE"];
    
    if ([PROFILE isEqualToString:@"PROFILE"]) {
        NSData *imgData = [[NSUserDefaults standardUserDefaults] dataForKey:@"ProfileImage"];
        UIImage *image = [[UIImage alloc]initWithData:imgData];
        
        if (image==nil) {
            
            NSString *path = [NSUSERDEFAULTS stringForKey:@"ProfileImagePath"];
            
            if (path.length==0) {
                NSString *path = [NSUSERDEFAULTS stringForKey:@"pathUserProfile"];
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:path]
                                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                //self.imageView.image=[UIImage imageNamed:@"profileImg"];
            }
            else{
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:path]
                                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                self.imageView.contentMode = UIViewContentModeScaleAspectFill;
                self.imageView.clipsToBounds = YES;
                NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
                
                [NSUSERDEFAULTS setObject:imageData forKey:@"ProfileImage"];
                [NSUSERDEFAULTS synchronize];
            }
        }
        else
            self.imageView.image=image;
        
    }
    else{
        NSString *path = [[NSUserDefaults standardUserDefaults] stringForKey:@"ProfileImagePath"];
        if (path.length==0) {
            NSString *path = [NSUSERDEFAULTS stringForKey:@"pathUserProfile"];
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:path]
                              placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            // self.imageView.image=[UIImage imageNamed:@"profileImg"];
        }
        else{
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:path]
                              placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            self.imageView.clipsToBounds = YES;
            
        }
    }
    
    
    
    if ([self.addressTXT.text isEqualToString:@"Address"] && [self.stateTXT.text isEqualToString:@"State"] && [self.cityTXT.text isEqualToString:@"City"] && [self.pinTXT.text isEqualToString:@"Pin"]) {
        
    }
    else{
        self.addressTXT.text=[dic valueForKey:@"Address"];
        self.stateTXT.text=[dic valueForKey:@"State"];
        self.cityTXT.text=[dic valueForKey:@"City"];
        self.pinTXT.text=[dic valueForKey:@"PostalCode"];
    }
    
    emailStr=self.emailTXT.text;
    mobileStr=self.phoneTXT.text;
    addressStr=self.addressTXT.text;
    stateStr=self.stateTXT.text;
    cityStr=self.cityTXT.text;
    pinStr=self.pinTXT.text;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectPhoto:(UIButton *)sender {
    [self showGrid];
    
    //    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //    picker.delegate = self;
    //    picker.allowsEditing = YES;
    //    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //
    //    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)editPassAction:(id)sender {
    ResetPasswordVC *resetVC = [[DealGaliInformation sharedInstance]Storyboard:RESETPASSSTORYBOARD];
    [self.navigationController pushViewController:resetVC animated:YES];
}

- (IBAction)saveBtnAction:(id)sender {
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
    NSString *savedValue1 = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
    
    BOOL isValid=[self CheckForValidation];
    if (active) {
        if (isValid) {
            [[DealGaliInformation sharedInstance]ShowWaiting:PROFILEUPDATING];
            [[DealGaliNetworkEngine sharedInstance]UpdateUserProfileAPI:savedValue UserName:savedValue1 EmailId:self.emailTXT.text Address:self.addressTXT.text State:self.stateTXT.text City:self.cityTXT.text Pin:self.pinTXT.text withCallback:^(NSDictionary *response) {
                [[DealGaliInformation sharedInstance]HideWaiting];
                [self showSucessWithMessage:PROFILEUPDATEDSUCCESSFULLY];
                
                active=NO;
                self.saveBtn.backgroundColor=[UIColor DGLightGrayColor];
            }];
        }
    }
    
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    self.imageView.image = chosenImage;
    NSData *imageData = UIImagePNGRepresentation(chosenImage);
    NSString *base64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"ProfileImage"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
    
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
        NSLog(@"[imageRep filename] : %@", [imageRep filename]);
        [[DealGaliInformation sharedInstance]ShowWaiting:IMAGEUPLODATING];
        NSString *imgName=[imageRep filename];
        if ([imgName length]==0) {
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMdd_HHmmss"];
            NSString *dateTimeStr=[dateFormatter stringFromDate:[NSDate date]];
            // NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
            imgName=[NSString stringWithFormat:@"ios%@.png",dateTimeStr];
        }
        [[DealGaliNetworkEngine sharedInstance]UploadProfileImageAPI:base64 imageName:imgName userId:savedValue withCallback:^(NSDictionary *response) {
            [[DealGaliInformation sharedInstance]HideWaiting];
            
        }];
        NSString *path=[NSString stringWithFormat:@"http://images.dealgali.com/Images/ProfileImage/%@_%@",savedValue,imgName];
        [NSUSERDEFAULTS setObject:path forKey:@"ProfileImagePath"];
        [NSUSERDEFAULTS setObject:@"PROFILE" forKey:@"PROFILE"];
        
        [NSUSERDEFAULTS synchronize];
        NSLog(@"name   %@",imgName);
    };
    
    // get the asset library and fetch the asset based on the ref url
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


#pragma mark UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    active=NO;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 230, 0.0);
    self.scrollView.contentInset = contentInsets;
    
    
    //self.scrollView.contentOffset = CGPointMake(0, textField.frame.origin.y+20);
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField ==self.pinTXT)
    {
        NSUInteger newLength = [self.pinTXT.text length] + [string length] - range.length;
        return newLength <= 6;
    }
    if(textField ==self.phoneTXT)
    {
        NSUInteger newLength = [self.phoneTXT.text length] + [string length] - range.length;
        return newLength <= 10;
    }
    
    
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.scrollView.contentInset = contentInsets;
    [textField resignFirstResponder];
    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField {
    // self.scrollView.contentOffset = CGPointMake(0, 0);
    if ([emailStr isEqualToString:self.emailTXT.text] &&
        [mobileStr isEqualToString:self.phoneTXT.text] &&
        [addressStr isEqualToString:self.addressTXT.text] &&
        [stateStr isEqualToString:self.stateTXT.text] &&
        [cityStr isEqualToString:self.cityTXT.text]&&
        [pinStr isEqualToString:self.pinTXT.text]) {
        self.saveBtn.backgroundColor=[UIColor DGLightGrayColor];
        active=NO;
    }
    else{
        active=YES;
        self.saveBtn.backgroundColor=[UIColor DGPinkColor];
    }
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [activeField resignFirstResponder];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [activeField resignFirstResponder];
}

-(void)touch{
    [self.emailTXT resignFirstResponder];
    [self.phoneTXT resignFirstResponder];
    [self.addressTXT resignFirstResponder];
    [self.stateTXT resignFirstResponder];
    [self.pinTXT resignFirstResponder];
    [self.cityTXT resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.scrollView.contentInset = contentInsets;
    
}
-(BOOL)CheckForValidation
{
    BOOL valid=YES;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[A-Z0-9a-z._%+-]+@[A-Za-z]+\\.[A-Za-z]{2,4}"];
    
    //Mobile number validation
    NSString *phoneRegex =@"^(?:(?:\\+|0{0,2})91(\\s*[\\-]\\s*)?|[0]?)?[789]\\d{9}$";// @"^[789]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if(self.emailTXT.text.length>0){
        if(![emailTest evaluateWithObject:self.emailTXT.text]){
            valid = NO;
            [self showErrorWithMessage:VALIDEMAIL];
            //   [[DealGaliInformation sharedInstance]showAlertWithMessage:VALIDEMAIL withTitle:nil withCancelTitle:OK];
        }
    }
    
    
    else if(self.phoneTXT.text.length>0){
        if((![phoneTest evaluateWithObject:self.phoneTXT.text]) || (self.phoneTXT.text.length!=10) || ([self.phoneTXT.text isEqualToString:@""]&& [self.phoneTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
        {
            valid = NO;
            [self.phoneTXT becomeFirstResponder];
            [self showErrorWithMessage:Validmobile];
            //  [[DealGaliInformation sharedInstance]showAlertWithMessage:Validmobile withTitle:nil withCancelTitle:OK];
        }
        
    }
    
    return valid;
}
- (void)showErrorWithMessage:(NSString *)message {
    if (self.minimalNotification) {
        [self.minimalNotification dismiss];
        [self.minimalNotification removeFromSuperview];
        self.minimalNotification = nil;
    }
    
    self.minimalNotification = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleError
                                                                      title:message
                                                                   subTitle:nil
                                                             dismissalDelay:2.0];
    
    /**
     * Set the desired font for the title and sub-title labels
     * Default is System Normal
     */
    UIFont* titleFont = [UIFont DGLocalNotiFont];
    [self.minimalNotification setTitleFont:titleFont];
    UIFont* subTitleFont = [UIFont systemFontOfSize:16.0];
    [self.minimalNotification setSubTitleFont:subTitleFont];
    
    self.minimalNotification.presentFromTop = YES;
    /**
     * Add the notification to a view
     */
    [self.navigationController.view addSubview:self.minimalNotification];
    
    // show
    [self performSelector:@selector(showNotification) withObject:nil afterDelay:0.1];
}
-(void)showNotification1{
    [self.minimalNotification dismiss];
}

- (void)showNotification {
    [self.minimalNotification show];
    [self performSelector:@selector(showNotification1) withObject:nil afterDelay:2.0];
    
}
- (void)showSucessWithMessage:(NSString *)message {
    if (self.minimalNotification) {
        [self.minimalNotification dismiss];
        [self.minimalNotification removeFromSuperview];
        self.minimalNotification = nil;
    }
    
    self.minimalNotification = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleSuccess
                                                                      title:message
                                                                   subTitle:nil
                                                             dismissalDelay:2.0];
    
    /**
     * Set the desired font for the title and sub-title labels
     * Default is System Normal
     */
    UIFont* titleFont = [UIFont DGLocalNotiFont];
    [self.minimalNotification setTitleFont:titleFont];
    UIFont* subTitleFont = [UIFont systemFontOfSize:16.0];
    [self.minimalNotification setSubTitleFont:subTitleFont];
    
    self.minimalNotification.presentFromTop = YES;
    /**
     * Add the notification to a view
     */
    [self.navigationController.view addSubview:self.minimalNotification];
    
    // show
    [self performSelector:@selector(showSucessNotification) withObject:nil afterDelay:0.1];
}
-(void)showSucessNotification{
    [self.minimalNotification show];
    [self performSelector:@selector(ProfileUpdatation) withObject:nil afterDelay:2.0];
    
}
-(void)ProfileUpdatation{
    [self.minimalNotification dismiss];
    
    
}



#pragma mark - RNGRIDVIEW

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [self showGridWithHeaderFromPoint:[longPress locationInView:self.ViewImgNameHolder]];
    }
}

#pragma mark - RNGridMenuDelegate

- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    //    NSLog(@"Dismissed with item %d: %@", itemIndex, item.title);
    
    switch (itemIndex) {
        case 0:
            //            NSLog(@"case 0, Gallery, Opening gallery");
            [self imagePickFromGallery];
            break;
            
        case 1:
            //            NSLog(@"case 1");
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                      message:@"Device has no camera"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles: nil];
                
                [myAlertView show];
            }else{
                [self imageCaptureByCamera];
            }
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark - Private

- (void)showImagesOnly {
    NSInteger numberOfOptions = 5;
    NSArray *images = @[
                        [UIImage imageNamed:@"arrow"],
                        [UIImage imageNamed:@"attachment"],
                        [UIImage imageNamed:@"block"],
                        [UIImage imageNamed:@"bluetooth"],
                        [UIImage imageNamed:@"cube"],
                        [UIImage imageNamed:@"download"],
                        [UIImage imageNamed:@"enter"],
                        [UIImage imageNamed:@"file"],
                        [UIImage imageNamed:@"github"]
                        ];
    RNGridMenu *av = [[RNGridMenu alloc] initWithImages:[images subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    [av showInViewController:self center:CGPointMake(self.ViewImgNameHolder.bounds.size.width/2.f, self.ViewImgNameHolder.bounds.size.height/2.f)];
}

- (void)showList {
    NSInteger numberOfOptions = 5;
    NSArray *options = @[
                         @"Next",
                         @"Attach",
                         @"Cancel",
                         @"Bluetooth",
                         @"Deliver",
                         @"Download",
                         @"Enter",
                         @"Source Code",
                         @"Github"
                         ];
    RNGridMenu *av = [[RNGridMenu alloc] initWithTitles:[options subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.itemTextAlignment = NSTextAlignmentLeft;
    av.itemFont = [UIFont boldSystemFontOfSize:18];
    av.itemSize = CGSizeMake(150, 55);
    [av showInViewController:self center:CGPointMake(self.ViewImgNameHolder.bounds.size.width/2.f, self.ViewImgNameHolder.bounds.size.height/2.f)];
}

- (void)showGrid {
    NSInteger numberOfOptions = 2;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"photos"] title:@"Gallery"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"camera"] title:@"Camera"],
                       // [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"block"] title:@"Cancel"]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.bounces = NO;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}





- (void)showGridWithHeaderFromPoint:(CGPoint)point {
    NSInteger numberOfOptions = 9;
    NSArray *items = @[
                       [RNGridMenuItem emptyItem],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"attachment"] title:@"Attach"],
                       [RNGridMenuItem emptyItem],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"bluetooth"] title:@"Bluetooth"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"cube"] title:@"Deliver"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"download"] title:@"Download"],
                       [RNGridMenuItem emptyItem],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"file"] title:@"Source Code"],
                       [RNGridMenuItem emptyItem]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    av.bounces = NO;
    av.animationDuration = 0.2;
    //av.blurExclusionPath = [UIBezierPath bezierPathWithOvalInRect:self.imgUser.frame];
    av.backgroundPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.f, 0.f, av.itemSize.width*3, av.itemSize.height*3)];
    
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    header.text = @"Example Header";
    header.font = [UIFont boldSystemFontOfSize:18];
    header.backgroundColor = [UIColor clearColor];
    header.textColor = [UIColor whiteColor];
    header.textAlignment = NSTextAlignmentCenter;
    // av.headerView = header;
    
    [av showInViewController:self center:point];
}

-(void)imagePickFromGallery{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


-(void)imageCaptureByCamera{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


@end
