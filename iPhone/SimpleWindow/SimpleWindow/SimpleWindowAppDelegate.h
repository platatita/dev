//
//  SimpleWindowAppDelegate.h
//  SimpleWindow
//
//  Created by  on 1/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"

@interface SimpleWindowAppDelegate : NSObject <UIApplicationDelegate>{
    UIWindow *_window;
    FirstViewController *_rootViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet FirstViewController *rootViewController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
