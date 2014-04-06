
#import <Foundation/Foundation.h>

/** This is the main model for the app, which is simply an array of Venues.
 */
@interface Model : NSObject

/// The array of venues
@property (nonatomic, strong) NSMutableArray *venues;

/** Retrieve a reference to the singleton
 @return A `Model` object
 */
+ (instancetype)sharedManager;

/// Load the model from persistent storage
- (void)load;

/// Save the model to persistent storage
- (void)save;

@end
