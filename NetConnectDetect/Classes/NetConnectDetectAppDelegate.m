//
//  NetConnectDetectAppDelegate.m
//  NetConnectDetect
//
//  Created by Keyvisuals to make your life a little bit easier
//  Feel free to use this code in any way you see fit!
//  Downloaded from http://iphone.keyvisuals.com
//

#import "NetConnectDetectAppDelegate.h"
#import "NetConnectDetectViewController.h"

@implementation NetConnectDetectAppDelegate

@synthesize window;
@synthesize viewController;

@synthesize remoteHostStatus;
@synthesize internetConnectionStatus;
@synthesize localWiFiConnectionStatus;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	// Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}

- (void)dealloc
{
	[viewController release];
	[window release];
	[super dealloc];
}

#pragma mark Reachability
- (NSString *)hostName
{
	return @"www.apple.com";
}

- (BOOL)CheckReachability
{
	[[Reachability sharedReachability] setHostName:[self hostName]];
	
	self.remoteHostStatus           = [[Reachability sharedReachability] remoteHostStatus];
    self.internetConnectionStatus    = [[Reachability sharedReachability] internetConnectionStatus];
    self.localWiFiConnectionStatus    = [[Reachability sharedReachability] localWiFiConnectionStatus];
	
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	
	int flag = 0;//all ok
	
	if (self.remoteHostStatus == NotReachable)
	{
		flag = 1;//remote host not reachable
	}
	
	if (self.internetConnectionStatus == NotReachable && self.localWiFiConnectionStatus == NotReachable)
	{
		flag = 2;//2:No Carrier data network
	}
	
	if( flag == 0 )
	{
		alert.title = @"Connection Available";
		alert.message = @"Connected to the Internet";
		[alert show];
		return TRUE;
	}
	else
	{
		switch (flag)
		{
			case 1:
				alert.message = @"Remote host not available. Please try again later.";
				break;
			case 2:
				alert.message = @"Please check connectivity options";
				break;
		}
		[alert show];
		return FALSE;
	}
}

@end
