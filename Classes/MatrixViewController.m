//
//  MatrixViewController.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MatrixViewController.h"


@implementation MatrixViewController

-(id)init {
	if (self = [super init]) {
		self.title = @"Tally Zoo";
		
		UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] 
										  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
										  target:self 
										  action:@selector(addItem:)];
		self.navigationItem.rightBarButtonItem = barButtonItem;
		[barButtonItem release];
		
		barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
														 style:UIBarButtonItemStylePlain
														target:self 
														action:@selector(editButtons:)];
		self.navigationItem.leftBarButtonItem = barButtonItem;
		[barButtonItem release];
		
	}
	return self;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	MatrixView *view = [[MatrixView alloc] init];
	[self setView:view];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)addItem:(id)sender {
}

- (void)editButtons:(id)sender {
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
