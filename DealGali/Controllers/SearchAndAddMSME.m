//
//  SearchAndAddMSME.m
//  DealGali
//
//  Created by Virinchi Software on 03/09/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "SearchAndAddMSME.h"
#import "DXPopover.h"
#import "SearchAndAddMSMECell.h"
#import "AddNewMSMECell.h"


#define SCREEN_HEIGHT_WITHOUT_STATUS_BAR     [[UIScreen mainScreen] bounds].size.height - 20
#define SCREEN_WIDTH                         [[UIScreen mainScreen] bounds].size.width
#define HEIGHT_STATUS_BAR                    20
#define Y_DOWN_TABLEVIEW                     SCREEN_HEIGHT_WITHOUT_STATUS_BAR - 34
#define DEFAULT_HEIGHT_HEADER                200.0f
#define MIN_HEIGHT_HEADER                    10.0f
#define DEFAULT_Y_OFFSET                     ([[UIScreen mainScreen] bounds].size.height == 480.0f) ? -200.0f : -250.0f
#define FULL_Y_OFFSET                        -200.0f
#define MIN_Y_OFFSET_TO_REACH                 -64
#define OPEN_SHUTTER_LATITUDE_MINUS          .005
#define CLOSE_SHUTTER_LATITUDE_MINUS         .018


@interface SearchAndAddMSME ()<UIGestureRecognizerDelegate>{
    
    CGFloat _popoverWidth;
    CGSize _popoverArrowSize;
    CGFloat _popoverCornerRadius;
    CGFloat _animationIn;
    CGFloat _animationOut;
    BOOL _animationSpring;
}

@property (nonatomic, strong) NSArray *configs;
@property (nonatomic, strong) UITableView *popTableView;
@property (nonatomic, strong) DXPopover *popover;


@property (strong, nonatomic) MKPointAnnotation *centerAnnotaion;
@property (strong, nonatomic) MKPinAnnotationView *centerAnnotationView;
@property (strong, nonatomic) UIToolbar *toolbar;
@property (nonatomic) BOOL lastValidZoomState;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, readwrite) CLLocationCoordinate2D selectedCoordinate;



@property (strong, nonatomic)   UITapGestureRecognizer  *tapMapViewGesture;
@property (strong, nonatomic)   UITapGestureRecognizer  *tapTableViewGesture;
@property (nonatomic)           CGRect                  headerFrame;
@property (nonatomic)           float                   headerYOffSet;
@property (nonatomic)           BOOL                    isShutterOpen;
@property (nonatomic)           BOOL                    displayMap;
@property (nonatomic)           float                   heightMap;

@end


@implementation SearchAndAddMSME
@synthesize searchbar;

-(id)init{
    self =  [super init];
    if(self){
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performSelector:@selector(getData) withObject:nil afterDelay:1.5];

    self.title = NSLocalizedString(@"add new seller", nil);
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self setupTableView];
    [self setupMapView];
    UINib *nib = [UINib nibWithNibName:@"SearchAndAddMSMECell" bundle:nil];
    
    //REGISTER XIB, CONTAINING THE CELL (IDENTIFIER NAME USUALLY SAME AS NIB NAME)
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"Cell"];
    UINib *nib1 = [UINib nibWithNibName:@"AddNewMSMECell" bundle:nil];
    
    //REGISTER XIB, CONTAINING THE CELL (IDENTIFIER NAME USUALLY SAME AS NIB NAME)
    [[self tableView] registerNib:nib1 forCellReuseIdentifier:@"AddCell"];
    
    
    // Do any additional setup after loading the view.
    self.tableData=[[NSMutableArray alloc]init];
    dic=[[NSMutableArray alloc]init];
    //self.tableData = [@[@"One",@"Two",@"Three",@"Twenty-one"] mutableCopy];
    self.searchResults=[[NSMutableArray alloc]init];
    //self.searchResults = [NSMutableArray arrayWithCapacity:[self.tableData count]];
    
    // NSData *data = [NSUSERDEFAULTS objectForKey:@"SEARCHDATA"];
    // dic= [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self.tableView reloadData];
    
    if ([self.value isEqualToString:@"SideBar"]) {
        
        SWRevealViewController *revealController = [self revealViewController];
        [revealController panGestureRecognizer];
        [revealController tapGestureRecognizer];
        revealButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myMethod)];
        
        // revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    }
    else{
        revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bckArr.png"] style:UIBarButtonItemStylePlain target:self action:@selector(previousecall)];
    }
    
    UIBarButtonItem * revealButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo.png"]]];
    self.navigationItem.leftBarButtonItems = @[revealButtonItem,revealButtonItem1];
    
    
    UITableView *blueView = [[UITableView alloc] init];
    blueView.frame = CGRectMake(10, 0, _popoverWidth, 175);
    blueView.dataSource = self;
    blueView.delegate = self;
    self.popTableView.scrollEnabled=NO;
    self.popTableView = blueView;
    
    self.popover = [DXPopover new];
    _popoverWidth = self.view.frame.size.width-20.0;
    self.configs = @[
                     @"suggest edits",
                     @"report duplicates",
                     @"inappropriate content",
                     @"not a public seller",
                     ];
    
    
}

