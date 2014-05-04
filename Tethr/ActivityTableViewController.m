//
//  ActivityTableViewController.m
//  Tethr
//
//  Created by Daniel Fein on 4/5/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//

#import "ActivityTableViewController.h"

#import "VenueViewController.h"
#import "Activity.h"

@interface ActivityTableViewController (){
    NSMutableData *_responseData;
}
    @end

@implementation ActivityTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dummyArray = [[NSMutableArray alloc] init];
//    Activity *dummyActivity = [[Activity alloc] init];
//    dummyActivity.name = @"Tennis";
//    dummyActivity.count = 10;
//    [self.dummyArray addObject:dummyActivity];
//    
//    dummyActivity = [[Activity alloc] init];
//    dummyActivity.name = @"Museums";
//    dummyActivity.count = 123;
//    [self.dummyArray addObject:dummyActivity];
//    
//    dummyActivity = [[Activity alloc] init];
//    dummyActivity.name = @"Dinner";
//    dummyActivity.count = 7;
//    [self.dummyArray addObject:dummyActivity];
    // Create the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://108.166.79.24/tethr/get_all_activities"]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSArray *sortedArray = [self.dummyArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b){
        NSInteger first = [(Activity * ) a count];
        NSInteger second = [(Activity * ) b count];
        return -1*(first -second);
    }];
    
    self.dummyArray = [sortedArray mutableCopy];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 2;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.dummyArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityCell" forIndexPath:indexPath];
    
    Activity *temp = [self.dummyArray objectAtIndex:indexPath.row];
        cell.textLabel.text = temp.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d Users", temp.count];

    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Activity *selectedActivity = [self.dummyArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"gotoMap" sender:selectedActivity];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    VenueViewController *vc = [segue destinationViewController];
    vc.activity = (Activity *) sender;
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    // NSLog(@"Data is %@", [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding ]);
    NSDictionary *activities = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingAllowFragments error:nil];
//
    NSArray *allActivities = [activities objectForKey:@"activities"];
    for (NSDictionary *dictionary in allActivities) {
        Activity *tempActivity = [[Activity alloc] initWithDictionary:dictionary];
        
        if([self getDuplicateActivity:tempActivity]){
            Activity *existingActivity = [self getDuplicateActivity:tempActivity];
            existingActivity.count += 1;
        }else{
            [self.dummyArray addObject:tempActivity];
        }
    }
    
    [self.tableView reloadData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

-(Activity*)getDuplicateActivity:(Activity*)activity{
    for(Activity *iteratorActivity in self.dummyArray){
        if([iteratorActivity.name isEqualToString:activity.name]){
            return iteratorActivity;
        }
    }
    return nil;
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
