
#import "VenueSearchOperation.h"
#import "Venue.h"

static const NSString *c_host_name = @"https://api.foursquare.com/v2/";
static const NSString *c_client_id = @"XZTV2M5BY32M0VISEBZZA3TIPDMHCLFAKP2OR0WB3AY4AO1P";
static const NSString *c_client_secret = @"5XIZJB025B4OFNAWDWBHX5MGPOZFKOOVUDAOXFVTEK5PY1OO";
static const NSString *c_version = @"20131016";

@interface VenueSearchOperation () <NSURLConnectionDataDelegate>

@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;

@property (nonatomic, weak) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSString *parseString;

@end

@implementation VenueSearchOperation

- (id)initWithCompletion:(VenueRequestCompletion)requestCompletion
{
    self = [super init];
    if (self) {
        self.AllVenues = [[NSMutableArray alloc] init];
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
    
    NSString *urlString = [NSString stringWithFormat:@"%@venues/search?ll=40.7,-74&query=museum&client_id=%@&client_secret=%@&v=%@",
                           c_host_name,c_client_id,c_client_secret,c_version];
    
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
    
    NSArray *venueDetails = [NSJSONSerialization JSONObjectWithData:self.data
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&error][@"response"][@"venues"];
    
    NSAssert(!error, @"%s: Error while parsing JSON", __FUNCTION__);
    
    for(NSDictionary *tempDictionary in venueDetails){
        Venue *tempVenue = [[Venue alloc] initWithDictioanry:tempDictionary];
        [self.AllVenues addObject:tempVenue];
    }
    
    if (!error)
    {
        if (self.requestCompletion)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.requestCompletion(self.AllVenues, nil);
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
