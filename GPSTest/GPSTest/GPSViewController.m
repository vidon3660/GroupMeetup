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
//@property (strong, nonatomic) NSMutableArray* points;

@end

@implementation GPSViewController

@synthesize myMapView = _myMapView;
@synthesize delegate = _delegate;
//@synthesize points = _points;
@synthesize locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){}
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    int i = 0;
    for(CLLocation* loc in locations){
        
            CLLocationCoordinate2D newCoord = {.latitude = loc.coordinate.latitude, .longitude = loc.coordinate.longitude};
            
            MKCoordinateRegion region;
            region.center = newCoord;
            
            MKCoordinateSpan span = {.latitudeDelta = 0.2, .longitudeDelta = 0.2};
            region.span = span;
            
            PersonLocation *point = [[PersonLocation alloc]init];
            [point setCoordinate:newCoord];
         
            //userLocation is always in locations array
            if(loc == self.myMapView.userLocation.location){
                [point setTitle:[NSString stringWithFormat:@"User Location"]];
                [self.myMapView setRegion:region];
            }
        
            [point setTitle:[NSString stringWithFormat:@"Person #%d", i]];
            [self.myMapView addAnnotation:point];
        
      
    }
    
}

/*
- (void)locationManager: (CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    if((oldLocation.coordinate.longitude != newLocation.coordinate.longitude) || (oldLocation.coordinate.latitude != newLocation.coordinate.latitude)){
        
        CLLocationCoordinate2D coord = {.latitude = newLocation.coordinate.latitude, .longitude = newLocation.coordinate.longitude};
        
        MKCoordinateRegion region;
        region.center = coord;
        
        MKCoordinateSpan span = {.latitudeDelta = 0.2, .longitudeDelta = 0.2};
        region.span = span;
        
        [self.myMapView setRegion:region];
        PersonLocation *point = [[PersonLocation alloc]init];
        [point setCoordinate:coord];
        [point setTitle: [NSString stringWithFormat:@"test%d", 1]];
        [self.myMapView addAnnotation:point];
   
    }
    
}
 */

/*
- (MKAnnotationView*)mapView: (MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    static NSString *identifier = @"Person";
    
    if([annotation isKindOfClass:[PersonLocation class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: identifier];
        if(annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc]init];
        }
        else{
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
   
    return nil;
}*/

/*
-(NSMutableArray*) points{
    if(!_points) _points = [[NSMutableArray alloc] init];
    return _points;
}*/


//-(void) addPoints /*:(NSMutableArray *)points*/{
/*    for (int i = 0; i < 5; i++){
        PersonLocation* point = [[PersonLocation alloc] init];
        
        CLLocationCoordinate2D coordinate = {.longitude = self.mapView.userLocation.location.coordinate.longitude + 5*(i + 1), .latitude = self.mapView.userLocation.location.coordinate.latitude + 5*(i + 1)};
        [point setCoordinate: coordinate];
        [point setTitle:[NSString stringWithFormat: @"test%d", i]];
        
        MKAnnotationView* pointDisplay = [[MKAnnotationView alloc] initWithAnnotation:point reuseIdentifier:[point getTitle]];
        
        
        [points addObject:pointDisplay];
    }        
    [self.mapView addAnnotations: points];
}*/

- (IBAction)StdButton:(UIBarButtonItem *)sender {
    self.myMapView.mapType = MKMapTypeStandard;
}

- (IBAction)SatButton:(UIBarButtonItem *)sender {
    self.myMapView.mapType = MKMapTypeSatellite;
}

- (IBAction)HybdButton:(UIBarButtonItem *)sender {
    self.myMapView.mapType = MKMapTypeHybrid;
}


-(void)updateMapViewAt:(CLLocationCoordinate2D)coord {
    
    [self.myMapView setCenterCoordinate:coord animated:TRUE];
    
    
}
- (IBAction)refreshButton:(UIBarButtonItem *)sender {
    
     MKUserLocation *usrLoc = self.myMapView.userLocation;
     CLLocation *location = usrLoc.location;
     CLLocationCoordinate2D coords = location.coordinate;
     [self updateMapViewAt: coords]; 
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
