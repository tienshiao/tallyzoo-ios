//
//  EditTextfieldViewController.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EditTextFieldViewController.h"


@implementation EditTextFieldViewController

@synthesize textValue;
@synthesize editedObject;
@synthesize editedFieldKey;
@synthesize numberEditing;

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
	
	textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, 300, 30)];
	textField.borderStyle = UITextBorderStyleBezel;
	textField.backgroundColor = [UIColor whiteColor];
	[containerView addSubview:textField];
	
	[self setView:containerView];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated {
	if (numberEditing) {
		textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	} else {
		textField.keyboardType = UIKeyboardTypeDefault;
	}
	textField.text = textValue;
	
	[textField becomeFirstResponder];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)save:(id)sender {
	if (numberEditing) {
		[editedObject setValue:[NSNumber numberWithDouble:textField.text.doubleValue] forKey:editedFieldKey];
	} else {
		[editedObject setValue:textField.text forKey:editedFieldKey];
	}
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
}


@end
