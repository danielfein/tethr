//
//  RootViewController.m
//  Tethr
//
//  Created by Zeinab Khan on 4/14/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];

    if(![FBSession activeSession].isOpen){
        [self openSessionWithAllowLoginUI:YES];
    }
}

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
{
    NSArray *permissions = @[@"basic_info", @"user_birthday"];
    
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
     if (error) {
         NSLog (@"Handle error %@", error.localizedDescription);
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"LogIn failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         [alertView show];
         // terminate app
     } else {
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"LogIn success" message:@"You have been logged In successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         [alertView show];
     }
 }];
}
    
@end
