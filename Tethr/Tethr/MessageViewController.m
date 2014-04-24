//
//  MessageViewController.m
//  Tethr
//
//  Created by Daniel Fein on 4/19/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.Username.text = self.messageReciever.name;
    self.activityName.text = self.selectedActivity.name;
    self.venueName.text = self.selectedLocation.venueName;

    self.customMessageBox.placeholder = @"Add your custom message here..";
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMessage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelMessage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
