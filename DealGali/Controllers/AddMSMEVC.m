//
//  AddMSMEVC.m
//  DealGali
//
//  Created by Virinchi Software on 03/09/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "AddMSMEVC.h"
#import "DXPopover.h"


@interface AddMSMEVC (){
    
    CGFloat _popoverWidth;
    CGSize _popoverArrowSize;
    CGFloat _popoverCornerRadius;
    CGFloat _animationIn;
    CGFloat _animationOut;
    BOOL _animationSpring;
}

@property (strong, nonatomic) MKPointAnnotation *centerAnnotaion;
@property (strong, nonatomic) MKPinAnnotationView *centerAnnotationView;
@property (strong, nonatomic) UIToolbar *toolbar;
@property (nonatomic) BOOL lastValidZoomState;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, readwrite) CLLocationCoordinate2D selectedCoordinate;

@property (nonatomic, strong) NSArray *configs;
@property (nonatomic, strong) UITableView *popTableView;
@property (nonatomic, strong) DXPopover *popover;
@end


@implementation AddMSMEVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData];
    
    
    //[mapView setShowsUserLocation: YES];
    [_mapView setUserTrackingMode: MKUserTrackingModeFollow animated: NO];
    [_mapView setDelegate: self];
    [self.mapView addSubview:self.centerAnnotationView];
    //[mapView setCenterCoordinate:mapView.region.center animated:NO];
    
    // Do any additional setup after loading the view.
    self.tableData=[[NSMutableArray alloc]init];
    dic=[[NSMutableArray alloc]init];
    //self.tableData = [@[@"One",@"Two",@"Three",@"Twenty-one"] mutableCopy];
    self.searchResults=[[NSMutableArray alloc]init];
    //self.searchResults = [NSMutableArray arrayWithCapacity:[self.tableData count]];
    
    // NSData *data = [NSUSERDEFAULTS objectForKey:@"SEARCHDATA"];
    // dic= [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self.tableView reloadData];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bckArr.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(previousecall)];
    UIBarButtonItem * revealButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo.png"]]];
    self.navigationItem.leftBarButtonItems = @[revealButtonItem,revealButtonItem1];
    
    
    UITableView *blueView = [[UITableView alloc] init];
    blueView.frame = CGRectMake(0, 0, _popoverWidth, 175);
    blueView.dataSource = self;
    blueView.delegate = self;
    self.popTableView = blueView;
    
    self.popover = [DXPopover new];
    _popoverWidth = self.view.frame.size.width;
    self.configs = @[
                     @"Suggest Edits",
                     @"Report Duplicates",
                     @"Inappropriate Content",
                     @"Not a Public Place",
                     ];
    
    
}
-(void)getData{
    //        NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
    //        NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
    //    [[DealGaliNetworkEngine sharedInstance]GetMSMETitleListAPI:@"" Lat:lat Lon:lon withCallback:^(NSDictionary *response) {
    //        dic=[response objectForKey:@"SearchData"];
    //        [self.tableView reloadData];
    //
    //    }];
}