-(void)myMethod{
    [self.view endEditing:YES];
    SWRevealViewController *reveal = self.revealViewController;
    [reveal revealToggleAnimated:YES];
}

- (void)addBtnAction {
    //    NSString *str=[NSString stringWithFormat:@"Add '%@'",searchTXT];
    //    [self.addBtn setTitle:str forState:UIControlStateNormal];
    
    AddMSMEDescVC *addMSMEDescVC = [[DealGaliInformation sharedInstance]Storyboard:ADDMSMEDESCSTRORYBOARD];
    addMSMEDescVC.name=searchTXT;
    [self.navigationController pushViewController:addMSMEDescVC animated:YES];
}
-(void)previousecall{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self getData];
    [self.mapView addSubview:self.centerAnnotationView];
    
    self.revealViewController.panGestureRecognizer.enabled=NO;
    

}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    self.revealViewController.panGestureRecognizer.enabled=YES;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

// Set all view we will need
-(void)setup{
    _heighTableViewHeader       = DEFAULT_HEIGHT_HEADER;
    _heighTableView             = SCREEN_HEIGHT_WITHOUT_STATUS_BAR;
    _minHeighTableViewHeader    = MIN_HEIGHT_HEADER;
    _default_Y_tableView        = HEIGHT_STATUS_BAR;
    _Y_tableViewOnBottom        = Y_DOWN_TABLEVIEW;
    _minYOffsetToReach          = MIN_Y_OFFSET_TO_REACH;
    _latitudeUserUp             = CLOSE_SHUTTER_LATITUDE_MINUS;
    _latitudeUserDown           = OPEN_SHUTTER_LATITUDE_MINUS;
    _default_Y_mapView          = DEFAULT_Y_OFFSET;
    _headerYOffSet              = DEFAULT_Y_OFFSET;
    _heightMap                  = 1000.0f;
    _regionAnimated             = YES;
    _userLocationUpdateAnimated = YES;
}

-(void)setupTableView{
    self.tableView                  = [[UITableView alloc]  initWithFrame: CGRectMake(0, 20, SCREEN_WIDTH, self.heighTableView)];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if (result.height == 480) {
            self.tableView.tableHeaderView  = [[UIView alloc]       initWithFrame: CGRectMake(0.0, 0.0, self.view.frame.size.width, self.heighTableViewHeader+44)];
            
        }
        else if (result.height == 568) {
            self.tableView.tableHeaderView  = [[UIView alloc]       initWithFrame: CGRectMake(0.0, 0.0, self.view.frame.size.width, self.heighTableViewHeader+44)];
            
        }
        else{
            self.tableView.tableHeaderView  = [[UIView alloc]       initWithFrame: CGRectMake(0.0, 0.0, self.view.frame.size.width, self.heighTableViewHeader+144)];
        }
    }
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    // Add gesture to gestures
    self.tapMapViewGesture      = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handleTapMapView:)];
    self.tapTableViewGesture    = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handleTapTableView:)];
    self.tapTableViewGesture.delegate = self;
    [self.tableView.tableHeaderView addGestureRecognizer:self.tapMapViewGesture];
    [self.tableView addGestureRecognizer:self.tapTableViewGesture];
    
    // Init selt as default tableview's delegate & datasource
    self.tableView.dataSource   = self;
    self.tableView.delegate     = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator=YES;
    
    [self.view addSubview:self.tableView];
}

