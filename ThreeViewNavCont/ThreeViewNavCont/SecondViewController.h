//
//  SecondViewController.h
//  ThreeViewNavCont
//
//  Created by  on 1/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThirdViewController.h"

@interface SecondViewController : UIViewController{
    IBOutlet UIBarButtonItem *_nextButton;
    ThirdViewController *_thirdViewController;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, retain) ThirdViewController *thirdViewController;

- (IBAction)moveToNextView:(id)sender;

@end
