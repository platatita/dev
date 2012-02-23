//
//  TestWifiAppDelegate.m
//  
//
//  Feel Free to do whatever you want with this code.
//  It is tested & working on iPhone OS 3.0+
//  Hopefully it made your life a little easier
//  Downloaded from http://iphone.keyvisuals.com
//

#import "TestWifiAppDelegate.h"
#import "TestWifiViewController.h"

@implementation TestWifiAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
