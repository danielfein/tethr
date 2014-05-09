//
//  AppDelegate.m
//  Tethr
//
//  Created by Daniel Fein on 4/5/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//\
#import "UpdateTokenOperation.h"


#import "UsersTableViewController.h"
#import "User.h"
#import "GetUsersOperation.h"
#import "UIImageView+WebCache.h"
#import "MapViewController.h"
#import "SendReplyOperation.h"
#import "AppDelegate.h"
#import "SendReplyOperation.h"
#import "GetNotificationMatchOperation.h"

@implementation AppDelegate

@synthesize locationManager = locationManager;
@synthesize operation = operation;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Load the FBProfilePictureView
    // You can find more information about why you need to add this line of code in our troubleshooting guide
    // https://developers.facebook.com/docs/ios/troubleshooting#objc
    [FBProfilePictureView class];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([CLLocationManager locationServicesEnabled]) {
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
            locationManager.distanceFilter = kCLDistanceFilterNone;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            [locationManager startUpdatingLocation];
        }
    });
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    return YES;
}



- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    self.deviceToken = deviceToken.description;
    self.deviceToken = [self.deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.deviceToken = [self.deviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    self.deviceToken = [self.deviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];

    NSLog(@"My token is: %@", self.deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.currentLocation = [locations lastObject];
}



// In order to process the response you get from interacting with the Facebook login process,
// you need to override application:openURL:sourceApplication:annotation:
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    if(userInfo[@"aps"][@"first"] != nil){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:userInfo[@"aps"][@"alert"] message:nil delegate:nil cancelButtonTitle:@"Reject" otherButtonTitles:@"Accept",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
           [alert setDelegate:self];
    
    GetNotificationMatchOperation *operationTemp = [[GetNotificationMatchOperation alloc] initWithAlert:userInfo[@"aps"][@"alert"]];
    
    [[self queue] addOperation:operationTemp];
    NSLog(@"%@", operationTemp);
       [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:userInfo[@"aps"][@"alert"] message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
          [alert show];
        
    }
}


- (NSOperationQueue *)queue
{
    static NSOperationQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 4;
        queue.name = [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingString:@".deviceQueue"];
    });
    
    return queue;
}
- (NSOperationQueue *)replyQueue
{
    static NSOperationQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 4;
        queue.name = [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingString:@".replyQueue"];
    });
    
    return queue;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // Handle interaction
    SendReplyOperation *replyOperation;
    switch (buttonIndex)
    {
        case 0:
            NSLog(@"Reject was pressed");
            replyOperation = [[SendReplyOperation alloc] initWithRecipient:self.replyRecipientID andSenderFbID:self.replySenderID andMessage:@"" isAccepted:NO];
            break;
        case 1:
            //Why can't I access Alert here?
            replyOperation = [[SendReplyOperation alloc] initWithRecipient:self.replyRecipientID andSenderFbID:self.replySenderID andMessage:[[alertView textFieldAtIndex:0] text] isAccepted:YES];
            NSLog(@"Accept was pressed %@",self.operation);
            break;
    }
    [[self replyQueue] addOperation:replyOperation];

}

-(NSString*)deviceToken{
    if(!_deviceToken){
        return @"6337406414343423423";
    }else{
        return _deviceToken;
    }
}

@end
