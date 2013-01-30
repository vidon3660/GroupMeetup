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
@property (nonatomic) int i;

@end

@implementation GPSViewController

@synthesize myMapView = _myMapView;
@synthesize delegate = _delegate;
@synthesize myLocation = _myLocation;
@synthesize myFriends = _myFriends;
@synthesize locationManager;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){}
    return self;
}

-(void)updateMapViewAt:(CLLocationCoordinate2D)coord {
    
    [self.myMapView setCenterCoordinate:coord animated:TRUE];
    
    
}

-(PersonLocation *)myLocation{
    if(!_myLocation){
        _myLocation = [[PersonLocation alloc]init];
        [_myLocation setCoordinate:self.myMapView.userLocation.location.coordinate];
        [_myLocation setTitle: @"ME"];
        [self addFriends];
    }
    else{
        [_myLocation setCoordinate:self.myMapView.userLocation.location.coordinate];
    }
    return _myLocation;
}

/* comment addition here: Jan 30, 4:00 AM */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

    [self.myMapView addAnnotation:self.myLocation];
}


-(NSMutableArray*) myFriends{
    if(!_myFriends) _myFriends = [[NSMutableArray alloc] init];
    return _myFriends;
}


/* may want to add specific person locations in the future instead of arbitrary */
-(void) addFriends {//:(NSMutableArray *)points{
   for (int i = 0; i < 5; i++){
        PersonLocation* friend = [[PersonLocation alloc] init];
        
        CLLocationCoordinate2D coordinate = {.longitude = [self.myLocation getCoordinate].longitude + .5*(i + 1), .latitude = [self.myLocation getCoordinate].latitude + .5*(i + 1)};
        [friend setCoordinate: coordinate];
        [friend setTitle:[NSString stringWithFormat: @"test%d", i]];
        
        [self.myFriends addObject:friend];
        [self.myMapView addAnnotation:friend];
    }
}

//tester method
-(void) clearFriends {
    [self.myMapView removeAnnotations:self.myFriends];
    [self.myFriends removeAllObjects];
}
 

- (IBAction)StdButton:(UIBarButtonItem *)sender {
    self.myMapView.mapType = MKMapTypeStandard;
}

- (IBAction)SatButton:(UIBarButtonItem *)sender {
    self.myMapView.mapType = MKMapTypeSatellite;
}

- (IBAction)HybdButton:(UIBarButtonItem *)sender {
    self.myMapView.mapType = MKMapTypeHybrid;
}



- (IBAction)refreshButton:(UIBarButtonItem *)sender {
    
     MKCoordinateRegion region;
     region.center = [self.myLocation getCoordinate];
     MKCoordinateSpan span = {.latitudeDelta = 0.2, .longitudeDelta = 0.2};
     region.span = span;
    
     [self clearFriends]; // for testing
     [self addFriends]; // for testing
     [self updateMapViewAt: [self.myLocation getCoordinate]];
     [self.myMapView setRegion:region animated:TRUE ];
}

-(void)setMapView:(MKMapView *)myMapView{
    _myMapView = myMapView;
}

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
