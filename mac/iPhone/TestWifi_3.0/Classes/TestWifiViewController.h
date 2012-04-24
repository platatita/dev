//
//  TestWifiViewController.h
//  
//
//  Feel Free to do whatever you want with this code.
//  It is tested & working on iPhone OS 3.0+
//  Hopefully it made your life a little easier
//  Downloaded from http://iphone.keyvisuals.com
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface TestWifiViewController : UIViewController
{
	NetworkStatus localWiFiConnectionStatus;
}

@property NetworkStatus localWiFiConnectionStatus;

- (BOOL)CheckReachability;

@end
