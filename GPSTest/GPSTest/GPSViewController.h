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

//for now no argument
-(void) addFriends;//:(NSMutableArray *)points;

-(void) clearFriends;

-(void) updateFriends;

-(void)setMapView:(MKMapView *)newMapView;

-(void)updateMapViewAt:(CLLocationCoordinate2D)coord AndRegion: (MKCoordinateRegion)region;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

-(void)viewDidLoad;

@end
