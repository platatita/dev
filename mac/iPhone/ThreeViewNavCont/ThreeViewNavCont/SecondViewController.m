//
//  SecondViewController.m
//  ThreeViewNavCont
//
//  Created by  on 1/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"

@implementation SecondViewController

@synthesize nextButton = _nextButton;
@synthesize thirdViewController = _thirdViewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)dealloc{
    [self.thirdViewController release];
    [super dealloc];
}

- (void)viewDidLoad
{
    self.navigationItem.title=@"Second green view";
    self.navigationItem.rightBarButtonItem = self.nextButton;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - move to next view methods

- (IBAction)moveToNextView:(id)sender{
    
    self.thirdViewController = [[[ThirdViewController alloc] initWithNibName:@"ThirdViewController" bundle:nil] autorelease];
    
    [self.navigationController pushViewController:self.thirdViewController animated:YES];
}

@end
