//
//  iHello_Word2ViewController.m
//  iHello_Word2
//
//  Created by Marcin Szewczyk on 9/24/11.
//  Copyright 2011 platatita@interia.pl. All rights reserved.
//

#import "iHello_Word2ViewController.h"

@implementation iHello_Word2ViewController

@synthesize lblEnterName = _lblEnterName;
@synthesize txtEnterName = _txtEnterName;
@synthesize lblTmp = _lblTmp;


- (void)dealloc
{
    [_lblEnterName release];
    [_txtEnterName release];
    [_lblTmp release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = CGRectMake(20.0f, 140.0f, 20.0f, 20.0f);
    _lblTmp = [[UILabel alloc] initWithFrame:rect];
    [_lblTmp setText:@"tmp"];
    [self.view addSubview:self.lblTmp];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    [theTextField resignFirstResponder];
    
    if (theTextField == self.txtEnterName)
    {
        [self updateText:theTextField];
    }
    
    return YES;
}


#pragma mark - updateText methods

- (IBAction)updateText:(id)sender
{
    NSString *text;
    if ([self.txtEnterName.text length] == 0)
    {
        text = @"Please enter name :)";
    }
    else
    {
        text = [[NSString alloc] initWithFormat:@"Hello %@!", self.txtEnterName.text];
    }
    
    self.lblEnterName.text = text;
    
    [text release];
}

@end
