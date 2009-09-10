//
//  SyncViewController.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 9/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SyncViewController.h"
#import "AccountBackgroundView.h"

@implementation SyncViewController

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
	containerView.backgroundColor = [UIColor blackColor];
	
	AccountBackgroundView *abv = [[AccountBackgroundView alloc] initWithFrame:CGRectMake(10, 50, 300, 71)];
	[containerView addSubview:abv];
	[abv release];
	
	usernameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, 280, 30)];
	usernameField.placeholder = @"Username";
	usernameField.returnKeyType = UIReturnKeyDone;
	usernameField.delegate = self;
	[abv addSubview:usernameField];

	passwordField = [[UITextField alloc] initWithFrame:CGRectMake(10, 42, 280, 30)];
	passwordField.placeholder = @"Password";
	passwordField.secureTextEntry = YES;
	passwordField.returnKeyType = UIReturnKeyDone;
	passwordField.delegate = self;
	[abv addSubview:passwordField];
	
	syncButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	syncButton.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
	[syncButton setTitleShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] forState:UIControlStateNormal];
	syncButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
	[syncButton setTitle:@"Sync Now" forState:UIControlStateNormal];
	
/*	UIImage *image = [UIImage imageNamed:@"red_up.png"];
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[deleteButton setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *imagePressed = [UIImage imageNamed:@"red_down.png"];
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[deleteButton setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];*/
	
	syncButton.frame = CGRectMake(10, 140, 300, 40);
	[syncButton addTarget:self action:@selector(sync:) forControlEvents:UIControlEventTouchUpInside];

	[containerView addSubview:syncButton];

	
	
	self.view = containerView;
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

- (void)sync:(id)sender {
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
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
	
	[usernameField release];
	[passwordField release];
	[syncButton release];
}


@end
