//
//  SendReplyOperation.m
//  Tethr
//
//  Created by Daniel Fein on 5/8/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//

#import "SendReplyOperation.h"
#import "User.h"


//Send push notification, taking in criteria of message and whether or not it is an acceptance or rejection


@interface SendReplyOperation () <NSURLConnectionDataDelegate>{
    NSString *recieverFbID;
    NSString *senderFbID;
    
}

@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;

@property (nonatomic, weak) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSString *parseString;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, assign) BOOL accepted;

@end

@implementation SendReplyOperation

- (id)initWithRecipient: (NSString*)rFbID andSenderFbID:(NSString*)sFbId andMessage:(NSString *)message isAccepted:(BOOL)accepted
{
    self = [super init];
    if (self) {
        self.message = message;
        self.accepted = accepted;
        recieverFbID = rFbID;
        senderFbID = sFbId;
        NSLog(@"here");
    }
    return self;
}

- (void)start
{
    if ([self isCancelled])
    {
        self.finished = YES;
        return;
    }
    
    self.executing = YES;
    NSString *acceptanceCriteria = self.accepted ? @"accept":@"reject";
    //Send push notification, taking in criteria of message and whether or not it is an acceptance or rejection
    NSString *urlString = [NSString stringWithFormat:@"http://108.166.79.24/tethr/send_message/%@/%@/%@/%@",senderFbID, recieverFbID,acceptanceCriteria,self.message ];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [connection start];
}

#pragma mark - NSOperation methods

- (BOOL)isConcurrent
{
    return YES;
}

- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)cancel
{
    [self.connection cancel];
    [super cancel];
    self.executing = NO;
    self.finished = YES;
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.data = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    self.executing = NO;
    self.finished = YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.executing = NO;
    self.finished = YES;
}

@end
