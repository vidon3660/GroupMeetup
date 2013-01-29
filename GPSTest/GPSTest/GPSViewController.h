//
//  GPSViewController.h
//  GPSTest
//
//  Created by Kiran Vodrahalli on 1/28/13.
//  Copyright (c) 2013 KVFunAppsHackWeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"

@class GPSViewController;

@protocol GPSViewControllerDelegate <NSObject>
@end

@interface GPSViewController : UIViewController
@property (nonatomic, weak) id <GPSViewControllerDelegate> delegate;


@end
