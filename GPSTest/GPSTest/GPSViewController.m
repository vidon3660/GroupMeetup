//
//  GPSViewController.m
//  GPSTest
//
//  Created by Kiran Vodrahalli on 1/28/13.
//  Copyright (c) 2013 KVFunAppsHackWeek. All rights reserved.
//

#import "GPSViewController.h"
#import "Parse/Parse.h"
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
    //[self.myMapView addAnnotation:self.centerLocation];
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
    
     
    [self updateMapView]; //]: [self.myLocation getCoordinate] AndRegion:region];
   
     
}


- (double) findLatSpan{
    CLLocationCoordinate2D center = [self findCenterCoordinate];
    double maxLat = 0;
    double minLat = 0;
    for(int i = 0; i< self.myFriends.count; i++){
        if([[self.myFriends objectAtIndex:i] getCoordinate].latitude >= maxLat){
            maxLat = [[self.myFriends objectAtIndex:i] getCoordinate].latitude;
        }
        if([[self.myFriends objectAtIndex:i] getCoordinate].latitude <= minLat){
            minLat = [[self.myFriends objectAtIndex:i] getCoordinate].latitude;
        }
    }
    if(center.latitude >= maxLat){
        maxLat = center.latitude;
    }
    if(center.latitude <= minLat){
        minLat = center.latitude;
    }
    return maxLat - minLat;
}

- (double) findLongSpan{
    CLLocationCoordinate2D center = [self findCenterCoordinate];
    double maxLong = 0;
    double minLong = 0;
    for(int i = 0; i< self.myFriends.count; i++){
        if([[self.myFriends objectAtIndex:i] getCoordinate].longitude >= maxLong){
            maxLong = [[self.myFriends objectAtIndex:i] getCoordinate].longitude;
        }
        if([[self.myFriends objectAtIndex:i] getCoordinate].longitude <= minLong){
            minLong = [[self.myFriends objectAtIndex:i] getCoordinate].longitude;
        }
    }
    if(center.longitude >= maxLong){
        maxLong = center.longitude;
    }
    if(center.longitude <= minLong){
        minLong = center.longitude;
    }
    return maxLong - minLong;
    
}

// returns the center of mass of an array of PersonLocation;
- (CLLocationCoordinate2D) findCenterCoordinate{
    double xcm = 0;
    double ycm = 0;
    double xCurrent;
    double yCurrent;
    int numOfFriends = self.myFriends.count;
    
    for (int i = 0; i < numOfFriends; i++)
    {
        if ([[self.myFriends objectAtIndex:i] isKindOfClass:[PersonLocation class]])
        {
            PersonLocation* person = [self.myFriends objectAtIndex:i];
            CLLocationCoordinate2D coord = person.getCoordinate;
            xCurrent = coord.latitude;
            yCurrent = coord.longitude;
            xcm = xcm + xCurrent;
            ycm = ycm + yCurrent;
        }
    }
    
    double xOfMe = [self.myLocation getCoordinate].latitude;
    double yOfMe = [self.myLocation getCoordinate].longitude;
    xcm = xcm + xOfMe;
    ycm = ycm + yOfMe;
    
    xcm = (xcm)/(1.0*numOfFriends + 1);
    ycm = ycm/(1.0*numOfFriends + 1);
    
    CLLocationCoordinate2D centerCoord = {.latitude = xcm, .longitude = ycm};
    return centerCoord;
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
    CLLocationCoordinate2D centerCoord = [self findCenterCoordinate];
    PersonLocation* center = [[PersonLocation alloc]init];
    [center setCoordinate:centerCoord];
    [center setTitle:@"center"];
    [self.myFriends addObject:center];
    [self.myMapView addAnnotation:center];
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
-(void)updateMapView{//At{//:(CLLocationCoordinate2D)coord {//AndRegion: (MKCoordinateRegion)region {
    
    [self updateFriends];
    MKCoordinateRegion region;
    region.center = [self.myLocation getCoordinate];
    MKCoordinateSpan span = {.latitudeDelta = .05, .longitudeDelta = .05};
    region.span = span;
    [self.myMapView setCenterCoordinate:[self.myLocation getCoordinate] animated:TRUE];
    [self.myMapView setRegion:region animated:TRUE ];
    
    
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
    
    //Parse test 
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    [testObject setObject:@"bar" forKey:@"foo"];
    [testObject save];
}




@end