-(void)setupMapView{
    self.mapView                        = [[MKMapView alloc] initWithFrame:CGRectMake(0, self.default_Y_mapView, SCREEN_WIDTH, self.heighTableView)];
    // [self.mapView setShowsUserLocation:YES];
    //[mapView setShowsUserLocation: YES];
    [_mapView setUserTrackingMode: MKUserTrackingModeFollow animated: NO];
    self.mapView.delegate = self;
    [self.mapView addSubview:self.centerAnnotationView];
    
    [self.view insertSubview:self.mapView
                belowSubview: self.tableView];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Internal Methods

- (void)handleTapMapView:(UIGestureRecognizer *)gesture {
    if(!self.isShutterOpen){
        // Move the tableView down to let the map appear entirely
        [self openShutter];
        // Inform the delegate
        if([self.delegate1 respondsToSelector:@selector(didTapOnMapView)]){
            [self.delegate1 didTapOnMapView];
        }
    }
}

- (void)handleTapTableView:(UIGestureRecognizer *)gesture {
    if(self.isShutterOpen){
        // Move the tableView up to reach is origin position
        [self closeShutter];
        // Inform the delegate
        if([self.delegate1 respondsToSelector:@selector(didTapOnTableView)]){
            [self.delegate1 didTapOnTableView];
        }
    }
}
// open to top
-(void) closeShutterToTop{
    activeDown=YES;
    [UIView animateWithDuration:0.4
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         //self.tableView.backgroundColor=[UIColor whiteColor];
                         
                         self.mapView.frame             = CGRectMake(0, self.default_Y_mapView, self.mapView.frame.size.width, self.heighTableView-60);
                         self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0, self.view.frame.size.width, 0)];
                         self.tableView.frame           = CGRectMake(0, 64, self.tableView.frame.size.width, self.heighTableView-44);
                     }
                     completion:^(BOOL finished){
                         // Enable cells selection
                         [self.tableView setAllowsSelection:YES];
                         self.isShutterOpen = NO;
                         [self.tableView setScrollEnabled:YES];
                         [self.tableView.tableHeaderView addGestureRecognizer:self.tapMapViewGesture];
                         // Center the user 's location
                         //                         [self zoomToUserLocation:self.mapView.userLocation
                         //                                      minLatitude:self.latitudeUserUp
                         //                                         animated:self.regionAnimated];
                         
                         // Inform the delegate
                         if([self.delegate respondsToSelector:@selector(didTableViewMoveUp)]){
                             [self.delegate1 didTableViewMoveUp];
                         }
                     }];
}

// Move DOWN the tableView to show the "entire" mapView
-(void) openShutter{
    [self.searchbar resignFirstResponder];
    activeDown=NO;
    
    [UIView animateWithDuration:0.4
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.tableView.tableHeaderView     = [[UIView alloc] initWithFrame: CGRectMake(0.0, 0.0, self.view.frame.size.width, self.minHeighTableViewHeader)];
                         self.mapView.frame                 = CGRectMake(0, FULL_Y_OFFSET, self.mapView.frame.size.width, self.heightMap);
                         self.tableView.frame               = CGRectMake(0, self.Y_tableViewOnBottom, self.tableView.frame.size.width, self.tableView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         // Disable cells selection
                         [self.tableView setAllowsSelection:NO];
                         self.isShutterOpen = YES;
                         [self.tableView setScrollEnabled:NO];
                         // Center the user 's location
                         //                         [self zoomToUserLocation:self.mapView.userLocation
                         //                                      minLatitude:self.latitudeUserDown
                         //                                         animated:self.regionAnimated];
                         
                         // Inform the delegate
                         if([self.delegate1 respondsToSelector:@selector(didTableViewMoveDown)]){
                             [self.delegate1 didTableViewMoveDown];
                         }
                     }];
}

// Move UP the tableView to get its original position
-(void) closeShutter{
    [self.searchbar resignFirstResponder];
    activeDown=NO;
    
    [UIView animateWithDuration:0.6
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.mapView.frame             = CGRectMake(0, self.default_Y_mapView, self.mapView.frame.size.width, self.heighTableView);
                         if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                             
                             CGSize result = [[UIScreen mainScreen] bounds].size;
                             
                             if (result.height == 480) {
                                 self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.headerYOffSet, self.view.frame.size.width, self.heighTableViewHeader+5)];
                             }
                             else if (result.height == 568) {
                                 self.tableView.tableHeaderView  = [[UIView alloc]       initWithFrame: CGRectMake(0.0, self.headerYOffSet, self.view.frame.size.width, self.heighTableViewHeader+5)];
                                 
                             }
                             else{
                                 self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.headerYOffSet, self.view.frame.size.width, self.heighTableViewHeader+105)];
                             }
                         }
                         
                         
                         self.tableView.frame           = CGRectMake(0, self.default_Y_tableView, self.tableView.frame.size.width, self.tableView.frame.size.height+44);
                     }
                     completion:^(BOOL finished){
                         // Enable cells selection
                         [self.tableView setAllowsSelection:YES];
                         self.isShutterOpen = NO;
                         [self.tableView setScrollEnabled:YES];
                         [self.tableView.tableHeaderView addGestureRecognizer:self.tapMapViewGesture];
                         // Center the user 's location
                         //                         [self zoomToUserLocation:self.mapView.userLocation
                         //                                      minLatitude:self.latitudeUserUp
                         //                                         animated:self.regionAnimated];
                         
                         // Inform the delegate
                         if([self.delegate respondsToSelector:@selector(didTableViewMoveDown)]){
                             [self.delegate1 didTableViewMoveDown];
                         }
                     }];
}

