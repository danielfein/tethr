//
//  Activities.m
//  Tethr
//
//  Created by Daniel Fein on 4/5/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//

#import "Activity.h"

@implementation Activity
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.name = [dictionary objectForKey:@"activity"];
        self.venue = [dictionary objectForKey:@"venue"];
        self.user_id = [[dictionary objectForKey:@"user_id"] integerValue];
        self.count = 1;
    }
    
    return self;
}
@end
