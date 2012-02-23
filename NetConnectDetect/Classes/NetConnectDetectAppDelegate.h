//
//  NetConnectDetectAppDelegate.h
//  NetConnectDetect
//
//  Created by Keyvisuals to make your life a little bit easier
//  Feel free to use this code in any way you see fit!
//  Downloaded from http://iphone.keyvisuals.com
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@class NetConnectDetectViewController;

@interface NetConnectDetectAppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow *window;
    NetConnectDetectViewController *viewController;
	
	NetworkStatus remoteHostStatus;
    NetworkStatus internetConnectionStatus;
    NetworkStatus localWiFiConnectionStatus;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet NetConnectDetectViewController *viewController;

@property NetworkStatus remoteHostStatus;
@property NetworkStatus internetConnectionStatus;
@property NetworkStatus localWiFiConnectionStatus;

- (BOOL)CheckReachability;

@end

