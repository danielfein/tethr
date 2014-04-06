

#import "Model.h"
#import "Venue.h"

@interface Model ()

@end

@implementation Model

+ (instancetype)sharedManager
{
    static id sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (NSString *)archiveFilename
{
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [documentsPath stringByAppendingPathComponent:@"FourSquareVenues.dat"];
}

- (void)load
{
    NSString *path = [self archiveFilename];

    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        self.venues = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        NSAssert(self.venues, @"%s: Unable to read venues", __FUNCTION__);
    }
    else
    {
        self.venues = [[NSMutableArray alloc] init];
        NSArray *venueIds = @[@"525e022711d2f114af4e7a49",
                              @"42377700f964a52024201fe3",
                              @"503de4dce4b0857b003af5f7",
                              @"524096e611d281cb3d63e667",
                              @"4ebac60a0cd6904066e4108f",
                              @"4ff6de22e4b02ca33c0a04fb"]; // a few random venues
        for (NSString *venueId in venueIds)
        {
            [self.venues addObject:[[Venue alloc] initWithVenueId:venueId]];
        }
    }
}

- (void)save
{
    BOOL success = [NSKeyedArchiver archiveRootObject:self.venues toFile:[self archiveFilename]];

    NSAssert(success, @"%s: Unable to save venues", __FUNCTION__);
}

@end
