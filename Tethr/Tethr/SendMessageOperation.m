//
//  SendMesssageOperation.m
//  Tethr
//
//  Created by Zeinab Khan on 5/8/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//
#import "SendMessageOperation.h"
#import "User.h"
//Sending the initial invitation push notification

@interface SendMessageOperation () <NSURLConnectionDataDelegate>{
    NSString *recieverFbID;
    NSString *senderFbID;
    NSString *venueDesc;
    NSString *activityDesc;

}

@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;

@property (nonatomic, weak) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSString *parseString;
@property (nonatomic, retain) NSString *Activity;
@property (nonatomic, retain) NSString *VenueDescription;

@end

@implementation SendMessageOperation

- (id)initWithActivity: (NSString *) activityDescription andVenue: (NSString *)venueDescription wthRecieverFbID:(NSString*)rFbID andSenderFbID:(NSString*)sFbId;
{
    self = [super init];
    if (self) {
        recieverFbID = rFbID;
        senderFbID = sFbId;
        venueDesc = venueDescription;
        activityDesc= activityDescription;

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
    //Send the notification to sender from sender with Activity and Venue. Using this we construct a message on the backend
    NSString *urlString = [NSString stringWithFormat:@"http://108.166.79.24/tethr/send_notification/%@/%@/%@/%@",senderFbID,recieverFbID,activityDesc,venueDesc];
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
