
#import <Foundation/Foundation.h>

@class Venue;

@interface SendMessageOperation : NSOperation

- (id)initWithActivity: (NSString *) activityDescription andVenue: (NSString *)venueDescription wthRecieverFbID:(NSString*)rFbID andSenderFbID:(NSString*)sFbId;


@end
