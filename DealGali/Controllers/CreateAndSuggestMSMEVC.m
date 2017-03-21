//
//  CreateAndSuggestMSMEVC.m
//  DealGali
//
//  Created by Virinchi Software on 08/09/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "CreateAndSuggestMSMEVC.h"

@interface CreateAndSuggestMSMEVC ()

@end

@implementation CreateAndSuggestMSMEVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.nameTXT.textColor=[UIColor DGBlackColor];
    self.nameTXT.font=[UIFont DGTextFieldFont];
    self.mobileTXT.textColor=[UIColor DGBlackColor];
    self.mobileTXT.font=[UIFont DGTextFieldFont];
    self.publicBtn.layer.borderColor=[UIColor DGPurpleColor].CGColor;
    self.publicBtn.layer.borderWidth=1.0;
    self.privateBtn.layer.borderColor=[UIColor DGPurpleColor].CGColor;
    self.privateBtn.layer.borderWidth=1.0;
    self.createNewORSuggestBtn.backgroundColor=[UIColor DGLightGrayColor];
    self.createNewORSuggestBtn.titleLabel.font=[UIFont DGActionButtonFont];
    active=NO;
    self.nameTXT.text=self.name;
    
    self.descTextView.text = ADDDESCRIPTION;
    self.descTextView.textColor = [UIColor DGLightGrayColor];
    self.descTextView.delegate = self;
    
    WhoCanSee=@"Public";
    
    if ([self.type isEqualToString:@"Suggest"]) {
         self.title = NSLocalizedString(self.name, nil);
        self.descLbl.textColor=[UIColor DGLightGrayColor];
        self.descLbl.hidden=NO;
        [self getMSMEDetail];
        [self.createNewORSuggestBtn setTitle:@"Suggest Edit" forState:UIControlStateNormal];
    }
    else{
        self.title = NSLocalizedString(@"create a seller", nil);

        self.descLbl.hidden=YES;
        WhoCanSee=@"Public";
        [self.publicBtn setBackgroundColor:[UIColor DGPurpleColor]];
        [self.privateBtn setBackgroundColor:[UIColor whiteColor]];
        [self.publicBtn setTitleColor:[UIColor DGWhiteColor] forState:UIControlStateNormal];
        [self.privateBtn setTitleColor:[UIColor DGDarkGrayColor] forState:UIControlStateNormal];
        self.uploadImgLbl.text=@"upload cover picture";
        [self.createNewORSuggestBtn setTitle:@"Create New" forState:UIControlStateNormal];
        
    }
    
    //    self.descTextView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    //    self.descTextView.layer.borderWidth=0.5f;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.scrollView addGestureRecognizer:recognizer];
    
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bckArr.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(previousecall)];
    UIBarButtonItem * revealButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo.png"]]];
    self.navigationItem.leftBarButtonItems = @[revealButtonItem,revealButtonItem1];
    // Do any additional setup after loading the view.
    
    NSData *data = [NSUSERDEFAULTS objectForKey:@"HOMEDATA"];
    NSDictionary *retrievedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.responceData = [[NSDictionary alloc] initWithDictionary:retrievedDictionary];
    
    catresArr=[self.responceData objectForKey:@"CategoryData"];
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

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self registerForKeyboardNotifications];
    self.revealViewController.panGestureRecognizer.enabled=NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.revealViewController.panGestureRecognizer.enabled=YES;
}

