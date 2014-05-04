//
//  UpdateTokenOperation.m
//  Tethr
//
//  Created by Daniel Fein on 5/4/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//

#import "UpdateTokenOperation.h"

@interface UpdateTokenOperation (){
    NSString *deviceToken;
    NSString *facebookId;
    NSString *username;
}
@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;

@property (nonatomic, weak) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSString *parseString;

@end

@implementation UpdateTokenOperation

-(id)initWithDeviceToken:(NSString*)token andFbID:(NSString*)fbID andName:(NSString *)name{
    self = [super init];
    if (self) {
        deviceToken = token;
        facebookId = fbID;
        username = name;
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
    
    NSString *urlString = [NSString stringWithFormat:@"http://108.166.79.24/tethr/update_token/%@/%@/%@",facebookId,deviceToken,username];
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
    
    

    self.executing = NO;
    self.finished = YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to register device" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    
    self.executing = NO;
    self.finished = YES;
}

@end
