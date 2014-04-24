//
//  MessageViewController.h
//  Tethr
//
//  Created by Daniel Fein on 4/19/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Activity.h"
#import "Venue.h"

@interface MessageViewController : UIViewController
@property (nonatomic,retain)User *messageReciever;
@property (nonatomic,retain)Activity *selectedActivity;
@property (nonatomic,retain)Venue *selectedLocation;
@property (weak, nonatomic) IBOutlet UITextField *customMessageBox;
- (IBAction)sendMessage:(id)sender;
- (IBAction)cancelMessage:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *Username;
@property (weak, nonatomic) IBOutlet UILabel *activityName;
@property (weak, nonatomic) IBOutlet UILabel *venueName;

@end