-(void)previousecall{
    [[DealGaliInformation sharedInstance]HideWaiting];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
    //    NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
    //[self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(DEFAULT_CENTER_LATTITUDE, DEFAULT_CENTER_LONGITUDE),self.initialMapSize, self.initialMapSize)];
    self.revealViewController.panGestureRecognizer.enabled=NO;
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.popTableView) {
        return self.configs.count;
    }
    else{
        if (searchBarActive)
        {
            return [self.searchResults count];
        } else {
            return [dic count];
        }
        
    }
    // Return the number of rows in the section.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_popTableView) {
        return 44;
    }
    else{
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *lbl = (UILabel *)[cell viewWithTag:100];
    UILabel *likeLbl = (UILabel *)[cell viewWithTag:101];
    UILabel *viewLbl = (UILabel *)[cell viewWithTag:102];
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:1000];
    
    lbl.textColor=[UIColor DGDarkGrayColor];
    lbl.font=[UIFont DGTextFieldFont];
    likeLbl.textColor=[UIColor DGLightGrayColor];
    likeLbl.font=[UIFont DGTextViewFont];
    viewLbl.textColor=[UIColor DGLightGrayColor];
    viewLbl.font=[UIFont DGTextViewFont];
    
    
    UIButton *btn =(UIButton *)[cell viewWithTag:1002];
    [btn addTarget:self action:@selector(showPopover:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (tableView==_popTableView) {
        static NSString *cellId = @"cellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.text = self.configs[indexPath.row];
        
        return cell;
    }
    else{
        if (searchBarActive) {
            
            lbl.text=[self.searchResults objectAtIndex:indexPath.row];
            NSString *str1=[self.searchResults objectAtIndex:indexPath.row];
            NSUInteger index = [[dic valueForKey:@"SearchName" ] indexOfObject:str1];
            NSDictionary *dict = index != NSNotFound ? dic[index] : nil;
            NSString *likeStr=[NSString stringWithFormat:@"%@ Likes",[dict valueForKey:@"TotalLike"]];
            NSString *viewStr=[NSString stringWithFormat:@"%@ Views",[dict valueForKey:@"TotalView"]];
            likeLbl.text=likeStr;
            viewLbl.text=viewStr;
            NSString *path=[dict valueForKey:@"CategoryImage"];
            [imgView sd_setImageWithURL:[NSURL URLWithString:path]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView.clipsToBounds = YES;
            
            
        }
        else {
            lbl.text=[[dic objectAtIndex:indexPath.row]valueForKey:@"SearchName"];
            NSString *path=[[dic objectAtIndex:indexPath.row]valueForKey:@"CategoryImage"];
            [imgView sd_setImageWithURL:[NSURL URLWithString:path]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView.clipsToBounds = YES;
            
            likeLbl.text=[NSString stringWithFormat:@"%@ Likes",[[dic objectAtIndex:indexPath.row]valueForKey:@"TotalLike"]];
            viewLbl.text=[NSString stringWithFormat:@"%@ Views",[[dic objectAtIndex:indexPath.row]valueForKey:@"TotalView"]];
            
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(tableView==_popTableView){
        if (indexPath.row==0) {
            CreateAndSuggestMSMEVC *createVC = [[DealGaliInformation sharedInstance]Storyboard:CREATEANDSUGGESTMSMESTORYBOARD];
            if (searchBarActive) {
                createVC.name=name;
                createVC.type=@"Suggest";
                createVC.DealId=catID;
                
            }
            else{
                createVC.name=name;
                createVC.DealId=catID;
                createVC.type=@"Suggest";
            }
            [self.navigationController pushViewController:createVC animated:YES];
        }
        else if (indexPath.row==1) {
            [[DealGaliInformation sharedInstance]showAlertWithMessage:@"Duplicate data reported" withTitle:ALERT withCancelTitle:OK];
        }
        else if (indexPath.row==2) {
            [[DealGaliInformation sharedInstance]showAlertWithMessage:@"Inappropiate Content" withTitle:ALERT withCancelTitle:OK];
        }
        else {
            [[DealGaliInformation sharedInstance]showAlertWithMessage:@"Not a Public Place" withTitle:ALERT withCancelTitle:OK];
        }
        
        [self.popover dismiss];
    }
    
    else{
        
        CreateAndSuggestMSMEVC *createVC = [[DealGaliInformation sharedInstance]Storyboard:CREATEANDSUGGESTMSMESTORYBOARD];
        if (searchBarActive) {
            NSString *str1=[self.searchResults objectAtIndex:indexPath.row];
            createVC.name=str1;
            
            NSUInteger index = [[dic valueForKey:@"SearchName" ] indexOfObject:str1];
            NSDictionary *dict = index != NSNotFound ? dic[index] : nil;
            createVC.type=@"Suggest";
            createVC.DealId=[dict valueForKey:@"Id"];
            
        }
        else{
            createVC.DealId=[[dic objectAtIndex:indexPath.row]valueForKey:@"Id"];
            createVC.type=@"Suggest";
            createVC.name=[[dic objectAtIndex:indexPath.row]valueForKey:@"SearchName"];
            
        }
        [self.navigationController pushViewController:createVC animated:YES];
        
    }
    
}
-(void)showPopover:(UIButton*)sender{
    [self updateTableViewFrame];
    
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    if (searchBarActive) {
        name=[self.searchResults objectAtIndex:indexPath.row];
        
        NSUInteger index = [[dic valueForKey:@"SearchName" ] indexOfObject:name];
        NSDictionary *dict = index != NSNotFound ? dic[index] : nil;
        catID=[dict valueForKey:@"Id"];
        
    }
    else{
        catID=[[dic objectAtIndex:indexPath.row]valueForKey:@"Id"];
        name=[[dic objectAtIndex:indexPath.row]valueForKey:@"SearchName"];
        
    }
    
    
    CGFloat yAxis=buttonPosition.y+188;
    CGFloat totalY=SCREENHEIGHT-yAxis;
    if (totalY<=210) {
        CGPoint startPoint = CGPointMake(CGRectGetMidX(CGRectMake(buttonPosition.x, buttonPosition.y, 25, 20)), buttonPosition.y+180);
        
        [self.popover showAtPoint:startPoint
                   popoverPostion:DXPopoverPositionUp
                  withContentView:self.popTableView
                           inView:self.view];
        
    }
    else{
        CGPoint startPoint = CGPointMake(CGRectGetMidX(CGRectMake(buttonPosition.x, buttonPosition.y, 25, 20)), buttonPosition.y+188);
        
        [self.popover showAtPoint:startPoint
                   popoverPostion:DXPopoverPositionDown
                  withContentView:self.popTableView
                           inView:self.view];
        
    }
    
    __weak typeof(self) weakSelf = self;
    self.popover.didDismissHandler = ^{
        [weakSelf bounceTargetView:weakSelf.addBtn];
    };
    
}

#pragma mark - search

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    //[self.searchResults removeAllObjects];
    
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    self.searchResults = [NSMutableArray arrayWithArray:[[dic valueForKey:@"SearchName"] filteredArrayUsingPredicate:resultPredicate]];
    NSLog(@"%@",self.searchResults);
    if ([self.searchResults count]==0) {
        [[DealGaliInformation sharedInstance]HideWaiting];
        self.tableView.hidden=YES;
    }
    else{
        self.tableView.hidden=NO;
    }
    //[[dic valueForKey:@"SearchName"] filteredArrayUsingPredicate:resultPredicate];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
    if (searchText.length>0) {
        searchTXT=searchText;
        NSString *str=[NSString stringWithFormat:@"Add '%@'",searchText];
        [self.addBtn setTitle:str forState:UIControlStateNormal];
        
        // search and reload data source
        searchBarActive = YES;
        // [[DealGaliInformation sharedInstance]ShowWaiting:@"Searching Data..."];
        [self filterContentForSearchText:searchText
                                   scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                          objectAtIndex:[self.searchDisplayController.searchBar
                                                         selectedScopeButtonIndex]]];
        
        
        [self.tableView reloadData];
        
        // self.tableView.hidden=NO;
        
        
    }
    
    else{
        //self.tableView.hidden=NO;
        
        // if text lenght == 0
        // we will consider the searchbar is not active
        [self.searchResults removeAllObjects];
        self.searchResults=[[NSMutableArray alloc]init];
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
    [self.searchBar setShowsCancelButton:NO animated:YES];
}
-(void)cancelSearching{
    
    searchBarActive = NO;
    self.tableView.hidden=NO;
    [self.searchBar resignFirstResponder];
    self.searchBar.text  = @"";
    
    
}


- (IBAction)addBtnAction:(id)sender {
    //    NSString *str=[NSString stringWithFormat:@"Add '%@'",searchTXT];
    //    [self.addBtn setTitle:str forState:UIControlStateNormal];
    
    AddMSMEDescVC *addMSMEDescVC = [[DealGaliInformation sharedInstance]Storyboard:ADDMSMEDESCSTRORYBOARD];
    addMSMEDescVC.name=searchTXT;
    [self.navigationController pushViewController:addMSMEDescVC animated:YES];
}

- (void)updateTableViewFrame {
    CGRect tableViewFrame = self.popTableView.frame;
    tableViewFrame.size.width = _popoverWidth;
    self.popTableView.frame = tableViewFrame;
    self.popover.contentInset = UIEdgeInsetsZero;
    self.popover.backgroundColor = [UIColor whiteColor];
}

- (void)bounceTargetView:(UIView *)targetView {
    targetView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.3
          initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         targetView.transform = CGAffineTransformIdentity;
                     }
                     completion:nil];
}

#pragma mark - Setters/Getters

- (MKPointAnnotation *)centerAnnotaion
{
    if (!_centerAnnotaion) {
        _centerAnnotaion = [[MKPointAnnotation alloc] init];
    }
    
    return _centerAnnotaion;
}

- (MKPinAnnotationView *)centerAnnotationView
{
    if (!_centerAnnotationView) {
        _centerAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:self.centerAnnotaion
                                                                reuseIdentifier:@"centerAnnotationView"];
        _centerAnnotationView.pinColor = MKPinAnnotationColorPurple;
    }
    
    return _centerAnnotationView;
}

//- (CLLocationCoordinate2D)selectedCoordinate
//{
//    return self.mapView.centerCoordinate;
//}

- (void)setMapView:(MKMapView *)mapView
{
    // Remove ourselves as delegate to old and add to new
    if (_mapView) {
        _mapView.delegate = nil;
    }
    
    _mapView = mapView;
    
    if (_mapView) {
        mapView.delegate = self;
    }
}

#define DEFAULT_INITIAL_SIZE 5000000

- (NSUInteger)initialMapSize
{
    if (!_initialMapSize) {
        _initialMapSize = DEFAULT_INITIAL_SIZE;
    }
    
    return _initialMapSize;
}

#define DEFAULT_ZOOM_SIZE 1000

- (NSUInteger)zoomMapSize
{
    if (!_zoomMapSize) {
        _zoomMapSize = DEFAULT_ZOOM_SIZE;
    }
    
    return _zoomMapSize;
}

- (void)setDoesDisplayPointAccuracyIndicators:(BOOL)doesDisplayPointAccuracyIndicators
{
    _doesDisplayPointAccuracyIndicators = doesDisplayPointAccuracyIndicators;
    [self updatePointAccuracyIndicators];
}

-(void)setRequiredPointAccuracy:(CLLocationDistance)requiredPointAccuracy
{
    _requiredPointAccuracy = requiredPointAccuracy;
    [self updatePointAccuracyIndicators];
}

- (void)setZoomToUser:(BOOL)zoomToUser
{
    if (zoomToUser) {
        if (self.mapView.showsUserLocation && self.mapView.userLocation.location && !self.mapView.userLocation.updating) {
            [self changeRegionToCoordinate:self.mapView.userLocation.location.coordinate withSize:self.zoomMapSize];
            _zoomToUser = NO;
        } else {
            _zoomToUser = YES;
        }
    } else
    {
        _zoomToUser = NO;
    }
}

- (UIToolbar *)toolbar
{
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] init];
        _toolbar.opaque = NO;
        _toolbar.translucent = YES;
        [_toolbar setBackgroundImage:[UIImage new]
                  forToolbarPosition:UIBarPositionAny
                          barMetrics:UIBarMetricsDefault];
        [_toolbar setShadowImage:[UIImage new]
              forToolbarPosition:UIToolbarPositionAny];
        MKUserTrackingBarButtonItem *userTrackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
        
        [_toolbar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], userTrackingButton]];
    }
    
    return _toolbar;
}

