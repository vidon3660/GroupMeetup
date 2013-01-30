//
//  PersonLocation.m
//  GPSTest
//
//  Created by Alexander Yu on 1/29/13.
//  Copyright (c) 2013 KVFunAppsHackWeek. All rights reserved.
//

#import "PersonLocation.h"

@interface PersonLocation()
@end
@implementation PersonLocation
@synthesize coordinate = _coordinate;
@synthesize title = _title;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
    _coordinate = newCoordinate;
}

- (CLLocationCoordinate2D)getCoordinate{
    return _coordinate;
}

-(void)setTitle:(NSString *)title{
    _title = title;
}

-(NSString *)getTitle{
    return _title;
}


@end
