//
//  AppDelegate.m
//  apnTest
//
//  Created by  on 12. 7. 19..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    
    NSDictionary *userInfo = [launchOptions objectForKey:
                              UIApplicationLaunchOptionsRemoteNotificationKey]; 
    
    if(userInfo != nil) 
    { 
        [self application:application didFinishLaunchingWithOptions:userInfo]; 
    } 
    
    // APNS에 디바이스를 등록한다. 
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: 
     UIRemoteNotificationTypeAlert| 
     UIRemoteNotificationTypeBadge| 
     UIRemoteNotificationTypeSound]; 
    
    NSLog(@"didFinishLaunchingWithOptions: %@", @"test"); 
    return YES; 
}

- (void)application:(UIApplication *)application 
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken 
{ 
    NSMutableString *deviceId = [NSMutableString string]; 
    const unsigned char* ptr = (const unsigned char*) [deviceToken bytes]; 
    
    for(int i = 0 ; i < 32 ; i++) 
    { 
        [deviceId appendFormat:@"%02x", ptr[i]]; 
    } 
    self.viewController.myToken = deviceId;
    
    NSString * userDefaults = [[NSUserDefaults standardUserDefaults] objectForKey:@"myToken"];
    if(userDefaults == nil || ![userDefaults isEqualToString:deviceId])
    {
        [self.viewController requestUrl:@"YOUR_SERVER_IP:YOUR_SERVER_PORT/register"]; //ex)http://10.0.1.21:8090
        [[NSUserDefaults standardUserDefaults] setValue:deviceId forKey:@"myToken"];
        NSLog(@"registering.. %@",deviceId);
    }
} 

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{ 
    NSLog(@"userInfo %@", userInfo); 
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message From:  " 
                                                    message: [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"messageFrom"]]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil]; 
    [alert show];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error 
{
    NSLog(@"APNS Device Token: %@ , %@ , %@ ", [error userInfo], [error domain], [error localizedFailureReason]); 
}
@end
