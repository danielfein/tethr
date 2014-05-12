//
//  UpdateTokenOperation.h
//  Tethr
//
//  Created by Zeinab Khan on 5/4/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateTokenOperation : NSOperation
-(id)initWithDeviceToken:(NSString*)token andFbID:(NSString*)fbID andName:(NSString*)name;
@end
