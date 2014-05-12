//
//  SendMesssageOperation.h
//  Tethr
//
//  Created by Zeinab Khan on 5/8/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//
#import <Foundation/Foundation.h>

@class Venue;

@interface SendMessageOperation : NSOperation

- (id)initWithActivity: (NSString *) activityDescription andVenue: (NSString *)venueDescription wthRecieverFbID:(NSString*)rFbID andSenderFbID:(NSString*)sFbId;


@end
