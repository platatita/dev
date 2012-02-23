//
//  TestWifiAppDelegate.h
//  
//
//  Feel Free to do whatever you want with this code.
//  It is tested & working on iPhone OS 3.0+
//  Hopefully it made your life a little easier
//  Downloaded from http://iphone.keyvisuals.com
//

#import <UIKit/UIKit.h>

@class TestWifiViewController;

@interface TestWifiAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TestWifiViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TestWifiViewController *viewController;

@end