-(void)getMSMEDetail{
    [[DealGaliInformation sharedInstance]ShowWaiting:Loading];
    
    [[DealGaliNetworkEngine sharedInstance]GetMSMEDealDetailByIdAPI:self.DealId withCallback:^(NSDictionary *response) {
        
        if ([response objectForKey:@"DealDetail"] != nil) {
            NSArray *data=[response objectForKey:@"DealDetail"];
            self.mobileTXT.text=[data valueForKey:@"MobileNumber"];
            WhoCanSee=[data valueForKey:@"WhoCanSee"];
            if ([WhoCanSee isEqualToString:@"Public"]) {
                WhoCanSee=@"Public";
                [self.publicBtn setBackgroundColor:[UIColor DGPurpleColor]];
                [self.privateBtn setBackgroundColor:[UIColor whiteColor]];
                [self.publicBtn setTitleColor:[UIColor DGWhiteColor] forState:UIControlStateNormal];
                [self.privateBtn setTitleColor:[UIColor DGDarkGrayColor] forState:UIControlStateNormal];
            }else{
                WhoCanSee=@"Only Me";
                [self.publicBtn setBackgroundColor:[UIColor DGWhiteColor]];
                [self.privateBtn setBackgroundColor:[UIColor DGPurpleColor]];
                [self.privateBtn setTitleColor:[UIColor DGWhiteColor] forState:UIControlStateNormal];
                [self.publicBtn setTitleColor:[UIColor DGDarkGrayColor] forState:UIControlStateNormal];
            }
            
            
            path=[data valueForKey:@"DealImage"];
            if ([path isKindOfClass:[NSNull class]] || (![path containsString:@".png"])) {
                self.uploadImgLbl.text=@"upload cover picture";
                
                self.imageView.image=[UIImage imageNamed:@"placeholder.png"];
            }
            else{
                self.uploadImgLbl.text=@"change cover picture";
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:path]
                                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            }
            
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            self.imageView.clipsToBounds = YES;
            
            self.descTextView.text=[data valueForKey:@"Description"];
            self.descTextView.textColor = [UIColor DGBlackColor];
            
            
        } else {
            [self getMSMEDetail];
            // No SetEntries in this dict
        }
        
        [[DealGaliInformation sharedInstance]HideWaiting];
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)previousecall{
    [[DealGaliInformation sharedInstance]HideWaiting];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)createNewAction:(id)sender {
    if (active) {
        BOOL isValid=[self CheckForValidation];
        if (isValid) {
            NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];

            self.btnBottomLayout.constant=0;
            
            NSString *deviceID = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceID"];
            
            if ([self.type isEqualToString:@"Suggest"]) {
                [[DealGaliInformation sharedInstance]ShowWaiting:UPDATING];
                [[DealGaliNetworkEngine sharedInstance]UpdateMSMEDealByIdAPI:self.nameTXT.text description:self.descTextView.text mobileNumber:self.mobileTXT.text WhoCanSee:WhoCanSee DeviceId:deviceID DeviceType:@"ios" DealId:self.DealId UserId:userID withCallback:^(NSDictionary *response) {
                    NSString *Status=[response valueForKey:@"Status"];
                    if ([Status isEqualToString:@"1"]) {
                        NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
                        NSString *base64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                        
                        if ([imgName length]==0) {
                            [[DealGaliInformation sharedInstance]HideWaiting];
                            
                            [self showSucessWithMessage:@"Your suggestion has been marked for approval."];
                            
                            }
                        else
                        {
                            [[DealGaliNetworkEngine sharedInstance]UploadMSMEDealImageByIdAPI:[response valueForKey:@"DealId"] uploadImage:base64 imageName:imgName UserId:userID withCallback:^(NSDictionary *response) {
                                [[DealGaliInformation sharedInstance]HideWaiting];
                                
                                [self showSucessWithMessage:@"Your suggestion has been marked for approval."];
                                
                            }];

                        }
                    }
                }];
                
            }
            else{
                NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
                NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
                NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
                [[DealGaliInformation sharedInstance]ShowWaiting:CREATING];
                
                [[DealGaliNetworkEngine sharedInstance]AddMSMEDealAPI:savedValue title:self.nameTXT.text description:self.descTextView.text mobileNumber:self.mobileTXT.text WhoCanSee:WhoCanSee Lat:lat Long:lon CategoryId:self.categoryID DeviceId:deviceID DeviceType:@"ios" withCallback:^(NSDictionary *response) {
                    
                    NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
                    NSString *base64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    if ([imgName length]==0) {
                        [[DealGaliInformation sharedInstance]HideWaiting];
                        [self showSucessWithMessage:@"Created successfully"];
                    }
                    else
                        [[DealGaliNetworkEngine sharedInstance]UploadMSMEDealImageAPI:[response valueForKey:@"DealId"] uploadImage:base64 imageName:imgName withCallback:^(NSDictionary *response) {
                            
                            [[DealGaliInformation sharedInstance]HideWaiting];
                            [self showSucessWithMessage:@"Created successfully"];
                        }];
                }];
            }
            
        }
        
    }
}
#pragma mark - Keyboard, textfield management

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    //self.errorLabel.text = @"";
    NSDictionary* info = [aNotification userInfo];
    keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Ensure that active text field is visible
    [self ensureVisible:self.descTextView withPrevious:NO];
    
    
    keyboardVisible = YES;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    // Reset view
    [self resetVisibleRect];
    
    keyboardVisible = NO;
}