- (void)setShowUserTrackingButton:(BOOL)showUserTrackingButton
{
    if (_showUserTrackingButton != showUserTrackingButton) {
        _showUserTrackingButton = showUserTrackingButton;
        if (self.view.window) {
            if (_showUserTrackingButton) {
                [self initToolbarAndAdd];
            } else {
                [self.toolbar removeFromSuperview];
            }
        }
    }
}

- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    
    return _geocoder;
}

- (CLLocationCoordinate2D)userCoordinate
{
    return self.mapView.userLocation.coordinate;
}

#pragma mark - View Controller Lifecycle


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self moveMapAnnotationToCoordinate:self.mapView.centerCoordinate];
    
    if (self.showUserTrackingButton) {
        [self initToolbarAndAdd];
    }
}

#pragma mark - main methods

- (void)initToolbarAndAdd
{
    self.toolbar.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
    
    [self.mapView addSubview:self.toolbar];
}

// These are the constants need to offset distance between the lower left corner of
// the annotaion view and the head of the pin
#define PIN_WIDTH_OFFSET 7.75
#define PIN_HEIGHT_OFFSET 5

- (void)moveMapAnnotationToCoordinate:(CLLocationCoordinate2D) coordinate
{
    CGPoint mapViewPoint = [self.mapView convertCoordinate:coordinate toPointToView:self.mapView];
    
    // Offset the view from to account for distance from the lower left corner to the pin head
    CGFloat xoffset = CGRectGetMidX(self.centerAnnotationView.bounds) - PIN_WIDTH_OFFSET;
    CGFloat yoffset = -CGRectGetMidY(self.centerAnnotationView.bounds) + PIN_HEIGHT_OFFSET;
    
    self.centerAnnotationView.center = CGPointMake(mapViewPoint.x + xoffset,
                                                   mapViewPoint.y + yoffset);
}

