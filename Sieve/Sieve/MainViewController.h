//
//  MainViewController.h
//  Sieve
//
//  Created by  on 12/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"

#import <CoreData/CoreData.h>

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>

- (IBAction)showInfo:(id)sender;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
