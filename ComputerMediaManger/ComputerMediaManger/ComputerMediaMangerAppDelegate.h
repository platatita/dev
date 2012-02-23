//
//  ComputerMediaMangerAppDelegate.h
//  ComputerMediaManger
//
//  Created by  on 12/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ComputerMediaMangerViewController;

@interface ComputerMediaMangerAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet ComputerMediaMangerViewController *viewController;

@end
