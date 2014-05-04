
#import "GetUsersOperation.h"
#import "User.h"


@interface GetUsersOperation () <NSURLConnectionDataDelegate>

@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;

@property (nonatomic, weak) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSString *parseString;
@property (nonatomic, retain) NSString *Activity;
@property (nonatomic, retain) NSString *VenueDescription;

@end

@implementation GetUsersOperation

- (id)initWithActivity:(NSString *)activityDescription andVenue:(NSString *)venueDescription andCompletion:(UserRequestCompletion)requestCompletion
{
    self = [super init];
    if (self) {
        self.AllUsers = [[NSMutableArray alloc] init];
        self.Activity = activityDescription;
        self.VenueDescription = venueDescription;
        self.requestCompletion = requestCompletion;
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
    
    NSString *urlString = [NSString stringWithFormat:@"http://108.166.79.24/tethr/get_activity/%@/%@",self.Activity,self.VenueDescription];
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
    
    NSAssert(!error, @"%s: Error while parsing JSON", __FUNCTION__);
    
    for(NSArray *tempDictionary in [userDetails objectForKey:@"users"]){
        User *tempUser = [[User alloc] initWithDictionary:[tempDictionary objectAtIndex:0]];
        [self.AllUsers addObject:tempUser];
    }
    
    if (!error)
    {
        if (self.requestCompletion)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.requestCompletion(self.AllUsers, nil);
            }];
        }
    };
    
    self.executing = NO;
    self.finished = YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.requestCompletion)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.requestCompletion(nil, error);
        }];
    }
    
    self.executing = NO;
    self.finished = YES;
}

@end
