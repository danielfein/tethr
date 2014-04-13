
#import <Foundation/Foundation.h>

@class Venue;

typedef void(^UserRequestCompletion)(NSArray *AllUsers, NSError *error);

@interface GetUsersOperation : NSOperation

- (id)initWithActivity: (NSString *) activityDescription andVenue: (NSString *)venueDescription andCompletion: (UserRequestCompletion) requestCompletion;
@property (nonatomic, strong) NSMutableArray *AllUsers;
@property (nonatomic, copy)   UserRequestCompletion requestCompletion;


@end
