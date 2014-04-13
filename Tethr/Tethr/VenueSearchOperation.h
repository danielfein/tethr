
#import <Foundation/Foundation.h>

@class Venue;

typedef void(^VenueRequestCompletion)(NSArray *AllVenues, NSError *error);

/** Venue Detail request operation
 This is a `NSOperation` subclass that employs the [Foursquare! Venue Detail API](https://developer.foursquare.com/docs/venues/venues) to retrieve the details for a couple of Venues
 */
@interface VenueSearchOperation : NSOperation

/** Initialize the operation
 @param Venue A `Venue` object that will have (a) name; (b) checkins count; and (c) an image URL populated.
 @param requestCompletion   The block that will be called when the request is complete.
 @return A `VenueSearchOperation` pointer. `nil` if error.
 */
- (id)initWithActivity:(NSString *) activityDescription Completion:(VenueRequestCompletion)requestCompletion;

/// The Venue details to be updated upon receiving information from the FourSquare! servers.
@property (nonatomic, strong) NSMutableArray *AllVenues;

/// The completion block to be performed.
@property (nonatomic, copy)   VenueRequestCompletion requestCompletion;


@end
