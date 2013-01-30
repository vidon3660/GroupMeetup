//
//  GPSViewController.m
//  GPSTest
//
//  Created by Kiran Vodrahalli on 1/28/13.
//  Copyright (c) 2013 KVFunAppsHackWeek. All rights reserved.
//

#import "GPSViewController.h"
#import "MapKit/MapKit.h"
#import <CoreLocation/CoreLocation.h>
#import "PersonLocation.h"


@interface GPSViewController ()

@property (retain, nonatomic) IBOutlet MKMapView* myMapView;
@property (retain, nonatomic) PersonLocation *myLocation;
@property (retain, nonatomic) NSMutableArray* myFriends;

@end

@implementation GPSViewController

@synthesize myMapView = _myMapView;
@synthesize delegate = _delegate;
@synthesize myLocation = _myLocation;
@synthesize myFriends = _myFriends;
@synthesize locationManager;


// for <CLLocationManagerDelegate>
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){}
    return self;
}

//crucial method, sets map view to var newMapView
-(void)setMapView:(MKMapView *)newMapView{
    _myMapView = newMapView;
}

//init myLocation, and always keeps it updated 
-(PersonLocation *)myLocation{
    if(!_myLocation){
        _myLocation = [[PersonLocation alloc]init];
        [_myLocation setCoordinate:self.myMapView.userLocation.location.coordinate];
        [_myLocation setTitle: @"ME"];
    }
    else{
        [_myLocation setCoordinate:self.myMapView.userLocation.location.coordinate];
    }
    return _myLocation;
}

//init myFriends
-(NSMutableArray*) myFriends{
    if(!_myFriends){
        _myFriends = [[NSMutableArray alloc] init];
    }
    return _myFriends;
}




/* locationManager updates and is necessary for <CLLocationManagerDelegate>*/
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

    [self.myMapView addAnnotation:self.myLocation];
}



// Buttons

// changes map type to standard 
- (IBAction)StdButton:(UIBarButtonItem *)sender {
    self.myMapView.mapType = MKMapTypeStandard;
}

// changes map type to satellite 
- (IBAction)SatButton:(UIBarButtonItem *)sender {
    self.myMapView.mapType = MKMapTypeSatellite;
}

// changes map type to hybrid (combo of standard and satellite) 
- (IBAction)HybdButton:(UIBarButtonItem *)sender {
    self.myMapView.mapType = MKMapTypeHybrid;
}

// refreshes the map -- creates a region based on myLocation, and calls updateMapView
- (IBAction)refreshButton:(UIBarButtonItem *)sender {
    
     MKCoordinateRegion region;
     region.center = [self.myLocation getCoordinate];
     MKCoordinateSpan span = {.latitudeDelta = 0.2, .longitudeDelta = 0.2};
     region.span = span;
     [self updateMapViewAt: [self.myLocation getCoordinate] AndRegion:region];
     
}

/* may want to add specific person locations in the future instead of arbitrary */

/* adds (currently) arbitrary locations for other friends, which are only changed whenever
 * the the user location is changed. these are added to the myFriends array (of PersonLocation
 * type), and are also added to the annotations of myMapView. */
-(void) addFriends {//:(NSMutableArray *)friends{
    unsigned index_x = 0;
    unsigned index_y = 0;
    int sign_x = 0;
    int sign_y = 0;
    for (int i = 0; i < 5; i++){
        PersonLocation* friend = [[PersonLocation alloc] init];
        index_x = arc4random() % 5;
        index_y = arc4random() % 5;
        sign_x = arc4random() % 2;
        sign_y = arc4random() % 2;
        if(sign_x == 0) sign_x = -1;
        if(sign_y == 0) sign_y = -1; 
        CLLocationCoordinate2D coordinate = {.longitude = [self.myLocation getCoordinate].longitude + .005*index_x*sign_x,
            .latitude = [self.myLocation getCoordinate].latitude + .005*index_y*sign_y};
        [friend setCoordinate: coordinate];
        [friend setTitle:[NSString stringWithFormat: @"Friend #%d", i+1]];
        
        [self.myFriends addObject:friend];
        [self.myMapView addAnnotation:friend];
    }
}

//removes the friend markers from myMapView's annotations, as well as clears the myFriends array
-(void) clearFriends {
    [self.myMapView removeAnnotations:self.myFriends];
    [self.myFriends removeAllObjects];
}

/* clears friends, then adds friends (addFriends will instead take in array of friends from
 * from the database (these will be represented as PersonLocations). This method then removes
 * the old locations of the friends, and updates with the new ones. */ 
-(void)updateFriends{
    [self clearFriends];
    [self addFriends];
}

/* updates the map view: shifts to the coordinate (non-scaling) and region (scaling) provided.
 * also updates myFriends. */
-(void)updateMapViewAt:(CLLocationCoordinate2D)coord AndRegion: (MKCoordinateRegion)region {
    
    [self.myMapView setCenterCoordinate:coord animated:TRUE];
    [self.myMapView setRegion:region animated:TRUE ];
    [self updateFriends];
    
}

// did the view load; also initializes locationManager and sets some BOOLs
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setLocationManager:[[CLLocationManager alloc]init]];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    if([CLLocationManager locationServicesEnabled]){
         [locationManager startUpdatingLocation];
         self.myMapView.showsUserLocation = YES;
    }
   
    self.myMapView.delegate = self;
}




@end
