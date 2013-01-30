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

@property (retain, nonatomic) IBOutlet MKMapView* mapView;
@property (strong, nonatomic) NSMutableArray* points;

@end

@implementation GPSViewController

@synthesize mapView = _mapView;
@synthesize delegate = _delegate;
@synthesize points = _points;
@synthesize locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){}
    return self;
}

- (void)locationManager: (CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    if((oldLocation.coordinate.longitude != newLocation.coordinate.longitude) || (oldLocation.coordinate.latitude != newLocation.coordinate.latitude)){
        
        CLLocationCoordinate2D coord = {.latitude = newLocation.coordinate.latitude, .longitude = newLocation.coordinate.longitude};
        MKCoordinateRegion region;
        region.center = coord;
        
        MKCoordinateSpan span = {.latitudeDelta = 0.2, .longitudeDelta = 0.2};
        region.span = span;
        [self.mapView setRegion:region];
        PersonLocation *point = [[PersonLocation alloc]init];
        [point setCoordinate:coord];
        [point setTitle: @"This is new, but wrong"];
        [self.mapView addAnnotation:point];
   
    }
    
}


-(NSMutableArray*) points{
    if(!_points) _points = [[NSMutableArray alloc] init];
    return _points;
}

-(void) addPoints:(NSMutableArray *)points{
    for (int i = 0; i < 5; i++){
        PersonLocation* point = [[PersonLocation alloc] init];
        
        CLLocationCoordinate2D coordinate = {.longitude = self.mapView.userLocation.location.coordinate.longitude + 5*(i + 1), .latitude = self.mapView.userLocation.location.coordinate.latitude + 5*(i + 1)};
        [point setCoordinate: coordinate];
        [point setTitle:[NSString stringWithFormat: @"test%d", i]];
        
        MKAnnotationView* pointDisplay = [[MKAnnotationView alloc] initWithAnnotation:point reuseIdentifier:[point getTitle]];
        
        
        [points addObject:pointDisplay];
    }        
    [self.mapView addAnnotations: points];
}

- (IBAction)StdButton:(UIBarButtonItem *)sender {
    self.mapView.mapType = MKMapTypeStandard;
}
- (IBAction)SatButton:(UIBarButtonItem *)sender {
    self.mapView.mapType = MKMapTypeSatellite;
}

- (IBAction)HybdButton:(UIBarButtonItem *)sender {
    self.mapView.mapType = MKMapTypeHybrid;
}


-(void)updateMapViewAt:(CLLocationCoordinate2D)coord {
    
    [self.mapView setCenterCoordinate:coord animated:TRUE];
    
    
}
- (IBAction)refreshButton:(UIBarButtonItem *)sender {
    
     MKUserLocation *usrLoc = self.mapView.userLocation;
     CLLocation *location = usrLoc.location;
     CLLocationCoordinate2D coords = location.coordinate;
     [self updateMapViewAt: coords]; 
}

-(void)setMapView:(MKMapView *)mapView{
    _mapView = mapView;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setLocationManager:[[CLLocationManager alloc]init]];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    [locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
}




@end