#pragma mark - Table view Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    scrollOffset        = scrollView.contentOffset.y;
    // NSLog(@"offset %f ",scrollOffset);
    
    CGRect headerMapViewFrame   = self.mapView.frame;
    
    if (scrollOffset < 0) {
        // Adjust map
        headerMapViewFrame.origin.y = self.headerYOffSet - ((scrollOffset / 2));
    } else {
        // Scrolling Up -> normal behavior
        headerMapViewFrame.origin.y = self.headerYOffSet - scrollOffset;
    }
    self.mapView.frame = headerMapViewFrame;
    
    // check if the Y offset is under the minus Y to reach
    if (self.tableView.contentOffset.y < self.minYOffsetToReach){
        if(!self.displayMap)
            
            self.displayMap                      = YES;
    }else{
        if(self.displayMap)
            self.displayMap                      = NO;
    }
    
    if (scrollOffset <=-62.000000  && scrollOffset >=-70.000000 ){
        [UIView animateWithDuration:0.4
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             
                         }
                         completion:^(BOOL finished){
                             self.mapView.frame                 = CGRectMake(0, headerMapViewFrame.origin.y, self.mapView.frame.size.width, self.mapView.frame.size.height+140);
                             
                         }];
        
    }
    
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(self.displayMap)
        [self openShutter];
}

