

#import "VenueViewController.h"
#import "Venue.h"
#import "VenueSearchOperation.h"
#import "UIImageView+WebCache.h"
#import "MapViewController.h"

@interface VenueViewController ()

@property (nonatomic, strong) NSArray *venues;

@end

@implementation VenueViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    VenueSearchOperation *operation = [[VenueSearchOperation alloc] initWithActivity:self.activity.name Completion:^(NSArray *allVenues,NSError *error){
        
        self.venues = [allVenues mutableCopy];
        [self.tableView reloadData];
    }];
    [[self venueReportQueue] addOperation:operation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSOperationQueue *)venueReportQueue
{
    static NSOperationQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 4;
        queue.name = [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingString:@".venue"];
    });

    return queue;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.venues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    Venue *venue = self.venues[indexPath.row];

    cell.textLabel.text = venue.venueName;
    [cell.imageView setImageWithURL:venue.imageURL];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     Venue *venue = self.venues[indexPath.row];
    [self performSegueWithIdentifier:@"toUsers" sender:venue];
    
}
//
//
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    UIViewController *vc= [segue destinationViewController];
    if([vc isKindOfClass:[MapViewController class]]){
        
        Venue *selectedVenue= (Venue*)sender;
        ((MapViewController*)vc).latitude= selectedVenue.lat;
        ((MapViewController*)vc).longitude= selectedVenue.longitude;

    }else{
        /*
         Continue from here, sending venue and activity
         */
    }
}
//


@end
