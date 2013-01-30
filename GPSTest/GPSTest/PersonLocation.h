//
//  PersonLocation.h
//  GPSTest
//
//  Created by Alexander Yu on 1/29/13.
//  Copyright (c) 2013 KVFunAppsHackWeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PersonLocation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
- (CLLocationCoordinate2D)getCoordinate;
- (void)setTitle:(NSString *)title;
- (NSString *)getTitle;

@end
