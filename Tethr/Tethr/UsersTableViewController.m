//
//  UsersTableViewController.m
//  Tethr
//
//  Created by Daniel Fein on 4/13/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//


#import "UsersTableViewController.h"
#import "User.h"
#import "GetUsersOperation.h"
#import "UIImageView+WebCache.h"
#import "MapViewController.h"
#import "AppDelegate.h"
#import "SendMessageOperation.h"

@interface UsersTableViewController ()

@property (nonatomic, strong) NSArray *allUsers;

@property (nonatomic, strong) NSMutableArray *allFacebookUsers; //Grab from Facebook API call, all current user's friends
@property(nonatomic, assign) BOOL requestOneComplete;
@property(nonatomic, assign) BOOL requestTwoComplete;
@property (nonatomic,retain)User *selectedUser;

@end

@implementation UsersTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.82 green:1 blue:0.72 alpha:1]]; //Background color

    self.allFacebookUsers=[[NSMutableArray alloc]init]; //Initiatlize an array
    
    //This is where we make our call to our backend to get the users who match the selected activity and venue.
    GetUsersOperation *operation = [[GetUsersOperation alloc] initWithActivity:self.selectedActivity.name andVenue:self.selectedLocation.venueName andCompletion:^(NSArray *allUsers,NSError *error)
    {
        self.allUsers = allUsers;
        [self.tableView reloadData];
        //After retrieving all users, mark these users as requestneComplete true. This is for marking mutual friends.
        self.requestOneComplete= YES;
        
        if(self.requestOneComplete && self.requestTwoComplete){
            //For displaying if a user is your facebook friend.
            [self markMutualFriends];
            
        }
    
    }];
    [[self venueReportQueue] addOperation:operation]; //This is where we initiate the connection by running the queue
  
    FBRequest * request= [FBRequest requestForMyFriends]; //Get friends
    [request startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary *result, NSError *error){
        if (error){
            
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Connection error" message:error.description delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            //If there's an error with connection we need to notify the user and allow the user to dismiss it
            [alert show];
            
            return;
            
        }
        //From our data we receive, get object by key of Data and then iterate through friends and mark the boolean of requestTwoComplete to True. Also add them to allFacebookUsers property of current user at self.
        NSArray *friends= [result objectForKey:@"data"];
        for (NSDictionary *friend in friends){
            self.requestTwoComplete= YES;
            [self.allFacebookUsers addObject:friend];
        }
        //If the user is boolean true for both requestOneComplete and requestTwoComplete they are mutual friends and should be displayed differently. Calls the function markMutualFriends with self
        if(self.requestOneComplete && self.requestTwoComplete){
            [self markMutualFriends];
        }
        
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//Queue for our connection
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
//A function that uses friends' ids and grabs users' profile pictures to be used in our display.
-(void) markMutualFriends{
    
    for( User *temp in self.allUsers){
        for( NSDictionary <FBGraphUser>*fbUsers in self.allFacebookUsers){
            //If the results for Activty and Venue match a user in my Facebook list, then following is done for displaying info:
            if ([temp.facebook_id isEqualToString:fbUsers.id] ){
                
                temp.isFriend= YES;
                temp.image_url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?",fbUsers.id];
            }
            
        }
    }
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    User *user = self.allUsers[indexPath.row];
    self.selectedUser = user;
    Activity *selectedActivity = self.selectedActivity;
    Venue *selectedVenue = self.selectedLocation;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Invite user %@ to join %@ at %@",user.name,selectedActivity.name,selectedVenue.venueName] message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send",nil];
    //alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
   // [self performSegueWithIdentifier:@"showMessageDialog" sender:user];
}

//Handle the alert of activity and initiate a message if the current user clicks on a user and chooses to send them an invitation.
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"%@", [alertView textFieldAtIndex:0].text);
    

    Activity *selectedActivity = self.selectedActivity;
    Venue *selectedVenue = self.selectedLocation;

    NSString *myUSerID = [((AppDelegate*)[UIApplication sharedApplication].delegate) fbID];
    if (buttonIndex == 1){ // Send only if the user clicks Send when they are prompted to send the invitation
        //Construct and send the message by including the Activity, the Venue, the recipient and the sender.
        SendMessageOperation *messageOperation = [[SendMessageOperation alloc] initWithActivity:selectedActivity.name andVenue:selectedVenue.venueName wthRecieverFbID:self.selectedUser.facebook_id andSenderFbID:myUSerID];
        
        //Initiate connection call to messageOperation
        [[self queue] addOperation:messageOperation];
    }
}

- (NSOperationQueue *)queue
{
    static NSOperationQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 4;
        queue.name = [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingString:@".usersQueue"];
    });
    
    return queue;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    Activity *selectedActivity = self.selectedActivity;
    Venue *selectedVenue = self.selectedLocation;

}



@end
