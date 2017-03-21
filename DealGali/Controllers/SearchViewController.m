//
//  SearchViewController.m
//  DealGali
//
//  Created by Virinchi Software on 23/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "SearchViewController.h"
#import "DealGaliNetworkEngine.h"
#import "DealGaliInformation.h"



@interface SearchViewController ()<UISearchDisplayDelegate,UISearchBarDelegate,UISearchControllerDelegate>
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSMutableArray *searchResults;


@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableData=[[NSMutableArray alloc]init];
    dic=[[NSMutableArray alloc]init];
    //self.tableData = [@[@"One",@"Two",@"Three",@"Twenty-one"] mutableCopy];
    self.searchResults=[[NSMutableArray alloc]init];
    //self.searchResults = [NSMutableArray arrayWithCapacity:[self.tableData count]];
    
    NSData *data = [NSUSERDEFAULTS objectForKey:@"SEARCHDATA"];
    dic= [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self.tableView reloadData];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bckArr.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(previousecall)];
    UIBarButtonItem * revealButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo.png"]]];
    self.navigationItem.leftBarButtonItems = @[revealButtonItem,revealButtonItem1];
    
}
-(void)previousecall{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    // [self getsearchData];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:YES];
    [self.searchBar becomeFirstResponder ];
    self.revealViewController.panGestureRecognizer.enabled=NO;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    self.revealViewController.panGestureRecognizer.enabled=YES;
}
-(void)getsearchData{
    [[DealGaliNetworkEngine sharedInstance] GetSearchListNewAPI:@"" UserId:@""  withCallback:^(NSDictionary *response) {
        dic=[response objectForKey:@"SearchData"];
        
        // [self.tableView reloadData];
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if (searchBarActive)
    {
        return [self.searchResults count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (searchBarActive) {
        UILabel *lbl = (UILabel *)[cell viewWithTag:100];
        UILabel *lbl1 = (UILabel *)[cell viewWithTag:101];
        lbl.textColor=[UIColor DGPurpleColor];
        lbl.font=[UIFont DGTextFieldFont];
        lbl1.textColor=[UIColor DGPinkColor];
        lbl1.font=[UIFont DGTextViewFont];
        //        cell.textLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:18];
        //        cell.textLabel.text =
        lbl.text=[self.searchResults objectAtIndex:indexPath.row];
        NSString *str1=[self.searchResults objectAtIndex:indexPath.row];
        NSUInteger index = [[dic valueForKey:@"SearchName" ] indexOfObject:str1];
        NSDictionary *dict = index != NSNotFound ? dic[index] : nil;
        NSString *typeStr=[NSString stringWithFormat:@"%@",[dict valueForKey:@"Type"]];
        if ([typeStr isEqualToString:@"2"]) {
            lbl1.text=SHOWCASE;
        }
        else if ([typeStr isEqualToString:@"3"]) {
            lbl1.text=SME;
        }
        else if ([typeStr isEqualToString:@"1"]) {
            lbl1.text=STORE;
        }
        
        
    } else {
        //cell.textLabel.text = self.tableData[indexPath.row];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:NO];
    
    // NSLog(@"%@",[self.searchResults objectAtIndex:indexPath.row]);
    NSString *str1=[self.searchResults objectAtIndex:indexPath.row];
    NSUInteger index = [[dic valueForKey:@"SearchName" ] indexOfObject:str1];
    NSDictionary *dict = index != NSNotFound ? dic[index] : nil;
    
    // NSLog(@"%@", [dict valueForKey:@"Type"]);
    NSString *type=[dict valueForKey:@"Type"];
    if ([type isEqualToString:@"2"]) {
        DealDescriptionViewController *dealDesViewController = [[DealGaliInformation sharedInstance]Storyboard:DEALDESCRIPTIONSTORYBOARD];
        dealDesViewController.dealCustomId=[dict valueForKey:@"CustomId"];
        [self.navigationController pushViewController:dealDesViewController animated:YES];
    }
    else if ([type isEqualToString:@"3"]) {
        
        MSMEDescVC *msmeDescVC = [[DealGaliInformation sharedInstance]Storyboard:MSMEDECSTORYBOARD];
        msmeDescVC.dealCustomId=[dict valueForKey:@"CustomId"];
        [self.navigationController pushViewController:msmeDescVC animated:YES];
    }
    else{
        // CompanyProfileViewController *companyVC=[[DealGaliInformation sharedInstance]Storyboard:COMPANYPROFILESTORYBOARD];
        CompanyProfileVC *companyVC = [[CompanyProfileVC alloc] init];
        companyVC.CompanyCustomId=[dict valueForKey:@"CustomId"];
        [self.navigationController pushViewController:companyVC animated:YES];
    }
    
}
-(void)waste{
    [[DealGaliInformation sharedInstance]HideWaiting];
}

#pragma mark - search Delegate

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    //[self.searchResults removeAllObjects];
    
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    self.searchResults = [NSMutableArray arrayWithArray:[[dic valueForKey:@"SearchName"] filteredArrayUsingPredicate:resultPredicate]];
    NSLog(@"%@",self.searchResults);
    if ([self.searchResults count]==0) {
        [[DealGaliInformation sharedInstance]HideWaiting];
        self.resultLbl.text=NOSEARCH;
        self.resultLbl.textColor=[UIColor DGLightGrayColor];
        self.resultLbl.hidden=NO;
    }
    else{
        self.resultLbl.hidden=YES;
    }
    [[dic valueForKey:@"SearchName"] filteredArrayUsingPredicate:resultPredicate];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    // user did type something, check our datasource for text that looks the same
    /* if (searchText.length==1) {
     // search and reload data source
     [[DealGaliNetworkEngine sharedInstance] searchListAPI:searchText withCallback:^(NSDictionary *response) {
     dic=[response objectForKey:@"SearchData"];
     //[dic addObjectsFromArray:data];
     
     [[DealGaliInformation sharedInstance]HideWaiting];
     //            [self searchDisplayController:self.searchDisplayController shouldReloadTableForSearchString:searchText];
     //            _tableView = self.searchDisplayController.searchResultsTableView;
     [self.tableView reloadData];
     
     }];
     
     [self.tableView reloadData];
     }
     
     else */
    
    if (searchText.length==3) {
        // search and reload data source
        searchBarActive = YES;
        [self performSelector:@selector(waste) withObject:nil afterDelay:1.0];
        // [[DealGaliInformation sharedInstance]ShowWaiting:@"Searching Data..."];
        [self filterContentForSearchText:searchText
                                   scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                          objectAtIndex:[self.searchDisplayController.searchBar
                                                         selectedScopeButtonIndex]]];
        
        //        [[DealGaliNetworkEngine sharedInstance] searchListAPI:searchText withCallback:^(NSDictionary *response) {
        //            dic=[response objectForKey:@"SearchData"];
        //            //[dic addObjectsFromArray:data];
        //
        //            [[DealGaliInformation sharedInstance]HideWaiting];
        ////            [self searchDisplayController:self.searchDisplayController shouldReloadTableForSearchString:searchText];
        ////            _tableView = self.searchDisplayController.searchResultsTableView;
        //            [self.tableView reloadData];
        //
        //        }];
        
        [self.tableView reloadData];
        
        
        
    }
    
    else if (searchText.length>3){
        self.resultLbl.hidden=YES;
        searchBarActive = YES;
        [self filterContentForSearchText:searchText
                                   scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                          objectAtIndex:[self.searchDisplayController.searchBar
                                                         selectedScopeButtonIndex]]];
        [self.tableView reloadData];
    }
    else{
        // if text lenght == 0
        // we will consider the searchbar is not active
        self.resultLbl.hidden=YES;
        searchBarActive = NO;
        [self.tableView reloadData];
    }
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self cancelSearching];
    [self.tableView reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    searchBarActive = YES;
    [self.searchBar resignFirstResponder];
    //[self.view endEditing:YES];
    UIButton *cancelButton = [searchBar valueForKey:@"_cancelButton"];
    if ([cancelButton respondsToSelector:@selector(setEnabled:)]) {
        cancelButton.enabled = YES;
    }
    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    // we used here to set self.searchBarActive = YES
    // but we'll not do that any more... it made problems
    // it's better to set self.searchBarActive = YES when user typed something
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    //    NSLog(@"searchBarShouldBeginEditing -Are we getting here??");
    //    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
    //                                                                                                  [UIColor whiteColor],
    //                                                                                                  NSForegroundColorAttributeName,
    //                                                                                                  nil]
    //                                                                                        forState:UIControlStateNormal];
    
    
    return YES;
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    // this method is being called when search btn in the keyboard tapped
    // we set searchBarActive = NO
    // but no need to reloadCollectionView
    searchBarActive = NO;
    [self.searchBar setShowsCancelButton:YES animated:YES];
}
-(void)cancelSearching{
    
    searchBarActive = NO;
    [self.searchBar resignFirstResponder];
    self.searchBar.text  = @"";
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    
    
}


@end
