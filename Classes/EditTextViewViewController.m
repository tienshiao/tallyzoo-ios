//
//  EditTextViewViewController.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EditTextViewViewController.h"


@implementation EditTextViewViewController

@synthesize textValue;
@synthesize editedObject;
@synthesize editedFieldKey;

- (id)init {
	if (self = [super init]) {
		
		UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																					   target:self 
																					   action:@selector(save:)];
		self.navigationItem.rightBarButtonItem = barButtonItem;
		[barButtonItem release];
		
		barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																	  target:self 
																	  action:@selector(cancel:)];
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
	UIView *containerView = [[UIView alloc] init];
	containerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	// TODO pretty up background
	textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 40, 300, 100)];
	textView.backgroundColor = [UIColor whiteColor];
	textView.font = [UIFont systemFontOfSize:16];
	[containerView addSubview:textView];
	
	[self setView:containerView];	
}



/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated {
	textView.text = textValue;
	[textView becomeFirstResponder];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (void)save:(id)sender {
	[editedObject setValue:textView.text forKey:editedFieldKey];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
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
	
	[textView release];
}


@end
