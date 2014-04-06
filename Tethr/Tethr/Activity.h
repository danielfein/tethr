//
//  Activities.h
//  Tethr
//
//  Created by Daniel Fein on 4/5/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* venue;
@property (nonatomic) NSInteger count;
@property (nonatomic) NSInteger user_id;
-(id) initWithDictionary: (NSDictionary* ) dictionary;
@end
