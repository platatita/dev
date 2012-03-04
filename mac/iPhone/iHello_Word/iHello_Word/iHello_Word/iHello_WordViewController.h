//
//  iHello_WordViewController.h
//  iHello_Word
//
//  Created by Marcin Szewczyk on 9/2/11.
//  Copyright 2011 platatita@interia.pl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iHello_WordViewController : UIViewController
{
    UILabel *textLavel;
    UIButton *clickButton;
}

@property (nonatomic, retain) IBOutlet UIButton *clickButton;
@property (nonatomic, retain) IBOutlet UILabel *textLabel;

-(IBAction)changeTextInLabel:(id)sender;

@end
