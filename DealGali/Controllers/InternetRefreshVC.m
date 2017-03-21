//
//  InternetRefreshVC.m
//  DealGali
//
//  Created by Virinchi Software on 16/09/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "InternetRefreshVC.h"

@interface InternetRefreshVC ()

@end

@implementation InternetRefreshVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.revealViewController.panGestureRecognizer.enabled=NO;
    [self.navigationController setNavigationBarHidden:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.revealViewController.panGestureRecognizer.enabled=YES;
    [self.navigationController setNavigationBarHidden:NO];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)refreshAction:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://services.dealgali.com/GMapService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        //responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Some error in your Connection. Please try again.");
    
    self.alertView = [[UIAlertView alloc] initWithTitle:NoInternetConnection message:TryAgainLater delegate:self cancelButtonTitle:OK otherButtonTitles:nil];
    [self.alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
}
@end
