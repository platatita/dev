//
//  iHello_Word2ViewController.h
//  iHello_Word2
//
//  Created by Marcin Szewczyk on 9/24/11.
//  Copyright 2011 platatita@interia.pl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iHello_Word2ViewController : UIViewController
{
    IBOutlet UILabel *_lblEnterName;
    IBOutlet UITextField *_txtEnterName;
    
    UILabel *_lblTmp;
}

@property (nonatomic, retain) IBOutlet UILabel *lblEnterName;
@property (nonatomic, retain) IBOutlet UITextField *txtEnterName;

@property (nonatomic, retain) UILabel *lblTmp;

-(IBAction) updateText:(id) sender;

@end