#pragma mark - Table view data source



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier= @"Cell";
    
    SearchAndAddMSMECell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    cell.titleLbl.textColor=[UIColor DGDarkGrayColor];
    cell.titleLbl.font=[UIFont DGTextFieldFont];
    cell.likeLbl.textColor=[UIColor DGLightGrayColor];
    cell.likeLbl.font=[UIFont DGTextViewFont];
    cell.viewLbl.textColor=[UIColor DGLightGrayColor];
    cell.viewLbl.font=[UIFont DGTextViewFont];
    
    [cell.popOverBtn addTarget:self action:@selector(showPopover:) forControlEvents:UIControlEventTouchUpInside];
    
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
            
            if (indexPath.row>=[self.searchResults count]) {
                static NSString *cellId = @"AddCell";
                AddNewMSMECell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.titleLbl.text=check;
                cell.titleLbl.textColor=[UIColor darkGrayColor];
                cell.titleLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:24.0f];
                
                if (indexPath.row>[self.searchResults count]){
                    cell.titleLbl.hidden=YES;
                    cell.imgView.hidden=YES;
                }
                return cell;
                
            }
            else{
                
                cell.titleLbl.text=[self.searchResults objectAtIndex:indexPath.row];
                NSString *str1=[self.searchResults objectAtIndex:indexPath.row];
                NSUInteger index = [[dic valueForKey:@"SearchName" ] indexOfObject:str1];
                NSDictionary *dict = index != NSNotFound ? dic[index] : nil;
                
                BOOL ownAdded = [[dict valueForKey:@"IsAdded"] boolValue];
                if (ownAdded) {
                    cell.popOverBtn.hidden=YES;
                }
                else{
                    cell.popOverBtn.hidden=NO;
                }
                
                int totalLike=[[dict valueForKey:@"TotalLike"] intValue];
                NSString *likeStr;
                if (totalLike>1) {
                   likeStr=[NSString stringWithFormat:@"%@ Likes",[dict valueForKey:@"TotalLike"]];

                }
                else
                 likeStr=[NSString stringWithFormat:@"%@ Like",[dict valueForKey:@"TotalLike"]];
                
                int totalView=[[dict valueForKey:@"TotalView"] intValue];
                NSString *viewStr;
                if (totalView>1) {
                    viewStr=[NSString stringWithFormat:@"%@ Views",[dict valueForKey:@"TotalView"]];
                }
                else
                    viewStr=[NSString stringWithFormat:@"%@ View",[dict valueForKey:@"TotalView"]];

                
                cell.likeLbl.text=likeStr;
                cell.viewLbl.text=viewStr;
                NSString *path=[dict valueForKey:@"CategoryImage"];
                [cell.imagView sd_setImageWithURL:[NSURL URLWithString:path]
                                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                cell.imagView.contentMode = UIViewContentModeScaleAspectFit;
                cell.imagView.clipsToBounds = YES;
                
            }
            
        }
        else {
            if ([dic count]==0) {
                static NSString *cellId = @"AddCell";
                AddNewMSMECell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.titleLbl.text=@"add";
                cell.titleLbl.textColor=[UIColor darkGrayColor];
                cell.titleLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:24.0f];
                
                if (indexPath.row>0){
                    cell.titleLbl.hidden=YES;
                    cell.imgView.hidden=YES;
                }
                return cell;
                
            }
            else{
                
                BOOL ownAdded = [[[dic valueForKey:@"IsAdded"]objectAtIndex:indexPath.row] boolValue];
                if (ownAdded) {
                    cell.popOverBtn.hidden=YES;
                }
                else{
                    cell.popOverBtn.hidden=NO;
                }
                
                cell.likeImgVw.hidden=NO;
                cell.viewImgVw.hidden=NO;
                cell.bottmLbl.hidden=NO;
                
                
                cell.titleLbl.text=[[dic objectAtIndex:indexPath.row]objectForKey:@"SearchName"];
                NSString *path=[[dic objectAtIndex:indexPath.row]objectForKey:@"CategoryImage"];
                [cell.imagView sd_setImageWithURL:[NSURL URLWithString:path]
                                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                cell.imagView.contentMode = UIViewContentModeScaleAspectFit;
                cell.imagView.clipsToBounds = YES;
                
                int totalLike=[[[dic objectAtIndex:indexPath.row]objectForKey:@"TotalLike"] intValue];
                NSString *likeStr;
                if (totalLike>1) {
                    likeStr=[NSString stringWithFormat:@"%@ Likes",[[dic objectAtIndex:indexPath.row]objectForKey:@"TotalLike"]];
                    
                }
                else
                    likeStr=[NSString stringWithFormat:@"%@ Like",[[dic objectAtIndex:indexPath.row]objectForKey:@"TotalLike"]];
                
                int totalView=[[[dic objectAtIndex:indexPath.row]objectForKey:@"TotalView"] intValue];
                NSString *viewStr;
                if (totalView>1) {
                    viewStr=[NSString stringWithFormat:@"%@ Views",[[dic objectAtIndex:indexPath.row]objectForKey:@"TotalView"]];
                }
                else
                    viewStr=[NSString stringWithFormat:@"%@ View",[[dic objectAtIndex:indexPath.row]objectForKey:@"TotalView"]];

                
                cell.likeLbl.text=likeStr;
                cell.viewLbl.text=viewStr;
                
            }
            
        }
        return cell;
    }
    
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    //first get total rows in that section by current indexPath.
//    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
//
//    //this is the last row in section.
//    if(indexPath.row == totalRow -1){
//        // get total of cells's Height
//        float cellsHeight = totalRow * cell.frame.size.height;
//        // calculate tableView's Height with it's the header
//        float tableHeight = (tableView.frame.size.height - tableView.tableHeaderView.frame.size.height);
//
//        // Check if we need to create a foot to hide the backView (the map)
//        if((cellsHeight - tableView.frame.origin.y)  < tableHeight){
//            // Add a footer to hide the background
//            int footerHeight = tableHeight - cellsHeight;
//            tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, footerHeight)];
//            [tableView.tableFooterView setBackgroundColor:[UIColor whiteColor]];
//        }
//    }
//}


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
        if (searchBarActive){
            if ([self.searchResults count]==0) {
                 [self.popover dismiss];
            }
            return [self.searchResults count]+11;
        }
        else {
            if ([dic count]==0) {
                 [self.popover dismiss];
                return 10;
            }
            else
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
        if (searchBarActive) {
            if (indexPath.row==[self.searchResults count]) {
                return 80;
            }
            else
                return 60;
        }
        if ([dic count]==0) {
            return 80;
        }
        else
            return 60;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
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
            [[DealGaliNetworkEngine sharedInstance]SetDuplicateMSMEDealAPI:catID userId:savedValue withCallback:^(NSDictionary *response) {
                NSArray *result=[response objectForKey:@"DuplicateResult"];
                NSString *status=[result valueForKey:@"Status"];
                NSString *msg=[result valueForKey:@"Message"];
                if ([status isEqualToString:@"0"]) {
                    [self showErrorWithMessage:msg];
                }
                else if ([status isEqualToString:@"1"]) {
                    [self showSucessWithMessage:DUPLICATEDATA];
                }
                else if ([status isEqualToString:@"2"]) {
                    [self showErrorWithMessage:msg];
                }
            }];
        }
        else if (indexPath.row==2) {
            [[DealGaliNetworkEngine sharedInstance]SetInAppropriateMSMEDealAPI:catID userId:savedValue withCallback:^(NSDictionary *response) {
                NSArray *result=[response objectForKey:@"DuplicateResult"];
                NSString *status=[result valueForKey:@"Status"];
                NSString *msg=[result valueForKey:@"Message"];
                if ([status isEqualToString:@"0"]) {
                    [self showErrorWithMessage:msg];
                }
                else if ([status isEqualToString:@"1"]) {
                    [self showSucessWithMessage:INAPPROPIATECONTENT];
                }
                else if ([status isEqualToString:@"2"]) {
                    [self showErrorWithMessage:msg];
                }
            }];
        }
        else {
            [[DealGaliNetworkEngine sharedInstance]SetPrivateMSMEDealAPI:catID userId:savedValue withCallback:^(NSDictionary *response) {
                NSArray *result=[response objectForKey:@"DuplicateResult"];
                NSString *status=[result valueForKey:@"Status"];
                NSString *msg=[result valueForKey:@"Message"];
                if ([status isEqualToString:@"0"]) {
                    [self showErrorWithMessage:msg];
                }
                else if ([status isEqualToString:@"1"]) {
                    [self showSucessWithMessage:PULICCONTENT];
                }
                else if ([status isEqualToString:@"2"]) {
                    [self showErrorWithMessage:msg];
                }
            }];
        }
        
        [self.popover dismiss];
    }
    
    else{
        
        CreateAndSuggestMSMEVC *createVC = [[DealGaliInformation sharedInstance]Storyboard:CREATEANDSUGGESTMSMESTORYBOARD];
        if (searchBarActive) {
            
            if (indexPath.row==[self.searchResults count]) {
                AddMSMEDescVC *addMSMEDescVC = [[DealGaliInformation sharedInstance]Storyboard:ADDMSMEDESCSTRORYBOARD];
                addMSMEDescVC.name=searchTXT;
                [self.navigationController pushViewController:addMSMEDescVC animated:YES];
                
            }
            else if (indexPath.row>[self.searchResults count]) {
                
            }
            else{
                NSString *str1=[self.searchResults objectAtIndex:indexPath.row];
                createVC.name=str1;
                
                NSUInteger index = [[dic valueForKey:@"SearchName" ] indexOfObject:str1];
                NSDictionary *dict = index != NSNotFound ? dic[index] : nil;
                createVC.type=@"Suggest";
                createVC.DealId=[dict valueForKey:@"Id"];
                [self.navigationController pushViewController:createVC animated:YES];
            }
            
        }
        else{
            if ([dic count]==0) {
                if (indexPath.row==0) {
                    AddMSMEDescVC *addMSMEDescVC = [[DealGaliInformation sharedInstance]Storyboard:ADDMSMEDESCSTRORYBOARD];
                    [self.navigationController pushViewController:addMSMEDescVC animated:YES];
                }
                
            }else{
                createVC.DealId=[[dic objectAtIndex:indexPath.row]valueForKey:@"Id"];
                createVC.type=@"Suggest";
                createVC.name=[[dic objectAtIndex:indexPath.row]valueForKey:@"SearchName"];
                [self.navigationController pushViewController:createVC animated:YES];
            }
            
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==_popTableView) {
        return 0;
    }
    
    else
        return 44;
    
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView                  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    self.searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.searchbar.delegate=self;
    
    // self.searchbar.barStyle = UIBarStyleBlackTranslucent;
    //self.searchbar.translucent = YES;
    self.searchbar.barTintColor = [UIColor DGLightGrayColor];
    self.searchbar.tintColor = [UIColor DGWhiteColor];
    self.searchbar.backgroundColor = [UIColor DGLightGrayColor];
    // self.searchbar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchbar.placeholder = @"Search";
    
    //self.searchbar.showsCancelButton = YES;
    self.searchbar.keyboardAppearance=UIKeyboardAppearanceDark;
    self.searchbar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchbar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [headerView addSubview:self.searchbar];
    
    return headerView;
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
    if (activeDown) {
        [self.searchbar resignFirstResponder];
        
        CGFloat yAxis=buttonPosition.y;
        CGFloat totalY=SCREENHEIGHT-yAxis;
        if (totalY<=220) {
            CGPoint startPoint = CGPointMake(CGRectGetMidX(CGRectMake(buttonPosition.x, buttonPosition.y, 34, 24)), buttonPosition.y+70);
            [self.popover showAtPoint:startPoint
                       popoverPostion:DXPopoverPositionUp
                      withContentView:self.popTableView
                               inView:self.view];
        }
        else{
            CGPoint startPoint = CGPointMake(CGRectGetMidX(CGRectMake(buttonPosition.x, buttonPosition.y, 34, 24)), buttonPosition.y+80);
            [self.popover showAtPoint:startPoint
                       popoverPostion:DXPopoverPositionDown
                      withContentView:self.popTableView
                               inView:self.view];
            
        }
        
    }
    else{
        
        CGFloat yAxis=buttonPosition.y;
        CGFloat totalY=SCREENHEIGHT-yAxis;
        if (totalY<=220) {
            CGPoint startPoint;
            if (scrollOffset>0) {
                startPoint = CGPointMake(CGRectGetMidX(CGRectMake(buttonPosition.x, buttonPosition.y, 34, 24)), buttonPosition.y+20-scrollOffset);
            }
            else
                startPoint = CGPointMake(CGRectGetMidX(CGRectMake(buttonPosition.x, buttonPosition.y, 34, 24)), buttonPosition.y+20);
            [self.popover showAtPoint:startPoint
                       popoverPostion:DXPopoverPositionUp
                      withContentView:self.popTableView
                               inView:self.view];
        }
        else{
            CGPoint startPoint;
            if (scrollOffset>0) {
                startPoint = CGPointMake(CGRectGetMidX(CGRectMake(buttonPosition.x, buttonPosition.y, 34, 24)), buttonPosition.y+40-scrollOffset);
            }
            else
                startPoint = CGPointMake(CGRectGetMidX(CGRectMake(buttonPosition.x, buttonPosition.y, 34, 24)), buttonPosition.y+40);
            
            [self.popover showAtPoint:startPoint
                       popoverPostion:DXPopoverPositionDown
                      withContentView:self.popTableView
                               inView:self.view];
        }
        
    }
    
    //    CGFloat yAxis=buttonPosition.y;
    //    CGFloat totalY=SCREENHEIGHT-yAxis;
    //    if (totalY<=210) {
    //        CGPoint startPoint = CGPointMake(CGRectGetMidX(CGRectMake(buttonPosition.x, buttonPosition.y, 25, 20)), buttonPosition.y-180);
    //
    //        [self.popover showAtPoint:startPoint
    //                   popoverPostion:DXPopoverPositionUp
    //                  withContentView:self.popTableView
    //                           inView:self.view];
    //
    //    }
    //    else{
    
    //  }
    
    //__weak typeof(self) weakSelf = self;
    self.popover.didDismissHandler = ^{
        // [weakSelf bounceTargetView:weakSelf.addBtn];
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
        // self.tableView.hidden=YES;
        
    }
    else{
        
        // self.tableView.hidden=NO;
    }
    //[[dic valueForKey:@"SearchName"] filteredArrayUsingPredicate:resultPredicate];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
    if (searchText.length>0) {
        searchTXT=searchText;
        check=[NSString stringWithFormat:@"add \"%@\"",searchText];
        
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
    [self.searchbar resignFirstResponder];
    //[self.view endEditing:YES];
    //    UIButton *cancelButton = [searchBar valueForKey:@"_cancelButton"];
    //    if ([cancelButton respondsToSelector:@selector(setEnabled:)]) {
    //        cancelButton.enabled = YES;
    //    }
    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    // we used here to set self.searchBarActive = YES
    // but we'll not do that any more... it made problems
    // it's better to set self.searchBarActive = YES when user typed something
    [self.searchbar setShowsCancelButton:YES animated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    [self closeShutterToTop];
    
    NSLog(@"searchBarShouldBeginEditing -Are we getting here??");
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor darkGrayColor],NSForegroundColorAttributeName, nil]  forState:UIControlStateNormal];
    
    
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    // this method is being called when search btn in the keyboard tapped
    // we set searchBarActive = NO
    // but no need to reloadCollectionView
    if ([self.searchbar.text length]==0) {
        searchBarActive = NO;
        [self.tableView reloadData];
    }
    else
        searchBarActive = YES;
    [self.searchbar setShowsCancelButton:YES animated:YES];
}
-(void)cancelSearching{
    searchBarActive = NO;
    [self.searchbar resignFirstResponder];
    self.searchbar.text  = @"";
     [self getData];
    
   //[self.tableView reloadData];
    [UIView animateWithDuration:0.0
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         
                     }
                     completion:^(BOOL finished){
                         [self closeShutter];
                         
                     }];
   
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
            NSLog(@"%f",self.selectedCoordinate.latitude);
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
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(showPan)];
        panGesture.delegate = self;
        [mapView addGestureRecognizer:panGesture];
        
