//
//  SimpleViewViewController.h
//  SimpleView
//
//  Created by  on 1/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleViewViewController : UIViewController {
    IBOutlet UILabel *_theLable;
}

@property (nonatomic, retain) UILabel *theLable;
- (IBAction)changeLabelValue:(id)sender;

@end