#pragma mark - TextField scrolling helpers

- (void)ensureVisible:(UITextView*)textField withPrevious:(BOOL)previous
{
    CGRect bounds = self.scrollView.bounds;
    
    CGPoint textFieldOrigin = [self.scrollView convertPoint:textField.frame.origin fromView:self.descTextView];
    CGSize textFieldSize = textField.bounds.size;
    
    CGFloat slideValue = 90.0;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        if (previous) {
            //slideValue = bounds.size.height + keyboardSize.height + textFieldSize.height + textFieldOrigin.y;
        } else {
            slideValue = bounds.size.height - keyboardSize.height - textFieldSize.height - textFieldOrigin.y;
        }
        else
            slideValue = bounds.size.height - keyboardSize.width - textFieldSize.height - textFieldOrigin.y;
    
    if (slideValue < 0){
        [self slideWithYValue:-30.0];
    }
    
}


- (void)resetVisibleRect
{
    [self slideWithYValue:70.0];
}

- (void)slideWithYValue:(float)value
{
    CGRect bounds = self.scrollView.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        [self.view setFrame:CGRectMake(0, value, bounds.size.width, bounds.size.height)];
    else
        [self.view setFrame:CGRectMake(value, 0, bounds.size.width, bounds.size.height)];
    [UIView commitAnimations];
}



#pragma mark - TextView Delegate

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    self.descLbl.textColor=[UIColor DGPurpleColor];
    self.descLbl.hidden=NO;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 90, 0.0);
    self.scrollView.contentInset = contentInsets;
    if ([self.descTextView.text isEqualToString:ADDDESCRIPTION]) {
        self.descTextView.text = @"";
    }else
        self.descTextView.text = textView.text;
    
    self.descTextView.textColor = [UIColor DGBlackColor];
    
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    [self submitMethod];
    
    if((self.descTextView.text.length == 0) && [self.descTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]){
        self.descTextView.textColor = [UIColor lightGrayColor];
        self.descTextView.text = ADDDESCRIPTION;
        self.descLbl.hidden=YES;
        [self.descTextView resignFirstResponder];
    }
    
    //    if((self.descTextView.text.length == 0) && [self.descTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]){
    //        // [self viewWillAppear:YES];
    //    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    self.descLbl.textColor=[UIColor DGLightGrayColor];
    self.btnBottomLayout.constant=5;
}

#pragma mark UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 90, 0.0);
    self.scrollView.contentInset = contentInsets;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField ==self.mobileTXT)
    {
        NSUInteger newLength = [self.mobileTXT.text length] + [string length] - range.length;
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
    [self submitMethod];
    self.btnBottomLayout.constant=5;
    
    // self.scrollview.contentOffset = CGPointMake(0, 0);
}
-(void)submitMethod{
    if (self.nameTXT.hasText && self.mobileTXT.hasText && self.descTextView.hasText) {
        self.createNewORSuggestBtn.backgroundColor=[UIColor DGPinkColor];
        active=YES;
    }
    else{
        self.createNewORSuggestBtn.backgroundColor=[UIColor DGLightGrayColor];
        active=NO;
    }
    
}

-(void)touch{
    self.btnBottomLayout.constant=0;
    [self.mobileTXT resignFirstResponder];
    [self.nameTXT resignFirstResponder];
    [self.descTextView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.scrollView.contentInset = contentInsets;
}

- (IBAction)editImageAction:(id)sender {
    [self showGrid];
}


#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    self.imageView.image = chosenImage;
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
        NSLog(@"[imageRep filename] : %@", [imageRep filename]);
        imgName=[imageRep filename];
        if ([imgName length]==0) {
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMdd_HHmmss"];
            NSString *dateTimeStr=[dateFormatter stringFromDate:[NSDate date]];
            imgName=[NSString stringWithFormat:@"ios%@.png",dateTimeStr];
        }
        self.uploadImgLbl.text=@"change cover picture";
        NSLog(@"name   %@",imgName);
        [self submitMethod];
        self.btnBottomLayout.constant=0;
    };
    
    // get the asset library and fetch the asset based on the ref url
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
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