//        if (searchBarActive) {
//            
//        }else{
//
//            NSLog(@"lat   long    %f%f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
//            //19.72932881.167000
//            NSString *updatedlat=[NSString stringWithFormat:@"%f",mapView.centerCoordinate.latitude];
//            NSString *updatedlong=[NSString stringWithFormat:@"%f",mapView.centerCoordinate.longitude];
//            NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
//            NSArray *listItems = [updatedlat componentsSeparatedByString:@"."];
//
//            BOOL Flag=[[listItems objectAtIndex:0] containsString:@"19"];
//            if (!Flag) {
//                [[DealGaliNetworkEngine sharedInstance]GetMSMETitleListAPI:userID SearchData:@"" Lat:updatedlat Lon:updatedlong withCallback:^(NSDictionary *responseData) {
//                    dic=[responseData objectForKey:@"SearchData"];
//                    
//                    [self.tableView reloadData];
//                    
//                }];
//            }
//            
//        }
        
    }
}
- (void)showPan
{
    //NSLog(@"pan!");
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
    NSString *updatedlat=[NSString stringWithFormat:@"%f",_mapView.centerCoordinate.latitude];
    NSString *updatedlong=[NSString stringWithFormat:@"%f",_mapView.centerCoordinate.longitude];
    if (searchBarActive) {
        
    }else{
    [[DealGaliNetworkEngine sharedInstance]GetMSMETitleListAPI:userID SearchData:@"" Lat:updatedlat Lon:updatedlong withCallback:^(NSDictionary *responseData) {
        dic=[responseData objectForKey:@"SearchData"];
        
        [self.tableView reloadData];
        
    }];
    }

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
    NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
    NSLog(@"dshdgshdjghsdjf  %@   %@",lat,lon);
    
  if ([DealGaliInformation sharedInstance].latLongStatus==NO) {
         Lat=userLocation.coordinate.latitude;
          Lon=userLocation.coordinate.longitude;
    }
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[lon doubleValue]];
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    NSLog(@"lat  shjdg long    %@",locB);

    if (distance < 100) {
        [DealGaliInformation sharedInstance].latLongStatus=YES;
        NSLog(@"less than 100 metres");// less than 100 metres
    }
    else{
        NSLog(@"more than 100 metres");
        if (searchBarActive) {
            
        }else{
            NSLog(@" user location: lat %f   long   %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
            
            NSString *updatedlat=[NSString stringWithFormat:@"%f",userLocation.coordinate.latitude];
            NSString *updatedlong=[NSString stringWithFormat:@"%f",userLocation.coordinate.longitude];
            NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
            
            [[DealGaliNetworkEngine sharedInstance]GetMSMETitleListAPI:userID SearchData:@"" Lat:updatedlat Lon:updatedlong withCallback:^(NSDictionary *responseData) {
                dic=[responseData objectForKey:@"SearchData"];
                [DealGaliInformation sharedInstance].latLongStatus=NO;
                [self.tableView reloadData];
               // [_tableView reloadRowsAtIndexPaths:[_tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationBottom];
                
            }];
            
        }
 
    }
    
    
    
    if (self.zoomToUser) {
        [self changeRegionToCoordinate:userLocation.coordinate withSize:self.zoomMapSize];
        self.zoomToUser = NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(centerPinMapViewController:didUpdateUserLocation:)]){
        [self.delegate centerPinMapViewController:self didUpdateUserLocation:userLocation.location];
    }
    
    
   
    
    //        if(_isShutterOpen)
    //            [self zoomToUserLocation:self.mapView.userLocation
    //                         minLatitude:self.latitudeUserDown
    //                            animated:self.userLocationUpdateAnimated];
    //        else
    //            [self zoomToUserLocation:self.mapView.userLocation
    //                         minLatitude:self.latitudeUserUp
    //                            animated:self.userLocationUpdateAnimated];
}



