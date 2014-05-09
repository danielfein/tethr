//
//  GetNotificationMatch.h
//  Tethr
//
//  Created by Daniel Fein on 5/8/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Venue;
typedef void(^GetNotificationRequestCompletion)(NSArray *AllUsers, NSError *error);
@interface GetNotificationMatchOperation : NSOperation
- (id)initWithAlert:(NSString *)alert_incoming;
@end
