//
//  Users.m
//  Tethr
//
//  Created by Daniel Fein on 4/13/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//

#import "User.h"

@implementation User
-(id) initWithDictionary: (NSDictionary *) dictionary{
    self = [super init];
    if (self) {
        self.userid = [[dictionary objectForKey:@"id"] integerValue]; //The user who is currrently using the app
        self.name = [dictionary objectForKey:@"name"]; //Name of user after Facebook connect
        self.image_url = [dictionary objectForKey:@"image_url"]; //Profile picture of user after Facebook Connect
        self.facebook_id = [dictionary objectForKey:@"facebook_id"]; //Facebook User ID
    }
    return self;
 
}

@end
