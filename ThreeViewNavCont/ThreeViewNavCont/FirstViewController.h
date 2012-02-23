//
//  FirstViewController.h
//  ThreeViewNavCont
//
//  Created by  on 1/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondViewController.h"

@interface FirstViewController : UIViewController{
    SecondViewController *_secondViewController;
}

@property (nonatomic, retain) SecondViewController *secondViewController;

- (IBAction)moveToNextView:(id)sender;


@end
