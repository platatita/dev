//
//  TestWifiViewController.m
//  
//
//  Feel Free to do whatever you want with this code.
//  It is tested & working on iPhone OS 3.0+
//  Hopefully it made your life a little easier
//  Downloaded from http://iphone.keyvisuals.com
//

#import "TestWifiViewController.h"

@implementation TestWifiViewController

@synthesize localWiFiConnectionStatus;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[self CheckReachability];

    [super viewDidLoad];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (BOOL)CheckReachability
{
    self.localWiFiConnectionStatus    = [[Reachability sharedReachability] localWiFiConnectionStatus];

	if (self.localWiFiConnectionStatus == NotReachable)
	{
		
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		alert.title = @"Error";
		alert.message = @"Please check connectivity options";
		[alert show];
		[alert release];
		
	}
	else
	{
		NSLog(@"Wifi Detected");
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Wifi Detected" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[alert show];
	}
	
	
	return FALSE;
}




-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self CheckReachability];
}
 


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}

@end
