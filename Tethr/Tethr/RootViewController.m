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

//    if(![FBSession activeSession].isOpen){
//        [self openSessionWithAllowLoginUI:NO];
//    }
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

- (void)facebookSessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            // handle successful login here
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            
            if (error) {
                // handle error here, for example by showing an alert to the user
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not login with Facebook"
                                                                message:@"Facebook login failed. Please check your Facebook settings on your phone."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            break;
        default:
            break;
    }
}

@end
