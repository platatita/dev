//
//  SimpleViewAppDelegate.h
//  SimpleView
//
//  Created by  on 1/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SimpleViewViewController;

@interface SimpleViewAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet SimpleViewViewController *viewController;

@end
