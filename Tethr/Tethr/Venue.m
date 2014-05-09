//
//  Venue.m
//  Tethr
//
//  Created by Zeinab Khan on 4/5/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//
#import "Venue.h"
#import <objc/runtime.h>

@implementation Venue

//Standard init method
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
    NSMutableSet *propNames = [NSMutableSet set]; //Create a set that can append properties
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
   
    //Temporarily store the curernt property into a variable of   objc_property_t type
    for (i = 0; i < outCount; i++) { //Iterate through the returned array after using class_copyPropertyList
    
        //Temporarily store the curernt property into a variable of   objc_property_t type
        objc_property_t property = properties[i];
      //Create propertyName string and then add it to propNames then return propNames after for loop
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding]; //Make
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

//Used in conjunction with our FourSquare API calls. Get name, id, location (lat and long) and store them in properties of self.
    self = [super init];
    if (self) {
        self.venueName = [dictionary objectForKey:@"name"];
         self.venueId = [dictionary objectForKey:@"id"];
         self.lat = [[[dictionary objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
         self.longitude = [[[dictionary objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
         self.distance = [[[dictionary objectForKey:@"location"] objectForKey:@"distance"] doubleValue];
        
        //Grab the icons for the locations which we display next to the venue names
        if([dictionary[@"categories"] count] > 0){
            NSString *imageURL = [NSString stringWithFormat:@"%@bg_32%@",dictionary[@"categories"][0][@"icon"][@"prefix"],dictionary[@"categories"][0][@"icon"][@"suffix"]];
            self.imageURL = [[NSURL alloc] initWithString:imageURL];
        }
    }
    return self;

}


@end
