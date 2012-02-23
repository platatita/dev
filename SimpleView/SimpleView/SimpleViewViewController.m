//
//  SimpleViewViewController.m
//  SimpleView
//
//  Created by  on 1/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SimpleViewViewController.h"

@implementation SimpleViewViewController
@synthesize theLable = _theLable;

- (void)didReceiveMemoryWarning
{
    NSLog(@"received memory warning...");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSLog(@"view did load...");
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    NSLog(@"view did unload...");
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"view did appear...");    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"view rotated....");    
}

- (void) dealloc{
    [_theLable release];
    [super dealloc];
}

#pragma theLabel members

- (IBAction)changeLabelValue:(id)sender{
    [_theLable setText:(@"Hello world.")];
    UIButton *theBut = sender;
    NSLog(theBut.currentTitle);
    theBut.enabled = NO;
    [theBut setTitle:@"Pressed Already" forState:UIControlStateDisabled];
}

@end