- (void)changeRegionToCoordinate:(CLLocationCoordinate2D)coordinate withSize:(NSUInteger)size
{
    MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(coordinate, size, size);
    [self.mapView setRegion:newRegion animated:YES];
}

- (CLLocationDistance)metersPerViewPoint
{
    CGRect comparisonRect = CGRectMake(self.mapView.center.x,
                                       self.mapView.center.y,
                                       1,
                                       1);
    MKCoordinateRegion comparisonRegion = [self.mapView convertRect:comparisonRect toRegionFromView:self.mapView];
    CLLocationCoordinate2D comparisonCoordinate1 = CLLocationCoordinate2DMake(comparisonRegion.center.latitude - comparisonRegion.span.latitudeDelta,
                                                                              comparisonRegion.center.longitude - comparisonRegion.span.longitudeDelta);
    CLLocationCoordinate2D comparisonCoordinate2 = CLLocationCoordinate2DMake(comparisonRegion.center.latitude + comparisonRegion.span.latitudeDelta,
                                                                              comparisonRegion.center.longitude + comparisonRegion.span.longitudeDelta);
    CLLocationDistance sizeInMeters = MKMetersBetweenMapPoints(MKMapPointForCoordinate(comparisonCoordinate1),
                                                               MKMapPointForCoordinate(comparisonCoordinate2));
    
    return sizeInMeters;
}

