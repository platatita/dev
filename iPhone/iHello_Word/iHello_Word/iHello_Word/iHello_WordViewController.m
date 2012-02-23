//
//  iHello_WordViewController.m
//  iHello_Word
//
//  Created by Marcin Szewczyk on 9/2/11.
//  Copyright 2011 platatita@interia.pl. All rights reserved.
//

#import "iHello_WordViewController.h"

@implementation iHello_WordViewController

@synthesize clickButton;
@synthesize textLabel;

- (void)dealloc
{
    [textLabel release];
    [clickButton release];
    [super dealloc];
}

- (IBAction)changeTextInLabel:(id)sender
{
    [textLabel setText:@"Hello, World!"];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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

@end
