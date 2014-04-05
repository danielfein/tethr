//
//  ActivityTableViewController.m
//  Tethr
//
//  Created by Daniel Fein on 4/5/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//

#import "ActivityTableViewController.h"
#import "Activity.h"

@interface ActivityTableViewController ()

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
    Activity *dummyActivity = [[Activity alloc] init];
    dummyActivity.name = @"Tennis";
    dummyActivity.count = 10;
    [self.dummyArray addObject:dummyActivity];
    
    dummyActivity = [[Activity alloc] init];
    dummyActivity.name = @"Museums";
    dummyActivity.count = 123;
    [self.dummyArray addObject:dummyActivity];
    
    dummyActivity = [[Activity alloc] init];
    dummyActivity.name = @"Dinner";
    dummyActivity.count = 7;
    [self.dummyArray addObject:dummyActivity];
    
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
    [self performSegueWithIdentifier:@"gotoMap" sender:nil];
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
