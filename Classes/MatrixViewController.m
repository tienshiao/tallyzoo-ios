//
//  MatrixViewController.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MatrixViewController.h"
#import "TallyZooAppDelegate.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "EditActivityViewController.h"
#import "EditCountViewController.h"
#import "TZActivity.h"
#import "TZCount.h"
#import "MatrixButton.h"
#import "ShakeView.h"
#import "AddTipView.h"
#import "AdWhirlView.h"

@implementation MatrixViewController

@synthesize editting;

- (NSString *)adWhirlApplicationKey {
	return @"0469832f2b854894b40aa5f31f2f5edc";
}

-(id)init {
	if (self = [super init]) {
		self.title = @"TallyZoo";
		
		UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] 
										  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
										  target:self 
										  action:@selector(addItem:)];
		self.navigationItem.rightBarButtonItem = barButtonItem;
		[barButtonItem release];
		
		editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
																		  target:self 
																		  action:@selector(editButtons:)];
		self.navigationItem.leftBarButtonItem = editBarButtonItem;

		doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																		  target:self 
																		  action:@selector(doneButtons:)];
		editting = NO;
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		button_behavior = [defaults integerForKey:@"behavior_preference"];
		
		locationSheet = [[UIActionSheet alloc] initWithTitle:@"Retrieving Location ...\nPlease wait or make a selection."
													delegate:self 
										   cancelButtonTitle:@"Cancel" 
									  destructiveButtonTitle:nil
										   otherButtonTitles:@"Save Without Location", @"Indoors (Disable For Now)", @"Disable Use Of Location", nil];
		locationSheet.actionSheetStyle = UIActionSheetStyleAutomatic;		
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


- (int)getNumberOfScreens {
	FMDatabase *dbh = UIAppDelegate.database;
	FMResultSet *rs = [dbh executeQuery:@"SELECT max(screen) AS max_screen FROM activities WHERE deleted = 0"];
	[rs next];
	return [rs intForColumn:@"max_screen"] + 1;
}

- (int)getNumberOfActivities {
	FMDatabase *dbh = UIAppDelegate.database;
	return [dbh intForQuery:@"SELECT count(*) FROM activities"];
}

- (int)getNumberOfCounts {
	FMDatabase *dbh = UIAppDelegate.database;
	return [dbh intForQuery:@"SELECT count(*) FROM counts"];
}

