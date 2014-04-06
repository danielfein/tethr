
#import "Venue.h"
#import <objc/runtime.h>

@implementation Venue

- (id)initWithVenueId:(NSString *)venueId
{
    self = [super init];
    if (self) {
        _venueId = [venueId copy];
    }
    return self;
}

- (BOOL)needsRefresh
{
    if (self.timestamp == nil || [self.timestamp timeIntervalSinceNow] > 30000)
        return YES;

    return NO;
}

#pragma mark - NSCoder methods

- (NSSet *)propertyNames
{
    NSMutableSet *propNames = [NSMutableSet set];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [propNames addObject:propertyName];
    }
    free(properties);

    return propNames;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        for (NSString *key in [self propertyNames])
        {
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	for (NSString *key in [self propertyNames])
    {
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
}

#pragma mark - NSCopying method

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] allocWithZone:zone] init];

    if (copy)
    {
        for (NSString *key in [self propertyNames])
            [copy setValue:[[self valueForKey:key] copyWithZone:zone] forKey:key];
    }

    return copy;
}

-(id) initWithDictioanry: (NSDictionary*) dictionary{


    self = [super init];
    if (self) {
        self.venueName = [dictionary objectForKey:@"name"];
         self.venueId = [dictionary objectForKey:@"id"];
         self.lat = [[dictionary objectForKey:@"location"] objectForKey:@"lat"];
         self.longitude = [[dictionary objectForKey:@"location"] objectForKey:@"lng"];
         self.distance = [[dictionary objectForKey:@"location"] objectForKey:@"distance"];
    }
    return self;

}


@end
