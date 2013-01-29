//
//  GPSViewController.m
//  GPSTest
//
//  Created by Kiran Vodrahalli on 1/28/13.
//  Copyright (c) 2013 KVFunAppsHackWeek. All rights reserved.
//

#import "GPSViewController.h"
#import "MapKit/MapKit.h"



@interface GPSViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView; 
@end

@implementation GPSViewController

@synthesize mapView = _mapView;
@synthesize delegate = _delegate;
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
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
}




@end
