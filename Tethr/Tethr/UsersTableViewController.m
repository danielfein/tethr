

#import "UsersTableViewController.h"
#import "User.h"
#import "GetUsersOperation.h"
#import "Model.h"
#import "UIImageView+WebCache.h"
#import "MapViewController.h"

@interface UsersTableViewController ()

@property (nonatomic, strong) NSArray *allUsers;

@property (nonatomic, strong) NSMutableArray *allFacebookUsers;
@property(nonatomic, assign) BOOL requestOneComplete;
@property(nonatomic, assign) BOOL requestTwoComplete;

@end

@implementation UsersTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.allFacebookUsers=[[NSMutableArray alloc]init];
    
    
    GetUsersOperation *operation = [[GetUsersOperation alloc] initWithActivity:@"activity" andVenue:@"venue" andCompletion:^(NSArray *allUsers,NSError *error)
    {
        self.allUsers = allUsers;
        [self.tableView reloadData];
        self.requestOneComplete= YES;
        
        if(self.requestOneComplete && self.requestTwoComplete){
            
            [self markMutualFriends];
            
        }
    
    }];
    [[self venueReportQueue] addOperation:operation];
  //
    FBRequest * request= [FBRequest requestForMyFriends];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary *result, NSError *error){
        if (error){
            
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Connection error" message:error.description delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            
            [alert show];
            
            return;
            
        }
        
        NSArray *friends= [result objectForKey:@"data"];
        for (NSDictionary *friend in friends){
            self.requestTwoComplete= YES;
            
            NSLog(@"%@", friends);
            
            [self.allFacebookUsers addObject:friend];
            
            
        }
        
        if(self.requestOneComplete && self.requestTwoComplete){
            
            [self markMutualFriends];
            
        }
        
    }];
    
    
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
    return [self.allUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    User *user = self.allUsers[indexPath.row];
    
    cell.textLabel.text = user.name;
    [cell.imageView setImageWithURL:[[NSURL  alloc] initWithString:user.image_url]];
    
    if(user.isFriend){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    return cell;

}

-(void) markMutualFriends{
    
    for( User *temp in self.allUsers){
        for( NSDictionary <FBGraphUser>*fbUsers in self.allFacebookUsers){
            
            if ([temp.facebook_id isEqualToString:fbUsers.id] ){
                
                temp.isFriend= YES;
                temp.image_url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?",fbUsers.id];
            }
            
        }
    }
    [self.tableView reloadData];
}









//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    Venue *venue = self.model.venues[indexPath.row];
//    [self performSegueWithIdentifier:@"goToMapView" sender:venue];
//    
//}


//-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    
//    MapViewController *vc= [segue destinationViewController];
//    Venue *selectedVenue= (Venue*)sender;
//    vc.latitude= selectedVenue.lat;
//    vc.longitude= selectedVenue.longitude;
//    
//}



@end
