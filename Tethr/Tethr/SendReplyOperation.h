//
//  SendReplyOperation.h
//  Tethr
//
//  Created by Daniel Fein on 5/8/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Venue;

@interface SendReplyOperation : NSOperation
- (id)initWithRecipient: (NSString*)rFbID andSenderFbID:(NSString*)sFbId andMessage:(NSString *)message isAccepted:(BOOL)accepted;
@end