- (BOOL)mapIsAtValidZoomScale
{
    if (self.requiredPointAccuracy) {
        return [self metersPerViewPoint] <= self.requiredPointAccuracy;
    } else {
        return YES;
    }
}

#define INDICATOR_BORDER_WIDTH 5

- (void)updatePointAccuracyIndicators
{
    if (self.doesDisplayPointAccuracyIndicators && self.requiredPointAccuracy > 0) {
        if ([self mapIsAtValidZoomScale]) {
            self.mapView.layer.borderColor = [UIColor greenColor].CGColor;
            self.mapView.layer.borderWidth = INDICATOR_BORDER_WIDTH;
        } else {
            self.mapView.layer.borderColor = [UIColor redColor].CGColor;
            self.mapView.layer.borderWidth = INDICATOR_BORDER_WIDTH;
        }
    }
    else
    {
        self.mapView.layer.borderWidth = 0;
    }
    
}

- (CLLocation *)locationForCoordinate:(CLLocationCoordinate2D)coordinate
{
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:coordinate
                                                         altitude:0
                                               horizontalAccuracy:1
                                                 verticalAccuracy:1
                                                        timestamp:[NSDate date]];
    
    return location;
}

- (void)reverseGeoCodeAfterTimer:(NSTimer *)timer
{
    CLLocation *location = (CLLocation *)timer.userInfo;
    
    // If we are still at the same location after the delay, reverse geocod
    if ((location.coordinate.latitude == self.selectedCoordinate.latitude) &&
        (location.coordinate.longitude == self.selectedCoordinate.longitude)) {
        CLGeocodeCompletionHandler handler = ^(NSArray *placemark, NSError *error){
            if (error) {
                NSLog(@"Error in geocode request. Error message: %@", error);
            }
            else
            {
                // If there is atleast one placemark, set the selected placemark and call delegate
                if (placemark && ([placemark count] > 0)) {
                    self.selectedPlacemark = placemark[0];
                    NSLog(@"%@", placemark);
                    NSLog(@"Reverse location name: %@", self.selectedPlacemark.name);
                    if ([self.delegate respondsToSelector:@selector(centerPinMapViewController:didResolvePlacemark:)]) {
                        // Notify delegate on main thread
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.delegate centerPinMapViewController:self didResolvePlacemark:placemark[0]];
                        });
                    }
                }
            }
        };
        [self.geocoder reverseGeocodeLocation:location completionHandler:handler];
    }
}

