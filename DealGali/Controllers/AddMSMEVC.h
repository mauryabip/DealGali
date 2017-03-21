//
//  AddMSMEVC.h
//  DealGali
//
//  Created by Virinchi Software on 03/09/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@class AddMSMEVC;

@protocol CenterPinMapViewControllerDelegate <NSObject>

@optional
- (void)centerPinMapViewController:(AddMSMEVC *)sender didChangeValidZoomScaleTo:(BOOL)valid;
- (void)centerPinMapViewController:(AddMSMEVC *)sender didResolvePlacemark:(CLPlacemark *)placemark;
- (void)centerPinMapViewController:(AddMSMEVC *)sender didChangeSelectedCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)centerPinMapViewController:(AddMSMEVC *)sender didUpdateUserLocation:(CLLocation *)userLocation;
@end


@interface AddMSMEVC : UIViewController<MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate,UISearchBarDelegate,UISearchControllerDelegate>{
    bool searchBarActive;
    NSMutableArray *dic;
    NSDictionary *dic1;
    NSString *searchTXT;
    NSString *name;
    NSString *catID;
}

@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSMutableArray *searchResults;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
- (IBAction)addBtnAction:(id)sender;






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

///@brief Controller's <CenterPinMapViewControllerDelegate> delegate
@property (nonatomic, weak) id <CenterPinMapViewControllerDelegate> delegate;

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
