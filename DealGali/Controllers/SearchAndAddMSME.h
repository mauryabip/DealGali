//
//  SearchAndAddMSME.h
//  DealGali
//
//  Created by Virinchi Software on 03/09/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "JFMinimalNotification.h"


@class SearchAndAddMSME;

@protocol CenterPinMapViewControllerDelegate1 <NSObject>

@optional
- (void)centerPinMapViewController:(SearchAndAddMSME *)sender didChangeValidZoomScaleTo:(BOOL)valid;
- (void)centerPinMapViewController:(SearchAndAddMSME *)sender didResolvePlacemark:(CLPlacemark *)placemark;
- (void)centerPinMapViewController:(SearchAndAddMSME *)sender didChangeSelectedCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)centerPinMapViewController:(SearchAndAddMSME *)sender didUpdateUserLocation:(CLLocation *)userLocation;
@end

@protocol SLParallaxControllerDelegate <NSObject>

// Tap handlers
-(void)didTapOnMapView;
-(void)didTapOnTableView;
// TableView's move
-(void)didTableViewMoveDown;
-(void)didTableViewMoveUp;

@end

@interface SearchAndAddMSME : UIViewController <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate,UISearchControllerDelegate,JFMinimalNotificationDelegate,UIGestureRecognizerDelegate>{
    bool searchBarActive;
    bool activeDown;
    NSArray *dic;
    NSDictionary *dic1;
    NSString *searchTXT;
    NSString *name;
    NSString *catID;
    UISearchBar * searchbar;
    UIButton *addBtn;
    UIView *addMSMEView;
    NSString *check;
    CGFloat scrollOffset;
    UIBarButtonItem *revealButtonItem;
    double Lat;
    double Lon;
    
}
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) JFMinimalNotification* minimalNotification;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, retain) IBOutlet UISearchBar* searchbar;




@property (nonatomic, weak)     id<SLParallaxControllerDelegate>    delegate1;
@property (nonatomic, strong)   UITableView                         *tableView;
@property (nonatomic, strong)   MKMapView                           *mapView;
@property (nonatomic)           float                               heighTableView;
@property (nonatomic)           float                               heighTableViewHeader;
@property (nonatomic)           float                               minHeighTableViewHeader;
@property (nonatomic)           float                               minYOffsetToReach;
@property (nonatomic)           float                               default_Y_mapView;
@property (nonatomic)           float                               default_Y_tableView;
@property (nonatomic)           float                               Y_tableViewOnBottom;
@property (nonatomic)           float                               latitudeUserUp;
@property (nonatomic)           float                               latitudeUserDown;
@property (nonatomic)           BOOL                                regionAnimated;
@property (nonatomic)           BOOL                                userLocationUpdateAnimated;

// Move the map in terms of user location
// @minLatitude : subtract to the current user's latitude to move it on Y axis in order to view it when the map move
- (void)zoomToUserLocation:(MKUserLocation *)userLocation minLatitude:(float)minLatitude animated:(BOOL)anim;


///@brief Center coordinate of the mapView
@property (nonatomic, readonly) CLLocationCoordinate2D selectedCoordinate;

///@brief The minimum number of meters per point. Set to 0 to disable;
@property (nonatomic) CLLocationDistance requiredPointAccuracy;

///@brief The initial size, in meters, of the map's smallest dimension
@property (nonatomic) NSUInteger initialMapSize;

///@brief Tells the mapview to zoom to the user location if known now or on next location update
@property (nonatomic) BOOL zoomToUser;

///@brief The size, in meters, of the smallest dimension of the map after zooming to user
@property (nonatomic) NSUInteger zoomMapSize;

///@brief Determines whether or not to display visual cues for meeting requiredPointAccuracy
@property (nonatomic) BOOL doesDisplayPointAccuracyIndicators;

///@brief Determines whether or not to show a user location tracking button
@property (nonatomic) BOOL showUserTrackingButton;

///@brief Controller's <CenterPinMapViewControllerDelegate1> delegate
@property (nonatomic, weak) id <CenterPinMapViewControllerDelegate1> delegate;

///@brief Set's whether to reverse geocode the selected coordinate (only at valid zoom scales)
@property (nonatomic) BOOL shouldReverseGeocode;

///@brief The currect reverse goecoded placemark (must enable shouldReverseGeocode)
@property (nonatomic, strong) CLPlacemark *selectedPlacemark;

///@brief The current user location of the user
@property (nonatomic, readonly) CLLocationCoordinate2D userCoordinate;

/*!
 The method uses the value set in requiredPointAccuracy to determine if the scale is valid.
 
 @brief Determines whether or not the map is at a valid zoom scale
 @return whether or not the map is at a valid scale
 */
- (BOOL)mapIsAtValidZoomScale;

/*!
 This method determines the meters in the diagnal of a unit point rectangle at the center of the map.
 
 @brief The meters per point in the MapView
 @return meters per point
 */
- (CLLocationDistance)metersPerViewPoint;



@end
