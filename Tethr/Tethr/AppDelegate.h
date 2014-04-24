//
//  AppDelegate.h
//  Tethr
//
//  Created by Daniel Fein on 4/5/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>{
}

@property (nonatomic,retain)CLLocationManager *locationManager;
@property (nonatomic,retain)CLLocation *currentLocation;
@property (strong, nonatomic) UIWindow *window;

@end
