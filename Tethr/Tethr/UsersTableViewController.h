//
//  UsersTableViewController.h
//  Tethr
//
//  Created by Daniel Fein on 4/13/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"
#import "Activity.h"

@interface UsersTableViewController : UITableViewController
@property (nonatomic,retain)Activity *selectedActivity;
@property (nonatomic,retain)Venue *selectedLocation;
@end
