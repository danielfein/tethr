
#import <Foundation/Foundation.h>

@class Venue;

typedef void(^SendMessageRequestCompletion)(NSArray *AllUsers, NSError *error);

@interface GetUsersOperation : NSOperation

- (id)initWithActivity: (NSString *) activityDescription andVenue: (NSString *)venueDescription andCompletion: (SendMessageRequestCompletion) requestCompletion;
@property (nonatomic, strong) NSMutableArray *AllUsers;
@property (nonatomic, copy)   SendMessageRequestCompletion requestCompletion;


@end
