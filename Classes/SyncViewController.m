//
//  SyncViewController.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 9/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SyncViewController.h"
#import "Syncer.h"
#import "SFHFKeychainUtils.h"
#import "AccountBackgroundView.h"
#import "FlurryAPI.h"
#import "TallyZooAppDelegate.h"

@implementation SyncViewController

- (id)init {
	if (self = [super init]) {
		self.title = @"Sync";
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
	containerView.backgroundColor = [UIColor blackColor];
	
	AccountBackgroundView *abv = [[AccountBackgroundView alloc] initWithFrame:CGRectMake(10, 20, 300, 71)];
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
	
	lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, 280, 20)];
	lastLabel.textColor = [UIColor whiteColor];
	lastLabel.backgroundColor = [UIColor blackColor];
	lastLabel.font = [UIFont systemFontOfSize:14];
	[containerView addSubview:lastLabel];
	
	progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
	progressView.frame = CGRectMake(20, 110, 280, 20);
	progressView.progress = 0.0;
	progressView.hidden = YES;
	[containerView addSubview:progressView];
	
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

	signupButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	signupButton.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
	[signupButton setTitleShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] forState:UIControlStateNormal];
	signupButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
	[signupButton setTitle:@"Sign Up for a Free Account" forState:UIControlStateNormal];	
	signupButton.frame = CGRectMake(10, 190, 300, 40);
	[signupButton addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchUpInside];
	[containerView addSubview:signupButton];
	
	self.view = containerView;
	
	[containerView release];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	usernameField.text = [defaults stringForKey:@"username"];
	original_username = [usernameField.text copy];
	
	NSError *error;
	passwordField.text = [SFHFKeychainUtils getPasswordForUsername:usernameField.text andServiceName:@"TallyZoo" error:&error];

	NSString *lastSync = [defaults stringForKey:@"lastSync"];
	
	if (lastSync) {
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		[df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		NSDate *temp = [df dateFromString:lastSync];
		lastLabel.text = [NSString stringWithFormat:@"Last Synced: %@", temp];
		[df release];
	} else {
		lastLabel.text = @"Last Synced: never";
	}
	
	Syncer *syncer = UIAppDelegate.syncer;
	syncer.delegate = self;
	
	if (syncer.state) {
		syncButton.enabled = NO; 
		lastLabel.hidden = YES;
		progressView.hidden = NO;
		progressView.progress = syncer.progress;		
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[FlurryAPI logEvent:@"Sync Appeared"];
}

- (void)viewWillDisappear:(BOOL)animated {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:usernameField.text forKey:@"username"];
	
	[defaults synchronize];

	NSError *error;
	if (![original_username isEqualToString:usernameField.text]) {
		[SFHFKeychainUtils deleteItemForUsername:original_username andServiceName:@"TallyZoo" error:&error];
	}
	
	[SFHFKeychainUtils storeUsername:usernameField.text andPassword:passwordField.text forServiceName:@"TallyZoo" updateExisting:YES error:&error];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)signup:(id)sender {
	[FlurryAPI logEvent:@"Signup Clicked"];

	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.tallyzoo.com/register"]];
}

- (void)sync:(id)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:usernameField.text forKey:@"username"];
	
	[defaults synchronize];
	
	NSError *error;
	if (![original_username isEqualToString:usernameField.text]) {
		[SFHFKeychainUtils deleteItemForUsername:original_username andServiceName:@"TallyZoo" error:&error];
	}
	
	[SFHFKeychainUtils storeUsername:usernameField.text andPassword:passwordField.text forServiceName:@"TallyZoo" updateExisting:YES error:&error];
	
	[FlurryAPI logEvent:@"Sync Started"];

	// TODO set up UI
	[usernameField resignFirstResponder];
	[passwordField resignFirstResponder];
	syncButton.enabled = NO; 
	lastLabel.hidden = YES;
	progressView.hidden = NO;
	progressView.progress = 0.0;
	
	Syncer *syncer = UIAppDelegate.syncer;
	syncer.delegate = self;

	[syncer start];
}

- (void)syncCleanUp {
	syncButton.enabled = YES;
	progressView.progress = 1.0;
	progressView.hidden = YES;
	lastLabel.hidden = NO;
	
	Syncer *syncer = UIAppDelegate.syncer;
	syncer.delegate = nil;	

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *lastSync = [defaults stringForKey:@"lastSync"];

	if (lastSync) {
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		[df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		NSDate *temp = [df dateFromString:lastSync];	
		lastLabel.text = [NSString stringWithFormat:@"Last Synced: %@", temp];
		[df release];
	} else {
		lastLabel.text = @"Last Synced: never";
	}
}

- (void)syncerUpdated:(Syncer *)s {
	if (s.state) {
		lastLabel.hidden = YES;
		progressView.hidden = NO;
		syncButton.enabled = NO;
		
		progressView.progress = s.progress;
	} else {
		progressView.hidden = YES;
		lastLabel.hidden = NO;
		syncButton.enabled = YES;
	}
}

- (void)syncerCompleted:(Syncer *)s {
	[self syncCleanUp];
	
	[FlurryAPI logEvent:@"Sync Completed"];
}

- (void)syncerFailed:(Syncer *)s {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Syncing" 
													message:s.message 
												   delegate:nil
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert autorelease];	
	
	[self syncCleanUp];
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
	[original_username release];
	[usernameField release];
	[passwordField release];
	[progressView release];
	[syncButton release];
	[signupButton release];
	
	[lastLabel release];
	[super dealloc];
}


@end
