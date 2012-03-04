//
//  iHello_WordAppDelegate.h
//  iHello_Word
//
//  Created by Marcin Szewczyk on 9/2/11.
//  Copyright 2011 platatita@interia.pl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iHello_WordViewController;

@interface iHello_WordAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet iHello_WordViewController *viewController;

@end
