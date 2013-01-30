//
//  GPSViewController.h
//  GPSTest
//
//  Created by Kiran Vodrahalli on 1/28/13.
//  Copyright (c) 2013 KVFunAppsHackWeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import <CoreLocation/CoreLocation.h>

@class GPSViewController;

@protocol GPSViewControllerDelegate <NSObject>
@end

@interface GPSViewController : UIViewController <CLLocationManagerDelegate> {
    CLLocationManager * locationManager; 
}
@property (retain, nonatomic) CLLocationManager *locationManager; 
@property (nonatomic, weak) id <GPSViewControllerDelegate> delegate;
-(NSMutableArray*) points;
-(void) addPoints:(NSMutableArray *)points;
-(void)updateMapViewAt:(CLLocationCoordinate2D)coord;
-(void)setMapView:(MKMapView *)mapView;
-(void)viewDidLoad;

@end
