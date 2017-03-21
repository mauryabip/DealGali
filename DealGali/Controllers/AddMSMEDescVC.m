//
//  AddMSMEDescVC.m
//  DealGali
//
//  Created by Virinchi Software on 06/09/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "AddMSMEDescVC.h"

@interface AddMSMEDescVC ()

@end

@implementation AddMSMEDescVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"select category", nil);

    NSData *dataCat = [NSUSERDEFAULTS objectForKey:@"CATEGORIES"];
    catArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataCat];
    NSData *dataMSMECat = [NSUSERDEFAULTS objectForKey:@"MSMECATEGORIES"];
    msmeCatArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataMSMECat];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bckArr.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(previousecall)];
    UIBarButtonItem *revealButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo.png"]]];
    self.navigationItem.leftBarButtonItems = @[revealButtonItem,revealButtonItem1];
    
    
    // Do any additional setup after loading the view.
}

-(void)previousecall{
    [[DealGaliInformation sharedInstance]HideWaiting];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.revealViewController.panGestureRecognizer.enabled=NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.revealViewController.panGestureRecognizer.enabled=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return [catArray count];
    }
    else
        return [msmeCatArray count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *catNameLbl = (UILabel *)[cell viewWithTag:100];
    UILabel *totalBusinessLbl = (UILabel *)[cell viewWithTag:101];
    
    catNameLbl.textColor=[UIColor DGDarkGrayColor];
    catNameLbl.font=[UIFont DGTextFieldFont];
    totalBusinessLbl.textColor=[UIColor DGLightGrayColor];
    totalBusinessLbl.font=[UIFont DGTextViewFont];
    if (indexPath.section==0) {
        NSString *catName=[[catArray valueForKey:@"CategoryName"]objectAtIndex:indexPath.row];
        
        catNameLbl.text=catName;
        totalBusinessLbl.text=[NSString stringWithFormat:@"%@ Business",[[catArray valueForKey:@"TotalDealCount"]objectAtIndex:indexPath.row]];
    }
    else{
        NSString *msmeCatName=[[msmeCatArray valueForKey:@"CategoryName"]objectAtIndex:indexPath.row];
        
        catNameLbl.text=msmeCatName;
        NSString *totaldeals=[[msmeCatArray valueForKey:@"TotalDealCount"]objectAtIndex:indexPath.row];
        if ([totaldeals isKindOfClass:[NSNull class]]) {
            totalBusinessLbl.text=@"0 Business";
        }
        else
            totalBusinessLbl.text=[NSString stringWithFormat:@"%@ Business",totaldeals];
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CreateAndSuggestMSMEVC *createVC = [[DealGaliInformation sharedInstance]Storyboard:CREATEANDSUGGESTMSMESTORYBOARD];
    createVC.name=self.name;
    if (indexPath.section==0) {
        NSString *catid=[[catArray valueForKey:@"CategoryId"]objectAtIndex:indexPath.row];
        createVC.categoryID=catid;
    }
    else{
        NSString *msmeCatid=[[msmeCatArray valueForKey:@"CategoryId"]objectAtIndex:indexPath.row];
        createVC.categoryID=msmeCatid;
        
    }
    
    [self.navigationController pushViewController:createVC animated:YES];
}


@end
