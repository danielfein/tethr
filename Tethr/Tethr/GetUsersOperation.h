//
//  GetUsersOperation.h
//  Tethr
//
//  Created by Daniel Fein on 5/8/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//
#import <Foundation/Foundation.h>

@class Venue;

typedef void(^SendMessageRequestCompletion)(NSArray *AllUsers, NSError *error);

@interface GetUsersOperation : NSOperation

- (id)initWithActivity: (NSString *) activityDescription andVenue: (NSString *)venueDescription andCompletion: (SendMessageRequestCompletion) requestCompletion;
@property (nonatomic, strong) NSMutableArray *AllUsers;
@property (nonatomic, copy)   SendMessageRequestCompletion requestCompletion;


@end