-(BOOL)CheckForValidation
{
    BOOL valid=YES;
    
    //Mobile number validation
    NSString *phoneRegex =@"^(?:(?:\\+|0{0,2})91(\\s*[\\-]\\s*)?|[0]?)?[789]\\d{9}$";// @"^[789]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    
    
    if(([self.nameTXT.text isEqualToString:@""]&& [self.nameTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        valid = NO;
        [self.nameTXT becomeFirstResponder];
        self.btnBottomLayout.constant=0;
        [self showErrorWithMessage:Enterusername];
        
        // [[DealGaliInformation sharedInstance]showAlertWithMessage:Enterusername withTitle:nil withCancelTitle:OK];
    }
    else if((![phoneTest evaluateWithObject:self.mobileTXT.text]) || (self.mobileTXT.text.length!=10) || ([self.mobileTXT.text isEqualToString:@""]&& [self.mobileTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        valid = NO;
        [self.mobileTXT becomeFirstResponder];
        self.btnBottomLayout.constant=0;
        [self showErrorWithMessage:Validmobile];
        
        // [[DealGaliInformation sharedInstance]showAlertWithMessage:Validmobile withTitle:nil withCancelTitle:OK];
    }
    
    else if(([self.descTextView.text isEqualToString:@""] || ([self.descTextView.text isEqualToString:ADDDESCRIPTION]&& [self.descTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))){
        
        valid = NO;
        self.btnBottomLayout.constant=0;
        [self showErrorWithMessage:EnterDescription];
        
        //[[DealGaliInformation sharedInstance]showAlertWithMessage:VALIDEMAIL withTitle:nil withCancelTitle:OK];
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
    self.btnBottomLayout.constant=0;
    
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
    
    [self.minimalNotification dismiss];
    [self performSelector:@selector(respnceSucess) withObject:nil afterDelay:2.0];
    
}
-(void)respnceSucess{
    
    
    DealLiistViewController *dealListViewController = [[DealGaliInformation sharedInstance]Storyboard:DEALLISTSTORYBOARD];
    dealListViewController.ControllerName=@"MSME";
    //dealListViewController.value=@"home";
    //dealListViewController.data=dic;
    dealListViewController.alldata=categoryDic;
    
    [self.navigationController pushViewController:dealListViewController animated:YES];
    
   // [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)selectionPublicAction:(id)sender {
    if (![WhoCanSee isEqualToString:@"Public"]) {
        [self submitMethod];
    }
    //    else{
    //        active=NO;
    //        self.createNewORSuggestBtn.backgroundColor=[UIColor DGLightGrayColor];
    //    }
    WhoCanSee=@"Public";
    [self.publicBtn setBackgroundColor:[UIColor DGPurpleColor]];
    [self.privateBtn setBackgroundColor:[UIColor whiteColor]];
    [self.publicBtn setTitleColor:[UIColor DGWhiteColor] forState:UIControlStateNormal];
    [self.privateBtn setTitleColor:[UIColor DGDarkGrayColor] forState:UIControlStateNormal];
    
    
}

- (IBAction)selectionPrivateAction:(id)sender {
    if ([WhoCanSee isEqualToString:@"Public"]) {
        [self submitMethod];
    }
    //    else{
    //        active=NO;
    //        self.createNewORSuggestBtn.backgroundColor=[UIColor DGLightGrayColor];
    //    }
    WhoCanSee=@"Only Me";
    [self.publicBtn setBackgroundColor:[UIColor DGWhiteColor]];
    [self.privateBtn setBackgroundColor:[UIColor DGPurpleColor]];
    [self.publicBtn setTitleColor:[UIColor DGDarkGrayColor] forState:UIControlStateNormal];
    [self.privateBtn setTitleColor:[UIColor DGWhiteColor] forState:UIControlStateNormal];
    
}

@end
