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
@property (nonatomic,copy)NSString *deviceToken;
@property (nonatomic,copy)NSString *fbID;
@property (nonatomic, retain) NSOperation *operation;

@property (nonatomic,copy)NSString *replyRecipientID;

@property (nonatomic,copy)NSString *replySenderID;
@end
