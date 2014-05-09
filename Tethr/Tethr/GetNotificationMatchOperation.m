//
//  GetNotificationMatch.m
//  Tethr
//
//  Created by Daniel Fein on 5/8/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//

 //This uses the text from an alert and finds who sent it.

#import "GetNotificationMatchOperation.h"
#import "User.h"
#import "AppDelegate.h"
@interface GetNotificationMatchOperation () <NSURLConnectionDataDelegate>



@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;

@property (nonatomic, weak) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSString *parseString;
@property (nonatomic, retain) NSString *alert;
@end


@implementation GetNotificationMatchOperation
- (id)initWithAlert:(NSString *)alert_incoming
{
    
    self = [super init];
    if (self) {
       
        self.alert = alert_incoming;
         NSLog(@"%@", self.alert);
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
    
    NSString *myFbID = [((AppDelegate*)[UIApplication sharedApplication].delegate) fbID];
    //This uses the text from an alert and finds who sent it.
    NSString *urlString = [NSString stringWithFormat:@"http://108.166.79.24/tethr/find_notification/%@",self.alert];
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
    
    NSAssert(![NSJSONSerialization isValidJSONObject:self.data], @"%s: Invalid JSON recieved from server", __FUNCTION__);
    
    NSDictionary *userDetails = [NSJSONSerialization JSONObjectWithData:self.data
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
    
    //Retrieve from our API call the recipient and sender of the invitation
    NSDictionary *user = [[userDetails objectForKey:@"users"] objectAtIndex:0];
    NSString *recipient_id = [user objectForKey:@"recipient_id"];
      NSString *sender_id = [user objectForKey:@"sender_id"];
    AppDelegate *sharedDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    sharedDelegate.replyRecipientID = recipient_id;
    sharedDelegate.replySenderID = sender_id;
   
    
    self.executing = NO;
    self.finished = YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

    self.executing = NO;
    self.finished = YES;
}


@end