#pragma mark - MapView Delegate methods

#define REVERSE_GEOCODE_DELAY 2.0

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    BOOL currentZoomStateValid = [self mapIsAtValidZoomScale];
    
    if (self.lastValidZoomState != currentZoomStateValid) {
        self.lastValidZoomState = currentZoomStateValid;
        if (self.doesDisplayPointAccuracyIndicators && self.requiredPointAccuracy > 0) {
            [self updatePointAccuracyIndicators];
        }
        
        if ([self.delegate respondsToSelector:@selector(centerPinMapViewController:didChangeValidZoomScaleTo:)]) {
            [self.delegate centerPinMapViewController:self didChangeValidZoomScaleTo:currentZoomStateValid];
        }
    }
    
    // If the center coordinate has changed, update values
    if ((self.centerAnnotaion.coordinate.latitude) != (self.mapView.centerCoordinate.latitude) ||
        (self.centerAnnotaion.coordinate.longitude != (self.mapView.centerCoordinate.longitude))) {
        
        self.centerAnnotaion.coordinate = mapView.centerCoordinate;
        self.selectedPlacemark = nil;
        
        [self moveMapAnnotationToCoordinate:mapView.centerCoordinate];
        
        // If the current zoom state is valid update selected values
        if (currentZoomStateValid) {
            self.selectedCoordinate = self.mapView.centerCoordinate;
            
            // Schedule geocode if enabled
            if (self.shouldReverseGeocode) {
                [NSTimer scheduledTimerWithTimeInterval:REVERSE_GEOCODE_DELAY
                                                 target:self selector:@selector(reverseGeoCodeAfterTimer:)
                                               userInfo:[self locationForCoordinate:self.selectedCoordinate]
                                                repeats:NO];
            }
            
            if ([self.delegate respondsToSelector:@selector(centerPinMapViewController:didChangeSelectedCoordinate:)]) {
                [self.delegate centerPinMapViewController:self didChangeSelectedCoordinate:self.mapView.centerCoordinate];
            }
        }
        //   NSLog(@"%f%f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
        NSString *updatedlat=[NSString stringWithFormat:@"%f",mapView.centerCoordinate.latitude];
        NSString *updatedlong=[NSString stringWithFormat:@"%f",mapView.centerCoordinate.longitude];
        NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
        
        [[DealGaliNetworkEngine sharedInstance]GetMSMETitleListAPI:userID SearchData:@"" Lat:updatedlat Lon:updatedlong withCallback:^(NSDictionary *response) {
            dic=[response objectForKey:@"SearchData"];
            [self.tableView reloadData];
            
        }];
        
    }
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (self.zoomToUser) {
        [self changeRegionToCoordinate:userLocation.coordinate withSize:self.zoomMapSize];
        self.zoomToUser = NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(centerPinMapViewController:didUpdateUserLocation:)]) {
        [self.delegate centerPinMapViewController:self didUpdateUserLocation:userLocation.location];
    }
}



@end
