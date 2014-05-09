

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
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.82 green:1 blue:0.72 alpha:1]];

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
    
    NSData *imageData = [NSData dataWithContentsOfURL:venue.imageURL];
    
    cell.imageView.image = [UIImage imageWithData:imageData];
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    return cell;
}
//if user clicks cell go to users list view controller
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     Venue *venue = self.venues[indexPath.row];
    //Call function to preparesegue
    [self performSegueWithIdentifier:@"toUsers" sender:venue];
    
}

//if user clicks icon then go to the map
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    Venue *venue = self.venues[indexPath.row];
     //Call function to preparesegue
    [self performSegueWithIdentifier:@"goToMapView" sender:venue];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //Prepare for segue to incoming view controller.
    UIViewController *vc= [segue destinationViewController];
    if([vc isKindOfClass:[MapViewController class]]){
        
        Venue *selectedVenue= (Venue*)sender;
        ((MapViewController*)vc).latitude= selectedVenue.lat;
        ((MapViewController*)vc).longitude= selectedVenue.longitude;

    }else{
        
        Activity *selectedActivity = self.activity;
        Venue *selectedVenue = (Venue*)sender;
        
        [((UsersTableViewController*)vc) setSelectedActivity:selectedActivity];
        [((UsersTableViewController*)vc) setSelectedLocation:selectedVenue];
    }
}
//


@end