//#pragma mark - MapView Delegate
//
- (void)zoomToUserLocation:(MKUserLocation *)userLocation minLatitude:(float)minLatitude animated:(BOOL)anim
{
    if (!userLocation)
        return;
    MKCoordinateRegion region;
    CLLocationCoordinate2D loc  = userLocation.location.coordinate;
    region.center               = loc;
    region.span                 = MKCoordinateSpanMake(.09, .09);       //Zoom distance
    region                      = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:anim];
}
//
//-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//    if(_isShutterOpen)
//        [self zoomToUserLocation:self.mapView.userLocation
//                     minLatitude:self.latitudeUserDown
//                        animated:self.userLocationUpdateAnimated];
//    else
//        [self zoomToUserLocation:self.mapView.userLocation
//                     minLatitude:self.latitudeUserUp
//                        animated:self.userLocationUpdateAnimated];
//}
//
//
//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
//{
//   NSLog(@"%f%f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
//
//}
-(void)getData{
    NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
    NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
    
    [[DealGaliNetworkEngine sharedInstance]GetMSMETitleListAPI:userID SearchData:@"" Lat:lat Lon:lon withCallback:^(NSDictionary *response) {
        dic=[response objectForKey:@"SearchData"];
        searchBarActive = NO;
        [self.tableView reloadData];
        
    }];
    
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.tapTableViewGesture) {
        return _isShutterOpen;
    }
    return YES;
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
    [self performSelector:@selector(respnceSucess) withObject:nil afterDelay:2.0];
    
}
-(void)respnceSucess{
    [self.minimalNotification dismiss];
}
@end
