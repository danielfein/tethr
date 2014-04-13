
#import <Foundation/Foundation.h>

@interface Venue : NSObject

/** Initialize the Venue
 @param venueId is a unique identifier given by foursquare to identify a venue.
 @return A reference to the `Venue` object.
 @note You have to either know these in advance (which this app does for just a few Venues), or you have to sign up for Foursquare services to look up Venue ID.
 */
- (id)initWithVenueId:(NSString *)venueId;

/** Determine if the Venue needs to be refreshed
 @return `YES` if the app must fetch updated Venue Information. `NO` otherwise.
 */
- (BOOL)needsRefresh;

/// The Foursquare unique ID for Venue
@property (nonatomic, copy)   NSString *venueId;

/// Venue name
@property (nonatomic, copy)   NSString *venueName;

/// number of check ins
@property (nonatomic)         int    checkinsCount;

/// The URL of the image associated with the Venue (if any)
@property (nonatomic, copy)   NSURL    *imageURL;

/// Timestamp that we last successfully retrieved the Venue
@property (nonatomic, strong) NSDate   *timestamp;
@property (nonatomic, assign) double   lat;
@property (nonatomic, assign) double   longitude;
@property (nonatomic, assign) double   distance;
-(id) initWithDictioanry: (NSDictionary*) dictionary;

@end
