//
//  iHello_Word2AppDelegate.h
//  iHello_Word2
//
//  Created by Marcin Szewczyk on 9/24/11.
//  Copyright 2011 platatita@interia.pl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iHello_Word2ViewController;

@interface iHello_Word2AppDelegate : NSObject <UIApplicationDelegate>
{
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iHello_Word2ViewController *viewController;

@end