- (void)loadMatrixViewWithPage:(int)page {
	if (page < 0) return;
	if (page >= [self getNumberOfScreens]) return;
	
	[matrixView clearButtons:page];
	NSMutableArray *buttons = [matrixView.pages objectAtIndex:page];
	FMDatabase *dbh = UIAppDelegate.database;
	FMResultSet *rs = [dbh executeQuery:@"SELECT id FROM activities WHERE deleted = 0 AND screen = ? ORDER BY position",
					   [NSNumber numberWithInt:page]];
	int currentPosition = 0;
	while ([rs next]) {		
		TZActivity *a = [[TZActivity alloc] initWithKey:[rs intForColumn:@"id"]];
		MatrixButton *button = [[MatrixButton alloc] initWithActivity:a];
		
		// setup frame
		CGRect r = CGRectMake(0, 0, 320/3, matrixView.bounds.size.height/3);
		r.origin.x = (currentPosition % 3) * r.size.width + 320 * page;
		r.origin.y = (currentPosition / 3) * r.size.height;
		button.frame = r;
		button.delegate = self;
		
		if (editting) {
			button.userInteractionEnabled = NO;
			[button wobble];
		}
		
		[buttons addObject:button];
		[matrixView addSubview:button];
		[a release];
		[button release];
		
		currentPosition++;
	}
	[rs close];
	
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	ShakeView *containerView = [[ShakeView alloc] init];
	containerView.backgroundColor = [UIColor blackColor];
	containerView.delegate = self;
	
	int screens = [self getNumberOfScreens];
	
	_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 317)];
	_scrollView.pagingEnabled = YES;
	_scrollView.contentSize = CGSizeMake(320 * screens, _scrollView.frame.size.height);
	_scrollView.showsHorizontalScrollIndicator = NO;
	_scrollView.showsVerticalScrollIndicator = NO;
	_scrollView.scrollsToTop = NO;
	_scrollView.delegate = self;
	[containerView addSubview:_scrollView];

	matrixView = [[MatrixView alloc] init];
	CGRect frame = CGRectZero;
	frame.size = _scrollView.contentSize;
	matrixView.frame = frame;
	matrixView.delegate = self;
	matrixView.scrollView = _scrollView;
	[_scrollView addSubview:matrixView];
	
	
	AdWhirlView *awView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
	frame = awView.frame;
	frame.origin.y = 318;
	awView.frame = frame;
	[containerView addSubview:awView];
	
	locationBusyView = [[LocationBusyView alloc] initWithFrame:CGRectMake(110, 5, 100, 100)];
	locationBusyView.hidden = YES;
	[containerView addSubview:locationBusyView];
	
	[self setView:containerView];
	
	if ([self getNumberOfActivities] == 0) {
		// user has not added an activity yet
		AddTipView *atv = [[AddTipView alloc] initWithFrame:UIAppDelegate.window.bounds];
		[UIAppDelegate.window addSubview:atv];
		[atv release];
	}
	if ([self getNumberOfCounts] == 0) {
		countTipView = [[CountTipView alloc] initWithFrame:CGRectMake(110, 0, 200, 300)];
		[self.view addSubview:countTipView];
	}
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	int screens = [self getNumberOfScreens];
	
	_scrollView.contentSize = CGSizeMake(320 * screens, _scrollView.frame.size.height);
	CGRect frame = matrixView.frame;
	frame.size = _scrollView.contentSize;
	matrixView.frame = frame;
	
	for (int i = 0; i < screens; i++) {
		[self loadMatrixViewWithPage:i];
	}
	
	if ([self getNumberOfCounts] == 0 && [self getNumberOfActivities] == 1) {
		countTipView.hidden = NO;
	} else {
		countTipView.hidden = YES;
	}

//	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];	
}

- (void)viewDidAppear:(BOOL)animater {
	[self.view becomeFirstResponder];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	matrixView.currentPage = page;
}

- (void)addItem:(id)sender {
	TZActivity *newActivity = [[TZActivity alloc] initWithKey:0];
	EditActivityViewController *eavc = [[EditActivityViewController alloc] initWithActivity:newActivity];
	UINavigationController *addNavigationController =[[UINavigationController alloc] initWithRootViewController:eavc];
	
	[[self navigationController] presentModalViewController:addNavigationController animated:YES];
	
	[addNavigationController release];
	[eavc release];	
	[newActivity release];
}

- (void)editButtons:(id)sender {
	editting = YES;
	self.navigationItem.leftBarButtonItem = doneBarButtonItem;
	matrixView.editting = YES;
}

- (void)doneButtons:(id)sender {
	editting = NO;
	self.navigationItem.leftBarButtonItem = editBarButtonItem;
	matrixView.editting = NO;

//	[self viewWillAppear:NO];
	_scrollView.contentSize = CGSizeMake(320 * [matrixView.pages count], _scrollView.frame.size.height);
	CGRect frame = matrixView.frame;
	frame.size = _scrollView.contentSize;
	matrixView.frame = frame;
}

- (void)matrixButtonClicked:(MatrixButton *)mb {
	if (editting) {
		EditActivityViewController *eavc = [[EditActivityViewController alloc] initWithActivity:mb.activity];
		UINavigationController *addNavigationController =[[UINavigationController alloc] initWithRootViewController:eavc];
		
		[[self navigationController] presentModalViewController:addNavigationController animated:YES];
		
		[addNavigationController release];
		[eavc release];			
	} else {
		if (button_behavior == 0) {
			NSLog(@"accuracy %f", UIAppDelegate.location.horizontalAccuracy);
			if (UIAppDelegate.location.horizontalAccuracy <= 0 &&
				UIAppDelegate.use_gps) {
				tmp_button = mb;
				[self waitForLocation];
			} else {
				[mb.activity simpleCount];
				countTipView.hidden = YES;
/*				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location" 
																message:[NSString stringWithFormat:@"%@", UIAppDelegate.location] 
															   delegate:nil
													  cancelButtonTitle:@"Close"
													  otherButtonTitles:nil];
				alert.delegate = self;
				[alert show];*/
				
			}
		} else {
			TZCount *newCount = [[TZCount alloc] initWithKey:0 andActivity:mb.activity];
			EditCountViewController *ecvc = [[EditCountViewController alloc] initWithCount:newCount];
			UINavigationController *addNavigationController =[[UINavigationController alloc] initWithRootViewController:ecvc];
			
			[[self navigationController] presentModalViewController:addNavigationController animated:YES];
			
			[addNavigationController release];
			[ecvc release];
			[newCount release];
		}
	}
}

