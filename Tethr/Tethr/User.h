//
//  Users.h
//  Tethr
//
//  Created by Daniel Fein on 4/13/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, assign) NSUInteger userid;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *image_url;
@property (nonatomic, retain) NSString *facebook_id;
@property (nonatomic, assign) BOOL isFriend;
-(id) initWithDictionary: (NSDictionary *) dictionary;
@end