- (void)matrixButtonHeld:(MatrixButton *)mb {
	if (editting) {
	} else {
		if (button_behavior == 0) {
			TZCount *newCount = [[TZCount alloc] initWithKey:0 andActivity:mb.activity];
			EditCountViewController *ecvc = [[EditCountViewController alloc] initWithCount:newCount];
			UINavigationController *addNavigationController =[[UINavigationController alloc] initWithRootViewController:ecvc];
	
			[[self navigationController] presentModalViewController:addNavigationController animated:YES];
	
			[addNavigationController release];
			[ecvc release];	
			[newCount release];
		} else {
			if (UIAppDelegate.location.horizontalAccuracy <= 0 &&
				UIAppDelegate.use_gps) {
				tmp_button = mb;
				[self waitForLocation];
			} else {
				[mb.activity simpleCount];
				countTipView.hidden = YES;
			}
		}
	}
}

-(void)shakeHappened:(ShakeView*)view {
	FMDatabase *dbh = UIAppDelegate.database;
	FMResultSet *rs = [dbh executeQuery:@"SELECT id FROM counts WHERE deleted = 0 AND local = 1 ORDER BY created_on DESC LIMIT 1"];

	if ([rs next]) {
	
		TZCount *c = [[TZCount alloc] initWithKey:[rs intForColumn:@"id"] andActivity:nil];
		undo_count_id = c.key;
	
		TZActivity *a = [[TZActivity alloc] initWithKey:c.activity_id];
	
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Undo" 
														message:[NSString stringWithFormat:@"Undo last count on '%@'?", a.name] 
													   delegate:self 
											  cancelButtonTitle:@"Cancel" 
											  otherButtonTitles:@"Undo Count", nil];
		alert.delegate = self;
		[alert show];

		[a release];
		[c release];
	}
	[rs close];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex) {
		FMDatabase *dbh = UIAppDelegate.database;
		FMResultSet *rs = [dbh executeQuery:@"UPDATE counts SET deleted = 1 WHERE id = ?", [NSNumber numberWithInt:undo_count_id]];
		[rs next];
		
		int screens = [self getNumberOfScreens];
		for (int i = 0; i < screens; i++) {
			[self loadMatrixViewWithPage:i];
		}
		
	}
	[alertView autorelease];
}

- (void)waitForLocation {
	locationBusyView.hidden = NO;
	UIAppDelegate.locationDelegate = self;
	[locationSheet showInView:self.tabBarController.view]; // show from our table view (pops up in the middle of the table)
}

- (void)locationFound {
	[locationSheet dismissWithClickedButtonIndex:1 animated:YES];
	[tmp_button.activity simpleCount];
	[tmp_button setNeedsDisplay];
	tmp_button = nil;
	locationBusyView.hidden = YES;
	countTipView.hidden = YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0) {
		[tmp_button.activity simpleCount];
		[tmp_button setNeedsDisplay];
	} else if (buttonIndex == 1) {
		UIAppDelegate.use_gps = NO;
		[tmp_button.activity simpleCount];
		[tmp_button setNeedsDisplay];
	} else if (buttonIndex == 2) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:[NSNumber numberWithBool:NO] forKey:@"gps_preference"];
		[defaults synchronize];
		
		UIAppDelegate.use_gps = NO;
		[tmp_button.activity simpleCount];
		[tmp_button setNeedsDisplay];		
	}
	tmp_button = nil;
	locationBusyView.hidden = YES;
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
	[_scrollView release];
	[matrixView release];
	
	[editBarButtonItem release];
	[doneBarButtonItem release];
	
	[locationSheet release];
	[locationBusyView release];
	
	[countTipView release];
	
	[super dealloc];
}


@end
